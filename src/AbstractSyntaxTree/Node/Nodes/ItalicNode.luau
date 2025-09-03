local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local ItalicNode = {} :: NodesTypes.ItalicNodeImpl
ItalicNode.__index = setmetatable(ItalicNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function ItalicNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "ItalicNode",
        Tag = "i",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IItalicNode) :: any, ItalicNode) :: NodesTypes.ItalicNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return ItalicNode
