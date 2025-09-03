local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local LineBreakNode = {} :: NodesTypes.LineBreakNodeImpl
LineBreakNode.__index = setmetatable(LineBreakNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function LineBreakNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "LineBreakNode",
        Tag = "br",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.ILineBreakNode) :: any, LineBreakNode) :: NodesTypes.LineBreakNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return LineBreakNode
