if SCB_LOADED then return end

local vgui = vgui

local IsValid = IsValid
local pairs = pairs
local LocalPlayer = LocalPlayer

local scb = scb

local tabs = {}
for _, f in ipairs(file.Find("scb/settings/tabs/*.lua", "LUA")) do
	local data = include("scb/settings/tabs/" .. f)
	tabs[data.pos or #tabs + 1] = data
end

function scb.open_settings()
	if IsValid(scb.settings_frame) then
		return scb.settings_frame:Remove()
	end

	local frame = vgui.Create("SCB.Frame")
	frame:SetTitle("SCB | Settings")
	frame:SetSize(382, 420)
	frame:Center()
	frame:MakePopup()

	local sheet = frame:Add("SCB.PropertySheet")
	sheet:Dock(FILL)
	sheet:DockMargin(4, 4, 4, 4)
	sheet:InvalidateParent(true)
	sheet:InvalidateLayout(true)

	for k, v in pairs(tabs) do
		if v.check == false or scb.has_permission(LocalPlayer(), "menu") then
			sheet:AddSheet(v.title, v.func)
		end
	end

	scb.settings_frame = frame
end