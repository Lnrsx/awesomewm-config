local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

function power_menu()
    local container = wibox {
        visible = false,
        bg = beautiful.bg_normal,
        height = 69,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local icons = {
        "power_icon",
        "logout_icon",
        "restart_icon",
        "sleep_icon",
        "night_icon"
    }

    local colours = {table.unpack(beautiful.rainbow, 1, 5)}

    local connect_signals = { }

    for i=1,#icons do
        table.insert(connect_signals, { 
        {signal = "mouse::enter", func = function(c) c:set_bg(beautiful.rainbow_focus[i]) end},
        {signal = "mouse::leave", func = function(c) c:set_bg(beautiful.rainbow[i]) end} })
    end

    local buttons = {
        -- Shuts down PC
        {{btn = 1, func = function()
            power_menu.visible = false
            awful.spawn("poweroff")
        end }},

        -- Logs out
        {{btn = 1, func = function()
            awful.spawn("pkill awesome")
        end }},

        -- Restart
        {{btn = 1, func = function()
            awful.spawn("reboot")
        end }},

        -- Sleep
        {{btn = 1, func = function()
            awful.spawn("systemctl suspend")
        end }},

        -- Toggle Night light
        {{btn = 1, func = function()
            awful.spawn("")
        end }},
    }

    local widgets = create_img_widgets(icons, {
        spacing = 10,
        margins = 12,
        shape = function(cr, width, height)
            gears.shape.circle(cr, width, height)
        end,
        custom_colours = colours,
        connect_signals = connect_signals
    })

    container:setup {
        {
            widgets,
            margins = 12,
            widget = wibox.container.margin
        },
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end

function buttons_template(power_menu)
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 69,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local widgets = {
        spacing = 10,
        layout = wibox.layout.fixed.horizontal
    }

    local icons = {
        "down_icon",
        "search_icon",
        "file_icon",
        "settings_icon",
        "software_icon"
    }

    local colours = {table.unpack(beautiful.rainbow, 1, 5)}

    local connect_signals = { }

    for i=1,#icons do
        table.insert(connect_signals, { 
        {signal = "mouse::enter", func = function(c) c:set_bg(beautiful.rainbow_focus[i]) end},
        {signal = "mouse::leave", func = function(c) c:set_bg(beautiful.rainbow[i]) end} })
    end

    local expand_widget = nil -- This will cache hold the imagebox widget so it only needs to be found once

    local buttons = {
        -- Toggles power menu
        {{ btn = 1, func = function (self)
            power_menu.visible = not power_menu.visible
            expand_widget = expand_widget or self.widget:get_children_by_id('down_icon')[1]
            if power_menu.visible then
                expand_widget.image = beautiful.up_icon
            else
                expand_widget.image = beautiful.down_icon
            end
        end }},

        -- Opens rofi
        {{btn = 1, func = function()
            power_menu.visible = false
            awful.spawn("rofi -show run")
        end }},

        -- Opens nautilus
        {{btn = 1, func = function()
            awful.spawn("nautilus")
        end }},

        -- Opens settings
        {{btn = 1, func = function()
            awful.spawn("gnome-control-center")
        end }},

        -- Opens software catalog
        {{btn = 1, func = function()
            awful.spawn("gnome-software")
        end }},
    }

    local widgets = create_img_widgets(icons, {
        spacing = 10,
        margins = 12,
        shape = function(cr, width, height)
            gears.shape.circle(cr, width, height)
        end,
        custom_colours = colours,
        connect_signals = connect_signals,
        buttons = buttons
    })

    container:setup {
        {
            widgets,
            margins = 12,
            widget = wibox.container.margin
        },
        valign = 'center',
        layout = wibox.container.place
    }

    return container
end