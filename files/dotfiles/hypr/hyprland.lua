local home        = os.getenv("HOME")
local mod         = "SUPER"
local cursor_size = "24"
local exec        = hl.dsp.exec_cmd

-- Colours, the cursor theme and the wallpaper all come from the variant dir that
-- theme-toggle points `current` at, then flips and reloads. Nothing below may
-- hardcode a colour, a cursor theme or a wallpaper. hyprlock reads the same file,
-- which is why it stays in hyprlang syntax; this picks out its `$name = value` lines.
local theme = {}
for line in io.lines(home .. "/.config/theme/current/hypr-colors.conf") do
    local name, value = line:match("^%$([%w_]+)%s*=%s*(.-)%s*$")
    if name then
        theme[name] = value
    end
end

-- Startup
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("hyprpaper")
    -- Re-applies the last choice: hyprpaper.conf and the GTK settings both start
    -- from the build-time default, which may not be what was picked.
    hl.exec_cmd("theme-toggle apply")
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- Office: Philips 346B1C ultrawide
hl.monitor({
    output   = "desc:Philips Consumer Electronics Company PHL 346B1C",
    mode     = "3440x1440@100",
    position = "0x0",
    scale    = 1.0,
})

-- Home: Dell Inc. DELL U3223QE 50J5G34
hl.monitor({ output = "desc:Dell Inc.", mode = "preferred", position = "0x0", scale = 1.25 })

-- Laptop internal panel. handle_lid_switch.sh restores these same values when
-- the lid opens, so change them in both places.
hl.monitor({ output = "eDP-1", mode = "2880x1800@120", position = "auto-right", scale = 1.5 })

-- fallback
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Disable laptop screen when lid is closed
hl.bind("switch:on:Lid Switch", exec("~/.config/hypr/handle_lid_switch.sh on"), { locked = true })
hl.bind("switch:off:Lid Switch", exec("~/.config/hypr/handle_lid_switch.sh off"), { locked = true })

-- Environment variables
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ANKI_WAYLAND", "1")
hl.env("DISABLE_QT5_COMPAT", "0")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")
hl.env("DIRENV_LOG_FORMAT", "")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("HYPRCURSOR_SIZE", cursor_size)
hl.env("HYPRCURSOR_THEME", theme.cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)
hl.env("XCURSOR_THEME", theme.cursor_theme)

hl.config({
    cursor = {
        no_hardware_cursors = true,
        hide_on_key_press   = true,
    },

    general = {
        resize_on_border = true,
        -- 8px is the one spacing unit: waybar's margins (config.jsonc) use it too,
        -- so the bar and the windows below it line up on every edge. gaps_in is
        -- half, which makes the space between two tiled windows 8 as well.
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,
        layout      = "master",
        col = {
            active_border   = theme.borderActive,
            inactive_border = theme.borderInactive,
        },
    },

    decoration = {
        active_opacity   = 1.0,
        inactive_opacity = 0.9,
        rounding         = 0,

        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 3,
            color        = theme.shadowColor,
        },

        blur = {
            enabled = true,
            size    = 18,
            passes  = 1,
        },
    },

    animations = {
        enabled = true,
    },

    master = {
        new_status = "master",
        mfact      = 0.5,
    },

    misc = {
        disable_hyprland_logo     = true,
        disable_splash_rendering  = true,
        disable_autoreload        = true,
        focus_on_activate         = true,
        on_focus_under_fullscreen = 2,
    },

    ecosystem = {
        no_update_news = true,
    },

    input = {
        kb_layout          = "us,ch",
        kb_options         = "grp:alt_shift_toggle",
        follow_mouse       = 1,
        sensitivity        = 0.5,
        repeat_delay       = 300,
        repeat_rate        = 50,
        numlock_by_default = true,

        touchpad = {
            natural_scroll       = true,
            clickfinger_behavior = true,
        },
    },
})

-- Animations
local function bezier(name, x1, y1, x2, y2)
    hl.curve(name, { type = "bezier", points = { { x1, y1 }, { x2, y2 } } })
end

local function animation(leaf, speed, curve, style)
    hl.animation({ leaf = leaf, enabled = true, speed = speed, bezier = curve, style = style })
end

