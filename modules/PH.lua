function ph_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 225,
        width = 150,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    container:setup {
        nil,
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end