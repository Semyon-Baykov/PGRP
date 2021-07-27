if SCB_LOADED then return end

local timer = timer
local draw = draw
local surface = surface
local math = math
local table = table
local vgui = vgui

local Lerp = Lerp
local Color = Color
local DermaMenu = DermaMenu
local unpack = unpack
local IsValid = IsValid
local UnPredictedCurTime = UnPredictedCurTime
local RoundedBox = draw.RoundedBox
local sub = string.sub
local find = string.find
local gsub = string.gsub
local lower = string.lower

local scb = scb
local sui = sui
local SUI = scb.SUI
local config = scb.config

scb.chat_parsers = {}
local add_parser_example = function(title, example, output)
	table.insert(scb.chat_parsers, {title, example, output:format("change_me")})
end

do
	local available_colors = "\n\nВот как это можно использовать!:\n"
	for k in pairs(config.colors) do
		available_colors = available_colors .. k .. " - "
	end
	available_colors = available_colors:sub(1, -4) .. "\n"

	add_parser_example("{cyan Этот текст будет голубой.}" .. available_colors, "{cyan Видите, он голубой!}", "{cyan %s}")
end
add_parser_example("{#d4af37 Этот текст будет золотой.}\nUsage: {#hex text}\n", "{#d4af37 Видите, он золотой!}", "{#d4af37 %s}")
add_parser_example("{*Этот текст будет радужным.}", "{*Видите, он радужный!}", "{*%s}")
add_parser_example("{!Этот текст будет будет мигать красным.}", "{!Видите, он мигает красным!}", "{!%s}")
add_parser_example("{!blue Этот текст будет мигать синим.}", "{!blue Видите, он мигает синим!}", "{!blue %s}")
add_parser_example("{!#d4af37 Этот текст будет мигать золотым.}", "{!#d4af37 Видите, он мигает золотым!}", "{!#d4af37 %s}")
add_parser_example("\\{*Тут вообще короче.}", "\\{*Внатуре ага.}", "\\{*%s}")

local ESCAPE_CHAR = "\\"

local created_panels = {}

local Panel = {}

AccessorFunc(Panel, "m_bFont", "Font", FORCE_STRING)
AccessorFunc(Panel, "m_bPlayer", "Player")

local current_x
local current_line
local current_y, line_h
function Panel:Init()
	self:Dock(TOP)
	self:SetFont(SCB_18)

	self:InvalidateParent(true)

	self:SetAlpha(0)
	self:AlphaTo(255, 0.5)

	self:SetCursor("hand")

	self.text_color = SUI.GetColor("text_entry")

	self.added = {}

	-- Methods
	local children = {}
	function self:Add(pnl)
		pnl = vgui.Create(pnl, self)
		pnl.line = current_line
		table.insert(children, pnl)
		return pnl
	end
	function self:OnChildRemoved(child)
		for i = 1, #children do
			local v = children[i]
			if v == child then
				table.remove(children, i)
				return
			end
		end
	end
	function self:GetChildren()
		return children
	end
	--

	-- self.next_pos = 132889554

	self:ScaleChanged()
	table.insert(created_panels, self)
end

function Panel:ScaleChanged()
	self:Clear()
	self:InvalidateParent(true)
	self:InvalidateLayout(true)

	current_x = 0
	current_line = 0
	current_y, line_h = 0, 0

	self.max_w = -1
	self.max_h = {0}
	self.text = ""

	self.emoji_size = 24

	self.parsing = true

	local added = self.added
	self.added = {}
	for i = 1, #added do
		local v = added[i]
		local v_1 = v[1]

		local func = (v_1 == 1 and self.NewLabel) or (v_1 == 2 and self.NewEmoji) or (v_1 == 3 and self.NewAvatar)
		func(self, unpack(v, 2, table.maxn(v)))

		added[i] = nil
	end

	self.parsing = nil
	self:SizeToChildren(false, true)
end

local hovered = Color(50, 50, 50, 150)
function Panel:Paint(w, h)
	if self.Hovered then
		RoundedBox(3, 0, 0, w, h, hovered)
	end
end

function Panel:DoRightClick()
	local d_menu = DermaMenu()
	local text = self.text
	d_menu:AddOption("Copy Text", function()
		SetClipboardText(text)
	end)
	d_menu:Open()
	d_menu:MakePopup()
end

function Panel:OnMouseReleased(mousecode)
	if self.Hovered and mousecode == MOUSE_RIGHT then
		self:DoRightClick()
	end
end

function Panel:IncrementLine()
	current_x = 0
	current_line = current_line + 1
	current_y, line_h = current_y + line_h, 0
	self.max_h[current_line + 1] = 0
end

