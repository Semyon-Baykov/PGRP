local APP = {}

APP.name = "Weather"
APP.icon = "akulla/aphone/app_weather.png"

local day = Material("akulla/aphone/after_noon.jpg")
local night = Material("akulla/aphone/night.jpg")
local rainy = Material("akulla/aphone/rainy.jpg")

function APP:ShowCondition()
	return tobool(StormFox or StormFox2)
end

function APP:Open(main, main_x, main_y)
	local c_w = aphone:Color("Text_White")
	local c_w120 = aphone:Color("Text_White120")
	local header = aphone:GetFont("Roboto40")
	local big = aphone:GetFont("Roboto80")
	local space = aphone.GUI.ScaledSizeY(45)

	function main:Paint(w,h)
		if (StormFox2 and StormFox2.Weather.IsRaining()) or (StormFox and StormFox.IsRaining()) then
			surface.SetMaterial(rainy)
		elseif (StormFox2 and StormFox2.Time.IsDay()) or (StormFox and StormFox.IsDay()) then
			surface.SetMaterial(day)
		else
			surface.SetMaterial(night)
		end

		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(StormFox2 and StormFox2.Weather.GetDescription() or StormFox.GetWeather(), header, main_x / 2, main_y * 0.08, c_w, 1, 1)
		draw.SimpleText(StormFox2 and StormFox2.Time.GetDisplay() or StormFox.GetRealTime(StormFox.GetTime()), header, main_x / 2, main_y * 0.08 + space, c_w120, 1, 1)

		surface.SetFont(big)
		draw.SimpleText(math.Round(StormFox2 and StormFox2.Temperature.Get() or StormFox.GetTemperature(false)) .. "°", big, main_x / 2 + select(1, surface.GetTextSize("°")) / 2, main_y * 0.28, color_white, 1, 1)
	end
	main:aphone_RemoveCursor()
end

aphone.RegisterApp(APP)