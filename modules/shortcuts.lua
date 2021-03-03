local function generate_widgets(sites, user_args)
    local args = user_args or { }
    local colour = args.colour or '#ffffff'
    local font = args.font or 'BreezeSans, Medium 20'

    local widgets = { 
        layout = wibox.layout.fixed.vertical
    }
    for _, widgetinfo in ipairs(sites) do
        local name, action = widgetinfo[1], widgetinfo[2]
        local widget = wibox.widget {
            {
                {
                    id = name,
                    markup = "<span foreground='"..colour.."'>"..name.."</span>",
                    widget = wibox.widget.textbox,
                    font = font,
                    align = 'center',
                    forced_width = 150,
                },
                top = 10, bottom = 10,
                widget = wibox.container.margin
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }
        table.insert(widgets, widget)

        widget:connect_signal("mouse::enter", function(c) 
            c:set_bg(beautiful.bg_focus) 
        end)
        widget:connect_signal("mouse::leave", function(c) 
            c:set_bg(beautiful.bg_normal) 
        end)

        widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                awful.spawn.with_shell(action)
            end)
        ))
    end

    return widgets
end

function websites_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 225,
        width = 150,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local colour = '#6DBFD4'
    local sites = {
        {'Twitter', 'firefox twitter.com'},
        {'Reddit', 'firefox reddit.com'},
        {'Youtube', 'firefox youtube.com'},
        {'Github', 'firefox github.com'},
        {'Twitch', 'firefox twitch.tv'}
    }

    container:setup {
        generate_widgets(sites, {colour = colour}),
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end

function apps_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 225,
        width = 150,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local colour = '#FC6294'
    local apps = {
        {'Vscode', 'code'},
        {'Discord', 'discord'},
        {'Spotify', 'spotify'},
        {'Firefox', 'firefox'},
        {'Kitty', 'kitty'}
    }

    container:setup {
        generate_widgets(apps, {colour = colour}),
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end