function Panel:SetLineH(h)
	if h > line_h then
		line_h = h
		self.max_h[current_line + 1] = h

		local childs = self:GetChildren()
		for i = #childs, 1, -1 do
			local v = childs[i]
			if v.line ~= current_line then break end
			v.y = self:GetCurrentY(v:GetTall())
		end
	end
end

function Panel:SizeToChildren(width, height)
	if self.parsing then return end

	if width then
		self:SetWide(self.max_w)
	end

	if height then
		self:SetTall(self:GetTotalH())
	end
end

function Panel:GetTotalH()
	local h = 0
	local max_h = self.max_h
	if max_h then
		for i = 1, #max_h do
			h = h + max_h[i]
		end
	end
	return h
end

function Panel:GetCurrentY(_h)
	local y = current_y
	if _h == line_h then return y end
	return math.floor((y + ((line_h / 2) - (_h / 2))) + 0.5)
end

function Panel:AddW(w)
	current_x = current_x + w

	if current_x > self.max_w then
		self.max_w = current_x
	end

	if current_x >= self:GetWide() then
		self:IncrementLine()
	end
end

function Panel:GetMessageW()
	return self.max_w
end

do
	local label_time

	local underline_color = Color(23, 115, 196)
	local url_underline = function(s, w, h)
		if s:IsHovered() then
			s:SetTextColor(underline_color)
		else
			s:SetTextColor(s.text_color)
		end
		RoundedBox(0, 0, h - 1, w, 1, s:GetTextColor())
	end

	local url_click = function(s)
		gui.OpenURL(s.url)
	end

	local url_right_click = function(s)
		local d_menu = DermaMenu()
		local url = s.url
		d_menu:AddOption("Copy URL", function()
			SetClipboardText(url)
		end)
		d_menu:Open()
		d_menu:MakePopup()
	end

	local disable_rainbow_colors = GetConVar("scb_disable_rainbow_colors"):GetBool()
	cvars.AddChangeCallback("scb_disable_rainbow_colors", function(_, _, value_new)
		disable_rainbow_colors = tobool(value_new)
	end)
	local label_rainbow = function(s)
		if disable_rainbow_colors then
			s:SetTextColor(s.text_color)
			return
		end

		local r, g, b = sui.hsv_to_rgb((s.time + UnPredictedCurTime()) % 360 * 0.6, 1, 1)
		s:SetFGColor(r, g, b, s.text_color_obj.a)
	end

	local disable_flashing_texts = GetConVar("scb_disable_flashing_texts"):GetBool()
	cvars.AddChangeCallback("scb_disable_flashing_texts", function(_, _, value_new)
		disable_flashing_texts = tobool(value_new)
	end)
	local label_flash = function(s)
		if disable_flashing_texts then
			s:SetTextColor(s.text_color)
			return
		end

		local col = s.text_color_obj
		s:SetFGColor(col.r, col.g, col.b, (s.time + UnPredictedCurTime()) * 300 % 255)
	end

	function Panel:AddLabel(text, color, url, is_hovered, font)
		if text == "" then return end

		local w, h = surface.GetTextSize(text)
		self:SetLineH(h)

		local label = self:Add("SCB.Label")
		label:SetFont(font)
		label:SetText(text:sub(1, 1) == "#" and ("#" .. text) or text)
		label:SetExpensiveShadow(1, color_black)
		label:SetSize(w, h)
		label:SetPos(current_x, self:GetCurrentY(h))

		label.text_color = scb.type(color) == "Color" and color or self.text_color

		if color == "rainbow" or self.flashing then
			label.text_color_obj = Color(label.text_color:Unpack())
			label.time = label_time
			label.Paint = color == "rainbow" and label_rainbow or label_flash
		else
			label:SetTextColor(label.text_color)
		end

		if url then
			label:SetMouseInputEnabled(true)
			label:SetCursor("hand")
			label.Paint = url_underline
			label.DoClick = url_click
			label.DoRightClick = url_right_click
			label.url = url
			label.IsHovered = is_hovered
		end

		self.text = self.text .. text
		self:AddW(w)

		-- if scb.type(color) ~= "Color" then
			-- hook.Add("SCB.ThemeChanged", label, function(s)
			-- 	s.text_color = SUI.GetColor("text_entry")
			-- 	s:SetTextColor(s.text_color)
			-- end)
		-- end

		return label
	end

	local AddLabel = Panel.AddLabel
	local IncrementLine = Panel.IncrementLine
	function Panel:NewLabel(text, color, is_url, font)
		if text == "" then return end

		font = font or self:GetFont()
		table.insert(self.added, {1, text, color, is_url, flashing, font})

		local url
		if is_url then
			url = text
		end

		local wide = self:GetWide()
		text = sui.wrap_text(text, font, wide, wide - current_x)

		local urls, is_hovered
		if is_url then
			urls, is_hovered = {}, function()
				for k, v in ipairs(urls) do
					if v.Hovered then
						return true
					end
				end
			end
		end

		label_time = math.sin(UnPredictedCurTime()) + math.random()

		local lines = text:Split("\n")
		local lines_n = #lines
		for i = 1, lines_n do
			local v = lines[i]

			local line = current_line

			local label = AddLabel(self, v, color, url, is_hovered, font)
			if urls then
				table.insert(urls, label)
			end

			if i ~= lines_n and line == current_line then
				IncrementLine(self)
			end
		end

		self:SizeToChildren(false, true)
	end
