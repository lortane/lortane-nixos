local awful = require("awful")
local wibox = require("wibox")

terminal = "xterm"
modkey = "Mod4"

-- Very visible wibox
local mywibox = awful.wibar({ position = "top", height = 35 })
mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Right
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.textclock(" %H:%M:%S "),
    },
}
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
          {description = "open a terminal", group = "launcher"}),
})
