local function generate_widgets(sites)
    local widgets = { 
        layout = wibox.layout.fixed.vertical
    }
    for _, widgetinfo in ipairs(sites) do
        local image, action = widgetinfo[1], widgetinfo[2]
        local widget = wibox.widget {
            {
                {
                    image = image,
                    forced_height = 32,
                    forced_width = 32,
                    widget = wibox.widget.imagebox,
                    align = 'center',
                },
                top = 6, bottom = 6, left = 9, right = 9,
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

local function container_template()
    return  wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 225,
        width = 50,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }
end

function websites_template()
    local container = container_template()

    -- local colour = '#6DBFD4'
    local sites = {
        {beautiful.twitter_icon, 'firefox twitter.com'},
        {beautiful.reddit_icon, 'firefox reddit.com'},
        {beautiful.youtube_icon, 'firefox youtube.com'},
        {beautiful.github_icon, 'firefox github.com'},
        {beautiful.twitch_icon, 'firefox twitch.tv'}
    }

    container:setup {
        generate_widgets(sites),
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end

function apps_template()
    local container = container_template()

    -- local colour = '#FC6294'
    local apps = {
        {beautiful.vscode_icon, 'code'},
        {beautiful.discord_icon, 'discord'},
        {beautiful.spotify_icon, 'spotify'},
        {beautiful.firefox_icon, 'firefox'},
        {beautiful.terminal_icon, 'kitty'}
    }

    container:setup {
        generate_widgets(apps),
        valign = 'top',
        layout = wibox.container.place
    }

    return container
end