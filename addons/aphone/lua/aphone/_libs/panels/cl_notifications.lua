// Config
local notif_ids = {
	["alert"] = {
		mat = Material("akulla/aphone/phone_popup_alert.png", "smooth 1"),
		mat_bg = Color(255, 82, 82),
	},
	["bell"] = {
		mat = Material("akulla/aphone/phone_popup_bell.png", "smooth 1"),
		mat_bg = Color(52, 152, 219),
	},
	["good"] = {
		mat = Material("akulla/aphone/phone_popup_good.png", "smooth 1"),
		mat_bg = Color(46, 204, 113),
	},
}

local function addnotif(background, icon, msg, cd)
	if aphone.RunningNotif or !aphone.NotifPanel or !IsValid(aphone.NotifPanel) then return end

	aphone.RunningNotif = true
	aphone.NotifPanel:SetMouseInputEnabled(true)

	local last_curtime = CurTime()
	local p = vgui.Create("DPanel", aphone.NotifPanel)
	p:SetMouseInputEnabled(false)

	function p:Paint(w, h)
		draw.RoundedBox(16, 0, 0, w, h, background)
	end

	local icon_pnl = vgui.Create("DPanel", p)
	icon_pnl:Dock(TOP)
	icon_pnl:DockMargin(0, aphone.GUI.ScaledSizeX(3), 0, 0)
	icon_pnl:SetTall(aphone.GUI.ScaledSizeY(40))
	icon_pnl:SetMouseInputEnabled(false)

	function icon_pnl:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect((w-h) / 2, 0, h, h)
	end

	local wrapped_text = aphone.GUI.WrapText(msg, aphone:GetFont("MediumHeader"), aphone.NotifPanel:GetWide()*0.8)

	local text = vgui.Create("DLabel", p)
	text:Dock(FILL)
	text:SetFont(aphone:GetFont("MediumHeader"))
	text:SetText(wrapped_text)
	text:SetContentAlignment(5)
	text:DockMargin(aphone.GUI.ScaledSize(3, 3, 3, 3))
	text:SetMouseInputEnabled(false)

	surface.SetFont(aphone:GetFont("MediumHeader"))

	local final_x = aphone.NotifPanel:GetWide()*0.84
	local final_y = select(2, surface.GetTextSize(wrapped_text)) + aphone.GUI.ScaledSizeY(60)

	// Anim : Pop-up
	p:SetSize(final_x * 1.5, final_y * 1.5)
	p:Center()

	p:SizeTo(final_x, final_y, 0.4, 0, 0.5)
	p:MoveTo((aphone.GUI.ScaledSizeX(405) - final_x) / 2, (aphone.GUI.ScaledSizeY(850) - final_y) / 2, 0.4, 0, 0.5)
	p:SetAlpha(0)
	p:AlphaTo(255, 0.4, 0)

	// Anim : Remove Pop-up
	local started_backanim = false

	function aphone.NotifPanel:Paint(w, h)
		local sum = last_curtime + cd - 0.25
		if sum < CurTime() then
			surface.SetDrawColor(0, 0, 0, Lerp((CurTime() - sum) * 4, 240, 0))

			if !started_backanim then
				p:SizeTo(final_x * 1.5, final_y * 1.5, 0.25, 0, 0.5)
				p:AlphaTo(0, 0.25, 0)
				p:MoveTo((aphone.GUI.ScaledSizeX(400) - final_x * 1.5) / 2, (aphone.GUI.ScaledSizeY(850) - final_y * 1.5) / 2, 0.25, 0, 0.5)
				started_backanim = true
			end
		else
			local sec = CurTime() - last_curtime

			// not clamping with math.clamp, With fprofiler I got bad experiences with math.clamp
			sec = sec > 0.25 and 0.25 or sec
			surface.SetDrawColor(0, 0, 0, Lerp(sec * 4, 0, 240))
		end

		surface.DrawRect(0, 0, w, h)
	end

	timer.Simple(cd, function()
		aphone.RunningNotif = false
		p:Remove()
		aphone.NotifPanel:SetMouseInputEnabled(false)
	end)

	aphone.NotifPanel:aphone_RemoveCursor()
end

function aphone.AddNotif(type, msg, cd)
	local infos = notif_ids[type]

	if !infos then
		// MAYBE WE GOT EM
		local app = aphone.RegisteredApps[type]

		if app then
			notif_ids[type] = {
				mat = app.icon,
				mat_bg = app.color or color_white,
			}

			infos = notif_ids[type]
		else
			return
		end
	end

	addnotif(infos.mat_bg, infos.mat, msg, cd)
end