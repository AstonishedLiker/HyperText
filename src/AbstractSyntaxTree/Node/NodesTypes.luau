local Types = require("./Types")

--// Text Node
--[[
    The `TextNode` interface.
]]
export type ITextNode = {
    --[[
        The type of the node.
    ]]
    Type: "TextNode",

    --[[
        The text stored inside this node.
    ]]
    Content: string
} & Types.INode

--[[
    The `TextNode` method implementations.
]]
export type TextNodeImpl = {
    __index: typeof(setmetatable({} :: TextNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `TextNode` node with an optional parent.

        @param content The text stored inside the node.
        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (content: string, parent: Types.Node?) -> TextNode
}

--[[
    An object used to represent text inside the syntax tree.
]]
export type TextNode = Types.Node & typeof(setmetatable({} :: ITextNode, {} :: TextNodeImpl))

--// Basic Node
--[[
    The `BasicNode` interface.
]]
export type IBasicNode = {
    --[[
        The type of the node.
    ]]
    Type: "BasicNode"
} & Types.INode

--[[
    The `BasicNode` method implementations.
]]
export type BasicNodeImpl = {
    __index: typeof(setmetatable({} :: BasicNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `BasicNode` node with an optional parent.

        @param parent The parent of the node to create, if any.
        @param tag The tag of the node.

        @return The created node.
    ]]
    new: (tag: string?, parent: Types.Node?) -> BasicNode
}

--[[
    An object used to represent a uncategorized node (often unknown) inside the syntax tree.
]]
export type BasicNode = Types.Node & typeof(setmetatable({} :: IBasicNode, {} :: BasicNodeImpl))

--// Font Node
--[[
    The `FontNode` interface.
]]
export type IFontNode = {
    --[[
        The type of the node.
    ]]
    Type: "FontNode",

    --[[
        The font's color, if specified.
    ]]
    Color: Color3?,

    --[[
        The font's size, if specified.
    ]]
    Size: number?,

    --[[
        The font's face, if specified.
    ]]
    Face: string?,

    --[[
        The font's family, if specified.
    ]]
    Family: string?,

    --[[
        The font's weight, if specified.
    ]]
    Weight: number?,

    --[[
        The font's transparency, if specified.
    ]]
    Transparency: number?
} & Types.INode

--[[
    The `FontNode` method implementations.
]]
export type FontNodeImpl = {
    __index: typeof(setmetatable({} :: FontNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `FontNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> FontNode
}

--[[
    An object used to represent font nodes inside the syntax tree.
]]
export type FontNode = Types.Node & typeof(setmetatable({} :: IFontNode, {} :: FontNodeImpl))

--// Stroke Node
--[[
    The `StrokeNode` interface.
]]
export type IStrokeNode = {
    --[[
        The type of the node.
    ]]
    Type: "StrokeNode",

    --[[
        The stroke's color, if specified.
    ]]
    Color: Color3?,

    --[[
        The stroke's corner style, if specified.
    ]]
    Joins: ("Round" | "Bevel" | "Miter")?,

    --[[
        The stroke's thickness, if specified.
    ]]
    Thickness: number?,

    --[[
        The stroke's transparency, if specified.
    ]]
    Transparency: number?
} & Types.INode

--[[
    The `StrokeNode` method implementations.
]]
export type StrokeNodeImpl = {
    __index: typeof(setmetatable({} :: StrokeNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `StrokeNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> StrokeNode
}

--[[
    An object used to represent a stroke node inside the syntax tree.
]]
export type StrokeNode = Types.Node & typeof(setmetatable({} :: IStrokeNode, {} :: StrokeNodeImpl))

--// Bold Node
--[[
    The `BoldNode` interface.
]]
export type IBoldNode = {
    --[[
        The type of the node.
    ]]
    Type: "BoldNode"
} & Types.INode

--[[
    The `BoldNode` method implementations.
]]
export type BoldNodeImpl = {
    __index: typeof(setmetatable({} :: BoldNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `BoldNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> BoldNode
}

--[[
    An object used to represent a bold node inside the syntax tree.
]]
export type BoldNode = Types.Node & typeof(setmetatable({} :: IBoldNode, {} :: BoldNodeImpl))

--// Italic Node
--[[
    The `ItalicNode` interface.
]]
export type IItalicNode = {
    --[[
        The type of the node.
    ]]
    Type: "ItalicNode"
} & Types.INode

--[[
    The `ItalicNode` method implementations.
]]
export type ItalicNodeImpl = {
    __index: typeof(setmetatable({} :: ItalicNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `ItalicNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> ItalicNode
}

--[[
    An object used to represent an italic node inside the syntax tree.
]]
export type ItalicNode = Types.Node & typeof(setmetatable({} :: IItalicNode, {} :: ItalicNodeImpl))

--// Underline Node
--[[
    The `UnderlineNode` interface.
]]
export type IUnderlineNode = {
    --[[
        The type of the node.
    ]]
    Type: "UnderlineNode"
} & Types.INode

--[[
    The `UnderlineNode` method implementations.
]]
export type UnderlineNodeImpl = {
    __index: typeof(setmetatable({} :: UnderlineNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `UnderlineNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> UnderlineNode
}

--[[
    An object used to represent an underline node inside the syntax tree.
]]
export type UnderlineNode = Types.Node & typeof(setmetatable({} :: IUnderlineNode, {} :: UnderlineNodeImpl))

--// Strikethrough Node
--[[
    The `StrikethroughNode` interface.
]]
export type IStrikethroughNode = {
    --[[
        The type of the node.
    ]]
    Type: "StrikethroughNode"
} & Types.INode

--[[
    The `StrikethroughNode` method implementations.
]]
export type StrikethroughNodeImpl = {
    __index: typeof(setmetatable({} :: StrikethroughNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `StrikethroughNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> StrikethroughNode
}

--[[
    An object used to represent a strikethrough node inside the syntax tree.
]]
export type StrikethroughNode = Types.Node & typeof(setmetatable({} :: IStrikethroughNode, {} :: StrikethroughNodeImpl))

--// Line Break Node
--[[
    The `LineBreakNode` interface.
]]
export type ILineBreakNode = {
    --[[
        The type of the node.
    ]]
    Type: "LineBreakNode"
} & Types.INode

--[[
    The `LineBreakNode` method implementations.
]]
export type LineBreakNodeImpl = {
    __index: typeof(setmetatable({} :: LineBreakNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `LineBreakNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> LineBreakNode
}

--[[
    An object used to represent a line break node inside the syntax tree.
]]
export type LineBreakNode = Types.Node & typeof(setmetatable({} :: ILineBreakNode, {} :: LineBreakNodeImpl))

--// Uppercase Node
--[[
    The `UppercaseNode` interface.
]]
export type IUppercaseNode = {
    --[[
        The type of the node.
    ]]
    Type: "UppercaseNode"
} & Types.INode

--[[
    The `UppercaseNode` method implementations.
]]
export type UppercaseNodeImpl = {
    __index: typeof(setmetatable({} :: UppercaseNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `UppercaseNode` node with an optional parent.

        @param tag The tag used to generate the node.
        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (tag: "uc" | "uppercase", parent: Types.Node?) -> UppercaseNode
}

--[[
    An object used to represent an uppercase node inside the syntax tree.
]]
export type UppercaseNode = Types.Node & typeof(setmetatable({} :: IUppercaseNode, {} :: UppercaseNodeImpl))

--// Smallcaps Node
--[[
    The `SmallcapsNode` interface.
]]
export type ISmallcapsNode = {
    --[[
        The type of the node.
    ]]
    Type: "SmallcapsNode"
} & Types.INode

--[[
    The `SmallcapsNode` method implementations.
]]
export type SmallcapsNodeImpl = {
    __index: typeof(setmetatable({} :: SmallcapsNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `SmallcapsNode` node with an optional parent.

        @param parent The parent of the node to create, if any.
        @param tag The tag used to generate the node.

        @return The created node.
    ]]
    new: (tag: "sc" | "smallcaps", parent: Types.Node?) -> SmallcapsNode
}

--[[
    An object used to represent a smallcaps node inside the syntax tree.
]]
export type SmallcapsNode = Types.Node & typeof(setmetatable({} :: ISmallcapsNode, {} :: SmallcapsNodeImpl))

--// Mark Node
--[[
    The `MarkNode` interface.
]]
export type IMarkNode = {
    --[[
        The type of the node.
    ]]
    Type: "MarkNode",

    --[[
        The mark's color, if specified.
    ]]
    Color: Color3?,

    --[[
        The mark's transparency, if specified.
    ]]
    Transparency: number?
} & Types.INode

--[[
    The `MarkNode` method implementations.
]]
export type MarkNodeImpl = {
    __index: typeof(setmetatable({} :: MarkNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `MarkNode` node with an optional parent.

        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (parent: Types.Node?) -> MarkNode
}

--[[
    An object used to represent a mark node inside the syntax tree.
]]
export type MarkNode = Types.Node & typeof(setmetatable({} :: IMarkNode, {} :: MarkNodeImpl))

--// Comment Node
--[[
    The `CommentNode` interface.
]]
export type ICommentNode = {
    --[[
        The type of the node.
    ]]
    Type: "CommentNode",

    --[[
        The text stored inside the comment.
    ]]
    Content: string
} & Types.INode

--[[
    The `CommentNode` method implementations.
]]
export type CommentNodeImpl = {
    __index: typeof(setmetatable({} :: CommentNodeImpl, {} :: Types.NodeImpl)),

    --[[
        Creates a `CommentNode` node with an optional parent.

        @param content The text stored inside the node.
        @param parent The parent of the node to create, if any.

        @return The created node.
    ]]
    new: (content: string, parent: Types.Node?) -> CommentNode
}

--[[
    An object used to represent a Comment node inside the syntax tree.
]]
export type CommentNode = Types.Node & typeof(setmetatable({} :: ICommentNode, {} :: CommentNodeImpl))

return nil
