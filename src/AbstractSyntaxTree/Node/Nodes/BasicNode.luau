local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local BasicNode = {} :: NodesTypes.BasicNodeImpl
BasicNode.__index = setmetatable(BasicNode, Node)

local ctorArgCheck = t.tuple(t.optional(t.string :: any), t.optional(Types.NodeCheck :: any))
function BasicNode.new(tag, parent)
    assert(ctorArgCheck(tag, parent))

    local self = setmetatable(({
        IsValid = true,
        Type = "BasicNode",
        Tag = tag,
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IBasicNode) :: any, BasicNode) :: NodesTypes.BasicNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

--// Override
function BasicNode:ToString()
    assert(self.Tag, "Cannot call ToString on a root node")
    return Node.ToString(self) --// Pass to original ToString
end

return BasicNode
