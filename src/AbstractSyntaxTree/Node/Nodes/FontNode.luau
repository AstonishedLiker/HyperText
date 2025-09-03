local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local FontNode = {} :: NodesTypes.FontNodeImpl
FontNode.__index = setmetatable(FontNode, Node)

local ctorArgCheck = t.tuple(t.optional(Types.NodeCheck :: any))
function FontNode.new(parent)
    assert(ctorArgCheck(parent))

    local self = setmetatable(({
        IsValid = true,
        Tag = "font",
        Type = "FontNode",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.IFontNode) :: any, FontNode) :: NodesTypes.FontNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

return FontNode
