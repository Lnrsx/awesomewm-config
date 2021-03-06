---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = "/home/felix/.config/awesome/"
require "lfs"

local theme = { }

awesome.set_preferred_icon_size(64)

theme.font          = "BreezeSans, Medium 12"

theme.bg_normal     = "#20252A"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
theme.fg_normal = "#ffffff" -- Default text colour

--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

theme.wallpaper = themes_path.."default/background.png"
theme.pfp = themes_path.."default/image.jpeg"

theme.assets_path = themes_path.."default/assets/"

local icons = {
    ["file_icon"] = "system/folder.svg",
    ["search_icon"] = "system/search.svg",
    ["console_icon"] = "system/console.svg",
    ["power_icon"] = "system/power.svg",
    ["power_settings_icon"] = "system/power_settings.svg",
    ["left_icon"] = "system/left_arrow.svg",
    ["right_icon"] = "system/right_arrow.svg",
    ["up_icon"] = "system/up_arrow.svg",
    ["down_icon"] = "system/down_arrow.svg",
    ["sleep_icon"] = "system/sleep.svg",
    ["restart_icon"] = "system/restart.svg",
    ["logout_icon"] = "system/logout.svg",
    ["cpu_icon"] = "system/cpu.svg",
    ["heart_icon"] = "system/heart.svg",
    ["settings_icon"] = "system/settings.svg",
    ["software_icon"] = "system/software.svg",
    ["night_icon"] = "system/night.svg",

    ["network_connected"] = "system/network/connected.svg",
    ["network_disconnected"] = "system/network/disconnected.svg",

    ["discord_icon"] = "apps/discord.svg",
    ["firefox_icon"] = "apps/firefox.svg",
    ["spotify_icon"] = "apps/spotify.svg",
    ["terminal_icon"] = "apps/terminal.svg",
    ["vscode_icon"] = "apps/vscode.svg",

    ["fast_forward_icon"] = "music/next.svg",
    ["rewind_icon"] = "music/previous.svg",
    ["play_icon"] = "music/play.svg",
    ["pause_icon"] = "music/pause.svg",

    ["github_icon"] = "sites/github.svg",
    ["youtube_icon"] = "sites/youtube.svg",
    ["reddit_icon"] = "sites/reddit.svg",
    ["twitch_icon"] = "sites/twitch.svg",
    ["twitter_icon"] = "sites/twitter.svg",

    ["sunrise_icon"] = "weather/sunrise.png",
    ["sunset_icon"] = "weather/sunset.png",

    ["alert_icon"] = "github/alert.svg",
    ["bug_icon"] = "github/bug.svg",
    ["low_prio_icon"] = "github/low_prio.svg",
    ["feature_icon"] = "github/feature.svg"
}

for k,v in pairs(icons) do
    theme[k] = theme.assets_path..v
end

theme.rainbow = {
    '#d04844', -- Red
    '#c9794c', -- Orange
    '#cab14f', -- Yellow
    '#99c557', -- Light green
    '#5ab98f', -- Blue-green ?
    '#51b7d8', -- Light blue
    '#5b67c4', -- Warlock colour ?
    '#774dce', -- Purple
} --]]

theme.rainbow_focus = {
    '#f49e9c', -- Red
    '#f3bd9f', -- Orange
    '#f9e79f', -- Yellow
    '#d1eda6', -- Light green
    '#acefd1', -- Blue-green ?
    '#8bd5ed', -- Light blue
    '#a2abeb', -- Warlock colour ?
    '#a483e7', -- Purple
}

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80