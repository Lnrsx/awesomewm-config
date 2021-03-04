-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
gears = require("gears")
awful = require("awful")

-- Widget and layout library
wibox = require("wibox")

-- Theme handling library
beautiful = require("beautiful")

-- Notification library
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Enables shapes
shape = require("gears")

-- Load Debian menu entries
debian = require("debian.menu")
has_fdo, freedesktop = pcall(require, "freedesktop")

-- Auto run programs
autorun = true
autorunApps = {
    "./xrandr.sh" -- Configures monitor positioning and resolution
}
if autorun then
    for app = 1, #autorunApps do
        awful.spawn(autorunApps[app])
    end
end

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init("/home/felix/.config/awesome/default/theme.lua")

-- Import own utilities
require("utils/widget_template")

-- Import own modules
require("modules.calendar")
require("modules.sysutils")
require("modules.tasklist")
require("modules.sysinfo")
require("modules.buttons")
require("modules.desktopclock")
require("modules.userinfo")
require("modules.shortcuts")
require("modules.weather")
require("modules.github")


-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Creates a list of image widgets, see favorite_icons for example syntax
local function create_img_widgets(icons)
    local widgets = { }

    for _,v in ipairs(icons) do
        table.insert(widgets, {
            {
                {
                    id = v[1],
                    image = beautiful[v[1]],
                    widget = wibox.widget.imagebox
                },
                margins = 0,
                widget = wibox.container.margin
            },
            id = v[1].."bg",
            bg = '#ffffff00',
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 5) 
            end,
            widget = wibox.container.background
        })
    end
    widgets.spacing = 7
    widgets.layout = wibox.layout.fixed.horizontal
    return widgets
end


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local sysinfo = sysinfo_template()

awful.screen.connect_for_each_screen(function(s)
    -- Set wallpaper
    set_wallpaper(s)

    -- Create a prompt box
    s.mypromptbox = awful.widget.prompt()

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    s.padding = {left = 10, right = 10, top = 10, bottom = 10}
    
    -- Creates system utilities widget
    s.tools = sysutils_template(s)

    -- Creates favorites widget
    s.tasklist = favorites_template(s)

    -- Creates the bottom_bar
    s.bottombar = awful.wibar({ 
        position = 'bottom',
        bg = "#00000000", 
        height = 35,
        width = 1910,
        y = 0,
        x = 0,
        screen = s,
    })

    -- Add widgets to the bottom bar
    s.bottombar:setup {
        expand = 'none',
        layout = wibox.layout.align.horizontal,
        { -- Left widget
            layout = wibox.layout.fixed.horizontal,
            spacing = 3,
            s.tools,
            s.tasklist,
        },
        nil, -- Middle widget placeholder
        { -- Right widget
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,
            s.musicinfo,
            sysinfo,
        }
    }
end)

-- Widgets placed on primary screen only (450px height)
-- Calendar widget
awful.placement.bottom(calendar_template(), { margins = {bottom = 400, left = 625}, parent = awful.screen.primary})

-- Desktop clock widget
awful.placement.bottom(desktopclock_template(), { margins = {bottom = 317, left = 625}, parent = awful.screen.primary})

-- User info
awful.placement.bottom(userinfo_template(), { margins = {bottom = 469, left = -625}, parent = awful.screen.primary})

-- Shortcuts
awful.placement.bottom(websites_template(), { margins = {bottom = 550, left = 260}, parent = awful.screen.primary})
awful.placement.bottom(apps_template(), { margins = {bottom = 317, left = 260}, parent = awful.screen.primary})

-- Github repo tracker
awful.placement.bottom(github_template(), { margins = {bottom = 315, left = -57}, parent = awful.screen.primary})

-- Weather
awful.placement.bottom(weather_template(), { margins = {bottom = 392, left = -625}, parent = awful.screen.primary})

-- Buttons
awful.placement.bottom(buttons_template(), { margins = {bottom = 315, left = -625}, parent = awful.screen.primary})

-- Mouse bindings
root.buttons(gears.table.join(
    
))

-- Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey,           }, "a", function () awful.client.swap.byidx(-1)    end,
              {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey,           }, "d", function () awful.client.swap.byidx(1)    end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, "Control" }, "c",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then 
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.spawn.easy_async_with_shell("rofi -show run", function() end) end,
              {description = "run rofi", group = "launcher"})
)

clientkeys = gears.table.join(

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey,           }, "Left",      function (c) c:move_to_screen(4) end,
              {description = "move to screen 4", group = "client"}),

    awful.key({ modkey,           }, "Right",      function (c) c:move_to_screen(3) end,
              {description = "move to screen 3", group = "client"}),

    awful.key({ modkey,           }, "Up",      function (c) c:move_to_screen(2) end,
              {description = "move to screen 2", group = "client"}),
    
    awful.key({ modkey,           }, "Down",      function (c) c:move_to_screen(1) end,
              {description = "move to screen 1", group = "client"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey,           }, "x",      function (c) c:kill() end,
              {description = "kills the window", group = "client"}),

    awful.key({ modkey,           }, "f",      function (c) c.maximized = false end,
              {description = "turn off maximized", group = "client"}),
    
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = false }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Rounds the windows
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,10)
    end
    c.maximized = false
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)