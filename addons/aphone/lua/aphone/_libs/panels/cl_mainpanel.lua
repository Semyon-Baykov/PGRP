local PANEL = {}

local wave_wscale = 0.5
local curtime_div = 8
local wave_h = 96

local home_wave = Material("akulla/aphone/home_wave.png", "smooth 1" )
local grad = Material("akulla/aphone/lua_grad1.png")
local rat = 0.2
local stencil_clr = Color(1, 1, 1, 1)

function PANEL:Init()
	local font_tall = aphone:GetFont("DateShow_200")

	local cache_white = aphone:Color("Text_White")
	local cache_white180 = aphone:Color("Text_White180")
	local hour_format = os.date("%H")
	local minute_format = os.date("%M")
	local day_format = aphone.L(os.date("%A"))
	local date_format = os.date("%d") .. " " .. aphone.L(os.date("%B"))
	local font_40 = aphone:GetFont("Roboto40")
	local font_60 = aphone:GetFont("Roboto60")
	local font_svg = aphone:GetFont("SVG_60")
	local font_svg2 = aphone:GetFont("SVG_90")

	if !aphone:Is2D() then
		self:SetPaintedManually(true)

		-- Issue, the ID is displayed with the phone on 3D and it goes in front of the phone
		hook.Add("HUDDrawTargetID", "APhone_HideDrawTarget", function()
			return false
		end )
	end

	self:SetSize(aphone.GUI.ScaledSize(400, 855))
	// I can't use self !
	local self_alt = self

	local lock = vgui.Create("DPanel", self)
	lock:SetSize(self:GetSize())
	lock:Center()
	lock:SetZPos(2)
	lock:aphone_RemoveCursor()

	local unlocked = false

	surface.SetFont(font_tall)
	local hour_x = surface.GetTextSize(hour_format)

	surface.SetFont(font_40)
	local day_x, day_y = surface.GetTextSize(day_format)
	local date_x = surface.GetTextSize(date_format)
	local final_wave_h = aphone.GUI.ScaledSize(wave_h)

	function lock:Paint(w, h)
		local c = CurTime()

		self.aphone_amt = self.aphone_amt or 0
		self.aphone_lastcheck = self.aphone_lastcheck or c
		local dif = c - self.aphone_lastcheck

		// Math.Clamp
		self.aphone_amt = self.aphone_amt + (lock:IsHovered() and dif or -dif)
		self.aphone_amt = self.aphone_amt > 1 and 1 or self.aphone_amt < 0 and 0 or self.aphone_amt
		self.aphone_lastcheck = c

		surface.SetDrawColor(HSVToColor( ((engine.TickCount() + (300 * self.aphone_amt)) * rat ) % 360, 1, 0.8 ))
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(HSVToColor( (engine.TickCount() + 300) * rat % 360, 1, 0.5 ))
		surface.SetMaterial(grad)
		surface.DrawTexturedRect(0, 0, w, h)

		// SimpleText is KILLING FProfiler, so I need to get ahead and cache things I can cache
		surface.SetFont(font_tall)
		surface.SetTextColor(cache_white)

		surface.SetTextPos(w / 2 - hour_x * 0.75, h * 0.2)
		surface.DrawText(hour_format)

		surface.SetTextPos(w / 2 - hour_x * 0.25, h * 0.4)
		surface.DrawText(minute_format)

		surface.SetFont(font_40)
		surface.SetTextColor(cache_white180)

		surface.SetTextPos((w - day_x) / 2, h * 0.63)
		surface.DrawText(day_format)

		surface.SetTextPos((w - date_x) / 2, h * 0.63 + day_y)
		surface.DrawText(date_format)

		surface.SetMaterial(home_wave)
		surface.SetDrawColor(color_white)

		local time = (c / curtime_div) % 1
		local wave_w = -8000 * wave_wscale * time

		// We need to repeat it
		if wave_w + 8000 * wave_wscale < self_alt:GetWide() then
			surface.DrawTexturedRect(wave_w + 8000 * wave_wscale, h - final_wave_h, 8000 * wave_wscale, final_wave_h)
		end
		surface.DrawTexturedRect(wave_w, h - final_wave_h, 8000 * wave_wscale, final_wave_h)

		if self.aphone_amt == 1 and !unlocked then
			unlocked = true
			lock:SetMouseInputEnabled(true)
			lock:MoveTo(0, -aphone.GUI.ScaledSize(855), 0.5, 0, 0.5, function(_, pnl)
				pnl:Remove()
			end)

			self.applist = vgui.Create("aphone_AppList", self_alt)
			self.applist:Dock(FILL)
		end
	end

	if aphone.Call.Infos and !self.already_callpanel then
		self.already_callpanel = vgui.Create("aphone_Call", self)
		self.already_callpanel:SetZPos(4)
	elseif !aphone.first_start then
		local first_start = vgui.Create("DPanel", self)
		first_start:SetSize(self:GetSize())
		first_start:SetZPos(3)

		local start_time = CurTime()
		local first_x, first_y = first_start:GetSize()

		local hello = vgui.Create("DLabel", first_start)
		hello:SetPos(0, first_y * 0.5)
		hello:SetSize(first_x, first_y * 0.1)
		hello:SetAlpha(0)
		hello:SetFont(font_60)
		hello:SetText(aphone.L("Hello"))
		hello:SetContentAlignment(5)
		hello:AlphaTo(255, 0.8, 0.5)
		hello:MoveTo(0, first_y * 0.45, 1, 0.5, 0.5)
		hello:MoveTo(0, first_y * 0.40, 1, 2, 0.5)
		hello:AlphaTo(0, 0.8, 2)
		hello:SetTextColor(color_white)

		local welcome = vgui.Create("DLabel", first_start)
		welcome:SetPos(0, first_y * 0.5)
		welcome:SetSize(first_x, first_y * 0.1)
		welcome:SetAlpha(0)
		welcome:SetFont(font_60)
		welcome:SetTextColor(color_white)
		welcome:SetText(aphone.L("WelcomeTo"))
		welcome:SetContentAlignment(5)
		welcome:AlphaTo(255, 0.8, 2.5)
		welcome:MoveTo(0, first_y * 0.45, 1, 2.5, 0.5)
		welcome:MoveTo(0, first_y * 0.40, 1, 4, 0.5)
		welcome:AlphaTo(0, 0.8, 4, function(_, pnl)
			pnl:Remove()
		end)

		local text_aphone = vgui.Create("DLabel", first_start)
		text_aphone:SetPos(0, first_y * 0.5)
		text_aphone:SetSize(first_x, first_y * 0.1)
		text_aphone:SetAlpha(0)
		text_aphone:SetFont(aphone:GetFont("StartScreen"))
		text_aphone:SetTextColor(color_white)
		text_aphone:SetText("APhone")
		text_aphone:SetContentAlignment(5)
		text_aphone:AlphaTo(255, 0.8, 4.5)
		text_aphone:MoveTo(0, first_y * 0.45, 1, 4.5, 0.5)

		local click_me_remove = vgui.Create("DButton", first_start)
		click_me_remove:SetPos(0, first_y * 0.7)
		click_me_remove:SetSize(first_x, first_y * 0.1)
		click_me_remove:SetAlpha(0)
		click_me_remove:SetText("")
		click_me_remove:AlphaTo(255, 0.8, 6)

		function click_me_remove:Paint(w, h)
			draw.SimpleTextOutlined("w", font_svg2, w / 2, h / 2, cache_white180, 1, 1, 1, Color(255, 255, 255, math.abs(math.sin(CurTime() * 1.5)) * 60))
		end

		function click_me_remove:DoClick()
			timer.Simple(0.5, function()
				aphone.first_start = CurTime()
			end)
			self:SetMouseInputEnabled(false)

			local unlock_smiley = vgui.Create("DLabel", first_start)
			unlock_smiley:SetPos(0, first_y * 0.58)
			unlock_smiley:SetSize(first_x, first_y * 0.1)
			unlock_smiley:SetFont(font_svg)
			unlock_smiley:SetText("z")
			unlock_smiley:SetContentAlignment(5)
			unlock_smiley:AlphaTo(0, 1, 0)
			unlock_smiley:MoveTo(0, first_y * 0.55, 1, 0, 0.5)
			unlock_smiley:SetTextColor(cache_white180)

			if math.Rand(0, 1) < 0.05 then
				unlock_smiley:SetText("(◠﹏◠)")
				unlock_smiley:SetFont(font_40)
			end
		end

		function first_start:Paint(w, h)
			if aphone.first_start then
				if (CurTime() - aphone.first_start) >= 1 then
					self:Remove()
				end 

				render.ClearStencil()
				// Reset
				render.SetStencilWriteMask( 0xFF )
				render.SetStencilTestMask( 0xFF )
				render.SetStencilFailOperation( STENCIL_ZERO )
				render.SetStencilZFailOperation( STENCIL_ZERO )

				// Enable
				render.SetStencilEnable(true)
				render.SetStencilReferenceValue( 1 )
				render.SetStencilCompareFunction( STENCIL_ALWAYS )
				render.SetStencilPassOperation( STENCIL_REPLACE )
					surface.DrawPoly(aphone.GUI.GenerateCircle(w / 2, h * 0.75, (w + h * 1.25) / 2 * (1 - (CurTime() - aphone.first_start))))
					surface.SetDrawColor(stencil_clr)
				render.SetStencilCompareFunction(STENCIL_EQUAL)
			end

			local sec_past = CurTime() - start_time

			surface.SetDrawColor(color_black)
			surface.DrawRect(0, 0, w, h)

			if sec_past > 4.5 then
				surface.SetTexture(surface.GetTextureID( "akulla/aphone/background_startup" ))
				surface.SetDrawColor(255, 255, 255, (sec_past - 4.5) * 255)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end

		function first_start:PaintOver()
			render.SetStencilEnable(false)
		end
		first_start:aphone_RemoveCursor()
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(aphone.GUI.GetBackground())

	local wi, hi = aphone.GUI.ScaledSize(400, 855)

	surface.DrawTexturedRectRotated(w/2, h/2, wi, hi, w < h and 0 or 90)
