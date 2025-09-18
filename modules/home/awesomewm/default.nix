{ config, pkgs, ... }:

{
  # Start AwesomeWM when you log in. This is the correct and primary way.
  xsession.enable = true;
  xsession.windowManager.awesome = {
    enable = true;
    luaModules = [ ]; # lgi is NOT needed for a basic config.
  };

  xdg.configFile."awesome/rc.lua".text = ''
    -- ~/.config/awesome/rc.lua
    -- A truly minimal AwesomeWM configuration.

    -- Standard awesome library
    local gears = require("gears")
    local awful = require("awful")
    local wibox = require("wibox")

    -- Define the terminal
    terminal = "alacritty"
    modkey = "Mod4" -- The Super/Windows key

    -- Table of layouts
    awful.layout.layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.max,
        -- awful.layout.suit.floating,
    }

    -- Create a text clock widget
    mytextclock = wibox.widget.textclock()

    -- Create the wibox (bar)
    mywibox = awful.wibar({ position = "top" })
    mywibox:setup {
        layout = wibox.layout.align.horizontal,
        nil, -- Left widgets (none)
        nil, -- Middle widget (none)
        {   -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
        },
    }

    -- Global Key Bindings
    globalkeys = gears.table.join(
        -- Super + Return to open a terminal
        awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
                  {description = "open a terminal", group = "launcher"}),

        -- Super + Shift + Ctrl + Q to quit AwesomeWM
        awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"})
    )
    root.keys(globalkeys)
  '';

  # Install necessary applications
  home.packages = with pkgs; [
    wezterm
    rofi
    firefox
  ];
}
