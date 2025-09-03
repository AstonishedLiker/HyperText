--// For lune support, please do not use

if string.sub(_VERSION, 1, 4) ~= "Lune" then
    return (Color3 :: any) :: typeof(Color3)
else
    return (require)("@lune/roblox").Color3 :: typeof(Color3)
end