local process = require("@lune/process")
local fs = require("@lune/fs")

pcall(fs.removeDir, "build")
fs.copy(".", "build/temp")

print(`Generating sourcemap in: '{process.cwd}/build/temp'...`)
local sourcemapSpawnResult = process.spawn("rojo", {"sourcemap", "--output", `sourcemap.json`}, {
    cwd = `build/temp`
})

assert(sourcemapSpawnResult.ok, sourcemapSpawnResult.stderr)
print(sourcemapSpawnResult.stdout)

print(`Transforming with darklua in: '{process.cwd}/build/temp'...`)
local darkluaSpawnResult = process.spawn("darklua", {"process", `src`, `src`}, {
    cwd = `build/temp`
})

assert(darkluaSpawnResult.ok, darkluaSpawnResult.stderr)
print(darkluaSpawnResult.stdout)

print(`Running 'rojo build' in: '{process.cwd}/build'...`)
local buildSpawnResult = process.spawn("rojo", {"build", "--output", `../HyperText.rbxm`}, {
    cwd = `build/temp`
})

assert(buildSpawnResult.ok, buildSpawnResult.stderr)
print(buildSpawnResult.stdout)

print("The built file is in './build/' with the name 'HyperText.rbxm'!")