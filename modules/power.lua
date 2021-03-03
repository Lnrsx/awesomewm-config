function power_template()
    local container = wibox {
        visible = true,
        bg = '#ff5555',
        height = 75,
        width = 75,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local clock = wibox.widget {
        text = "Power",
        widget = wibox.widget.textbox
    }

    container:setup {
        clock,
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end