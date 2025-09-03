local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local StrikethroughNode = {} :: NodesTypes.StrikethroughNodeImpl
StrikethroughNode.__index = setmetatable(StrikethroughNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function StrikethroughNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "StrikethroughNode",
        Tag = "s",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IStrikethroughNode) :: any, StrikethroughNode) :: NodesTypes.StrikethroughNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return StrikethroughNode