end

function Panel:NewEmoji(name, info, size)
	local _size = size or self.emoji_size
	table.insert(self.added, {2, name, info, _size})

	if scb.isnumber(_size) then
		size = SUI.ScaleEven(_size)
	else
		size = tonumber(_size)
	end

	if size >= self:GetWide() - current_x then
		self:IncrementLine()
	end

	self:SetLineH(size)

	local image = self:Add("SCB.Image")
	image:SetImage(scb.is_custom_emoji(info) and info or ("scb/emojis/" .. name .. ".png"))
	image:SetSize(size, size)
	image:SetPos(current_x, self:GetCurrentY(size))

	if size == SUI.ScaleEven(24) then
		image:SetMinus(2)
	end

	self:AddW(size)

	self.text = self.text .. (":" .. name .. ":")

	self:SizeToChildren(false, true)

	return image
end

function Panel:NewAvatar(ply, size)
	table.insert(self.added, {3, ply, size})

	size = SUI.ScaleEven(size or 26)

	self:SetLineH(size)

	local avatar = self:Add("Panel")
	avatar:SetSize(size, size)
	avatar:SetPos(current_x, self:GetCurrentY(size))
	avatar:SetMouseInputEnabled(false)
	avatar:SUI_TDLib()
		:CircleAvatar()

	if scb.isentity(ply) then
		avatar:SetPlayer(ply, size)
	else
		avatar:SetSteamID(ply, size)
	end

	surface.SetFont(self:GetFont())
	self:AddW(size + surface.GetTextSize(" "))
end

function Panel:HideAfterTime(time)
	self.can_hide = false
	timer.Simple(time, function()
		if not IsValid(self) then return end
		self.can_hide = nil
		if scb.chatbox.hidden then
			self:AlphaTo(0, 0.5)
		end
	end)
end

