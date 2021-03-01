local volumearc_widget = require("utils.volume")

sysinfo = wibox.widget {
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
    bg = '#182236',
    shape = function(cr, width, height)
        gears.shape.rounded_bar(cr, width, height, 15) 
    end,
    widget = wibox.container.background
}