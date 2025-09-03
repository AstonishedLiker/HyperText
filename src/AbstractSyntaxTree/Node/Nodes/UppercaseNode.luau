local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local UppercaseNode = {} :: NodesTypes.UppercaseNodeImpl
UppercaseNode.__index = setmetatable(UppercaseNode, Node)

local ctorArgCheck = t.tuple(t.optional(t.literal_list({"uc", "uppercase"}) :: any), t.optional(Types.NodeCheck :: any))
function UppercaseNode.new(tag, parent)
    assert(ctorArgCheck(tag, parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "UppercaseNode",
        Tag = tag :: string,
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IUppercaseNode) :: any, UppercaseNode) :: NodesTypes.UppercaseNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return UppercaseNode
