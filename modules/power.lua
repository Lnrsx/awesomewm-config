function power_template(s)
    s.power = wibox.widget {
        {
            {
                id = "power",
                image = beautiful.power_icon,
                widget = wibox.widget.imagebox
            },
            margins = 4,
            layout = wibox.container.margin
        },
        bg = '#ff5555',
        shape = function(cr, width, height)
            gears.shape.circle(cr, width, height) 
        end,
        widget = wibox.container.background
    }
    local options = {
        { name = "Shutdown", icon = beautiful.power_icon, action = "shutdown -h now" },
        { name = "Sleep", icon = beautiful.sleep_icon, action = "systemctl hibernate" },
        { name = "Restart", icon = beautiful.restart_icon, action = "reboot" },
        { name = "Log Out", icon = beautiful.logout_icon, action = "exit" },
    }

    local popup = awful.popup {
        ontop = true,
        visible = false,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
        border_width = 1,
        border_color = beautiful.bg_focus,
        offset = { y = -10, x = 5 },
        widget = { }
    }
    local rows = { layout = wibox.layout.fixed.vertical }
    
    for _, item in ipairs(options) do

        local row = wibox.widget {
            {
                {
                    {
                        image = item.icon,
                        forced_width = 16,
                        forced_height = 16,
                        widget = wibox.widget.imagebox
                    },
                    {
                        text = item.name,
                        widget = wibox.widget.textbox
                    },
                    spacing = 8,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = 8,
                widget = wibox.container.margin
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }

        row:connect_signal("mouse::enter", function(c) 
            c:set_bg(beautiful.bg_focus) 
        end)
        row:connect_signal("mouse::leave", function(c) 
            c:set_bg(beautiful.bg_normal) 
        end)

        row:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                popup.visible = not popup.visible
                awful.spawn.with_shell(item.action)
            end)
        ))


        table.insert(rows, row)   
    end
    popup:setup(rows)
    
    s.power:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                if popup.visible then
                    popup.visible = not popup.visible
                else
                     popup:move_next_to(mouse.current_widget_geometry)
                end
        end))
    )
end