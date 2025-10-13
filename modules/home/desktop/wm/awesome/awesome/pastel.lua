--      ██████╗  █████╗ ███████╗████████╗███████╗██╗
--      ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║
--      ██████╔╝███████║███████╗   ██║   █████╗  ██║
--      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  ██║
--      ██║     ██║  ██║███████║   ██║   ███████╗███████╗
--      ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")

local pastel = {}


-- ===================================================================
-- Pastel setup
-- ===================================================================


pastel.initialize = function()
   -- Import components
   require("components.pastel.wallpaper")
   require("components.exit-screen")
   require("components.volume-adjust")

   -- Import panels
   local top_panel = require("components.pastel.top-panel")

   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      for i = 1, 4, 1
      do
         awful.tag.add(i, {
            layout = awful.layout.suit.tile,
            screen = s,
            selected = i == 1
         })
      end

      -- Only add the top panel on the primary screen
      if s.index == 1 then
         top_panel.create(s)
      end
   end)
end

return pastel
