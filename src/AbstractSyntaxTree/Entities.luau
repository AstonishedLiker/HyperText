local t = require("@pkg/t")

local Entities = {}
Entities.UnescapeMap = table.freeze {
    ["&lt;"] = "<",
    ["&gt;"] = ">",
    ["&quot;"] = '"',
    ["&apos;"] = "'",
    ["&amp;"] = "&"
}

Entities.EscapeMap = table.freeze {
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&apos;",
    ["&"] = "&amp;"
}

local stringInputArgCheck = t.tuple(t.string)
function Entities.Decode(str: string): string
    assert(stringInputArgCheck(str))

    for escape, input in pairs(Entities.UnescapeMap) do
        str = string.gsub(str, escape, input)
    end

    return str
end

function Entities.Encode(str: string): string
    assert(stringInputArgCheck(str))

    for input, escape in pairs(Entities.EscapeMap) do
        str = string.gsub(str, input, escape)
    end

    return str
end

return Entities
