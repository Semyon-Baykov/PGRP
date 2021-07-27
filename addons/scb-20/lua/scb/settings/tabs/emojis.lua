if SCB_LOADED then return end

local scb = scb
local SUI = scb.SUI

scb.emojis = include("scb/cl_emojis_data.lua")

do
	local set_material = surface.SetMaterial
	local i = 0
	for name in pairs(scb.emojis) do
		timer.Simple(i * 0.001, function()
			set_material(SUI.Material("scb/emojis/" .. name .. ".png"))
		end)
		i = i + 1
	end
end

net.Receive("SCB.SendEmojis", function()
	local emojis = net.ReadData(net.ReadUInt(17))
	emojis = util.Decompress(emojis)

	for k, v in pairs(scb.mp.unpack(emojis)) do
		scb.emojis[k] = v
	end

	hook.Call("SCB.EmojisModified")
end)

net.Receive("SCB.AddEmoji", function()
	local emoji = net.ReadString()
	local url = net.ReadString()
	scb.emojis[emoji] = url

	local old = net.ReadString()
	if old ~= "" then
		scb.emojis[old] = nil
	end

	hook.Call("SCB.EmojisModified")
end)

net.Receive("SCB.RemoveEmoji", function()
	scb.emojis[net.ReadString()] = nil
	hook.Call("SCB.EmojisModified")
end)

local emoji_menu = function(title, emoji_name, emoji_url)
	emoji_name = emoji_name or ""

	local add_frame = vgui.Create("SCB.Frame")
	add_frame:SetDrawOnTop(true)
	add_frame:SetWide(300)
	add_frame:MakePopup()
	add_frame:SetTitle(title)
	add_frame:DoModal()

	local old_Paint = add_frame.Paint

	local start_time = SysTime() - 0.3
	function add_frame:Paint(w, h)
		Derma_DrawBackgroundBlur(self, start_time)
		old_Paint(self, w, h)
	end

	local body = add_frame:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(4, 4, 4, 4)
	body:DockPadding(3, 3, 3, 3)
	body:InvalidateLayout(true)
	body:InvalidateParent(true)
	function body:Paint(w, h)
		draw.RoundedBox(3, 0, 0, w, h, SUI.GetColor("scroll_panel"))
	end

	local added = -99999
	function body:OnChildAdded(child)
		added = added + 2
		child:SetZPos(added)
	end

	local name = body:Add("SCB.TextEntry")
	name:Dock(TOP)
	name:SetPlaceholder("Name")
	name:SetValue(emoji_name)

	function name:AllowInput(c)
		return not c:find("[%w_]")
	end

	local url = body:Add("SCB.TextEntry")
	url:Dock(TOP)
	url:DockMargin(0, 4, 0, 0)
	url:SetPlaceholder("URL")
	url:SetValue(emoji_url or "")

	function url:AllowInput(c)
		return c:find("%s") and true or false
	end

	local bottom = body:Add("Panel")
	bottom:Dock(TOP)
	bottom:DockMargin(0, 28, 0, 0)

	local test = bottom:Add("Panel")
	test:Dock(RIGHT)
	test:SetWide(60)

	local save = test:Add("SCB.Button")
	save:SetText("SAVE")
	save:Dock(RIGHT)
	save:SetEnabled(false)

	function save:DoClick()
		local _name = name:GetText():lower()
		local _url = url:GetText()

		if not _url:find("^https?://") then
			_url = "http://" .. _url
		end

		net.Start("SCB.AddEmoji")
			net.WriteString(_name)
			net.WriteString(_url)
			net.WriteString(_name ~= emoji_name and emoji_name or "")
		net.SendToServer()
		add_frame:Remove()
	end

	function save:Think()
		local valid = true

		do
			local _name = name:GetText():lower()
			if _name == "" or (scb.emojis[_name] and emoji_name ~= _name) then
				valid = false
				name:SetBarColor(Color(244, 67, 54))
			else
				name:SetBarColor()
			end

			local _url = url:GetText()
			if not _url:find("^https?://") then
				_url = "http://" .. _url
			end
			if scb.find_url(_url) ~= 1 then
				valid = false
				url:SetBarColor(Color(244, 67, 54))
			else
				url:SetBarColor()
			end
		end

		self:SetEnabled(valid)
		self:SetMouseInputEnabled(valid)
	end

	local cancel = test:Add("SCB.Button")
	cancel:Dock(RIGHT)
	cancel:DockMargin(0, 0, 4, 0)
	cancel:SetContained(false)
	cancel:SetColors(Color(244, 67, 54, 30), Color(244, 67, 54))
	cancel:SetText("CANCEL")

	cancel:On("DoClick", function()
		timer.Simple(0.05, function()
			add_frame:Remove()
		end)
	end)

	test:SetSize(save:GetWide() * 2 + 4, save:GetTall())
	bottom:SizeToChildren(true, true)

	body:InvalidateParent(true)
	body:InvalidateLayout(true)

	local _, children_h = body:ChildrenSize()
	body:SetTall(children_h + 4)

	add_frame:SizeToChildren(false, true)
	add_frame:Center()
