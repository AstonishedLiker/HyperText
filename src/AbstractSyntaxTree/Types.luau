local Types = require("./Node/Types")
local NodesTypes = require("./Node/NodesTypes")

--[[
    The parser methods.
]]
export type Parser = {
    --[[
        Parses an input string.

        @param input The input to parse.

        @return A syntax tree.
    ]]
    Parse: (input: string) -> AbstractSyntaxTree,
}

--[[
    The `IVisitor` interface.

    Each member represents a node type and its corresponding callback.
    If the visitor returns true, the visitor will stop visiting.
]]
export type IVisitor = {
    --[[
        Whether this visitor is currently visiting.
    ]]
    IsVisiting: boolean,

    --[[
        Whether a callback asked the visitor to stop visiting.
    ]]
    ShouldStopVisiting: boolean,

    Node: ((node: Types.Node) -> boolean?)?,
    TextNode: ((node: NodesTypes.TextNode) -> boolean?)?,
    BasicNode: ((node: NodesTypes.BasicNode) -> boolean?)?,
    FontNode: ((node: NodesTypes.FontNode) -> boolean?)?,
    StrokeNode: ((node: NodesTypes.StrokeNode) -> boolean?)?,
    BoldNode: ((node: NodesTypes.BoldNode) -> boolean?)?,
    ItalicNode: ((node: NodesTypes.ItalicNode) -> boolean?)?,
    UnderlineNode: ((node: NodesTypes.UnderlineNode) -> boolean?)?,
    StrikethroughNode: ((node: NodesTypes.StrikethroughNode) -> boolean?)?,
    LineBreakNode: ((node: NodesTypes.LineBreakNode) -> boolean?)?,
    UppercaseNode: ((node: NodesTypes.UppercaseNode) -> boolean?)?,
    SmallcapsNode: ((node: NodesTypes.SmallcapsNode) -> boolean?)?,
    MarkNode: ((node: NodesTypes.MarkNode) -> boolean?)?,
    CommentNode: ((node: NodesTypes.CommentNode) -> boolean?)?,
}

--[[
    The `VisitorImpl` method implementations.
]]
export type VisitorImpl = {
    __index: VisitorImpl,

    --[[
        Creates a blank syntax tree visitor.

        @return A blank syntax tree visitor.
    ]]
    new: () -> Visitor,

    --[[
        Visits a syntax tree.

        @param syntaxTree The syntax tree to visit.
    ]]
    VisitSyntaxTree: (self: Visitor, syntaxTree: AbstractSyntaxTree) -> (),

    --[[
        Visits a node.

        @param node The node to visit.
    ]]
    VisitNode: (self: Visitor, node: Types.Node) -> ()
}

--[[
    An object used to represent a visitor that traverses a syntax tree.
]]
export type Visitor = typeof(setmetatable({} :: IVisitor, {} :: VisitorImpl))

--[[
    The `AbstractSyntaxTree` interface.
]]
export type IAbstractSyntaxTree = {
    --[[
        An error produced by the parser if the syntax tree is valid.
    ]]
    Error: string?,

    --[[
        The root node which stores the collection of nodes this syntax tree holds.
    ]]
    RootNode: NodesTypes.BasicNode
}

--[[
    The `AbstractSyntaxTree` method implementations.
]]
export type AbstractSyntaxTreeImpl = {
    __index: AbstractSyntaxTreeImpl,

    --[[
        Creates a blank syntax tree.

        @return A blank syntax tree.
    ]]
    new: () -> AbstractSyntaxTree,

    --[[
        Converts the syntax tree back to a string in RichText form.

        @return The syntax tree into RichText form.
    ]]
    ToString: (self: AbstractSyntaxTree) -> string,
}

--[[
    An object used to represent Roblox RichText syntax programmatically.
]]
export type AbstractSyntaxTree = typeof(setmetatable({} :: IAbstractSyntaxTree, {} :: AbstractSyntaxTreeImpl))

return nil
