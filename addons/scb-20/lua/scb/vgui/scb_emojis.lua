if SCB_LOADED then return end

local draw = draw
local IsValid = IsValid
local math = math
local pairs = pairs
local table = table
local SortedPairsByMemberValue = SortedPairsByMemberValue
local timer = timer

local scb = scb
local sui = sui
local SUI = scb.SUI

local Panel = {}

local flag = "flag_" .. (system.GetCountry() or ""):lower()
local categories = {
	People = {1, "grinning"},
	Nature = {2, "cat"},
	Food = {3, "watermelon"},
	Activities = {4, "person_in_lotus_position"},
	Travel = {5, "desert_island"},
	Objects = {6, "coffee"},
	Symbols = {7, "question"},
	Flags = {8, scb.emojis[flag] and flag or "flag_eg"},
	Custom = {9, "unlock"}
}

local generate_emojis = function()
	for k, v in pairs(categories) do
		local key = tostring(v[1])
		local emojis = {}

		local i, max_pos = 1, -math.huge
		for name, cat in pairs(scb.emojis) do
			local pos = i
			if not scb.is_custom_emoji(cat) then
				cat, pos = cat:sub(1, 1), tonumber(cat:sub(2))
			end

			if cat ~= key and (k ~= "Custom" or not scb.is_custom_emoji(cat)) then continue end

			emojis[pos] = name
			max_pos = math.max(max_pos, pos)

			i = i + 1
		end

		v[3] = emojis
		v[4] = max_pos
	end
end
generate_emojis()
hook.Add("SCB.EmojisModified", "FixEmojis", generate_emojis)

local DoClick = function(s)
	local text_entry = scb.chatbox.text_entry
	text_entry:RequestFocus()
	text_entry:AddValue(":" .. s.name .. ": ")

	s.parent:Remove()
end

local hovered_color = Color(50, 50, 50, 150)
local emoji_Paint = function(s, w, h)
	if s.parent.selected == s then
		s.search_field:SetPlaceholder(":" .. s.name .. ":")
		draw.RoundedBox(0, 0, 0, w, h, hovered_color)
	end
end

local emoji_OnCursorEntered = function(s, w, h)
	s.parent.selected = s
end

local category_list_Paint = function(_, w, h)
	draw.RoundedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"))
end

local make_category_list = function(parent, columns)
	local category_list = parent:Add("SCB.ThreeGrid")
	category_list:Dock(FILL)
	category_list:DockMargin(2, 0, 2, 2)
	category_list:GetCanvas():DockPadding(2, 2, 2, 2)
	category_list:InvalidateParent(true)
	category_list:SetWide2(category_list:GetWide() - (SUI.Scale(4) * 2))
	category_list:InvalidateParent(true)

	category_list:SetColumns(columns)
	category_list:SetHorizontalMargin(4)

	category_list.Paint = category_list_Paint

	return category_list
end

local add_emoji = function(self, emoji, category_list, search_field)
	if not IsValid(category_list) then return end

	local emoji_size = SUI.ScaleEven(28)

	local pnl = vgui.Create("DButton")
	pnl:SetTall(emoji_size)
	category_list:AddCell(pnl)

	pnl:SetSize(emoji_size, emoji_size)
	pnl:SetText("")
	pnl:SetTooltip(emoji)

	pnl.parent = self
	pnl.name = emoji
	pnl.search_field = search_field
	pnl.Paint = emoji_Paint
	pnl.OnCursorEntered = emoji_OnCursorEntered
	pnl.DoClick = DoClick

	local img = pnl:Add("SCB.Image")
	img:Dock(FILL)
	img:DockMargin(3, 3, 3, 3)
	img:SetMouseInputEnabled(false)

	local info = scb.emojis[emoji]
	img:SetImage(scb.is_custom_emoji(info) and info or ("scb/emojis/" .. emoji .. ".png"))
end

