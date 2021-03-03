function weather_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 75,
        width = 215,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local clock = wibox.widget {
        text = "Weather Widget",
        widget = wibox.widget.textbox
    }

    container:setup {
        clock,
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end