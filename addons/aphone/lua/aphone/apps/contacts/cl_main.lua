local APP = {}

APP.name = aphone.L("Contacts")
APP.icon = "akulla/aphone/app_contacts.png"

local clr_green = Color(46, 204, 113)

function APP:Open(main, main_x, main_y, screenmode)
	local clr_black2 = aphone:Color("Black2")
	local clr_white = aphone:Color("Text_White")
	local clr_white120 = aphone:Color("Text_White120")
	local clr_black3 = aphone:Color("Black3")
	local clr_red = aphone:Color("mat_red")
	local font_mediumheader = aphone:GetFont("MediumHeader")
	local font_svg30 = aphone:GetFont("SVG_30")

	function main:Paint(w, h)
		surface.SetDrawColor(clr_black2)
		surface.DrawRect(0,0,w,h)
	end

	local top_app = vgui.Create("DPanel", main)
	top_app:Dock(TOP)
	top_app:DockMargin(main_y * 0.03, main_y * 0.045, main_y * 0.03, 0)
	top_app:SetTall(screenmode and main_x * 0.075 or main_y * 0.075)
	top_app:SetPaintBackground(false)

	local ply = LocalPlayer()
	local local_num = LocalPlayer():aphone_GetNumber()

	function top_app:Paint(w, h)
		draw.SimpleText(ply:Nick(), font_mediumheader, h * 1.25, h / 2, clr_white, 0, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(local_num, font_mediumheader, h * 1.25, h / 2, clr_white120, 0, TEXT_ALIGN_TOP)
	end

	local avatar = vgui.Create("aphone_CircleAvatar", top_app)
	avatar:Dock(LEFT)
	avatar:SetWide(top_app:GetTall())
	avatar:SetPlayer(LocalPlayer(), 128)

	local p = vgui.Create("DButton", main)
	p:Dock(BOTTOM)
	p:SetTall(aphone.GUI.ScaledSizeY(60))
	p:SetPaintBackground(false)
	p:TDLib()
	p:BarHover(aphone:Color("mat_red"), 3)
	p:Text("+", aphone:GetFont("Roboto60"))
	p:DockMargin(main_x / 2 - aphone.GUI.ScaledSizeX(30), 0, main_x / 2 - 30, screenmode and main_y * 0.04 or main_x * 0.075)

	local main_scroll = vgui.Create("DScrollPanel", main)
	main_scroll:Dock(FILL)
	main_scroll:DockMargin(main_x * 0.075, 0, main_x * 0.075, 0)
	main_scroll:aphone_PaintScroll()

	function main_scroll:Add_Contact(contact_id, contact_name, create)
		local p = main_scroll:Add("DPanel")
		p:Dock(TOP)
		p:DockMargin(0, main_x * 0.040, 0, main_x * 0.040)
		p:SetTall(aphone.GUI.ScaledSizeY(100))

		if screenmode then
			p:DockMargin(0, main_y * 0.02, 0, main_y * 0.02)
		else
			p:DockMargin(0, main_x * 0.075, 0, 0)
		end

		local is_connected = false
		for _, j in ipairs(player.GetHumans()) do
			if j:aphone_GetID() == k then
				is_connected = true
				break
			end
		end

		local num = contact_id == 0 and aphone.L("No_Number") or aphone.GetNumber(contact_id)

		function p:Paint(w, h)
			if !self:IsHovered() and !self:IsChildHovered() then
				draw.RoundedBox(16, 0, 0, w, h, clr_black3)
			else
				draw.RoundedBox(16, 0, 0, w, h, is_connected and clr_green or clr_red)
			end
		end

		local close = vgui.Create("DButton", p)
		close:DockMargin(0, 0, aphone.GUI.ScaledSizeX(16), 0)
		close:Dock(RIGHT)
		close:SetWide(select(1, draw.SimpleText("S", font_svg30)) * 1.2)
		close:SetText("")

		function close:Paint(w, h)
			if p:IsHovered() or p:IsChildHovered() then
				draw.SimpleText("S", font_svg30, w / 2, h / 2, clr_white, 1, 1)
			end
		end

		function close:DoClick()
			p:Remove()
			aphone.Contacts.Remove(contact_id)
		end

		surface.SetFont(aphone:GetFont("Roboto40"))
		local text_h = select(2, surface.GetTextSize(contact_name))

		local modify_name = vgui.Create("DLabel", p)
		modify_name:Dock(TOP)
		modify_name:SetTall(text_h)
		modify_name:SetText(contact_name)
		modify_name:SetFont(aphone:GetFont("Roboto40"))
		modify_name:SetTextColor(clr_white)
		modify_name:DockMargin(aphone.GUI.ScaledSizeX(32), p:GetTall() / 2 - text_h, 0, 0)
		modify_name:SetMouseInputEnabled(true)

		function modify_name:textEnd(text_pnl)
			aphone.Contacts.ChangeName(contact_id, text_pnl)
			contact_name = text_pnl
			self:SetText(text_pnl)
		end

		function modify_name:DoClick()
			modify_name:Phone_AskTextEntry(contact_name, 32)
		end

		surface.SetFont(font_mediumheader)
		text_h = select(2, surface.GetTextSize(num))

		local number_label = vgui.Create("DLabel", p)
		number_label:Dock(TOP)
		number_label:SetTall(text_h)
		number_label:SetText(num)
		number_label:SetFont(font_mediumheader)
		number_label:SetTextColor(aphone:Color("Text_White120"))
		number_label:DockMargin(aphone.GUI.ScaledSizeX(32), 0, 0, p:GetTall() / 2 - text_h)

		if contact_id == 0 then
			number_label:SetMouseInputEnabled(true)

			function number_label:textEnd(text_pnl)
				for k, v in ipairs(player.GetHumans()) do
					if v:aphone_GetNumber() == text_pnl then
						if aphone.Contacts.GetName(v:aphone_GetID()) then
							self:SetText( aphone.L("Already_Exist") )
							return
						end

						self.AP_NoClick = true
						num = text_pnl
						aphone.Contacts.Add(v:aphone_GetID(), modify_name:GetText())

						return
					end
				end

				self:SetText(aphone.L("PlayerNotFound"))
			end

			function number_label:DoClick()
				if self.AP_NoClick then return end
				local str = string.len(string.Replace(aphone.Format, "%", ""))
				number_label:Phone_AskTextEntry(self:GetText(), str)
			end
		end

		p:aphone_RemoveCursor()
	end

	for k, v in pairs(aphone.Contacts.GetContacts()) do
		main_scroll:Add_Contact(k, v)
	end

	function p:DoClick()
		main_scroll:Add_Contact(0, aphone.L("ChangeName"))
	end

	main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
	self:Open(main, main_x, main_y, true)
end

aphone.RegisterApp(APP)