-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

-- define module table
local tag_list = {}

-- ===================================================================
-- Widget Creation
-- ===================================================================

tag_list.create = function(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        
        -- Buttons for tag interactions
        buttons = awful.util.table.join(
            -- Left click: switch to tag
            awful.button({}, 1, function(t) 
                t:view_only() 
            end),
            
            -- Mod + Left click: move focused client to tag
            awful.button({ require('keys').modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            
            -- Right click: toggle tag view
            awful.button({}, 3, awful.tag.viewtoggle),
            
            -- Mod + Right click: toggle focused client on tag
            awful.button({ require('keys').modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            
            -- Mouse wheel: navigate tags
            awful.button({}, 4, function(t) 
                awful.tag.viewprev(t.screen) 
            end),
            awful.button({}, 5, function(t) 
                awful.tag.viewnext(t.screen) 
            end)
        ),
        
        -- Simple widget template - just show the tag name
        widget_template = {
            {
                {
                    id = 'text_role',
                    widget = wibox.widget.textbox,
                },
                left = 8,
                right = 8,
                top = 4,
                bottom = 4,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            
            -- Add some visual feedback
            create_callback = function(self, tag, index, tags)
                -- Set initial appearance
                self:get_children_by_id('background_role')[1].bg = beautiful.bg_normal
            end,
            
            update_callback = function(self, tag, index, tags)
                -- Update appearance based on tag state
                local background = self:get_children_by_id('background_role')[1]
                local text = self:get_children_by_id('text_role')[1]
                
                if tag.selected then
                    background.bg = beautiful.bg_focus
                    text.markup = '<b>' .. tag.name .. '</b>'
                elseif #tag:clients() > 0 then
                    background.bg = beautiful.bg_urgent
                    text.markup = tag.name
                else
                    background.bg = beautiful.bg_normal
                    text.markup = tag.name
                end
            end,
        },
        
        layout = wibox.layout.fixed.horizontal
    }
end

return tag_list
