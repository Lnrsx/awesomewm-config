local function decorate_cell (widget, flag, date)
    if flag == 'focus' then
        local ret = wibox.widget {
            {
                widget,
                margins = 2,
                widget = wibox.container.margin
            },
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 3)
            end,
            bg = '#5466A8',
            widget = wibox.container.background
        }
        return ret
    else
        return widget
    end
end

function calendar_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        ontop = true,
        height = 200,
        width = 250,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 25)
        end
    }

    local cal = wibox.widget {
        {
            date         = os.date('*t'),
            font = 'BreezeSans, Medium 15',
            spacing      = 7.5,
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