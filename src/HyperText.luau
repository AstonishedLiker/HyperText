local t = require("@pkg/t")

local Types = require("./Types")
local NodeTypes = require("./AbstractSyntaxTree/Node/Types")
local NodesTypes = require("./AbstractSyntaxTree/Node/NodesTypes")

local Entities = require("./AbstractSyntaxTree/Entities")
local Nodes = require("./AbstractSyntaxTree/Node/Nodes")

local HyperText = {} :: Types.HyperTextImpl
HyperText.__index = HyperText

function HyperText.new()
    local rootNode = Nodes.BasicNode.new()

    return setmetatable({
        _RootNode = rootNode,
        _CurrentNode = rootNode
    } :: Types.IHyperText, HyperText)
end

function HyperText:Font()
    self._CurrentNode = Nodes.FontNode.new(self._CurrentNode)
    return self
end

local colorArgCheck = t.tuple(t.Color3)
function HyperText:Color(color)
    assert(colorArgCheck(color))

    local node = self._CurrentNode ::
        NodesTypes.FontNode &
        NodesTypes.StrokeNode &
        NodesTypes.MarkNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "StrokeNode"
        or (node.Type :: NodeTypes.NodeType) == "MarkNode"
        or (node.Type :: NodeTypes.NodeType) == "FontNode",

        "The color modifier expects either a StrokeNode, MarkNode, or a FontNode"
    )

    assert(not node.Attributes.color, "The color is already set for this node")
    node.Attributes.color = `#{string.upper(color:ToHex())}`

    return self
end

local sizeArgCheck = t.tuple(t.number)
function HyperText:Size(size)
    assert(sizeArgCheck(size))

    local node = self._CurrentNode :: NodesTypes.FontNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "FontNode",
        "The size modifier expects a FontNode"
    )

    assert(not node.Attributes.size, "The size is already set for this node")
    node.Attributes.size = tostring(size)

    return self
end

local transparencyArgCheck = t.tuple(t.number_constrained(0 :: any, 1 :: any))
function HyperText:Transparency(transparency)
    assert(transparencyArgCheck(transparency))

    local node = self._CurrentNode ::
        NodesTypes.FontNode &
        NodesTypes.StrokeNode &
        NodesTypes.MarkNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "StrokeNode"
        or (node.Type :: NodeTypes.NodeType) == "MarkNode"
        or (node.Type :: NodeTypes.NodeType) == "FontNode",

        "The transparency modifier expects either a StrokeNode, MarkNode, or a FontNode"
    )

    assert(not node.Attributes.transparency, "The transparency is already set for this node")
    node.Attributes.transparency = tostring(transparency)

    return self
end

local faceArgCheck = t.tuple(t.string)
function HyperText:Face(face)
    assert(faceArgCheck(face))

    local node = self._CurrentNode :: NodesTypes.FontNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "FontNode",
        "The face modifier expects a FontNode"
    )

    assert(not node.Attributes.face, "The face is already set for this node")
    node.Attributes.face = face

    return self
end

local familyArgCheck = t.tuple(t.string)
function HyperText:Family(family)
    assert(familyArgCheck(family))

    local node = self._CurrentNode :: NodesTypes.FontNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "FontNode",
        "The family modifier expects a FontNode"
    )

    assert(not node.Attributes.family, "The family is already set for this node")
    node.Attributes.family = family

    return self
end

local weightArgCheck = t.tuple(t.number_constrained(100 :: any, 900 :: any))
function HyperText:Weight(weight)
    assert(weightArgCheck(weight))

    local node = self._CurrentNode :: NodesTypes.FontNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "FontNode",
        "The weight modifier expects a FontNode"
    )

    assert(not node.Attributes.weight, "The weight is already set for this node")
    node.Attributes.weight = tostring(weight)

    return self
end

local joinsArgCheck = t.tuple(t.literal_list({"Round", "Bevel", "Miter"}))
function HyperText:Joins(joins)
    assert(joinsArgCheck(joins))

    local node = self._CurrentNode :: NodesTypes.StrokeNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "StrokeNode",
        "The joins modifier expects a StrokeNode"
    )

    assert(not node.Attributes.joins, "The joins is already set for this node")
    node.Attributes.joins = joins

    return self
end

local thicknessArgCheck = t.tuple(t.number)
function HyperText:Thickness(thickness)
    assert(thicknessArgCheck(thickness))

    local node = self._CurrentNode :: NodesTypes.StrokeNode

    assert(NodeTypes.NodeCheck(node :: any))
    assert(
        (node.Type :: NodeTypes.NodeType) == "StrokeNode",
        "The thickness modifier expects a StrokeNode"
    )

    assert(not node.Attributes.thickness, "The thickness is already set for this node")
    node.Attributes.thickness = tostring(thickness)

    return self
end

function HyperText:Stroke()
    self._CurrentNode = Nodes.StrokeNode.new(self._CurrentNode)
    return self
end

function HyperText:Bold()
    self._CurrentNode = Nodes.BoldNode.new(self._CurrentNode)
    return self
end

function HyperText:Italic()
    self._CurrentNode = Nodes.ItalicNode.new(self._CurrentNode)
    return self
end

function HyperText:Underline()
    self._CurrentNode = Nodes.UnderlineNode.new(self._CurrentNode)
    return self
end

function HyperText:Strikethrough()
    self._CurrentNode = Nodes.StrikethroughNode.new(self._CurrentNode)
    return self
end

function HyperText:NewLine()
    self._CurrentNode = Nodes.LineBreakNode.new(self._CurrentNode)
    return self
end

function HyperText:Uppercase()
    self._CurrentNode = Nodes.UppercaseNode.new("uc", self._CurrentNode)
    return self
end

function HyperText:Smallcaps()
    self._CurrentNode = Nodes.SmallcapsNode.new("sc", self._CurrentNode)
    return self
end

function HyperText:Mark()
    self._CurrentNode = Nodes.MarkNode.new(self._CurrentNode)
    return self
end

function HyperText:Clone()
    local clonedRootNode = self._RootNode:Clone()
    local clonedCurrentNode = clonedRootNode

    local childNode = clonedCurrentNode:GetChildren(true)[1]
    while childNode do
        clonedCurrentNode = childNode
        childNode = clonedCurrentNode:GetChildren(true)[1]
    end

    return setmetatable({
        _RootNode = clonedRootNode,
        _CurrentNode = clonedCurrentNode
    } :: Types.IHyperText, HyperText)
end

function HyperText:Finalize(input)
    local children = self._RootNode:GetChildren()
    if #children == 0 then
        return Entities.Encode(input)
    end

    local textNode = Nodes.TextNode.new(input, self._CurrentNode)
    local str = children[1]:ToString()

    textNode:Destroy()
    return str
end

return HyperText