end

function PANEL:PaintOver(w, h)
	// There is the white fade when you change display mode ( horizontal/vertical )
	if aphone.horizontal_ratio and aphone.horizontal_ratio != 0 and aphone.horizontal_ratio != 1 then
		local alpha = math.abs(aphone.horizontal_ratio - 0.5) * 2

		surface.SetDrawColor(255, 255, 255, (1 - alpha) * 255)
		surface.DrawRect(0, 0, w, h)

		if alpha < 0.15 and aphone.asking_changestate then
			aphone.asking_changestate = false

			if !aphone.Horizontal then
				self:SetSize(aphone.GUI.ScaledSize(400, 855))
			else
				self:SetSize(aphone.GUI.ScaledSize(855, 400))
			end

			if aphone.Call and aphone.Call.Infos then
				local call = vgui.Create("aphone_Call", aphone.MainDerma)
				call:SetZPos(3)
			
				if !aphone.Call.Infos.pending then
					call:Accepted()
				end
			end

			for k, v in pairs(aphone.MainDerma:GetChildren()) do
				if v:GetName() == "aphone_AppList" then
					v:SetVisible(!aphone.Horizontal)
					break
				end
			end

			// Forced ? then skip anims, we don't know why it's forced
			if aphone.Force_AllowHorizontal then
				aphone.App_Panel:SetSize(self:GetSize())
			elseif IsValid(aphone.App_Panel) then
				// Remove old app
				aphone.App_Panel:Clear()

				local pos_x, pos_y = self:GetSize()

				// Re-create things
				// p, same as main in APP:Open
				local p = vgui.Create("DPanel", aphone.App_Panel)
				p:SetSize(self:GetSize())

				// Close button
				local b_menu = vgui.Create("DButton", p)
				b_menu:SetText("")
				b_menu:Dock(BOTTOM)
				b_menu:SetTall(aphone.Horizontal and pos_y * 0.04 or pos_y * 0.02)
				b_menu:DockMargin(pos_x * 0.2, 0, pos_x * 0.2, 0)

				function b_menu:Paint(w, h)
					draw.RoundedBox(h / 4, 0, 0, w, h / 2, color_black)
					draw.RoundedBox(h / 4, 2, 2, w-4, h / 2-4, color_white)

					if input.IsMouseDown(MOUSE_MIDDLE) and IsValid(aphone.App_Panel) then
						local hoveredpnl = vgui.GetHoveredPanel()
						if !IsValid(hoveredpnl) or hoveredpnl.aphone_dontmiddlemouse then return end

						self:DoClick()
					end
				end

				function b_menu:DoClick()
					if !aphone.Horizontal then
						local anim = aphone.App_Panel:NewAnimation(0.5, 0, 0.5)

						function anim:Think(_, frac_anim)
							aphone.App_Panel.frac = frac_anim
						end
					end

					if aphone.HorizontalApp then
						aphone.RequestAnim(1)
					end

					aphone.App_Panel.phone_gettingremoved = true
				end

				// Open our new app
				aphone.HorizontalApp = aphone.Horizontal

				if aphone.Horizontal then
					aphone.Running_App:Open2D(p, self:GetSize())
				else
					aphone.Running_App:Open(p, self:GetSize())
				end
			else
				aphone.HorizontalApp = false
			end
		end
	end
end

function PANEL:OnRemove()
	aphone.RV = {}
	hook.Remove("HUDDrawTargetID", "APhone_HideDrawTarget")
end

vgui.Register("aphone_Main", PANEL, "EditablePanel")