bezier("md3_decel", 0.05, 0.7, 0.1, 1)
bezier("md3_accel", 0.3, 0, 0.8, 0.15)
bezier("overshot", 0.05, 0.9, 0.1, 1.1)
bezier("crazyshot", 0.1, 1.5, 0.76, 0.92)
bezier("hyprnostretch", 0.05, 0.9, 0.1, 1.0)
bezier("menu_decel", 0.1, 1, 0, 1)
bezier("menu_accel", 0.38, 0.04, 1, 0.07)
bezier("easeInOutCirc", 0.85, 0, 0.15, 1)
bezier("easeOutCirc", 0, 0.55, 0.45, 1)
bezier("easeOutExpo", 0.16, 1, 0.3, 1)

animation("windows", 2.5, "md3_decel", "popin 60%")
animation("windowsIn", 2.5, "md3_decel", "popin 60%")
animation("windowsOut", 2.5, "md3_accel", "popin 60%")
animation("border", 6, "default")
animation("fade", 2.5, "md3_decel")
animation("layersIn", 2.5, "menu_decel", "slide")
animation("layersOut", 2.5, "menu_accel")
animation("fadeLayersIn", 2.5, "menu_decel")
animation("fadeLayersOut", 2.5, "menu_accel")
animation("workspaces", 2.5, "menu_decel", "slide")
animation("specialWorkspace", 2.5, "md3_decel", "slidevert")

-- Window rules
hl.window_rule({ match = { tag = "modal" }, float = true, pin = true, center = true })

-- Calculator
hl.window_rule({ match = { class = "^(org.gnome.Calculator)$" }, float = true, size = "360 490" })

-- Picture-in-Picture
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true })

-- Zoom
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { class = "^(zoom)$", title = "^(Zoom Meeting)$" }, tile = true })

