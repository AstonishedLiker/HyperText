local Types = require("./Types")
local Visitor = require("./Visitor")

local NodesTypes = require("./Node/NodesTypes")
local NodeTypes = require("./Node/Types")
local BasicNode = require("./Node/Nodes").BasicNode

local AbstractSyntaxTree = {} :: Types.AbstractSyntaxTreeImpl
AbstractSyntaxTree.__index = AbstractSyntaxTree

function AbstractSyntaxTree.new()
    return setmetatable({
        Error = nil,
        RootNode = BasicNode.new(),
    } :: Types.IAbstractSyntaxTree, AbstractSyntaxTree)
end

function AbstractSyntaxTree:ToString()
    local str = ""

    for _, childNode in self.RootNode:GetChildren(true) do
        str ..= childNode:ToString()
    end

    return str
end

return AbstractSyntaxTree
