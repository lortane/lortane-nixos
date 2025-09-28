{ config, pkgs, ... }:

{
  xdg.configFile."awesome/rc.lua".text = ''
    -- ~/.config/awesome/rc.lua
    -- A minimal AwesomeWM configuration.

    -- Standard awesome library
    local gears = require("gears")
    local awful = require("awful")
    local wibox = require("wibox")

    -- Define the terminal
    terminal = "wezterm" 
    modkey = "Mod4" -- The Super/Windows key

    -- Table of layouts
    awful.layout.layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.max,
    }

    -- Create a text clock widget
    mytextclock = wibox.widget.textclock()

    -- Create the wibox (bar)
    mywibox = awful.wibar({ position = "top" })
    mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle widget
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
        },
    }

    -- Global Key Bindings
    globalkeys = gears.table.join(
        -- Super + Return to open a terminal
        awful.key({ modkey }, "Return", function () 
            awful.spawn(terminal) 
        end, {description = "open a terminal", group = "launcher"}),

        -- Super + Shift + Q to quit AwesomeWM (more standard shortcut)
        awful.key({ modkey, "Shift" }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"})
    )

    -- Set keys
    root.keys(globalkeys)

    -- Signal function to execute when a new client appears.
    client.connect_signal("manage", function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end)

    -- Enable sloppy focus, so that focus follows mouse.
    client.connect_signal("mouse::enter", function(c)
        c:activate { context = "mouse_enter", raise = false }
    end)
  '';

  # Install necessary applications
  home.packages = with pkgs; [
    wezterm
    rofi
    firefox
  ];
}