function Panel:Init()
	local has_permission = scb.has_permission(LocalPlayer(), "custom_emojis")
	local categories_n = table.Count(categories) - (has_permission and 0 or 1)

	self.tabs_tall = 30
	self.tab_scroller:SetTall(SUI.Scale(self.tabs_tall))

	self:SetFont(SCB_14)
	self:SetWide(self.tab_scroller:GetTall() * categories_n)
	self:SetTall(self:GetWide() + 10)
	self:InvalidateLayout(true)

	self.tab_scroller:Dock(BOTTOM)

	local emoji_size = SUI.ScaleEven(28)
	local columns = math.floor(self:GetWide() / emoji_size) - 1

	local search_field = self:Add("SCB.TextEntry")
	search_field:Dock(TOP)
	search_field:DockMargin(2, 2, 2, 2)
	search_field:SetPlaceholder("Search emojis...")
	search_field:SetMouseInputEnabled(true)
	search_field:SetNoBar(true)

	local old_Paint = search_field.Paint
	function search_field:Paint(w, h)
		local outline = SUI.GetColor("scroll_panel_outline")
		if outline then
			sui.TDLib.DrawOutlinedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"), outline, 1)
		else
			draw.RoundedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"))
		end

		old_Paint(self, w, h)
	end

	function search_field.OnValueChange(s, value)
		if value == "" then
			if IsValid(s.search_body) then
				s.search_body:Remove()
			end
			self:SetActiveTab(self.tabs[1])
			search_field:SetPlaceholder("Search emojis...")
			return
		end

		value = value:gsub(":", ""):lower()

		local search_body = s.search_body
		if not IsValid(search_body) then
			self:SetActiveTab(nil)

			search_body = self:Add("Panel")
			s.search_body = search_body
		end

		search_body:Dock(FILL)
		search_body:InvalidateParent(true)
		search_body:Clear()

		local category_list = make_category_list(search_body, columns)

		local main_i = 0
		for k, v in SortedPairsByMemberValue(categories, 1) do
			local emojis, n = v[3], v[4]
			for i = 1, n do
				local emoji = emojis[i]
				if not emoji then continue end
				if not emoji:find(value) then continue end

				timer.Simple(main_i * 0.004, function()
					add_emoji(self, emoji, category_list, search_field)
				end)

				main_i = main_i + 1
			end
		end
	end

	function self.tab_scroller:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, SUI.GetColor("header"))
	end

	for k, v in SortedPairsByMemberValue(categories, 1) do
		if k == "Custom" and not has_permission then continue end

		self:AddSheet(SUI.Material("scb/emojis/" .. v[2] .. ".png"), function(parent)
			local category_list = make_category_list(parent, columns)

			local emojis, n = v[3], v[4]
			for i = 1, n do
				local emoji = emojis[i]
				if not emoji then continue end

				timer.Simple(i * 0.004, function()
					add_emoji(self, emoji, category_list, search_field)
				end)
			end

			return category_list
		end):SetTooltip(k)
	end

	self:MakePopup()
	self:ParentToHUD()

	search_field:RequestFocus()

	hook.Add("VGUIMousePressed", self, function(_, panel, mouse_code)
		if self == panel then return end
		if self:IsOurChild(panel) then return end
		if mouse_code ~= MOUSE_LEFT then return end
		if panel == self.button then return end
		if panel == scb.chatbox.header then return end

		self:Remove()
	end)
end

function Panel:Paint(w, h)
	if SUI.GetColor("frame_blur") then
		sui.TDLib.BlurPanel(self)
	end

	draw.RoundedBox(0, 0, 0, w, h, SUI.GetColor("frame"))
end

function Panel:OnKeyCodePressed(key_code)
	if key_code == KEY_ENTER and IsValid(self.selected) then
		self.selected:DoClick()
	end
end

function Panel:Think()
	local button = self.button

	local m_w, m_h = self:GetSize()

	local x, y, w = button:GetBounds()
	x, y = button:LocalToScreen(0, 0)
	x = x - (m_w / 2 - w / 2)
	y = y - m_h - 4
	self:SetPos(x, y)

	self:MoveToFront()
end

sui.register("EmojiList", Panel, "SCB.PropertySheet")