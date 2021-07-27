local rt = GetRenderTargetEx( "aphone_RT_Shop", 1024, 1024, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_RGBA8888)
local tex = CreateMaterial( "aphone_RT_Shop", "VertexLitGeneric", {
	["$basetexture"] = rt:GetName()
} )

aphone.matlist = {6}

local slider_list = {
	["mat_id"] = {
		name = aphone.L("Material"),
		min = 1,
		max = #aphone.Painting,
		default = 1,
		round = 0,
		order = 0,
	},
	["angle"] = {
		name = aphone.L("Angle"),
		min = 0,
		max = 360,
		default = 0,
		order = 1,
	},
	["clr_r"] = {
		name = aphone.L("Red"),
		min = 0,
		max = 255,
		default = 255,
		order = 2,
	},
	["clr_g"] = {
		name = aphone.L("Green"),
		min = 0,
		max = 255,
		default = 255,
		order = 3,
	},
	["clr_b"] = {
		name = aphone.L("Blue"),
		min = 0,
		max = 255,
		default = 255,
		order = 4,
	},
	["posx"] = {
		name = aphone.L("PosX"),
		min = 0,
		max = 1,
		default = 0.5,
		round = 2,
		order = 5,
	},
	["posy"] = {
		name = aphone.L("PosY"),
		min = 0,
		max = 1,
		default = 0.5,
		round = 2,
		order = 6,
	},
	["sizex"] = {
		name = aphone.L("SizeX"),
		min = 0,
		max = 5,
		default = 1,
		round = 2,
		order = 7,
	},
	["sizey"] = {
		name = aphone.L("SizeY"),
		min = 0,
		max = 5,
		default = 1,
		round = 2,
		order = 8,
	},
}

