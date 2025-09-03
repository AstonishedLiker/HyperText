local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local BoldNode = {} :: NodesTypes.BoldNodeImpl
BoldNode.__index = setmetatable(BoldNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function BoldNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Tag = "b",
        Type = "BoldNode",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IBoldNode) :: any, BoldNode) :: NodesTypes.BoldNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return BoldNode
