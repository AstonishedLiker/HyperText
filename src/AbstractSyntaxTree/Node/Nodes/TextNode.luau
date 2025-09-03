local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")
local Entities = require("../../Entities")

local TextNode = {} :: NodesTypes.TextNodeImpl
TextNode.__index = setmetatable(TextNode, Node)

local ctorArgCheck =  t.tuple(t.string, Types.NodeCheck)
function TextNode.new(content, parent)
    assert(ctorArgCheck(content, parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "TextNode",
        Tag = "",
        Attributes = {},
        _Children = {},

        Content = content
    } :: NodesTypes.ITextNode) :: any, TextNode) :: NodesTypes.TextNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

--// Override
function TextNode:ToString()
    return Entities.Encode((self :: NodesTypes.TextNode).Content)
end

return TextNode
