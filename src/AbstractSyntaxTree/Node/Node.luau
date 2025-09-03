local t = require("@pkg/t")

local Types = require("./Types")

local Entities = require("../Entities")

local Node = {} :: Types.NodeImpl
Node.__index = Node

local function setRawParent(self: Types.Node, newParent: Types.Node?)
    local oldParent = self._Parent
    self._Parent = newParent

    if newParent then
        table.insert(newParent._Children, self)
    end

    if not oldParent then
        return
    end

    table.remove(oldParent._Children, table.find(oldParent._Children, self))
end

function Node:Destroy()
    setRawParent(self, nil)
end

function Node:GetParent()
    return self._Parent
end

local setParentArgCheck = t.tuple(Types.NodeCheck)
function Node:SetParent(newParent)
    assert(setParentArgCheck(newParent))
    setRawParent(self, newParent)
end

function Node:GetChildren()
    return table.clone(self._Children)
end

function Node:IsDescendantOf(ancestor)
    local parent = self:GetParent()

    while parent do
        if parent == ancestor then
            return true
        end

        parent = parent:GetParent()
    end

    return false
end

function Node:IsAncestorOf(descendant)
    local parent = descendant:GetParent()

    while parent do
        if parent == self then
            return true
        end

        parent = parent:GetParent()
    end

    return false
end

function Node:Clone()
    local newINode = {
        _Children = {}
    } :: Types.INode

    for member, value in (self :: any) :: Types.INode do
        if member == "_Parent" or member == "_Children" then
            continue
        end

        if type(value) == "table" then
            value = table.clone(value :: {})
        end

        newINode[member] = value
    end

    local newNode = setmetatable(newINode, getmetatable(self))
    for _, childNode in self:GetChildren(true) do
        childNode:Clone():SetParent(newNode)
    end

    return newNode
end

function Node:ToString()
    local str = `<{self.Tag}`
    local children = self:GetChildren(true)

    if #children == 0 then
        return `{str}/>`
    end

    for attribute, value in self.Attributes do
        str ..= ` {attribute}="{Entities.Encode(value)}"`
    end

    str ..= ">"
    for _, childNode in children do
        str ..= childNode:ToString()
    end

    return `{str}</{self.Tag}>`
end

return Node
