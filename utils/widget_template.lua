function create_img_widgets(icons, user_args)

    local args = user_args or { }
    local layout = args.layout or wibox.layout.fixed.horizontal
    local spacing = args.spacing or 7
    local bg = args.bg or '#ffffff00' -- Invisible by default
    local margins = args.margins or 0
    local shape = args.shape or function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 5) end
    local custom_colours = args.custom_colours or { }
    local buttons = args.buttons or { }
    local connect_signals = args.connect_signals or { }

    local widgets = {
        layout = layout,
        spacing = spacing
     }

    for i, icon in ipairs(icons) do
        local widget = wibox.widget {
            {
                {
                    id = icon,
                    image = beautiful[icon],
                    widget = wibox.widget.imagebox
                },
                margins = margins,
                widget = wibox.container.margin
            },
            id = icon.."bg",
            bg = custom_colours[i] or bg,
            shape = shape,
            widget = wibox.container.background
        }
        table.insert(widgets, widget)

        -- Configure any connect signals
        if connect_signals[i] then
            for _, info in ipairs(args.connect_signals[i]) do
                widget:connect_signal(info.signal, info.func)
            end
        end

        -- Configure buttons
        if buttons[i] then
            for _, info in ipairs(args.buttons[i]) do
                widget:buttons(
                    awful.util.table.join(
                    awful.button({}, info.btn, info.func)
                    ))
            end
        end
    end

    return widgets
end