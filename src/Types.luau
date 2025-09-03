local NodeTypes = require("./AbstractSyntaxTree/Node/Types")

--[[
    The `HyperText` interface.
]]
export type IHyperText = {
    --[[
        **`(PRIVATE MEMBER)` - Not meant for public use.**

        The root node which stores the collection of nodes this `HyperText` object holds.
    ]]
    _RootNode: NodeTypes.Node,

    --[[
        **`(PRIVATE MEMBER)` - Not meant for public use.**

        The current node.
    ]]
    _CurrentNode: NodeTypes.Node,
}

--[[
    The `HyperText` method implementations.
]]
export type HyperTextImpl = {
    __index: HyperTextImpl,

    --[[
        Constructs a HyperText object.

        @return A blank `HyperText` object.
    ]]
    new: () -> HyperText,

    --[[
        Adds a font modifier.

        @return The current `HyperText` object.
    ]]
    Font: (self: HyperText) -> HyperText,

    --[[
        Adds a color modifier to the previous node (must be a `FontNode`, `StrokeNode` or `MarkNode`).

        @param color The color.

        @return The current `HyperText` object.
    ]]
    Color: (self: HyperText, color: Color3) -> HyperText,

    --[[
        Adds a size modifier to the previous `TextNode`.

        @param size The size.

        @return The current `HyperText` object.
    ]]
    Size: (self: HyperText, size: number) -> HyperText,

    --[[
        Adds a transparency modifier to the previous node (must be a `FontNode`, `StrokeNode` or `MarkNode`).

        @param transparency The transparency.

        @return The current `HyperText` object.
    ]]
    Transparency: (self: HyperText, transparency: number) -> HyperText,

    --[[
        Adds a face modifier to the previous `TextNode`.

        @param face The face.

        @return The current `HyperText` object.
    ]]
    Face: (self: HyperText, face: string) -> HyperText,

    --[[
        Adds a family modifier to the previous `TextNode`.

        @param family The family.

        @return The current `HyperText` object.
    ]]
    Family: (self: HyperText, family: string) -> HyperText,

    --[[
        Adds a weight modifier to the previous `TextNode`.

        @param weight The weight.

        @return The current `HyperText` object.
    ]]
    Weight: (self: HyperText, weight: number) -> HyperText,

    --[[
        Adds a corner style modifier to the previous `StrokeNode`.

        @param joins The corner style.

        @return The current `HyperText` object.
    ]]
    Joins: (self: HyperText, joins: "Round" | "Bevel" | "Miter") -> HyperText,

    --[[
        Adds a thickness modifier to the previous `StrokeNode`.

        @param thickness The thickness.

        @return The current `HyperText` object.
    ]]
    Thickness: (self: HyperText, thickness: number) -> HyperText,

    --[[
        Adds a stroke modifier.

        @return The current `HyperText` object.
    ]]
    Stroke: (self: HyperText) -> HyperText,

    --[[
        Adds a bold modifier.

        @return The current `HyperText` object.
    ]]
    Bold: (self: HyperText) -> HyperText,

    --[[
        Adds an italic modifier.

        @return The current `HyperText` object.
    ]]
    Italic: (self: HyperText) -> HyperText,

    --[[
        Adds an underline modifier.

        @return The current `HyperText` object.
    ]]
    Underline: (self: HyperText) -> HyperText,

    --[[
        Adds a strikethrough modifier.

        @return The current `HyperText` object.
    ]]
    Strikethrough: (self: HyperText) -> HyperText,

    --[[
        Adds a line break modifier.

        @return The current `HyperText` object.
    ]]
    NewLine: (self: HyperText) -> HyperText,

    --[[
        Adds an uppercase modifier.

        @return The current `HyperText` object.
    ]]
    Uppercase: (self: HyperText) -> HyperText,

    --[[
        Adds a smallcaps modifier.

        @return The current `HyperText` object.
    ]]
    Smallcaps: (self: HyperText) -> HyperText,

    --[[
        Adds a mark modifier.

        @return The current `HyperText` object.
    ]]
    Mark: (self: HyperText) -> HyperText,

    --[[
        Clone the `HyperText` object.

        @return The cloned `HyperText` object.
    ]]
    Clone: (self: HyperText) -> HyperText,

    --[[
        Applies the modifiers to the input string.

        @param input The input string to modify.

        @return The modified input string.
    ]]
    Finalize: (self: HyperText, input: string) -> string
}

--[[
    An object for text manipulation for Roblox RichText.
]]
export type HyperText = typeof(setmetatable({} :: IHyperText, {} :: HyperTextImpl))

return nil
