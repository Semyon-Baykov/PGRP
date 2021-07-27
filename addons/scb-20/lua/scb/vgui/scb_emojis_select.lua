if SCB_LOADED then return end

local draw = draw

local scb = scb
local sui = sui
local SUI = scb.SUI

local Panel = {}

AccessorFunc(Panel, "m_bTextEntry", "TextEntry")

function Panel:Init()
	self.emojis = {}
end

local line_DoClick = function(s)
	local parent = s:GetParent()
	parent[KEY_ENTER](parent)
end

local emoji_Paint = function(s, w, h)
	local parent = s.parent
	if parent.selected_emoji == s then
		draw.RoundedBox(0, 0, 0, w, h, SUI.GetColor("emoji_select_menu_selected"))
	end
end

local emoji_OnCursorEntered = function(s)
	s.parent.selected_emoji = s.emoji
end

function Panel:AddEmoji(name)
	local line = self:Add("DButton")
	line:Dock(TOP)
	line:SetTall(SUI.ScaleEven(22))
	line:InvalidateParent(true)
	line:SetText("")
	line.Paint = nil
	line.DoClick = line_DoClick
	line.parent = self
	line.OnCursorEntered = emoji_OnCursorEntered

	local emoji = line:Add("SCB.ChatLine")
	emoji:Dock(NODOCK)
	emoji:SetSize(line:GetSize())
	emoji:NewLabel(" ")
	emoji:NewEmoji(name, scb.emojis[name], 20)
	emoji:NewLabel(" :" .. name .. ":")
	emoji:Center()
	emoji:SetMouseInputEnabled(false)

	emoji.parent = self
	emoji.name = name
	emoji.Paint = emoji_Paint

	emoji.i = table.insert(self.emojis, emoji)

	if emoji.i == 1 then
		self.selected_emoji = emoji
	end

	line.emoji = emoji

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)

	return emoji
end

function Panel:SetStartEnd(start, _end)
	self.start, self._end = start, _end
end

function Panel:Paint(w, h)
	if SUI.GetColor("frame_blur") then
		sui.TDLib.BlurPanel(self)
	end

	draw.RoundedBox(3, 0, 0, w, h, SUI.GetColor("emoji_select_menu"))
end

Panel[KEY_UP] = function(self)
	self.selected_emoji = self.emojis[self.selected_emoji.i - 1] or self.emojis[#self.emojis]
	return true
end

Panel[KEY_DOWN] = function(self)
	self.selected_emoji = self.emojis[self.selected_emoji.i + 1] or self.emojis[1]
	return true
end

Panel[KEY_ENTER] = function(self)
	local text_entry = self:GetTextEntry()
	text_entry:RequestFocus()
	text_entry:AddValue(":" .. self.selected_emoji.name .. ": ", self.start - 1, self._end + 1)

	scb.emoji_set_used(self.selected_emoji.name)
	return true
end
Panel[KEY_TAB] = Panel[KEY_ENTER]

Panel[KEY_ESCAPE] = function(self)
	gui.HideGameUI()
	self:Remove()
end

sui.register("EmojisSelect", Panel, "Panel")