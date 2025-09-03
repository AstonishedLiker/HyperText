local t = require("@pkg/t")

local Types = require("../Types")
local NodesTypes = require("../NodesTypes")

local Node = require("../Node")

local CommentNode = {} :: NodesTypes.CommentNodeImpl
CommentNode.__index = setmetatable(CommentNode, Node)

local ctorArgCheck =  t.tuple(t.string, Types.NodeCheck)
function CommentNode.new(content, parent)
    assert(ctorArgCheck(content, parent))

    local self = setmetatable(({
        IsValid = true,
        Tag = "",
        Type = "CommentNode",
        Attributes = {},
        _Children = {}
    } :: NodesTypes.ICommentNode) :: any, CommentNode) :: NodesTypes.CommentNode

    if parent then
        self:SetParent(parent)
    end

    return self
end

--// Override
function CommentNode:ToString()
    return `<!--{(self :: NodesTypes.CommentNode).Content}-->`
end

return CommentNode