do
	local NewLabel = Panel.NewLabel

	local trim = function(s)
		return s:match("^%s*(.-)%s*$") or s
	end

	local parse_arg = function(text)
		local arg = ""
		local i, n = 1, #text
		while i <= n do
			local c = sub(text, i, i)
			if c == " " then break end
			if c == "}" then break end
			arg = arg .. c

			i = i + 1
		end
		return lower(arg), i + 1
	end

	local color_parsers = {}
	for k, v in pairs(config.colors) do
		color_parsers[k] = {
			permission = "colored_texts",
			callback = function(self, text, arg)
				text = trim(text)
				if text == "" then return false end
				NewLabel(self, text, scb.hex_rgb(v))
			end
		}
	end

	local parsers; parsers = {
		["$"] = {
			callback = function(self, emoji, ply, color)
				emoji = lower(emoji)

				local emoji_info = scb.emojis[emoji]
				if emoji_info and not (scb.is_custom_emoji(emoji_info) and not scb.has_permission(ply, "custom_emojis")) then
					self:NewEmoji(emoji, emoji_info)
				else
					return false, ":" .. emoji .. ":"
				end
			end
		},
		["#"] = {
			permission = "colored_texts",
			callback = function(self, text, _, color)
				local hex_col, start = parse_arg(text)
				if #hex_col < 3 or not find(hex_col, "^[%da-fA-F]+$") then
					return false
				end
				text = trim(sub(text, start))
				if text == "" then return false end
				NewLabel(self, text, scb.hex_rgb(hex_col), nil, flashing)
			end
		},
		["*"] = {
			permission = "rainbow",
			callback = function(self, text, ...)
				text = trim(text)
				if text == "" then return false end
				NewLabel(self, text, "rainbow")
			end
		},
		["@"] = {
			callback = function(self, text)
				if scb.find_url(text) then
					NewLabel(self, text, nil, true)
				else
					return false
				end
			end
		},
		["!"] = {
			permission = "flashing",
			callback = function(self, text, ply)
				local ret

				self.flashing = true

				local arg, start = parse_arg(text)
				if scb.has_permission(ply, "colored_texts") then
					if sub(arg, 1, 1) == "#" then
						ret = parsers["#"].callback(self, sub(text, 2))
						goto skip
					elseif color_parsers[arg] then
						color_parsers[arg].callback(self, sub(text, start), "flash")
						goto skip
					end
				end

				text = trim(text)
				if text == "" then
					ret = false
					goto skip
				end
				NewLabel(self, text, Color(255, 0, 0))
				::skip::

				self.flashing = false

				return ret
			end
		}
	}

	local parse_between_braces = function(text, pos, len)
		local tmp_text = ""
		local end_pos = pos
		local closed = false
		local escape = false
		for i = pos, len do
			end_pos = i
			local c = sub(text, i, i)
			if escape then
				tmp_text = tmp_text .. c
				escape = false
				continue
			end
			if c == ESCAPE_CHAR then
				escape = true
			elseif c == "}" then
				closed = true
				break
			else
				tmp_text = tmp_text .. c
			end
		end
		return tmp_text, closed, end_pos
	end

	function Panel:Parse(text, color)
		self.parsing = true

		text = gsub(text, "()%:([%w_]+)%:", function(start, found)
			if text[start - 1] ~= ESCAPE_CHAR then
				return "{$" .. found .. "}"
			end
		end)

		do
			local pos = 0
			while true do
				local start, url, _end = scb.find_url(text, pos + 1)
				if not start then break end
				if text:sub(start - 1, start - 1) ~= ESCAPE_CHAR then
					text = text:sub(1, start - 1) .. ("{@" .. url .. "}") .. text:sub(_end + 1)
				end
				pos = _end + 1
			end
		end

		local ply = self:GetPlayer()

		local len = #text
		local tmp_text = ""
		local i = 0
		while true do
			i = i + 1
			if i > len then break end

			local c = sub(text, i, i)
			if c == ESCAPE_CHAR then
				tmp_text = tmp_text .. sub(text, i + 1, i + 1)
				i = i + 1
				continue
			end

			if c ~= "{" then
				tmp_text = tmp_text .. c
				continue
			end

			local ret_text, closed, end_pos = parse_between_braces(text, i + 1, len)
			if not closed then
				tmp_text = tmp_text .. sub(text, i, end_pos)
				break
			end

			local tag, tag_end = sub(ret_text, 1 , 1), 1
			if not scb.is_letter_digit(tag) then
				tag = parsers[tag]
			else
				for i2 = 2, #ret_text do
					local c2 = sub(ret_text, i2, i2)
					if not scb.is_letter_digit(c2) then break end
					tag = tag .. c2
					tag_end = tag_end + 1
				end
				tag_end = tag_end + 1
				tag = color_parsers[tag]
			end

			i = end_pos

			local failed_text = "{" .. ret_text .. "}"

			if tag == nil then
				tmp_text = tmp_text .. failed_text
				continue
			end

			local permission = tag.permission
			if permission and not scb.has_permission(ply, permission) then
				tmp_text = tmp_text .. failed_text
				continue
			end

			ret_text = sub(ret_text, tag_end + 1)

			NewLabel(self, tmp_text, color)
			local done, ret = tag.callback(self, ret_text, ply, color)
			if done == false then
				if ret then
					NewLabel(self, ret, color)
				else
					NewLabel(self, failed_text, color)
				end
			end
			tmp_text = ""
		end

		NewLabel(self, tmp_text, color)
		self.parsing = nil
		self:SizeToChildren(false, true)
	end
end

do
	local AnimationThink = function(s)
		local anim = s.anim
		if not anim then return end

		local time = UnPredictedCurTime()
		if time >= anim.start_time then
			local frac = math.TimeFraction(anim.start_time, anim.end_time, time)
			frac = math.Clamp(frac, 0, 1)

			s:SetAlpha(Lerp(frac ^ (1 - (frac - 0.5)), s:GetAlpha(), anim.alpha))

			if frac == 1 then
				s.anim = nil
				s.AnimationThink = nil
			end
		end
	end

	function Panel:AlphaTo(alpha, length)
		local time = UnPredictedCurTime()

		self.anim = {
			start_time = time,
			end_time = time + length,

			alpha = alpha
		}

		self.AnimationThink = AnimationThink
	end

	function Panel:Stop()
		self.anim = nil
	end
end

function Panel:OnRemove()
	for i = 1, #created_panels do
		if created_panels[i] == self then
			table.remove(created_panels, i)
			break
		end
	end
end

SUI.OnScaleChanged("ChatLines", function()
	timer.Simple(0, function()
		for i = 1, #created_panels do
			local v = created_panels[i]
			if v:IsValid() then
				v:ScaleChanged()
			end
		end
	end)
end)

sui.register("ChatLine", Panel, "Panel")