local t = require("@pkg/t")

local Types = require("./Types")
local NodeTypes = require("./Node/Types")
local NodesTypes = require("./Node/NodesTypes")

local AbstractSyntaxTree = require("./AbstractSyntaxTree")
local Nodes = require("./Node/Nodes")

local Color3 = require("../Color3")
local Entities = require("./Entities")

local Parser = {} :: Types.Parser

-- types
type JoinsType = "bevel" | "miter" | "round"

type KnownRichTextTag =
    "font" |
    "stroke" |
    "b" |
    "i" |
    "u" |
    "s" |
    "br" |
    "uc" |
    "uppercase" |
    "sc" |
    "smallcaps" |
    "mark"

local CharacterMap = table.freeze {
    UPPERCASE_ALPHA_START = string.byte("A"),
    UPPERCASE_ALPHA_END = string.byte("Z"),

    LOWERCASE_ALPHA_START = string.byte("a"),
    LOWERCASE_ALPHA_END = string.byte("z"),

    SPACE = string.byte(" "),
    TAB = string.byte("\t"),
    CR = string.byte("\r"),
    LF = string.byte("\n"),
    EQUALS = string.byte("="),

    TAG_START = string.byte("<"),
    TAG_END = string.byte(">"),
    TAG_CLOSING_MARKER = string.byte("/"),

    EXCLAMATION_MARK = string.byte("!"),
    HYPHEN = string.byte("-"),

    DOUBLE_QUOTES = string.byte("\""),
    SINGLE_QUOTES = string.byte("\'"),

    AMPERSAND = string.byte("&")
}

-- XML name validation (XML 1.0 compatible ranges, practical for Luau)
local function isXmlStartCharCodeValid(code: number): boolean
    -- ASCII letters and underscore
    if (code >= 65 and code <= 90) or (code >= 97 and code <= 122) or code == 95 then
        return true
    end

    -- Unicode letter ranges (per XML 1.0, practical subset + astral)
    if
        (code >= 0xC0 and code <= 0xD6) or (code >= 0xD8 and code <= 0xF6) or (code >= 0xF8 and code <= 0x2FF)
        or (code >= 0x370 and code <= 0x37D) or (code >= 0x37F and code <= 0x1FFF)
        or (code >= 0x200C and code <= 0x200D) or (code >= 0x2070 and code <= 0x218F)
        or (code >= 0x2C00 and code <= 0x2FEF) or (code >= 0x3001 and code <= 0xD7FF)
        or (code >= 0xF900 and code <= 0xFDCF) or (code >= 0xFDF0 and code <= 0xFFFD)
        or (code >= 0x10000 and code <= 0xEFFFF)
    then
        return true
    end

    return false
end

local function isXmlNameCharCodeValid(code: number): boolean
    if isXmlStartCharCodeValid(code) then
        return true
    end

    -- digits 0-9
    if (code >= 48 and code <= 57) then
        return true
    end

    -- hyphen, period, middle dot
    if code == 45 or code == 46 or code == 0x00B7 then
        return true
    end

    -- Combining marks and other allowed ranges
    if (code >= 0x300 and code <= 0x36F) or (code >= 0x203F and code <= 0x2040) then
        return true
    end

    return false
end

local function isValidRichTextXmlName(name: string): boolean
    --// NOTE: We don't check `xml` prefixed names because roblox supports them for some reason.

    if #name == 0 then
        return false
    end

    local first = true
    for _, code in utf8.codes(name) do
        if first then
            if not isXmlStartCharCodeValid(code) then
                return false
            end
            first = false
        else
            if not isXmlNameCharCodeValid(code) then
                return false
            end
        end
    end

    return true
end

local finalizeNodeArgCheck = t.tuple(t.literal_list({"Text", "Comment", "Other"}), t.optional(t.string :: any))
local parseArgCheck = t.tuple(t.string)

