local music_icons = {
    {"rewind_icon"},
    {"pause_icon"},
    {"fast_forward_icon"}
}

local music_widgets = create_img_widgets(music_icons)

local function update_widget_icon(widget, stdout, _, _, _)
    stdout = string.gsub(stdout, "\n", "")
    widget:set_status(stdout == 'Playing')
end

local function update_current_song(widget, stdout, _, _, _)
    if string.match(stdout, "Error: Spotify is not running") then
        widget:set_visibility(false)
        return
    end
    -- local art_url = string.match(stdout, "length|(.-)\n")
    local song = string.match(stdout, "title|(.-)\n")
    local artist = string.match(stdout, "artist|(.-)\n")
    if (not song or not artist) then
        return -- Will display if spotify is loading
    end
    if (widget:get_text() ~= song.." | "..artist) then
        widget:set_visibility(true)
        widget:set_text(song.." | "..artist)
    end
end

-- Creates music player widget
function music_template (s)
    s.music = wibox.widget {
        {
            music_widgets,
            top = 4, bottom = 4, left = 8, right = 8,
            widget = wibox.container.margin
        },
        bg = '#182236',
        shape = function(cr, width, height)
            gears.shape.rounded_bar(cr, width, height, 15) 
        end,
        widget = wibox.container.background
    }

    s.musicinfo = wibox.widget {
        {
            {
                id = "music_info_text",
                text = "",
                widget = wibox.widget.textbox,
                font = "BreezeSans, Medium 10"
            },
            top = 4, bottom = 4, left = 12, right = 12,
            widget = wibox.container.margin
        },
        id = "music_info_background",
        visible = false,
        bg = '#182236',
        shape = function(cr, width, height)
            gears.shape.rounded_bar(cr, width, height, 15) 
        end,
        widget = wibox.container.background
    }

    -- Finds imagebox objects from parent
    local previous_widget = s.music:get_children_by_id("rewind_icon")[1]
    local toggle_widget = s.music:get_children_by_id("pause_icon")[1]
    local next_widget = s.music:get_children_by_id("fast_forward_icon")[1]

    local music_info_text = s.musicinfo:get_children_by_id("music_info_text")[1]
    local music_info_background = s.musicinfo:get_children_by_id("music_info_background")[1]

    -- Sets left click bindings
    previous_widget:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.easy_async_with_shell("sp prev", function() end)
            toggle_widget:set_status(true)
        end)))
    toggle_widget:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.easy_async_with_shell("sp play", function() end)
        end)))
    next_widget:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.easy_async_with_shell("sp next", function() end)
            toggle_widget:set_status(true)
        end)))
    
    -- Add function to set status (play/pause) of center icon
    toggle_widget.set_status = function(self, playing)
        if playing then
            self.playing = true
            self.image = beautiful.pause_icon
        else
            self.playing = false
            self.image = beautiful.play_icon
        end
    end

    -- Add function to hide music info widget
    music_info_text.set_visibility = function(self, state)
        music_info_background.visible = state
    end

    -- Watches pause/play widget to check status of song every second
    awful.widget.watch("sp status", 1, update_widget_icon, toggle_widget)
    awful.widget.watch("sp metadata", 1, update_current_song, music_info_text)
end