local volumearc_widget = require("utils.volume")

function sysinfo_template()
    local sysinfo = wibox.widget {
        {
            {
                {
                    widget = volumearc_widget({ mute_color = '#ff5555' })
                },
                {
                    widget = wibox.widget.textclock,
                    font = "BreezeSans, Medium 10" -- Default 10
                },
                spacing = 7,
                layout = wibox.layout.fixed.horizontal
            },
            left = 8, right = 8, top = 4, bottom = 4,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        shape = function(cr, width, height)
            gears.shape.rounded_bar(cr, width, height, 15) 
        end,
        widget = wibox.container.background
    }
    return sysinfo
end