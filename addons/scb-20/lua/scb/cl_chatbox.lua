if SCB_LOADED then return end

local draw = draw
local surface = surface
local math = math
local hook = hook
local gui = gui
local net = net

local IsValid = IsValid
local ipairs = ipairs

local color_white = color_white

local scb = scb
local sui = sui
local SUI = scb.SUI
local utf8 = sui.utf8

for k, v in ipairs({18, 16, 14}) do
	_G["SCB_" .. v] = SUI.CreateFont(tostring(v), "Roboto", v)
end

scb.pattern = "%{ *([%w_%#%$@%*!]+)([^%{}]-) *%}"

function scb.open_parsers_menu()
	if IsValid(scb.parsers_menu) then
		return scb.parsers_menu:Remove()
	end

	local text_entry = scb.chatbox.text_entry

	local parsers_menu = vgui.Create("SCB.Frame")
	scb.parsers_menu = parsers_menu

	parsers_menu:SetSize(320, 340)
	parsers_menu:Center()
	parsers_menu:MakePopup()
	parsers_menu:SetTitle("SCB | Chat Parsers")

	local parsers_list = parsers_menu:Add("SCB.ScrollPanel")
	parsers_list:Dock(FILL)
	parsers_list:DockMargin(4, 4, 4, 4)
	parsers_list:InvalidateParent(true)
	parsers_list:InvalidateLayout(true)

	for k, v in ipairs(scb.chat_parsers) do
		local parser = parsers_list:Add("DButton")
		parser:Dock(TOP)
		parser:DockMargin(2, 2, 2, 2)
		parser:DockPadding(2, 2, 2, 2)
		parser:InvalidateParent(true)
		parser:SetText("")

		parser:SUI_TDLib()
		parser:ClearPaint()
		parser:Background(SUI.GetColor("on_sheet"), 3)
		parser:FadeHover(SUI.GetColor("on_sheet_hover"), _, 3)

		function parser:DoClick()
			parsers_menu:Remove()
			scb.chatbox:MoveToFront()
			text_entry:RequestFocus()
			text_entry:AddValue(v[3] .. " ")
		end

		local title = parser:Add("SCB.Label")
		title:Dock(TOP)
		title:SetAutoStretchVertical(true)
		title:SetWrap(true)
		title:SetFont(SCB_16)
		title:SetText(v[1])
		title:InvalidateParent(true)

		local example = parser:Add("SCB.ChatLine")
		example:Dock(TOP)
		example:DockMargin(0, 1, 0, 0)
		example:InvalidateParent(true)
		example:InvalidateLayout(true)
		example:Parse(v[2])
		example:SetMouseInputEnabled(false)

		function parser:PerformLayout()
			self:SizeToChildren(false, true)
		end
	end
end

local function invalidate_children(self, recursive)
	local children = self:GetChildren()
	for i = 1, #children do
		if recursive then
			invalidate_children(children[i])
		else
			children[i]:InvalidateLayout(true)
		end
	end
	self:InvalidateLayout(true)
end

