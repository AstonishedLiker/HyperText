local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local UnderlineNode = {} :: NodesTypes.UnderlineNodeImpl
UnderlineNode.__index = setmetatable(UnderlineNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function UnderlineNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "UnderlineNode",
        Tag = "u",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IUnderlineNode) :: any, UnderlineNode) :: NodesTypes.UnderlineNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return UnderlineNode