local function parseColor(color: string): Color3
    if #color == 7 and string.sub(color, 1, 1) == "#" then
        return Color3.fromHex(color) --// performs validation, may error
    end

    local r, g, b = string.match(color, "rgb%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)")
    if r then
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) --// same here
    end

    error("Invalid color format")
end

-- Parser.Parse implementation
function Parser.Parse(input)
    assert(parseArgCheck(input))

    local syntaxTree = AbstractSyntaxTree.new()
    local root = syntaxTree.RootNode
    local currentNode: NodeTypes.Node = root
    local nodeStack: {NodeTypes.Node} = table.create(4)

    if root then
        table.insert(nodeStack, root)
    end

    local inputBuffer = buffer.fromstring(input)
    local inputLength = buffer.len(inputBuffer)
    local cursor = 0

    local function ensureNotEOF(): ()
        if cursor >= inputLength then
            error("Unexpected EOF")
        end
    end

    local function readByte(shouldNotAdvance: boolean?): number
        ensureNotEOF()
        local byte = buffer.readu8(inputBuffer, cursor)

        if not shouldNotAdvance then
            cursor += 1
        end

        return byte
    end

    local function lookAheadString(size: number): string
        if (cursor + size) > inputLength then
            return buffer.readstring(inputBuffer, cursor, math.max(0, inputLength - cursor))
        end

        return buffer.readstring(inputBuffer, cursor, size)
    end

    --// read a full UTF-8 character (string) starting at cursor, advances cursor
    local function readUtf8Char(): (string, number)
        ensureNotEOF()

        local first = buffer.readu8(inputBuffer, cursor)
        local expectedLength = 1

        if first < 0x80 then
            expectedLength = 1
        elseif first >= 0xC0 and first <= 0xDF then
            expectedLength = 2
        elseif first >= 0xE0 and first <= 0xEF then
            expectedLength = 3
        elseif first >= 0xF0 and first <= 0xF7 then
            expectedLength = 4
        else
            error("Invalid UTF-8 lead byte")
        end

        if cursor + expectedLength > inputLength then
            error("Truncated UTF-8 sequence")
        end

        local str = buffer.readstring(inputBuffer, cursor, expectedLength)
        cursor += expectedLength

        return str, utf8.codepoint(str)
    end

    local function consumeWhitespaces(): ()
        while cursor < inputLength do
            local b = buffer.readu8(inputBuffer, cursor)
            if b == CharacterMap.SPACE or b == CharacterMap.TAB or b == CharacterMap.CR or b == CharacterMap.LF then
                cursor += 1
            else
                break
            end
        end
    end

    local function readStringValue(): string
        ensureNotEOF()

        local quote = readByte()
        if quote ~= CharacterMap.DOUBLE_QUOTES and quote ~= CharacterMap.SINGLE_QUOTES then
            error(`Expected quote, got '{string.char(quote)}'`)
        end

        local str = ""
        local foundEscape = false

        while true do
            ensureNotEOF()
            local character = readByte()

            if character == quote then
                break
            end

            if character == CharacterMap.AMPERSAND then
                foundEscape = true
            end

            str ..= string.char(character)
        end

        if foundEscape then
            str = Entities.Decode(str)
        end

        return str
    end

    local function readContinuousName(): string
        --// Roblox doesn't respect the reserved `xml` prefixes for some reason. Therefore, we don't throw on them.
        local name = ""
        local first = true

        while cursor < inputLength do
            local saved = cursor
            local ok, character, code = pcall(readUtf8Char)

            if not ok then
                cursor = saved
                break
            end

            if first then
                if not isXmlStartCharCodeValid(code) then
                    cursor = saved
                    break
                end

                name ..= character
                first = false
            else
                if not isXmlNameCharCodeValid(code) then
                    cursor = saved
                    break
                end

                name ..= character
            end
        end

        assert(#name > 0, "Invalid identifier")

        if not isValidRichTextXmlName(name) then
            error(`Invalid name '{name}' according to XML rules`)
        end

        return name
    end

    local tagName: KnownRichTextTag = nil
    local attributes: {[string]: string} = {}
    local function constructNode(nodeType: "Text" | "Comment" | "Other", content: string?): ()
        assert(finalizeNodeArgCheck(nodeType, content))

        local node: NodeTypes.Node
        if nodeType == "Text" then
            node = Nodes.TextNode.new(content or "", currentNode)
        elseif nodeType == "Comment" then
            node = Nodes.CommentNode.new(content or "", currentNode)
        else
            if tagName == "font" then
                local fontNode = Nodes.FontNode.new(currentNode)
                fontNode.IsValid = false

                fontNode.Color = if attributes.color then parseColor(attributes.color) else nil
                fontNode.Size = if attributes.size then tonumber(attributes.size) else nil
                fontNode.Face = attributes.face
                fontNode.Family = attributes.family

                fontNode.Weight = if attributes.weight then tonumber(attributes.weight) else nil
                if fontNode.Weight and (fontNode.Weight < 100 or fontNode.Weight > 900) then
                    error(`Expected font weight in range [100, 900], got '{fontNode.Weight}'`)
                end

                fontNode.Transparency = if attributes.transparency then tonumber(attributes.transparency) else nil

                node = fontNode
            elseif tagName == "stroke" then
                local strokeNode = Nodes.StrokeNode.new(currentNode)
                strokeNode.IsValid = false

                strokeNode.Color = if attributes.color then parseColor(attributes.color) else nil

                local joins: JoinsType = attributes.joins :: JoinsType
                if joins ~= "bevel" and joins ~= "miter" and joins ~= "round" then
                    error(`Expected corner style to be 'bevel', 'miter' or 'round', got '{joins}'`)
                end

                strokeNode.Joins = (
                    if joins == "bevel"
                    then "Bevel"
                    elseif joins == "miter"
                    then "Miter"
                    else "Round")

                strokeNode.Thickness = if attributes.thickness then tonumber(attributes.thickness) else nil
                strokeNode.Transparency = if attributes.transparency then tonumber(attributes.transparency) else nil

                node = strokeNode
            elseif tagName == "b" then
                node = Nodes.BoldNode.new(currentNode)
            elseif tagName == "i" then
                node = Nodes.ItalicNode.new(currentNode)
            elseif tagName == "u" then
                node = Nodes.UnderlineNode.new(currentNode)
            elseif tagName == "s" then
                node = Nodes.StrikethroughNode.new(currentNode)
            elseif tagName == "br" then
                node = Nodes.LineBreakNode.new(currentNode)
            elseif tagName == "uc" or tagName == "uppercase" then
                node = Nodes.UppercaseNode.new(tagName, currentNode)
            elseif tagName == "sc" or tagName == "smallcaps" then
                node = Nodes.SmallcapsNode.new(tagName, currentNode)
            elseif tagName == "mark" then
                local markNode = Nodes.MarkNode.new(currentNode)
                markNode.Color = if attributes.color then parseColor(attributes.color) else nil
                markNode.Transparency = if attributes.transparency then tonumber(attributes.transparency) else nil
                node = markNode
            else
                node = Nodes.BasicNode.new(tagName, currentNode)
            end

            node.Attributes = attributes
        end

        table.insert(nodeStack, node)
        currentNode = node
        tagName = (nil :: string?) :: KnownRichTextTag
        attributes = {}
    end

    local function finalizeNode(): ()
        local popped = table.remove(nodeStack)
        assert(popped, "Cannot finalize node because there are no nodes to finalize")

        popped.IsValid = true
        currentNode = nodeStack[#nodeStack]
    end

    local function finalizeIfTextNode()
        if currentNode.Type == "TextNode" then
            finalizeNode()
        end
    end

    local function appendTextToCurrent(character: string): ()
        if not currentNode or currentNode.Type ~= "TextNode" then
            local textNode = Nodes.TextNode.new("", currentNode)
            table.insert(nodeStack, textNode)

            textNode.IsValid = true
            currentNode = textNode
        end

        local textNode = (currentNode :: NodesTypes.TextNode)
        textNode.Content ..= character
    end

    xpcall(function()
        while cursor < inputLength do
            local character = readByte()
            if character == CharacterMap.TAG_START then
                finalizeIfTextNode()

                local lookAhead3 = lookAheadString(3)
                if lookAhead3 == "!--" then
                    --// Comment
                    cursor += 3
                    local content = ""
                    local prevHyphen = false
                    while true do
                        if cursor >= inputLength then
                            error("Unterminated comment")
                        end

                        if lookAheadString(3) == "-->" then
                            cursor += 3
                            break
                        end

                        local nextCharacter = readByte()
                        if nextCharacter == CharacterMap.HYPHEN then
                            if prevHyphen then
                                error("XML comment cannot contain '--'")
                            end
                            prevHyphen = true
                        else
                            prevHyphen = false
                        end

                        content ..= string.char(nextCharacter)
                    end

                    constructNode("Comment", content)
                    finalizeNode()
                    continue
                end

                local nextCharacter = readByte(true)
                if nextCharacter == CharacterMap.TAG_CLOSING_MARKER then
                    cursor += 1
                    consumeWhitespaces()

                    local closeName = readContinuousName()
                    consumeWhitespaces()

                    local tagEnd = readByte()
                    if tagEnd ~= CharacterMap.TAG_END then
                        error(`Expected '>' after closing tag, got '{string.char(tagEnd)}'`)
                    end

                    if currentNode.Tag ~= closeName and currentNode.Tag then
                        error(`Expected the enclosing tag to reference the current tag '{currentNode.Tag}', got '{closeName}'`)
                    elseif currentNode.Tag ~= closeName then
                        error(`Unexpected enclosing tag '{closeName}'`)
                    end

                    finalizeNode()
                    continue
                end

                tagName = readContinuousName() :: KnownRichTextTag
                attributes = {}

                --// parse attributes until '>' or '/>'
                while true do
                    consumeWhitespaces()

                    if cursor >= inputLength then
                        error(`Unterminated tag '{tagName}'`)
                    end

                    local two = lookAheadString(2)
                    if two == "/>" then
                        cursor += 2
                        constructNode("Other")
                        finalizeNode()
                        break
                    end

                    local one = lookAheadString(1)
                    if one == ">" then
                        cursor += 1
                        constructNode("Other")
                        break
                    end

                    local attributeName = readContinuousName()
                    consumeWhitespaces()

                    local equals = readByte()
                    if equals ~= CharacterMap.EQUALS then
                        error(`Equals sign expected between attribute name and value, got '{string.char(equals)}'`)
                    end

                    consumeWhitespaces()
                    attributes[attributeName] = readStringValue()
                end
            else
                --// Text
                if character == CharacterMap.AMPERSAND then
                    --// read up to ';' (basic entity processing)
                    local escaped = "&"
                    while cursor < inputLength do
                        local nextCharacter = readByte()
                        escaped ..= string.char(nextCharacter)

                        if nextCharacter == string.byte(";") then
                            break
                        end
                    end

                    local decoded = Entities.UnescapeMap[escaped] or escaped
                    appendTextToCurrent(decoded :: string)
                else
                    appendTextToCurrent(string.char(character))
                end
            end
        end

        if (#nodeStack > 1 and nodeStack[2].Type ~= "TextNode") or #nodeStack > 2 then
            error(`Unterminated tag '{nodeStack[#nodeStack].Tag}'`)
        end
    end, function(message)
        if not syntaxTree.Error then
            syntaxTree.Error = string.format("%d: %s", cursor, string.match(message, "^.+:%d+: (.+)") :: string)
        end

        local node = if currentNode.Type == "TextNode" and currentNode:GetParent()
            then currentNode:GetParent() :: NodeTypes.Node
            else currentNode

        node.IsValid = false
    end)

    return syntaxTree
end

return Parser
