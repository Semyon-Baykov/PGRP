if SCB_LOADED then return end

local scb = scb
local SUI = scb.SUI

scb.tags = scb.tags or {}

net.Receive("SCB.SendTags", function()
	local tags = net.ReadData(net.ReadUInt(17))
	tags = util.Decompress(tags)
	scb.tags = scb.mp.unpack(tags)
end)

net.Receive("SCB.AddTag", function()
	local key = net.ReadString()
	local tag = net.ReadString()
	scb.tags[key] = tag

	local old = net.ReadString()

	if old ~= "" then
		scb.tags[old] = nil
	end

	hook.Call("SCB.TagsModified")
end)

net.Receive("SCB.RemoveTag", function()
	scb.tags[net.ReadString()] = nil
	hook.Call("SCB.TagsModified")
end)

local tags_menu = function(title, key, key_tag)
	key = key or ""

	local size_to_children

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
	name:SetPlaceholder("SteamID/SteamID64/Rank")
	name:SetValue(key)

	local tag = body:Add("SCB.TextEntry")
	tag:Dock(TOP)
	tag:DockMargin(0, 4, 0, 0)
	tag:SetPlaceholder("Tag")
	tag:SetValue(key_tag or "")

	local preview = body:Add("SCB.ChatLine")
	preview:DockMargin(0, 6, 0, 0)
	preview.x = 3
	preview.emoji_size = 18

	preview:SetMouseInputEnabled(false)

	function tag:OnValueChange(v)
		preview.added = {}
		preview:ScaleChanged()
		preview:Parse(v)
		size_to_children()
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
		net.Start("SCB.AddTag")
			net.WriteString(name:GetText())
			net.WriteString(tag:GetText())
			net.WriteString(name:GetText() ~= key and key or "")
		net.SendToServer()
		add_frame:Remove()
	end

	function save:Think()
		local valid = true

		local _name = name:GetText()
		if _name == "" or (scb.tags[_name] and key ~= _name) then
			valid = false
			name:SetBarColor(Color(244, 67, 54))
		else
			name:SetBarColor()
		end

		if tag:GetText() == "" then
			valid = false
			tag:SetBarColor(Color(244, 67, 54))
		else
			tag:SetBarColor()
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

	size_to_children = function()
		body:InvalidateLayout(true)
		body:SetTall(select(2, body:ChildrenSize()) + 4)
		add_frame:SizeToChildren(false, true)
	end
	size_to_children()
	tag:OnValueChange(tag:GetValue())

	add_frame:Center()
end

return {
	title = "Tags",
	pos = 2,
	func = function(parent)
		local body = parent:Add("Panel")
		body:Dock(FILL)
		body:DockMargin(0, 1, 0, 0)
		body:InvalidateParent(true)

		SUI.OnScaleChanged(body, function()
			body:Remove()
		end)

		local tags_list = body:Add("SCB.ThreeGrid")
		tags_list:Dock(FILL)
		tags_list:InvalidateLayout(true)
		tags_list:InvalidateParent(true)

		tags_list:SetColumns(2)
		tags_list:SetHorizontalMargin(2)
		tags_list:SetVerticalMargin(2)

		local load_tags = function()
			tags_list:Clear()

			for key, tag in SortedPairs(scb.tags) do
				local pnl = vgui.Create("DButton")
				pnl:SetText("")
				pnl:SetTall(SUI.Scale(560))
				pnl:SUI_TDLib()
					:ClearPaint()
					:FadeHover()

				function pnl:DoClick()
					tags_menu("Edit '" .. key .. "'", key, tag)
				end

				function pnl:DoRightClick()
					local d_menu = DermaMenu()

					d_menu:AddOption("Remove", function()
						net.Start("SCB.RemoveTag")
							net.WriteString(key)
						net.SendToServer()
					end)

					d_menu:Open()
					d_menu:MakePopup()

					function pnl:OnRemove()
						d_menu:Remove()
					end
				end
				tags_list:AddCell(pnl)

				local name = pnl:Add("SCB.Label")
				name:Dock(TOP)
				name:SetFont(SCB_16)
				name:SetText(key)
				name:SetTextInset(3, 0)
				name:SetExpensiveShadow(1, color_black)
				name:SizeToContentsY(3)

				local _tag = pnl:Add("SCB.ChatLine")
				_tag:DockMargin(3, 0, 0, 0)
				_tag:SetFont(SCB_16)

				_tag.emoji_size = 16
				_tag:Parse(tag)
				_tag:SetMouseInputEnabled(false)

				pnl:SizeToChildren(false, true)
			end

			for k, v in ipairs(tags_list.Rows) do
				tags_list:CalculateRowHeight(v)
			end
		end
		load_tags()

		hook.Add("SCB.TagsModified", tags_list, load_tags)

		local add = body:Add("SCB.Button")
		add:Dock(BOTTOM)
		add:DockMargin(0, 4, 0, 0)
		add:SetText("ADD TAG")

		add:On("DoClick", function()
			tags_menu("Add Tag")
		end)

		return body
	end
}