-- Idle inhibit
hl.window_rule({ match = { class = "^(mpv|.+exe|celluloid)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^(zen)$", title = "^(.*YouTube.*)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^(zen)$" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^(zoom)$" }, idle_inhibit = "focus" })

-- Opacity exceptions
local fully_opaque = "1.0 override 1.0 override"
hl.window_rule({ match = { class = "^(mpv|celluloid)$" }, opacity = fully_opaque })
hl.window_rule({ match = { class = "^(zen)$", fullscreen = true }, opacity = fully_opaque })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, opacity = fully_opaque })

-- Dim around dialogs
hl.window_rule({ match = { class = "^(gcr-prompter)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(zen)$", title = "^(File Upload)$" }, dim_around = true })

-- Key bindings
--
-- Every binding that is worth remembering uses `bindd` so that it carries a
-- description. `hypr-keybinds` (SUPER+K) reads them straight back out of
-- Hyprland, which means this file is the only place a shortcut is ever written
-- down. The bare workspace-number bindings stay on `hl.bind` on purpose: twenty
-- "Switch to workspace N" rows would bury everything else in that list.
local function bindd(keys, description, dispatcher)
    hl.bind(keys, dispatcher, { description = description })
end

-- Applications
bindd(mod .. " + RETURN", "Terminal", exec("ghostty"))
bindd(mod .. " + E", "File manager", exec("nautilus"))
bindd(mod .. " + B", "Browser", exec("zen-browser"))
bindd(mod .. " + L", "Lock screen", exec("hyprlock"))

-- Menus
bindd(mod .. " + SPACE", "Menu", exec("hypr-menu"))
bindd(mod .. " + ALT + SPACE", "App launcher", exec("wofi --show drun"))
bindd(mod .. " + K", "Keybindings", exec("hypr-keybinds"))
bindd(mod .. " + ESCAPE", "System menu", exec("wlogout -b 5"))
bindd(mod .. " + CTRL + C", "Capture menu", exec("hypr-menu capture"))
bindd(mod .. " + CTRL + O", "Toggle menu", exec("hypr-menu toggles"))
bindd(mod .. " + CTRL + SPACE", "Style menu", exec("hypr-menu style"))
bindd(mod .. " + CTRL + V", "Clipboard history", exec("hypr-menu clipboard"))
bindd(mod .. " + CTRL + E", "Emoji picker", exec("bemoji -t"))

-- Windows
bindd(mod .. " + Q", "Close window", hl.dsp.window.close())
bindd(mod .. " + T", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
bindd(mod .. " + F", "Fullscreen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bindd(mod .. " + CTRL + F", "Maximize (keep bar)", hl.dsp.window.fullscreen({ mode = "maximized" }))
bindd(mod .. " + P", "Pseudo tile", hl.dsp.window.pseudo())
bindd(mod .. " + G", "Toggle window group", hl.dsp.group.toggle())
bindd(mod .. " + ALT + G", "Move window out of group", hl.dsp.window.move({ out_of_group = true }))
bindd(mod .. " + ALT + TAB", "Next window in group", hl.dsp.group.next())
bindd(mod .. " + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())

-- Focus
bindd(mod .. " + left", "Focus left", hl.dsp.focus({ direction = "left" }))
bindd(mod .. " + right", "Focus right", hl.dsp.focus({ direction = "right" }))
bindd(mod .. " + up", "Focus up", hl.dsp.focus({ direction = "up" }))
bindd(mod .. " + down", "Focus down", hl.dsp.focus({ direction = "down" }))
bindd("ALT + TAB", "Cycle windows", hl.dsp.window.cycle_next())
bindd("ALT + SHIFT + TAB", "Cycle windows backwards", hl.dsp.window.cycle_next({ next = false }))
-- Raise whatever cycle_next just focused; a second binding on the same key runs
-- alongside the first rather than replacing it.
hl.bind("ALT + TAB", hl.dsp.window.bring_to_top())
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.bring_to_top())

-- Move and resize. The modifier says what the arrow keys do: plain focuses,
-- SHIFT swaps, CTRL resizes, SHIFT+ALT throws the workspace at another monitor.
bindd(mod .. " + SHIFT + left", "Swap window left", hl.dsp.window.swap({ direction = "left" }))
bindd(mod .. " + SHIFT + right", "Swap window right", hl.dsp.window.swap({ direction = "right" }))
bindd(mod .. " + SHIFT + up", "Swap window up", hl.dsp.window.swap({ direction = "up" }))
bindd(mod .. " + SHIFT + down", "Swap window down", hl.dsp.window.swap({ direction = "down" }))

bindd(mod .. " + CTRL + left", "Shrink window horizontally", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
bindd(mod .. " + CTRL + right", "Grow window horizontally", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
bindd(mod .. " + CTRL + up", "Shrink window vertically", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
bindd(mod .. " + CTRL + down", "Grow window vertically", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

bindd(mod .. " + SHIFT + ALT + left", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
bindd(mod .. " + SHIFT + ALT + right", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
bindd(mod .. " + SHIFT + ALT + up", "Move workspace to upper monitor", hl.dsp.workspace.move({ monitor = "u" }))
bindd(mod .. " + SHIFT + ALT + down", "Move workspace to lower monitor", hl.dsp.workspace.move({ monitor = "d" }))

-- Workspaces
bindd(mod .. " + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
bindd(mod .. " + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
bindd(mod .. " + CTRL + TAB", "Last workspace", hl.dsp.focus({ workspace = "previous" }))
bindd(mod .. " + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
bindd(mod .. " + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

for i = 1, 10 do
    local key = i % 10 -- workspace 10 sits on the 0 key
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Notifications
bindd(mod .. " + A", "Notification centre", exec("swaync-client -t -sw"))
bindd(mod .. " + comma", "Dismiss notification", exec("swaync-client --close-latest --skip-wait"))
bindd(mod .. " + SHIFT + comma", "Dismiss all notifications", exec("swaync-client --close-all --skip-wait"))
bindd(mod .. " + CTRL + comma", "Toggle do not disturb", exec("swaync-client -d -sw"))

-- Toggles
bindd(mod .. " + SHIFT + T", "Toggle light/dark theme", exec("theme-toggle"))
bindd(mod .. " + N", "Toggle night light", exec("pkill hyprsunset || hyprsunset -t 4500"))
bindd(mod .. " + SHIFT + SPACE", "Toggle top bar", exec("pkill waybar || waybar"))

-- Screenshots
bindd(mod .. " + PRINT", "Screenshot region", exec("hyprshot -m region"))
bindd("PRINT", "Screenshot output", exec("hyprshot -m output"))
bindd(mod .. " + SHIFT + PRINT", "Screenshot window", exec("hyprshot -m window"))
bindd(mod .. " + SHIFT + S", "Screenshot region to clipboard", exec("hyprshot -m region --clipboard-only"))
bindd(mod .. " + CTRL + PRINT", "Colour picker", exec("pkill hyprpicker || hyprpicker -a"))

-- Media keys
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

-- Volume and brightness
hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", exec("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Mouse bindings
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
