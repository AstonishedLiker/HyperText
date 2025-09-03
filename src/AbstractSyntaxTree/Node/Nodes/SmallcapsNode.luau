local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local SmallcapsNode = {} :: NodesTypes.SmallcapsNodeImpl
SmallcapsNode.__index = setmetatable(SmallcapsNode, Node)

local ctorArgCheck = t.tuple(t.optional(t.literal_list({"sc", "smallcaps"}) :: any), t.optional(Types.NodeCheck :: any))
function SmallcapsNode.new(tag, parent)
    assert(ctorArgCheck(tag, parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "SmallcapsNode",
        Tag = tag :: string,
        Attributes = {},
        _Children = {}
    } :: NodesTypes.ISmallcapsNode) :: any, SmallcapsNode) :: NodesTypes.SmallcapsNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return SmallcapsNode
