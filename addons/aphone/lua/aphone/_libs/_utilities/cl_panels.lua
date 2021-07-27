local meta = FindMetaTable("Panel")

function meta:Phone_AskTextEntry(text, max_char, panel_resize, panel_wide, only_resizetargetpnl)
	// If you make a error with that, this will catch it, I can't take the risk to hostage the player with invisible, self-locking panel
	local pnl = self
	local hit_me = vgui.Create("EditablePanel")
	hit_me:SetSize(ScrW(), ScrH())
	hit_me:SetMouseInputEnabled(true)

	local good, err = pcall(function()
		local t = vgui.Create("DTextEntry", hit_me)
		t:MakePopup()
		t:SetSize(ScrW(), ScrH())
		t:SetAlpha(0)
		t:SetMultiline(false)
		t:SetValue(text or "")
		t.aphone_dontmiddlemouse = true

		if placeholder then
			t:SetPlaceholderText(placeholder)
		end

		pnl.oldsize_text = pnl.oldsize_text or pnl:GetTall()

		if panel_resize then
			panel_resize.oldsize_text = panel_resize.oldsize_text or panel_resize:GetTall()
		end

		local oldsize = pnl.oldsize_text

		surface.SetFont(pnl:GetFont())
		local txt_w = surface.GetTextSize("... | ")

		local block_change = false
		function t:OnChange()
			if block_change then return end

			local txt = self:GetValue() or ""
			local cursorpos = self:GetCaretPos()

			txt = utf8.sub(txt, 1, cursorpos) .. "|" .. utf8.sub(txt, cursorpos + 1)

			pnl:SetText(txt)

			if IsValid(pnl) and pnl.textChange then
				pnl:textChange(self:GetValue())
			end

			if panel_resize then
				// Remove first line, it should be in the old_size
				local wrapped_text = aphone.GUI.WrapText(pnl:GetText(), pnl:GetFont(), (panel_wide or pnl:GetWide()) - txt_w) or "o"
				local splitted_tbl = string.Split( wrapped_text, "\n" )
				table.remove(splitted_tbl, 1)

				// Font already set by wraptext
				if !table.IsEmpty(splitted_tbl) then
					pnl:SetText(wrapped_text)
				end

				local wrapped_size = select(2, surface.GetTextSize(wrapped_text))

				if wrapped_size < oldsize then
					if !only_resizetargetpnl then
						pnl:SetTall(oldsize)
					end

					panel_resize:SetTall(panel_resize.oldsize_text)
				else
					if !only_resizetargetpnl then
						pnl:SetTall(oldsize + select(2, surface.GetTextSize(wrapped_text)))
					end

					panel_resize:SetTall(panel_resize.oldsize_text + select(2, surface.GetTextSize(wrapped_text)))
				end
			end
		end

		if max_char then
			function t:AllowInput()
				return string.len(self:GetValue()) > max_char
			end
		end

		local old_caret = t:GetCaretPos()

		function t:Think()
			if !IsValid(pnl) then
				self:Remove()
			end

			if old_caret != t:GetCaretPos() then
				self:OnChange()

				if pnl:GetName() != "DTextEntry" then
					old_caret = t:GetCaretPos()
				else
					pnl:SetCaretPos(self:GetCaretPos())
				end
				old_caret = t:GetCaretPos()
			end
		end

		function t:OnEnter()
			block_change = true
			pnl:SetText(self:GetValue())
			if IsValid(pnl) and pnl.textEnd then
				pnl:textEnd(self:GetValue(), aphone.GUI.WrapText(pnl:GetText(), pnl:GetFont(), (panel_wide or pnl:GetWide()) - txt_w))
			end
			hit_me:Remove()
		end

		function t:OnMousePressed()
			if t.OnEnter then
				t:OnEnter()
			end
		end

		// Refresh
		t:OnChange()
		hit_me:aphone_RemoveCursor()

		return t
	end )

	if !good then
		aphone.AddNotif("alert", aphone.L("Error_FailedTextScreen"), 3)
		hit_me:Remove()
		ErrorNoHaltWithStack(err)
	end
end

function meta:Phone_AlphaHover()
	function self:OnCursorEntered()
		self:SetTextColor(aphone:Color("Text_White"))
	end

	function self:OnCursorExited()
		self:SetTextColor(aphone:Color("Text_White120"))
	end

	self:SetTextColor(aphone:Color("Text_White120"))
end

function meta:Phone_DrawTop(w, h, dark)
	local hour_label = vgui.Create("DLabel", self)
	hour_label:SetPos(w * 0.08, 0)
	hour_label:SetFont(aphone:GetFont("Little2"))
	hour_label:SetText(os.date("%H:%M"))
	hour_label:SetSize(w * 0.25, h * 0.05)
	hour_label:SetTextColor(dark and color_black or color_white)

	local wifi_label = vgui.Create("DLabel", self)
	wifi_label:SetPos(w * 0.82, 0)
	wifi_label:SetFont(aphone:GetFont("SVG_25"))
	wifi_label:SetText("s")
	wifi_label:SetSize(w * 0.25, h * 0.05)
	wifi_label:SetTextColor(dark and color_black or color_white)
	wifi_label.stack_minutes = math.ceil(os.time() / 60)

	// This sounds weird, but it's the way I found to refresh time, without using the drawtext and taking performances
	function hour_label:Think()
		local actual_stack = math.ceil(os.time() / 60)
		if wifi_label.stack_minutes != actual_stack then
			self:SetText(os.date("%H:%M"))
			wifi_label.stack_minutes = actual_stack
		end
	end

	local radio_label = vgui.Create("DLabel", self)
	radio_label:SetPos(w * 0.80, 0)
	radio_label:SetFont(aphone:GetFont("SVG_25"))
	radio_label:SetText("p")
	radio_label:SetSize(w * 0.25, h * 0.05)
	radio_label:SetTextColor(dark and color_black or color_white)
	radio_label.stack_minutes = math.ceil(os.time() / 60)
	radio_label:SetAlpha(0)

	function radio_label:Think()
		if IsValid(aphone.My_Radio) then
			if self:GetAlpha() == 0 then
				self:SetAlpha(255)
				wifi_label:SetPos(w * 0.87, 0)
			end
		else
			if self:GetAlpha() == 255 then
				wifi_label:SetPos(w * 0.82, 0)
				self:SetAlpha(0)
			end
		end
	end
end