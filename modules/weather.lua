local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")

local json = require("json")

local config = json.load("/home/felix/.config/awesome/config.json")

local get_cmd = [[bash -c "curl -s --show-error -X GET '%s'"]]
local url = 'http://api.openweathermap.org/data/2.5/weather?lat=51.990808&lon=1.074713&appid='..config.openweather

local file_extension = '.png'
local icon_map = {
    ["01d"] = "clear-sky",
    ["02d"] = "few-clouds",
    ["03d"] = "scattered-clouds",
    ["04d"] = "broken-clouds",
    ["09d"] = "shower-rain",
    ["10d"] = "rain",
    ["11d"] = "thunderstorm",
    ["13d"] = "snow",
    ["50d"] = "mist",
    ["01n"] = "clear-sky-night",
    ["02n"] = "few-clouds-night",
    ["03n"] = "scattered-clouds-night",
    ["04n"] = "broken-clouds-night",
    ["09n"] = "shower-rain-night",
    ["10n"] = "rain-night",
    ["11n"] = "thunderstorm-night",
    ["13n"] = "snow-night",
    ["50n"] = "mist-night"
}

function weather_template()
    local container = wibox {
        visible = true,
        bg = beautiful.bg_normal,
        height = 69,
        width = 300,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 16)
        end
    }

    local weather_widget = wibox.widget {
        {
            id = 'icon',
            image = beautiful.power_icon,
            forced_height = 64,
            forced_width = 64,
            widget = wibox.widget.imagebox
        },
        {        
            {
                {
                    id = "temp",
                    text = " ",
                    font = 'BreezeSans, Medium 32',
                    widget = wibox.widget.textbox
                },
                {
                    id = "description",
                    text = " ",
                    font = 'BreezeSans, Medium 10',
                    widget = wibox.widget.textbox
                },
                spacing = -6,
                layout = wibox.layout.fixed.vertical
            },
            top = 6,
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            image = beautiful.sunrise_icon,
                            forced_height = 16,
                            forced_width = 16,
                            widget = wibox.widget.imagebox
                        },
                        {
                            id = "sunrise",
                            text = " ",
                            alight = 'right',
                            widget = wibox.widget.textbox
                        },
                        spacing = 6,
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        {
                            image = beautiful.sunset_icon,
                            forced_height = 16,
                            forced_width = 16,
                            widget = wibox.widget.imagebox
                        },
                        {
                            id = "sunset",
                            text = " ",
                            alight = 'right',
                            widget = wibox.widget.textbox
                        },
                        spacing = 5,
                        layout = wibox.layout.fixed .horizontal
                    },
                    spacing = 4,
                    layout = wibox.layout.fixed.vertical
                },
                left = 24,
                widget = wibox.container.margin
            },
            top = 16, left = 50,
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    }

    local icon = weather_widget:get_children_by_id('icon')[1]
    local temp = weather_widget:get_children_by_id('temp')[1]
    local description = weather_widget:get_children_by_id('description')[1]
    local sunrise = weather_widget:get_children_by_id('sunrise')[1]
    local sunset = weather_widget:get_children_by_id('sunset')[1]

    container:setup {
        weather_widget,
        valign = 'center',
        layout = wibox.layout.align.horizontal
    }
    local function format_celcius(kelvin)
        return string.format("%s°C", math.floor(kelvin - 273.15))
    end

    local function format_hours(hour)
        if hour < 10 then
            hour = "0"..hour
        end
        return hour
    end

    local function update_widget(widget, stdout, stderr)
        local response = json.decode(stdout)
        icon:set_image(beautiful.assets_path.."weather/"..icon_map[response.weather[1].icon]..file_extension)
        temp:set_text(format_celcius(response.main.temp))
        description:set_text(response.weather[1].description:gsub("^%l", string.upper))

        local sunrise_date = os.date("*t", response.sys.sunrise)
        local sunset_date = os.date("*t", response.sys.sunset)
        sunrise:set_text(format_hours(sunrise_date.hour)..":"..sunrise_date.min)
        sunset:set_text(format_hours(sunset_date.hour)..":"..sunset_date.min)
    end

    -- watch(string.format(get_cmd, url), 1800, update_widget, weather_widget)

    return container
end