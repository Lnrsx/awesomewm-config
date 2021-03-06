local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")

local json = require("json")
local config = json.load("/home/felix/.config/awesome/config.json")

local cmd = string.format('curl -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer %s" https://api.github.com/repos/Lnrsx/awesomewm-config/issues', config.github)

function github_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 460,
        width = 250,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }
    local function get_main_widget(widgets)
        return wibox.widget {
            {
                {
                    {
                        {
                            forced_width = 24,
                            forced_height = 24,
                            image = beautiful.github_icon,
                            widget = wibox.widget.imagebox
                        },
                        {
                            text = 'Github',
                            font = 'BreezeSans, Medium 18',
                            widget = wibox.widget.textbox
                        },
                        spacing = 5,
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = 60, right = 60,
                    widget = wibox.container.margin
                },
                {
                    shape        = gears.shape.rectangle,
                    color        = '#aaaaaa',
                    forced_height = 1,
                    widget       = wibox.widget.separator,
                },
                widgets,
                spacing = 10,
                layout = wibox.layout.fixed.vertical
            },
            margins = 10,
            widget = wibox.container.margin,
        }
    end

    local main_widget = get_main_widget()

    local issues_widget = main_widget:get_children_by_id('issues_widget')[1]

    local function update_widget(_, stdout, stderr)
        local response = json.decode(stdout)
        local widgets = {
            id = "issues_widget",
            layout = wibox.layout.fixed.vertical
        }
        local accepted_labels = {
            ["Feature"] = beautiful.feature_icon,
            ["Low Prio"] = beautiful.low_prio_icon,
            ["High Prio"] = beautiful.alert_icon,
            ["Bug"] = beautiful.bug_icon
        }
        for _, issue in ipairs(response) do
            local widget = { 
                {
                    markup = '<b>'..'• '..issue.title..'</b>',
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.horizontal 
            }
    
            for _, label in ipairs(issue.labels) do
                if accepted_labels[label.name] then
                    local icon = {
                        image = accepted_labels[label.name],
                        forced_height = 18,
                        forced_width = 18,
                        widget = wibox.widget.imagebox
                    }
                    table.insert(widget, icon)
                end
            end
            
            local widget = wibox.widget {
                {
                    widget,
                    margins = 5,
                    widget = wibox.container.margin
                },
                bg = beautiful.bg_normal,
                shape = function(cr, width, height)
                    gears.shape.rectangle(cr, width, height)
                end,
                widget = wibox.container.background
            }
    
            widget:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
            widget:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_normal) end)
    
            table.insert(widgets, widget)
        end
        
        container:setup {
            get_main_widget(widgets),
            valign = 'top',
            layout = wibox.container.place
        }
    
    end

    container:setup {
        main_widget,
        valign = 'top',
        layout = wibox.container.place
    }

    watch(cmd, 1800, update_widget, main_widget)

    return container
end