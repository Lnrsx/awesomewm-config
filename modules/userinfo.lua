function userinfo_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 375,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local userinfo = wibox.widget {
        {
            {
                {
                    image = beautiful.pfp,
                    forced_height = 128,
                    forced_width = 128,
                    widget = wibox.widget.imagebox
                },
                bg = beautiful.bg_normal,
                shape = function(cr, width, height)
                    gears.shape.circle(cr, width, height)
                end,
                shape_clip = true,
                widget = wibox.container.background
            },
                {
                    {
                    markup = '<span font="BreezeSans, Medium 24">'..'Felix'..'</span>',
                    align = 'center',
                    widget = wibox.widget.textbox
                },
                {
                    markup = '<span font="BreezeSans, Medium 12">'.."Felix's PC"..'</span>',
                    align = 'center',
                    widget = wibox.widget.textbox
                },
                spacing = 5,
                layout = wibox.layout.fixed.vertical
            },
            spacing = 20,
            layout = wibox.layout.fixed.vertical
        },
        margins = 32,
        widget = wibox.container.margin
    }

    awful.spawn.easy_async_with_shell('whoami && hostname', function(stdout)  end)

    container:setup {
        userinfo,
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end