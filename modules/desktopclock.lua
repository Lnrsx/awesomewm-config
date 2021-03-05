local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

function desktopclock_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 75,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local clock = wibox.widget.textclock ('<span font="BreezeSans, Medium 32"> %H : %M : %S </span>', 1)

    container:setup {
        clock,
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end