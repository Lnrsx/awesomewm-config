local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local favorite_icons = { 
    {"console_icon", "gnome-terminal"},
    {"globe_icon", "firefox"},
    {"discord_icon", "discord"},
    {"spotify_icon", "spotify"},
    {"vscode_icon", "code"}}

-- Config for tasklist appearance
beautiful.tasklist_disable_task_name = true
beautiful.tasklist_bg_normal = '#00000000'
beautiful.tasklist_bg_focus = '#00000000'

local minimize_client = function (c)
    if c == client.focus then
      c.minimized = true
    else
        c:emit_signal(
            "request::activate", 
            "tasklist",
            {raise = true}
        )
    end
end

local tasklist_buttons = gears.table.join(awful.button({ }, 1,   minimize_client))

function favorites_template (s)
    local tasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.allscreen,
        buttons  = tasklist_buttons,
    }
    return tasklist
end