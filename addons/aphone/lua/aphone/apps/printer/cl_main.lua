local APP = {}

APP.name = aphone.L("Printer")
APP.icon = "akulla/aphone/app_printer.png"

local lua_grad = Material("akulla/aphone/bg_printer.png", "smooth 1")

function APP:ShowCondition()
	return tobool(aphone.Printer)
end

local wave_wscale = 0.8
local green = Color(46, 204, 113)
local red = Color(255, 82, 82)

local text_infos = {
    ["money"] = true,
    ["sec"] = true,
    ["capacity"] = true,
    ["danger"] = false,
}

function APP:Open(main, main_x, main_y, screenmode)
	// consts
	local font_header = aphone:GetFont("Roboto60")
    local font_small = aphone:GetFont("Small")
    local clr_white60 = aphone:Color("Text_White60")
    local ping_time = 0

    function main:Paint(w, h)
        surface.SetDrawColor(aphone:Color("Black48"))
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(lua_grad)

		local time = (CurTime() / 20) % 1
		local wave_w = -2048 * wave_wscale * time

		// We need to repeat it
		if wave_w + 2048 * wave_wscale < main_x then
			surface.DrawTexturedRect(wave_w + 2048 * wave_wscale, h - main_y*0.45, 2048 * wave_wscale, main_y*0.45)
		end
		surface.DrawTexturedRect(wave_w, h - main_y*0.45, 2048 * wave_wscale, main_y*0.45)

        if ping_time < CurTime() then
            net.Start("APhone_Printer_Ping")
            net.SendToServer()
            ping_time = CurTime() + 5
        end
    end

    local bottom_bg = vgui.Create("DPanel", main)
    bottom_bg:Dock(BOTTOM)
    bottom_bg:SetTall(main_y*0.45)
    bottom_bg:SetPaintBackground(false)

    local getprinters = aphone.Printer.GetPrinters(LocalPlayer()) or {}
    local infos, getprinters = aphone.Printer.GetInfo(getprinters)

    local top = vgui.Create("DPanel", main)
    top:Dock(TOP)
    top:SetTall(main_y * 0.03)
    top:SetPaintBackground(false)

    local panels = {}

    for k, v in ipairs(infos) do
        local title = vgui.Create("DLabel", main)
        title:SetText(aphone.L("printer_" .. v.name) or "nil")
        title:SetFont(font_small)
        title:Dock(TOP)
        title:SetTextColor(clr_white60)
        title:SetContentAlignment(5)
        title:DockMargin(0, main_y*0.03, 0, 0)
        title:SetAutoStretchVertical(true)

        local text = vgui.Create("DLabel", main)
        text:SetText(text_infos[v.name] and aphone.Printer.FormatMoney(v.val) or v.val)
        text:SetFont(font_header)
        text:Dock(TOP)
        text:SetTextColor(text_infos[v.name] and green or red)
        text:SetContentAlignment(5)
        text:SetAutoStretchVertical(true)

        panels[v.name] = text
    end

    local last_check = CurTime()
    function main:Think()
        if last_check < CurTime() then
            local infos, new_printers = aphone.Printer.GetInfo(getprinters)

            for k, v in pairs(infos) do
                panels[v.name]:SetText(text_infos[v.name] and aphone.Printer.FormatMoney(v.val) or v.val)
            end

            getprinters = new_printers
            last_check = CurTime() + 0.2
        end
    end

	main:aphone_RemoveCursor()
end

aphone.RegisterApp(APP)