function aphone.OpenPaint()
	gui.EnableScreenClicker(true)
	local stickers = aphone.SelfPaint or {}

	// Cache colors
	local black_48 = aphone:Color("Black48")
	local black_40 = aphone:Color("Black40")
	local mat_red = aphone:Color("mat_red")
	local text_orange = aphone:Color("Text_Orange")
	local white_font = aphone:Color("White_Font")
	local text_white = aphone:Color("Text_White")
	local mat_black = aphone:Color("mat_black")
	local mat_lightred = aphone:Color("mat_lightred")
	local mat_blackred = aphone:Color("mat_blackred")

	aphone:Painting_Generate(rt, stickers)

	local f = vgui.Create("EditablePanel")
	f:SetSize(ScrW() * 0.45, ScrH() * 0.5)
	f:Center()
	f:MakePopup()

	function f:OnRemove()
		gui.EnableScreenClicker(false)
	end

	function f:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, black_40)
	end

	local AdjustableModelPanel = vgui.Create( "DAdjustableModelPanel", f)
	AdjustableModelPanel:Dock(LEFT)
	AdjustableModelPanel:SetWide(f:GetTall())
	AdjustableModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
	AdjustableModelPanel:SetModel( "models/akulla/aphone/w_aphone.mdl" )
	function AdjustableModelPanel:LayoutEntity() return end // disables default rotation

	// HACK : The model will show only if the panel is already clicked one time if I don't do that.
	AdjustableModelPanel:OnMousePressed(MOUSE_LEFT)

	timer.Simple(0.3, function()
		AdjustableModelPanel:OnMouseReleased(MOUSE_LEFT)
	end)
	// End of hack

	if !aphone.Texturelist[LocalPlayer():UserID()] then
		aphone:Painting_Generate(rt, {})
	end

	for k, v in pairs(aphone.matlist) do
		AdjustableModelPanel.Entity:SetSubMaterial(v, "!" .. tex:GetName())
	end

	local bottom_dock = vgui.Create("DPanel", f)
	bottom_dock:Dock(BOTTOM)
	bottom_dock:SetTall(50)

	local add_sticker = vgui.Create("DButton", bottom_dock)
	add_sticker:Dock(LEFT)
	add_sticker:SetWide((f:GetWide() - f:GetTall()) / 2)
	add_sticker:SetPaintBackground(false)
	add_sticker:TDLib()
	add_sticker:Background(mat_red)
	add_sticker:FadeHover(text_orange)
	add_sticker:Text(aphone.L("Add_Layer"), "MediumHeader_2D", white_font)

	local finish_sticker = vgui.Create("DButton", bottom_dock)
	finish_sticker:Dock(FILL)
	finish_sticker:SetPaintBackground(false)
	finish_sticker:TDLib()
	finish_sticker:Background(mat_red)
	finish_sticker:FadeHover(text_orange)
	finish_sticker:Text(aphone.L("Confirm"), "MediumHeader_2D", white_font)

	local list = vgui.Create("DScrollPanel", f)
	list:Dock(FILL)
	list:GetVBar():SetWide(0)
	list:aphone_PaintScroll()

	function list:Paint(w, h)
		surface.SetDrawColor(black_48)
		surface.DrawRect(0, 0, w, h)
	end

	function list:AddSticker(id, id_table)
		local deployable = vgui.Create("DPanel")
		list:AddItem(deployable)
		deployable:Dock(TOP)
		deployable:SetTall(50)
		deployable:SetPaintBackground(false)

		local b = vgui.Create("DButton", deployable)
		b:Dock(TOP)
		b:SetText("")
		b:SetTall(50)
		b:SetPaintBackground(false)
		b:TDLib()
		b:FillHover(mat_red, LEFT)

		local delete = vgui.Create("DButton", b)
		delete:Dock(RIGHT)
		delete:SetText("")
		delete:SetPaintBackground(false)
		delete:SetWide(b:GetTall())

		function delete:DoClick()
			stickers[id] = nil
			deployable:Remove()
			aphone:Painting_Generate(rt, stickers)
		end

		function deployable:Paint(w, h)
			if deployable:GetTall() != b:GetTall() then
				surface.SetDrawColor(mat_black)
				surface.DrawRect(0, 0, w, h)
			end
		end

		b:On("PaintOver", function(pnl, w, h)
			if deployable:GetTall() != pnl:GetTall() then
				surface.SetDrawColor(mat_red)
				surface.DrawRect(0, 0, w, h)
			end

			draw.SimpleText("Sticker " .. id, "MediumHeader_2D", 10, h / 2, text_white, 0, 1)
			// Bit ghetto, but I won't need to mess with ZPos etc...
			draw.SimpleText("-", "MediumHeader_2D", w - h / 2, h / 2, white_font, 1, 1)
		end)

		local settings_wide = f:GetWide() - AdjustableModelPanel:GetWide() - 20
		local settings = vgui.Create("DScrollPanel", deployable)
		settings:Dock(TOP)
		settings:DockMargin(10, 0, 10, 0)
		settings:SetPadding(settings_wide * 0.05)

		b:On("DoClick", function(pnl)
			deployable:SizeTo(-1, deployable:GetTall() == b:GetTall() and settings:GetTall() + b:GetTall() or b:GetTall(), 0.5, 0, 0.5)
		end)

		// Choose material
		for k, v in SortedPairsByMemberValue(slider_list, "order") do
			local set_txt = vgui.Create("DLabel")
			settings:AddItem(set_txt)
			set_txt:Dock(TOP)
			set_txt:SetText(v.name)
			set_txt:SetFont("Small_2D")

			local set_slider = vgui.Create("DSlider")
			settings:AddItem(set_slider)
			set_slider:Dock(TOP)
			set_slider:DockMargin(settings_wide * 0.15, 0, settings_wide * 0.15, 0)
			set_slider:SetSlideX((id_table[k] - v.min) / (v.max - v.min))

			function set_slider:Paint(w, h)
				surface.SetDrawColor(mat_lightred)
				surface.DrawRect(0, h * 0.35, w, h * 0.3)
				surface.SetDrawColor(mat_blackred)
				surface.DrawRect(0, h * 0.35, w * self:GetSlideX(), h * 0.3)
			end

			function set_slider:Think()
				if self:IsEditing() then
					local val = (v.max - v.min) * self:GetSlideX() + v.min

					if v.round then
						val = math.Round(val, v.round)
					end

					stickers[id][k] = val
					aphone:Painting_Generate(rt, stickers)
				end
			end

			function set_slider.Knob:Paint(w, h) end
		end

		// SizeToChildren don't work, making it myself
		local final_height = 0
		for k, v in ipairs(settings:GetCanvas():GetChildren()) do
			local _, dm_top, __, dm_bottom = v:GetDockMargin()
			final_height = final_height + v:GetTall() + dm_top + dm_bottom
		end
		settings:SetTall(final_height)
	end

	-- Can have gap, not using ipairs
	for k, v in pairs(stickers) do
		list:AddSticker(k, v)
	end

	function add_sticker:DoClick()
		if table.Count(stickers) >= aphone.MaxPainting then return end

		local t = {}
		-- Can have gap, not using ipairs
		for k, v in pairs(slider_list) do
			t[k] = v.default
		end

		list:AddSticker(table.insert(stickers, t), t)
		aphone:Painting_Generate(rt, stickers)
	end

	function finish_sticker:DoClick()
		net.Start("aphone_ChangeSticker")
			net.WriteUInt(table.Count(stickers), 6)

			// Send the wannabe table
			for k, v in SortedPairs(stickers) do
				net.WriteUInt(v.mat_id, 16)
				net.WriteUInt(v.angle, 9)
				net.WriteUInt(v.clr_r, 8)
				net.WriteUInt(v.clr_g, 8)
				net.WriteUInt(v.clr_b, 8)
				net.WriteUInt(v.posx * 100, 10)
				net.WriteUInt(v.posy * 100, 10)
				net.WriteUInt(v.sizex * 100, 10)
				net.WriteUInt(v.sizey * 100, 10)
			end
		net.SendToServer()
		f:Remove()
	end
end