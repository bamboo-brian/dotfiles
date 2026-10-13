-- Portable preferences, with machine-local options before and overrides after.
local config_home = os.getenv("XDG_CONFIG_HOME")
if not config_home or config_home == "" then
    config_home = os.getenv("HOME") .. "/.config"
end
local config_dir = config_home .. "/hypr"
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

local function load_local(name)
    local path = config_dir .. "/" .. name .. ".lua"
    local file, message, code = io.open(path, "r")
    if not file then
        if code == 2 then return nil end -- Optional file does not exist.
        error(message)
    end
    file:close()
    return dofile(path)
end

local options = {
    modifier = "SUPER",
    workspace_count = 3,
    monitors = {},
    commands = {},
}
local overrides = load_local("local-options") or {}
for key, value in pairs(overrides) do options[key] = value end
assert(type(options.workspace_count) == "number"
    and options.workspace_count % 1 == 0
    and options.workspace_count >= 1 and options.workspace_count <= 10,
    "workspace_count must be an integer from 1 to 10")
assert(#options.monitors <= 10, "at most 10 numbered monitors are supported")

require("shared.colors")
require("shared.animations")
require("shared.decorations")
require("shared.inputs")
require("shared.misc")
require("shared.windowrules")
require("shared.binds")(options)

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
load_local("local-settings")
