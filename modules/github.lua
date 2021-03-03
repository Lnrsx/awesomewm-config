function github_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 225,
        width = 150,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local title = wibox.widget {
        {
            {
                forced_width = 24,
                forced_height = 24,
                image = beautiful.github_icon,
                widget = wibox.widget.imagebox
            },
            {
                text = 'Github',
                widget = wibox.widget.textbox
            },
            spacing = 5,
            layout = wibox.layout.fixed.horizontal
        },
        margins = 5,
        widget = wibox.container.margin,
    }

    container:setup {
        title,
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end