local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local styles = { }

styles.normal = { }

styles.focus = {
    fg = '#FC6294',
    markup = function(t) return '<b>'..t..'</b>' end
}

styles.header = {
    fg = '#6DBFD4',
    markup = function(t) return '<span font_desc="BreezeSans, Medium 27">'..t..'</span>' end
}

styles.weekday = {
    markup = function(t) return '<span font_desc="BreezeSans, Medium 17">'..t..'</span>' end
}

local function decorate_cell (widget, flag, date)
    local props = styles[flag] or { }
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    widget = wibox.widget {
        widget,
        fg = props.fg or '#ffffff',
        widget = wibox.container.background
    }
    return widget
end

function calendar_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 375,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local cal = wibox.widget {
        {
            date         = os.date('*t'),
            font = 'BreezeSans, Medium 16',
            spacing      = 10,
            week_numbers = false,
            start_sunday = false,
            fn_embed = decorate_cell,
            widget       = wibox.widget.calendar.month
        },
        top = 20,
        widget = wibox.container.margin
    }

    container:setup {
        cal,
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end