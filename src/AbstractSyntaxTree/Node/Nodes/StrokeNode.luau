local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local StrokeNode = {} :: NodesTypes.StrokeNodeImpl
StrokeNode.__index = setmetatable(StrokeNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function StrokeNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "StrokeNode",
        Tag = "stroke",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IStrokeNode) :: any, StrokeNode) :: NodesTypes.StrokeNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return StrokeNode
