-- Load libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Variables
modkey = "Mod4" -- Super key
terminal = "xterm"
browser = "firefox"

-- Theme/defaults (keep stock look, minimal changes)
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 0 -- no gaps
beautiful.border_width = 1

-- Layouts: default first is spiral
awful.layout.layouts = {
    awful.layout.suit.spiral, 
    awful.layout.suit.floating,
}

-- Helper: Show date when clock clicked
local function show_date()
    naughty.notify({ title = os.date("%A, %B %d, %Y"), text = os.date("%c"), timeout = 5 })
end

-- Tags (workspaces) named 0-3
awful.screen.connect_for_each_screen(function(s)
    awful.tag({"0", "1", "2", "3"}, s, awful.layout.layouts[1])
end)

-- Widgets
-- Workspace list as clickable text widgets (left)
local taglist = {}
local function make_taglist(s)
    local widgets = {}
    for i = 1, 4 do
        local t = s.tags[i]
        local lbl = wibox.widget {
            markup = "<span> " .. t.name .. " </span>",
            align = 'center',
            widget = wibox.widget.textbox
        }
        lbl:buttons(gears.table.join(
            awful.button({}, 1, function() t:view_only() end)
        ))
        -- Update markup on tag change
        t:connect_signal("property::selected", function() 
            if t.selected then
                lbl.markup = "<b> " .. t.name .. " </b>"
            else
                lbl.markup = "<span> " .. t.name .. " </span>"
            end
        end)
        table.insert(widgets, lbl)
    end
    return wibox.layout.fixed.horizontal(unpack(widgets))
end

-- Clock in center
local mytextclock = wibox.widget.textclock("%H:%M")
mytextclock:buttons(gears.table.join(
    awful.button({}, 1, function() show_date() end)
))

-- Volume widget (uses amixer). If not available, shows 'N/A'
local vol_widget = wibox.widget.textbox("Vol: N/A")
awful.spawn.easy_async_with_shell("amixer get Master | awk -F'[][]' '/Left:/ {print $2,$4}' | head -n1", function(out)
    if out and #out>0 then
        vol_widget.text = out:gsub('\n','')
    end
end)
-- Update periodically
gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        awful.spawn.easy_async_with_shell("amixer get Master | awk -F'[][]' '/Left:/ {print $2,$4}' | head -n1", function(out)
            if out and #out>0 then
                vol_widget.text = out:gsub('\n','')
            else
                vol_widget.text = "Vol: N/A"
            end
        end)
    end
}
-- Volume click to toggle mute
vol_widget:buttons(gears.table.join(
    awful.button({}, 1, function() awful.spawn.with_shell("amixer set Master toggle") end)
))

-- Power widget: a small textbox that on left-click shows a menu
local power_widget = wibox.widget.textbox("[power]")
power_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        local choice = awful.menu({
            items = {
                {"Reboot", function() awful.spawn.with_shell("systemctl reboot") end},
                {"Power off", function() awful.spawn.with_shell("systemctl poweroff") end},
                {"Cancel", function() end}
            }
        })
        choice:toggle()
    end)
))

-- Create top wibox
awful.screen.connect_for_each_screen(function(s)
    -- Left: taglist
    local left = make_taglist(s)

    local topbar = awful.wibar({ position = "top", screen = s })

    topbar:setup {
        layout = wibox.layout.align.horizontal,
        { -- left
            layout = wibox.container.margin,
            left,
            left = 6, right = 6
        },
        mytextclock, -- center
        { -- right
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            vol_widget,
            power_widget
        }
    }
end)

-- Keybindings
globalkeys = gears.table.join(
    
    awful.key({ modkey }, "w", function(c) if client.focus then client.focus:kill() end end, {description = "close window", group = "client"}),
    -- Basic apps
    awful.key({ modkey }, "1", function() awful.spawn(browser) end,
              {description = "open browser", group = "launcher"}),
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
              {description = "open terminal", group = "launcher"}),

    -- Focus change: arrows and vim hjkl
    awful.key({ modkey }, "Left", function() awful.client.focus.bydirection("left") end),
    awful.key({ modkey }, "Right", function() awful.client.focus.bydirection("right") end),
    awful.key({ modkey }, "Up", function() awful.client.focus.bydirection("up") end),
    awful.key({ modkey }, "Down", function() awful.client.focus.bydirection("down") end),
    awful.key({ modkey }, "h", function() awful.client.focus.bydirection("left") end),
    awful.key({ modkey }, "l", function() awful.client.focus.bydirection("right") end),
    awful.key({ modkey }, "k", function() awful.client.focus.bydirection("up") end),
    awful.key({ modkey }, "j", function() awful.client.focus.bydirection("down") end),

    -- Move windows: mod+shift + arrows or hjkl
    awful.key({ modkey, "Shift" }, "Left", function() local c = client.focus; if c then awful.client.swap.bydirection("left", c) end end),
    awful.key({ modkey, "Shift" }, "Right", function() local c = client.focus; if c then awful.client.swap.bydirection("right", c) end end),
    awful.key({ modkey, "Shift" }, "Up", function() local c = client.focus; if c then awful.client.swap.bydirection("up", c) end end),
    awful.key({ modkey, "Shift" }, "Down", function() local c = client.focus; if c then awful.client.swap.bydirection("down", c) end end),
    awful.key({ modkey, "Shift" }, "h", function() local c = client.focus; if c then awful.client.swap.bydirection("left", c) end end),
    awful.key({ modkey, "Shift" }, "l", function() local c = client.focus; if c then awful.client.swap.bydirection("right", c) end end),
    awful.key({ modkey, "Shift" }, "k", function() local c = client.focus; if c then awful.client.swap.bydirection("up", c) end end),
    awful.key({ modkey, "Shift" }, "j", function() local c = client.focus; if c then awful.client.swap.bydirection("down", c) end end),

    -- Prompt/launcher using built-in prompt (no external dmenu)
    awful.key({ modkey }, "r", function()
        awful.screen.focused().mypromptbox = awful.screen.focused().mypromptbox or awful.widget.prompt()
        awful.prompt.run {
            prompt       = "Run: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = function(cmd) if not cmd or #cmd == 0 then return end; awful.spawn.with_shell(cmd) end
        }
    end),

    -- Reload and quit
    awful.key({ modkey, "Control" }, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "q", awesome.quit, {description = "quit awesome", group = "awesome"})
)

-- Numpad workspace keys (KP_0 .. KP_3)
for i = 0, 3 do
    local key = "KP_" .. tostring(i)
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, key, function()
            local s = awful.screen.focused()
            if s.tags[i+1] then s.tags[i+1]:view_only() end
        end),
        awful.key({ modkey, "Control" }, key, function()
            local c = client.focus
            if c and awful.screen.focused().tags[i+1] then c:move_to_tag(awful.screen.focused().tags[i+1]) end
        end)
    )
end

root.keys(globalkeys)

-- Rules: keep things simple and stock
awful.rules.rules = {
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = {},
          buttons = {},
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
    }
}

-- Signals: no fancy animations/effects
client.connect_signal("manage", function (c)
    -- set slave by default
    if not awesome.startup then awful.client.setslave(c) end
end)

-- mouse bindings for clients: minimal
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
    awful.button({ modkey }, 1, function (c) c:activate{context = "mouse_click"}; awful.mouse.client.move(c) end),
    awful.button({ modkey }, 3, function (c) c:activate{context = "mouse_click"}; awful.mouse.client.resize(c) end)
)

-- Assign clientkeys to each client (basic focus/move keys are global)

-- End of minimal rc.lua
