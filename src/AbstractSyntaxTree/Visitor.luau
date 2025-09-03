local t = require("@pkg/t")

local Types = require("./Types")
local NodeTypes = require("./Node/Types")

local Visitor = {} :: Types.VisitorImpl
Visitor.__index = Visitor

function Visitor.new()
    return setmetatable({
        IsVisiting = false,
        ShouldStopVisiting = false,

        TextNode = nil,
        BasicNode = nil,
        FontNode = nil,
        StrokeNode = nil,
        BoldNode = nil,
        ItalicNode = nil,
        UnderlineNode = nil,
        StrikethroughNode = nil,
        LineBreakNode = nil,
        UppercaseNode = nil,
        SmallcapsNode = nil,
        MarkNode = nil,
        CommentNode = nil,
    } :: Types.IVisitor, Visitor)
end

local function visitorCall(self: Types.Visitor, node: NodeTypes.Node, nodeVisitor: (node: NodeTypes.Node) -> boolean?)
    local valid = t.callback(nodeVisitor)
    if not valid then
        self.IsVisiting = false
        self.ShouldStopVisiting = false

        assert(t.callback(nodeVisitor)) --// The type error forces us to do this instead of caching the error...
    end

    local success, err = pcall(function()
        self.ShouldStopVisiting = nodeVisitor(node) == true
    end)

    if not success then
        self.IsVisiting = false
        self.ShouldStopVisiting = false

        error(err)
    end
end

local visitSyntaxTreeArgCheck = t.tuple(t.interface({
    RootNode = NodeTypes.NodeCheck
} :: any))

function Visitor:VisitSyntaxTree(syntaxTree)
    assert(visitSyntaxTreeArgCheck(syntaxTree))
    self:VisitNode(syntaxTree.RootNode)
end

local visitNodeArgCheck = t.tuple(NodeTypes.NodeCheck)
function Visitor:VisitNode(node)
    assert(visitNodeArgCheck(node))

    local isVisitLeader = not self.IsVisiting
    self.IsVisiting = true

    if self.ShouldStopVisiting then
        return
    end

    if self.Node then
        visitorCall(self, node, self.Node)
    end

    if self[node.Type] then
        visitorCall(self, node, self[node.Type])
    end

    for _, node in node:GetChildren(true) do
        assert(NodeTypes.NodeCheck(node :: any))
        self:VisitNode(node)

        if self.ShouldStopVisiting then
            break
        end
    end

    if isVisitLeader then
        self.IsVisiting = false
        self.ShouldStopVisiting = false
    end
end

return Visitor
