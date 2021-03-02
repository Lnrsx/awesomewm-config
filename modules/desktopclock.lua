function desktopclock_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        ontop = true,
        height = 75,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local clock = wibox.widget.textclock ('<span font="BreezeSans, Medium 36"> %H:%M </span>', 5)

    container:setup {
        clock,
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end