function scb.create_chatbox()
	if scb.chatbox then return end

	sui.TDLib.Start()

	local frame = vgui.Create("SCB.Frame", nil, "SCB")
	scb.chatbox = frame

	local c_x = CreateClientConVar("scb_x", sui.scale(18), true, false, "")
	local c_y = CreateClientConVar("scb_y", ScrH() - SUI.Scale(220) - sui.scale(170), true, false, "")
	local c_w = CreateClientConVar("scb_w", 480, true, false, "")
	local c_h = CreateClientConVar("scb_h", 220, true, false, "")

	frame:SetSizable(true)
	frame:SetMinWidth(SUI.Scale(300))
	frame:SetMinHeight(SUI.Scale(160))
	frame:SetSize(c_w:GetInt(), c_h:GetInt())
	frame:SetPos(c_x:GetInt(), c_y:GetInt())
	frame:ParentToHUD()
	frame:MakePopup()

	frame.title.background_color = true

	local chatbox_title = scb.config.chatbox_title
	frame:SetTitle(chatbox_title)
	if chatbox_title:find("SERVER_NAME") or chatbox_title:find("PLAYER_COUNT") then
		local delay = 2
		local next_run = UnPredictedCurTime()

		frame:On("Think", function(s)
			if UnPredictedCurTime() < next_run then return end
			next_run = UnPredictedCurTime() + delay

			s:SetTitle(chatbox_title:gsub("SERVER_NAME", GetHostName()):gsub("PLAYER_COUNT", player.GetCount()))
		end)
	end

	function frame:OnPosChanged()
		c_x:SetInt(self.x)
		c_y:SetInt(self.y)
	end

	function frame:OnSizeChanged(w, h)
		c_w:SetInt(w)
		c_h:SetInt(h)
	end

	function frame:AddPanelToHide(panel)
		if not self.panels_to_hide then
			self.panels_to_hide = {self}
		end
		table.insert(self.panels_to_hide, panel)
	end

	function frame:SetVisible(visible)
		self.hidden = not visible
		local panels_to_hide = self.panels_to_hide
		for i = 1, #panels_to_hide do
			local v = panels_to_hide[i]
			v.Paint, v.oldPaint = visible and (v.oldPaint or v.Paint) or nil, not visible and v.Paint or nil
			if v.background_color or v.old_bg_color then
				v.background_color, v.old_bg_color = visible and (v.old_bg_color or v.background_color) or nil, not visible and v.background_color or nil
				v:SetBGColor(v.background_color)
			end
		end
		return self.hidden
	end

	function frame:IsVisible()
		return not self.hidden
	end

	frame.close.DoClick = chat.Close

	local scroll_panel = frame:Add("SCB.ScrollPanel")
	scroll_panel:Dock(FILL)
	scroll_panel:DockMargin(4, 4, 4, 0)
	scroll_panel:SetFromBottom(true)

	function scroll_panel:ScrollToBottom()
		self:GetParent():InvalidateLayout(true)
		invalidate_children(self)

		local vbar = self.VBar
		vbar:SetScroll(vbar.CanvasSize)
	end

	local canvas = scroll_panel:GetCanvas()
	canvas:DockPadding(2, 2, 2, 2)

	function scroll_panel:ShouldScrollDown()
		local vbar = self.VBar
		local canvas_size = vbar.CanvasSize
		return frame.hidden or canvas_size == 1 or canvas_size <= vbar.scroll_target
	end

	local count = 0
	local max_messages_convar = GetConVar("scb_max_messages")
	local fixed_width = false
	function scroll_panel:ChildAdded()
		local vbar = self.VBar
		if vbar.Enabled then
			if not fixed_width then
				for k, v in ipairs(canvas.children) do
					if v.ScaleChanged then
						v:ScaleChanged()
					end
				end
				fixed_width = true
				return self:ChildAdded()
			end
		else
			fixed_width = nil
		end

		count = count + 1

		local max = max_messages_convar:GetInt()
		if count <= max then return end

		local down = self:ShouldScrollDown()

		local full_h = 0
		local children = canvas.children
		for i = count, max + 1, -1 do
			local child = children[i - max]
			if not child.being_removed then
				child.being_removed = true
				full_h = full_h + child:GetTotalH()
				child:Remove()

				count = count - 1
			end
		end

		local scroll = vbar.Scroll
		if down then
			vbar.Scroll = scroll - full_h
		else
			vbar.Scroll = scroll - full_h
			vbar.scroll_target = scroll
		end
	end

	frame:InvalidateLayout(true)
	invalidate_children(frame, true)

	local preview = vgui.Create("Panel")
	preview:SetMouseInputEnabled(false)
	preview:ParentToHUD()

	local preview_bg = vgui.Create("Panel")
	preview_bg:Hide()
	preview_bg:ParentToHUD()
	preview_bg:MoveToBack()

	preview_bg:Blur()
		:Background(Color(50, 50, 50, 200))

	frame:On("PerformLayout", function(s, w, h)
		local f_x, f_y = s:GetPos()
		local new_x, new_y = f_x + ((w / 2) - ((preview.w or 0) / 2)), f_y + h + 4
		preview:SetPos(new_x, new_y)
		preview_bg:SetPos(new_x - 4, new_y - 4)
	end)

	local text_entry = frame:Add("SCB.TextEntry")
	text_entry:Dock(BOTTOM)
	text_entry:DockMargin(4, 4, 4, 4)
	text_entry:SetTall(24)
	text_entry:SetPlaceholder("начните писать...")
	text_entry:SetFont(SCB_18)
	text_entry:SetMultiline(true)
	text_entry:SetVerticalScrollbarEnabled(true)
	text_entry:InvalidateParent(true)
	text_entry:SetMaxChars(126)
	text_entry:SetNoBar(true)

	if scb.config.hide_language_sign then
		text_entry:SetDrawLanguageID(false)
	end

	function text_entry:OnEnter()
		local txt = self:GetValue()
		if txt == "" then chat.Close() return end
		local length = #txt
		net.Start(frame.bteam ~= 1 and "SCB.SendMessageTeam" or "SCB.SendMessage")
			net.WriteUInt(length, 8)
			net.WriteData(txt, length)
		net.SendToServer()
		self:AddHistory(txt)
		chat.Close()
	end

	local old_Paint = text_entry.Paint
	function text_entry:Paint(w, h)
		local outline = SUI.GetColor("scroll_panel_outline")
		if outline then
			sui.TDLib.DrawOutlinedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"), outline, 1)
		else
			draw.RoundedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"))
		end

		old_Paint(self, w, h)
	end

	function text_entry:OnValueChange(value)
		self.using_scale = true

		local down = scroll_panel:ShouldScrollDown()

		-- https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/vgui2/vgui_controls/TextEntry.cpp#L3790
		self:SetTall(self:GetNumLines() * (SUI.Scale(18) --[[font size]] + 1) + 1 + 2)

		if down then
			scroll_panel:ScrollToBottom()
		end

		if value == "" then
			gui.InternalKeyCodeTyped(KEY_LEFT)
		end

		hook.Run("ChatTextChanged", value)
	end
	text_entry:OnValueChange("")

	do
		local emojis_table = {
			"grinning", "grin", "joy",
			"smiley", "smile", "sweat_smile",
			"laughing", "innocent", "smiling_imp",
			"wink", "blush", "yum", "relieved",
			"heart_eyes", "sunglasses", "smirk",
			"neutral_face", "expressionless", "unamused",
			"sweat", "pensive", "confused",
			"rage", "partying_face", "cold_face",
			"hot_face", "face_with_cowboy_hat"
		}

		local real_size = 0
		local mat, padding = SUI.Material("scb/emojis/flushed.png"), 3

		local emojis_button = text_entry:Add("DButton")
		emojis_button:SetText("")
		emojis_button:SetMouseInputEnabled(true)
		emojis_button:NoClipping(true)

		function emojis_button:IsActive()
			return self:IsHovered() or IsValid(scb.emojis_menu)
		end

		local inactive_col = Color(175, 175, 175)
		function emojis_button:Paint(w, h)
			surface.SetDrawColor(self:IsActive() and color_white or inactive_col)
			surface.SetMaterial(mat)
			surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, real_size, real_size, 0)
		end

		function emojis_button:OnCursorEntered()
			if not IsValid(scb.emojis_menu) then
				mat = SUI.Material("scb/emojis/" .. emojis_table[math.random(1, #emojis_table)] .. ".png")
			end
		end

		function emojis_button:Think()
			self:MoveToFront()
			real_size = Lerp(RealFrameTime() * 15, real_size, self:IsActive() and SUI.Scale(22) or SUI.Scale(18))
		end

		function emojis_button:DoClick()
			if IsValid(scb.emojis_menu) then
				return self:OnRemove()
			end

			local emojis_menu = vgui.Create("SCB.EmojiList")
			emojis_menu.button = self

			scb.emojis_menu = emojis_menu
		end

		function emojis_button:OnRemove()
			if IsValid(scb.emojis_menu) then
				scb.emojis_menu:Remove()
			end
		end

		text_entry:On("PerformLayout", function(s, w, h)
			local size = SUI.ScaleEven(18)
			emojis_button:SetSize(size, size)
			emojis_button:SetPos(w - (size + padding), h / 2 - size / 2)

			local vbar = s:GetChildren()[1]
			if vbar then
				vbar:Hide()
				vbar:SetWide(math.Round(size + padding))
			end
		end)

		frame.emojis_button = emojis_button
		frame:AddPanelToHide(emojis_button)
	end

	-- Message Preview
	text_entry:On("OnValueChange", function(self, value)
		preview:SetWide(SUI.Scale(340))
		preview:Clear()
		preview_bg:Hide()

		if value == "" then return end

		local line = preview:Add("SCB.ChatLine")
		line:SetPlayer(LocalPlayer())
		line:SetAlpha(255)
		line:Parse(value)
		line:SizeToChildren(true, true)

		preview:SizeToChildren(false, true)
		preview:SetWide(line:GetMessageW())
		preview.w = line:GetMessageW()
		preview_bg:SetSize(preview.w + 8, preview:GetTall() + 8)
		preview_bg:Show()
	end)
	--

	-- Emoji Select
	local emoji_list

	local open_emojis_list = function(emoji_name, start, _end)
		local selected_text
		if IsValid(emoji_list) then
			selected_text = emoji_list.selected_emoji and emoji_list.selected_emoji.name
			emoji_list:Remove()
		end

		local emojis = scb.search_emojis(emoji_name)
		if #emojis == 0 then return end

		emoji_list = frame:Add("SCB.EmojisSelect")
		emoji_list:SetWide(text_entry:GetWide())
		emoji_list:SetTextEntry(text_entry)
		emoji_list:SetStartEnd(start, _end)

		for _, v in ipairs(emojis) do
			local emoji = emoji_list:AddEmoji(v.name)
			if emoji.name == selected_text then
				emoji_list.selected_emoji = emoji
			end

			if #emoji_list.emojis == math.floor(SUI.Scale(120) / SUI.Scale(22)) then
				break
			end
		end

		emoji_list:SetPos(text_entry.x, text_entry.y - emoji_list:GetTall())
	end

	local typing_emoji = function()
		local value = text_entry:GetValue()
		local start, _end, emoji_name = 0
		while true do
			start, _end, emoji_name = value:find("%:([%w_]+)", _end)
			if not start then break end
			if utf8.len(value:sub(1, _end)) == text_entry:GetCaretPos() and not value:sub(_end + 1, _end + 1):match("%S") then
				return open_emojis_list(emoji_name:lower(), start, _end)
			end
			_end = _end + 1
		end

		if IsValid(emoji_list) then
			emoji_list:Remove()
		end
	end

	local old = text_entry.OnKeyCodeTyped
	function text_entry:OnKeyCodeTyped(code)
		if frame.hidden then return end

		if code == KEY_BACKQUOTE then
			gui.HideGameUI()
		elseif emoji_list and emoji_list[code] then
			return emoji_list[code](emoji_list)
		elseif code == KEY_ESCAPE then
			gui.HideGameUI()
			chat.Close()
			return
		elseif code == KEY_TAB then
			local text = hook.Run("OnChatTab", self:GetValue())
			if scb.isstring(text) then
				self:SetValue(text)
			end
			self:SetCaretPos(#self:GetValue())
			self:RequestFocus()
			return true
		end

		return old(self, code)
	end

	text_entry:On("OnValueChange", typing_emoji)
	text_entry:On("OnKeyCodeReleased", function(_, code)
		if code == KEY_LEFT or code == KEY_RIGHT then
			typing_emoji()
		end
	end)

	SUI.OnScaleChanged("EmojisListRemove", function()
		if IsValid(emoji_list) then
			emoji_list:Remove()
		end

		timer.Simple(0, function()
			text_entry:OnValueChange(text_entry:GetValue())
		end)
	end)
	--

	local settings = frame:AddHeaderButton("scb/settings.png", "settings", function()
		scb.open_settings()
	end)
	local parsers = frame:AddHeaderButton("scb/mind.png", "settings", function()
		scb.open_parsers_menu()
	end)

	frame:AddPanelToHide(frame.header)
	frame:AddPanelToHide(frame.title)
	frame:AddPanelToHide(frame.close)
	frame:AddPanelToHide(frame.close.image)
	frame:AddPanelToHide(settings)
	frame:AddPanelToHide(settings.image)
	frame:AddPanelToHide(parsers)
	frame:AddPanelToHide(parsers.image)
	frame:AddPanelToHide(scroll_panel)
	frame:AddPanelToHide(scroll_panel.VBar)
	frame:AddPanelToHide(scroll_panel.VBar.btnGrip)
	frame:AddPanelToHide(text_entry)

	frame.scroll_panel = scroll_panel
	frame.text_entry = text_entry

	sui.TDLib.End()
end

SUI.RemoveTheme("Light")

SUI.AddToTheme("Dark", {
	settings = Color(255, 255, 255, 133),
	settings_hover = Color(65, 185, 255),
	settings_press = Color(255, 255, 255, 30),

	emoji_select_menu = Color(18, 18, 18),
	emoji_select_menu_selected = Color(200, 200, 200, 1),
})

SUI.AddToTheme("Blur", {
	settings = Color(200, 200, 200),
	settings_hover = Color(65, 185, 255),
	settings_press = Color(255, 255, 255, 30),

	emoji_select_menu = Color(50, 50, 50, 230),
	emoji_select_menu_selected = Color(40, 40, 40),
})