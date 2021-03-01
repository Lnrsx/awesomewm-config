function create_img_widgets(icons)
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