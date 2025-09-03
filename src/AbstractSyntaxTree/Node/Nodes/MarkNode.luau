local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local MarkNode = {} :: NodesTypes.MarkNodeImpl
MarkNode.__index = setmetatable(MarkNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function MarkNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "MarkNode",
        Tag = "mark",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IMarkNode) :: any, MarkNode) :: NodesTypes.MarkNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return MarkNode
