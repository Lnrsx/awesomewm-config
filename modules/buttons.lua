function buttons_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 69,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local widgets = {
        spacing = 10,
        layout = wibox.layout.fixed.horizontal
    }

    local buttoninfo = {
        {beautiful.power_icon, '#d04844'},
        {beautiful.search_icon, '#c9794c'},
        {beautiful.file_icon, '#cab14f'},
        {beautiful.settings_icon, '#99c557'},
        {beautiful.software_icon, '#5ab98f'}
    }

    for _, info in pairs(buttoninfo) do
        local icon, colour = info[1], info[2]
        local widget = wibox.widget {
            {
                {
                    image = icon,
                    widget = wibox.widget.imagebox
                },
                margins = 12,
                widget = wibox.container.margin
            },
            bg = colour or beautiful.bg_focus,
            shape = function(cr, width, height)
                gears.shape.circle(cr, width, height)
            end,
            widget = wibox.container.background
        }
        table.insert(widgets, widget)
    end

    container:setup {
        {
            widgets,
            margins = 12,
            widget = wibox.container.margin
        },
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end