end

return {
	title = "Emojis",
	pos = 3,
	func = function(parent)
		local body = parent:Add("Panel")
		body:Dock(FILL)
		body:DockMargin(0, 1, 0, 0)
		body:InvalidateParent(true)

		SUI.OnScaleChanged(body, function()
			body:Remove()
		end)

		local top_body = body:Add("Panel")
		top_body:Dock(FILL)
		top_body:InvalidateParent(true)

		local search_field = top_body:Add("SCB.TextEntry")
		search_field:Dock(TOP)
		search_field:SetPlaceholder("Search emojis...")

		local emojis_list = top_body:Add("SCB.ThreeGrid")
		emojis_list:Dock(FILL)
		emojis_list:DockMargin(3, 3, 3, 3)
		emojis_list:InvalidateLayout(true)
		emojis_list:InvalidateParent(true)

		emojis_list:SetColumns(3)
		emojis_list:SetHorizontalMargin(2)
		emojis_list:SetVerticalMargin(2)

		top_body.Paint, emojis_list.Paint = emojis_list.Paint, nil

		local load_emojis = function(search_key)
			emojis_list:Clear()

			search_key = search_key:lower()

			for emoji_name, v in pairs(scb.emojis) do
				if not scb.is_custom_emoji(v) then
					continue
				end

				if not string.find(emoji_name:lower(), search_key, 1, true) then
					continue
				end

				local pnl = vgui.Create("DButton")
				pnl:SetText("")
				pnl:SetTall(SUI.Scale(30))
				pnl:SUI_TDLib()
					:ClearPaint()
					:FadeHover()

				function pnl:DoClick()
					emoji_menu("Edit '" .. emoji_name .. "'", emoji_name, v)
				end

				function pnl:DoRightClick()
					local d_menu = DermaMenu()

					d_menu:AddOption("Remove", function()
						net.Start("SCB.RemoveEmoji")
							net.WriteString(emoji_name:lower())
						net.SendToServer()
					end)

					d_menu:Open()
					d_menu:MakePopup()

					function pnl:OnRemove()
						d_menu:Remove()
					end
				end

				local emoji = pnl:Add("SCB.ChatLine")
				emoji:Dock(NODOCK)
				emoji.x = 2

				emoji:NewEmoji(emoji_name, v, 26)
				emoji:Center()
				emoji:SetMouseInputEnabled(false)

				local name = pnl:Add("SCB.Label")
				name:Dock(FILL)
				name:DockMargin(SUI.ScaleEven(26) + 8, 0, 0, 0)
				name:SetFont(SCB_16)
				name:SetText(emoji_name)

				emojis_list:AddCell(pnl)
			end
		end
		load_emojis("")

		hook.Add("SCB.EmojisModified", emojis_list, function()
			load_emojis(search_field:GetValue())
		end)

		function search_field:OnValueChange(v)
			load_emojis(v)
		end

		local add_emoji = body:Add("SCB.Button")
		add_emoji:Dock(BOTTOM)
		add_emoji:DockMargin(0, 4, 0, 0)
		add_emoji:SetText("ADD EMOJI")

		add_emoji:On("DoClick", function()
			emoji_menu("Add Emoji")
		end)

		return body
	end
}