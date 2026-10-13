return function(options)
    local mainMod = options.modifier
    local NUM_WPM = options.workspace_count
    local function command(name)
        local cmd = options.commands[name]
        if cmd and cmd ~= "" then
            return hl.dsp.exec_cmd(cmd)
        end
    end
    local function bind_command(keys, name, flags)
        local dispatcher = command(name)
        if dispatcher then hl.bind(keys, dispatcher, flags) end
    end

    -- AZERTY fix: the number-row keys emit symbols (& é " ' ...) without Shift, so
    -- binding to the digit characters fails. Bind by physical keycode instead.
    -- Digit d -> evdev keycode: 1..9 => 10..18, 0 => 19
    local function digitCode(d)
        return "code:" .. (d == 0 and 19 or (9 + d))
    end

    ---------------------------
    ---- WINDOW MANAGEMENT ----
    ---------------------------

    -- Window manipulation
    hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"))
    hl.bind(mainMod .. " + W",           hl.dsp.window.close())
    hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
    hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
    hl.bind(mainMod .. " + S",           hl.dsp.layout("togglesplit"))

    -- Change focus
    hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))
    hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())
    bind_command(mainMod .. " + Tab", "window_switcher")

    -- Move active window around workspaces & monitors
    hl.bind(mainMod .. " + SHIFT + H",                 hl.dsp.window.move({ direction = "l" }))
    hl.bind(mainMod .. " + SHIFT + L",                hl.dsp.window.move({ direction = "r" }))
    hl.bind(mainMod .. " + SHIFT + K",                   hl.dsp.window.move({ direction = "u" }))
    hl.bind(mainMod .. " + SHIFT + J",                 hl.dsp.window.move({ direction = "d" }))
    hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }))
    hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }))
    hl.bind(mainMod .. " + ALT + SHIFT + H",       hl.dsp.window.move({ workspace = "m-1" }))
    hl.bind(mainMod .. " + ALT + SHIFT + L",      hl.dsp.window.move({ workspace = "m+1" }))
    hl.bind(mainMod .. " + ALT + SHIFT + J",      hl.dsp.window.move({ workspace = "emptym" }))
    hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }))
    hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))
    for i = 1, NUM_WPM do
        local key = i % 10
        hl.bind(mainMod .. " + SHIFT + CONTROL + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i }))
    end
    for i = 1, NUM_WPM do
        local key = i % 10
        hl.bind(mainMod .. " + SHIFT + ALT + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i, follow = false }))
    end

    -- Move & Resize with mouse
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

    -- Zoom
    local function zoomfunction(value)
        local zoomvalue = hl.get_config("cursor:zoom_factor")
        if (zoomvalue + value) > 3.0 then
            hl.config({ cursor = { zoom_factor = 3.0 } })
        elseif (zoomvalue + value) < 1.0 then
            hl.config({ cursor = { zoom_factor = 1.0 } })
        else
            hl.config({ cursor = { zoom_factor = zoomvalue + value } })
        end
    end
    hl.bind(mainMod .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true})
    hl.bind(mainMod .. " + Plus", function() zoomfunction(0.3) end, { repeating = true })

    --# Zoom with keypad
    hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
    hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true })


    ------------------
    ---- LAUNCHER ----
    ------------------

    bind_command(mainMod .. " + Return", "terminal")
    bind_command(mainMod .. " + E", "file_manager")
    bind_command(mainMod .. " + T", "editor")
    bind_command(mainMod .. " + C", "calculator")
    bind_command("XF86Calculator", "calculator")
    bind_command("CONTROL + SHIFT + Escape", "system_monitor")
    bind_command(mainMod .. " + Z", "settings")
    bind_command(mainMod .. " + X", "control_center")
    bind_command(mainMod .. " + Space", "launcher")
    bind_command(mainMod .. " + period", "emoji")
    bind_command(mainMod .. " + CONTROL + L", "lock")
    bind_command(mainMod .. " + ALT + C", "session")

    ---------------------------
    ---- HARDWARE CONTROLS ----
    ---------------------------

    -- Audio
    bind_command("XF86AudioRaiseVolume", "volume_up",   { locked = true, repeating = true })
    bind_command("XF86AudioLowerVolume", "volume_down", { locked = true, repeating = true })
    bind_command("XF86AudioMute", "volume_mute", { locked = true })
    bind_command("XF86AudioMicMute", "mic_mute",    { locked = true })

    -- Media
    bind_command("XF86AudioPlay", "media_toggle",   { locked = true })
    bind_command("XF86AudioPause", "media_toggle",   { locked = true })
    bind_command("XF86AudioNext", "media_next",     { locked = true })
    bind_command("XF86AudioPrev", "media_previous", { locked = true })

    -- Brightness
    bind_command("XF86MonBrightnessUp", "brightness_up",   { locked = true, repeating = true })
    bind_command("XF86MonBrightnessDown", "brightness_down", { locked = true, repeating = true })

    -------------------
    ---- UTILITIES ----
    -------------------

    -- Screen Capture
    bind_command(mainMod .. " + SHIFT + P", "color_picker")
    bind_command(mainMod .. " + P", "screenshot_region")
    bind_command(mainMod .. " + Print", "screenshot_fullscreen")

    -- Theming and Wallpaper
    bind_command(mainMod .. " + SHIFT + W", "wallpaper")

    -- Clipboard
    bind_command(mainMod .. " + V", "clipboard")

    -- Notifications
    bind_command(mainMod .. " + A", "notifications")

    -- Monitor toggle
    bind_command("CONTROL + ALT + F", "monitor_toggle")
    -------------------------------
    ---- WORKSPACES & MONITORS ----
    -------------------------------

    -- Focus on workspace number
    -- Absolute
    for i = 1, NUM_WPM do
        local key = i % 10
        hl.bind(mainMod .. " + ALT + " .. digitCode(key), hl.dsp.focus({ workspace = i }))
    end
    -- Relative
    for i = 1, NUM_WPM do
        local key = i % 10
        hl.bind(mainMod .. " + CONTROL + " .. digitCode(key), hl.dsp.focus({ workspace = "m~" .. i }))
    end

    -- Move to adjacent workspaces and next empty on a given monitor
    hl.bind(mainMod .. " + ALT + H",        hl.dsp.focus({ workspace = "m-1" }))
    hl.bind(mainMod .. " + ALT + L",       hl.dsp.focus({ workspace = "m+1" }))
    hl.bind(mainMod .. " + ALT + J",        hl.dsp.focus({ workspace = "emptym" }))

    -- Scroll through existing workspaces & monitors
    hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }))
    hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }))
    hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
    hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

    -- Special workspace (scratchpad)
    --hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
    --hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special())

    -- Only configured outputs get numbered monitor bindings.
    for i, monitor in ipairs(options.monitors) do
        hl.bind(mainMod .. " + " .. digitCode(i % 10), hl.dsp.focus({ monitor = monitor }))
        hl.bind(mainMod .. " + SHIFT + " .. digitCode(i % 10), hl.dsp.window.move({ monitor = monitor }))
    end
end
