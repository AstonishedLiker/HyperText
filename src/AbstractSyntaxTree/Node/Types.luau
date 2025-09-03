local t = require("@pkg/t")

--[[
    The possible types of nodes.
]]
export type NodeType =
    --// A node with no element linked to it; e.g. "Hi!"
    "TextNode" |
    --// An unknown node; e.g. "<IAmUnknown a='b'>Hello</IAmUnknown>"
    "BasicNode" |
    --// Roblox Nodes (cf. https://create.roblox.com/docs/ui/rich-text)
    "FontNode" |
    "StrokeNode" |
    "BoldNode" |
    "ItalicNode" |
    "UnderlineNode" |
    "StrikethroughNode" |
    "LineBreakNode" |
    "UppercaseNode" |
    "SmallcapsNode" |
    "MarkNode" |
    "CommentNode"

--[[
    The `Node` interface.
]]
export type INode = {
    --[[
        Whether the node has been parsed correctly.
    ]]
    IsValid: boolean,

    --[[
        The type of the node.
    ]]
    Type: NodeType,

    --[[
        The tag name of the node. This determines the node type.
    ]]
    Tag: string,

    --[[
        The attributes that this node has.
    ]]
    Attributes: {[string]: string},

    --[[
        **`(PRIVATE MEMBER)` - Not meant for public use.**

        The children of the node.
    ]]
    _Children: {Node},

    --[[
        **`(PRIVATE MEMBER)` - Not meant for public use.**

        The parent of the node, if any.
    ]]
    _Parent: Node?
}

--[[
    The `Node` method implementations.
]]
export type NodeImpl = {
    __index: NodeImpl,

    --[[
        Destroys the node.
    ]]
    Destroy: (self: Node) -> (),

    --[[
        Gets the parent of the node.

        @return The parent of the node.
    ]]
    GetParent: (self: Node) -> Node?,

    --[[
        Sets the parent of the node.

        @param newParent The new parent of the node.
    ]]
    SetParent: (self: Node, newParent: Node) -> (),

    --[[
        Gets the children of the node.

        @param returnAsIs Does not perform cloning. If true, modifying the function's output will cause undefined behavior.

        @return The children of the node.
    ]]
    GetChildren: (self: Node, returnAsIs: boolean?) -> typeof(({} :: INode)._Children),

    --[[
        Checks whether the node is a descendant of another node.

        @param ancestor The node to check the ancestry against.

        @return Whether the node is a descendant of the specified node.
    ]]
    IsDescendantOf: (self: Node, ancestor: Node) -> boolean,

    --[[
        Checks whether the node is an ancestor of another node.

        @param descendant The node to check the ancestry against.

        @return Whether the node is an ancestor of the specified node.
    ]]
    IsAncestorOf: (self: Node, descendant: Node) -> boolean,

    --[[
        Clones the node and its descendants. Its parent isn't set.

        @return The cloned node.
    ]]
    Clone: (self: Node) -> Node,

    --[[
        Converts a node and its descendants to a string.

        @return The node and its descendants as a string.
    ]]
    ToString: (self: Node) -> string
}

--[[
    An object used to represent a Roblox RichText element programmatically.
]]
export type Node = typeof(setmetatable({} :: INode, {} :: NodeImpl))

--// Runtime type checks
local nodeCheck do
    local childrenCheck, parentCheck

    nodeCheck = t.interface({
        Type = t.string,
        Attributes = t.map(t.string :: any, t.string :: any),
        _Children = childrenCheck,
        _Parent = parentCheck
    } :: any)

    childrenCheck, parentCheck = t.array(nodeCheck :: any), nodeCheck
end

return {
    NodeCheck = nodeCheck
}
