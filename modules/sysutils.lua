function sysutils_template (s)
    local sysutil_icons = {
        {"heart_icon"},
        {"file_icon"},
        {"search_icon"}
    }

    local sysutil_widgets = create_img_widgets(sysutil_icons)

    -- Creates apps widget
    local tools = wibox.widget {
        {
            sysutil_widgets,
            top = 4, bottom = 4, left = 10, right = 8,
            widget = wibox.container.margin
        },
        bg = '#182236',
        shape = function(cr, width, height)
            gears.shape.rounded_bar(cr, width, height, 15) 
        end,
        widget = wibox.container.background
    }

    -- Get icon objects from parent
    local favorites = tools:get_children_by_id('heart_icon')[1]
    local file = tools:get_children_by_id('file_icon')[1]
    local apps = tools:get_children_by_id('search_icon')[1]

    -- Set options for favorites
    local options = {
        { name = "Vscode", icon = beautiful.vscode_icon, action = "code"},
        { name = "Discord", icon = beautiful.discord_icon, action = "discord" },
        { name = "Spotify", icon = beautiful.spotify_icon, action = "spotify" },
        { name = "Firefox", icon = beautiful.firefox_icon, action = "firefox" },
        { name = "Terminal", icon = beautiful.terminal_icon, action = "kitty" },
    }

    -- Configure popup for favorites
    local popup = awful.popup {
        ontop = true,
        visible = false,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
        border_width = 1,
        border_color = beautiful.bg_focus,
        offset = { y = -5, x = -10 },
        minimum_width = 110,
        widget = { }
    }
    local rows = { layout = wibox.layout.fixed.vertical }
    
    for _, item in ipairs(options) do

        local row = wibox.widget {
            {
                {
                    {
                        image = item.icon,
                        forced_width = 24,
                        forced_height = 24,
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
    
    favorites:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                if popup.visible then
                    popup.visible = not popup.visible
                else
                     popup:move_next_to(mouse.current_widget_geometry)
                end
        end))
    )
    
    -- Set mouse binds for favorites
    file:buttons(gears.table.join(
        awful.button({ }, 1, function () 
            
        end)))

    -- Set mouse binds for file icon
    file:buttons(gears.table.join(
        awful.button({ }, 1, function () 
            awful.spawn.easy_async_with_shell("nautilus", function() end)
        end)))
    
    -- Set mouse binding for search bar
    apps:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.easy_async_with_shell("rofi -show run", function() end)
    end)))

    return tools
end