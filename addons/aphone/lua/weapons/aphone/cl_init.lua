include("shared.lua")

local last_open = 0
local vm_pos, vm_ang
local phone_bg2D = Material("materials/akulla/aphone/phone_bg.png", "smooth 1")
local clr = Color(40, 40, 40)

local backup_setting = aphone:GetParameters("Core", "2D", false)
aphone:ChangeParameters("Core", "2D", false)

local rt = GetRenderTarget("aphone_rt_" .. math.ceil(aphone.GUI.ScaledSize(400)) .. "_" .. math.ceil(aphone.GUI.ScaledSize(855)), aphone.GUI.ScaledSize(400), aphone.GUI.ScaledSize(855), RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, bit.bor(2, 256), 0, IMAGE_FORMAT_RGBA8888)
local mat_rt = CreateMaterial( "mat_aphone_rt", "UnlitGeneric", {
	["$basetexture"] = rt:GetName(),
} )

aphone:ChangeParameters("Core", "2D", backup_setting)

local ratio_3D2D_notinvert = ScrH() / 1080
local ratio_3D2D = 1 / ratio_3D2D_notinvert

aphone.cursor_visible = false

// Stencils
local stencil_poly_default = {
	[1] = {
		x = -1,
		y = 20,
	},
	[2] = {
		x = 15,
		y = 0,
	},
	[3] = {
		x = 385,
		y = 0,
	},
	[4] = {
		x = 405,
		y = 20,
	},
	[5] = {
		x = 405,
		y = 840,
	},
	[6] = {
		x = 385,
		y = 855,
	},
	[7] = {
		x = 15,
		y = 855,
	},
	[8] = {
		x = -1,
		y = 840,
	},
}
local stencil_poly = table.Copy(stencil_poly_default)

local function calculate_ratios()
	local ratio_h = ScrH() / 1080
	local ratio_w = ScrW() / 1920
	local new_ratio = ratio_h < ratio_w and ratio_h or ratio_w

	ratio = new_ratio
	ratio_3D2D = 1 / ratio
	ratio_3D2D_notinvert = ratio

	--[[
	I tried to avoid recreating a rendertarget
	However, even if I avoid recreating by sizing perfectly panels, if the new resolution is too much bigger, then the phone panel would broke
	A solution would be to scale with matrix at the end, but it makes everything looks like a PS1 UI
	]]--

	local backup_setting = aphone:GetParameters("Core", "2D", false)
	aphone:ChangeParameters("Core", "2D", false)

	rt = GetRenderTarget("aphone_rt_" .. math.ceil(aphone.GUI.ScaledSize(400)) .. "_" .. math.ceil(aphone.GUI.ScaledSize(855)), aphone.GUI.ScaledSize(400), aphone.GUI.ScaledSize(855), RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, bit.bor(2, 256), 0, IMAGE_FORMAT_RGBA8888)

	aphone:ChangeParameters("Core", "2D", backup_setting)
	mat_rt:SetTexture("$basetexture", rt)

	if IsValid(aphone.MainDerma) then
		-- Reset the panel
		aphone.MainDerma:Remove()
	end

	for k, v in pairs(stencil_poly_default) do
		for i, j in pairs(v) do
			stencil_poly[k][i] = j * ratio_3D2D_notinvert
		end
	end
end
calculate_ratios()

hook.Add("OnScreenSizeChanged", "APhone_Refresh3D2DRatio", calculate_ratios)

function aphone.blur_rt(x, y, pass)
	if rt then
		render.BlurRenderTarget( rt, x, y, pass)
	end
end

local hdr_vec = Vector(0.67, 0.67, 0.67)

function SWEP:PostDrawViewModel(vm)
	self.ViewModelFOV = LocalPlayer():GetFOV()

	-- FIXME: This should be removed when ViewModelFOV() is binded
	local nFOV = self.ViewModelFOV
	if (not isnumber(nFOV)) then nFOV = 62 end

	if !aphone.MainDerma or !IsValid(aphone.MainDerma) then
		aphone.MainDerma = vgui.Create("aphone_Main")
		aphone.MainDerma:SetMouseInputEnabled(false)

		/* 
		Why 100 ? Because if we set it to a little value like 0 or 1, if he drag his mouse to the left of the screen and he is playing windowed then
		my code won't detect him going outside, so the mouse will stay and can make your mouse move out of the game
		Don't worry, I will fix this pos later in my rendertarget with matrix
		*/

		aphone.MainDerma:SetPos(aphone.GUI.ScaledSize(100, 100))

		// Notif panel, made it global so we can notify things
		aphone.NotifPanel = vgui.Create("DPanel", aphone.MainDerma)
		aphone.NotifPanel:SetSize(aphone.MainDerma:GetSize())
		aphone.NotifPanel:SetPaintedManually(true)
		aphone.NotifPanel:SetPaintBackground(false)
		aphone.NotifPanel:SetMouseInputEnabled(false)
		aphone.NotifPanel:SetZPos(4)
		
		if !aphone:Is2D() then
			aphone.NotifPanel:SetCursor("blank")
		else
			local aphone_main2D = vgui.Create("EditablePanel")

			aphone_main2D:SetSize(aphone.GUI.ScaledSize(215 * 2, 490 * 2))
			aphone_main2D:SetPos(ScrW() - aphone_main2D:GetWide(), ScrH() - aphone_main2D:GetTall())

			aphone.MainDerma:SetParent(aphone_main2D)
			aphone.MainDerma:SetPos(aphone.GUI.ScaledSize(15, 63))

			function aphone_main2D:PaintOver(w, h)
				surface.SetMaterial(phone_bg2D)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(0, 0, w, h)
			end

			function aphone_main2D:Think()
				self:MoveToFront()
				if !IsValid(aphone.MainDerma) then
					self:Remove()
					aphone.MainDerma = nil
				end

				local hovered_pnl = vgui.GetHoveredPanel()
				if input.IsMouseDown( 107 ) and last_open < CurTime() and !self:IsChildHovered() and !self:IsHovered() and IsValid(hovered_pnl) then
					gui.EnableScreenClicker(false)
					aphone.cursor_visible = false
				end
			end
		end
	end

	local tAttachment = vm:GetAttachment(1)

	vm_pos = tAttachment.Pos
	vm_ang = tAttachment.Ang

	vm_pos = vm_pos + vm_ang:Up() * 0.025
	vm_ang:RotateAroundAxis( vm_ang:Up(), -90)

	// Global, for camera app
	aphone.VM_Pos = vm_pos

	local ext_attachment = self:GetAttachment(1)

	aphone.WM_Pos = ext_attachment.Pos
	aphone.WM_Ang = ext_attachment.Ang

	if !aphone:Is2D() then
		// Ratio
		local c = vm:GetCycle()
		if c == 1 then
			aphone.horizontal_ratio = tonumber(aphone.Horizontal)
		else
			aphone.horizontal_ratio = (!aphone.Horizontal and 1 - c or c)
		end

		local pre_hdr = render.GetToneMappingScaleLinear()

		if aphone:GetParameters("Core", "AutoLight", false) and render.GetHDREnabled() then
			local inverted = math.Clamp(5 / pre_hdr.x - 2.6, 0.1, 0.67)
			render.SetToneMappingScaleLinear(Vector(inverted, inverted, inverted))
		else
			render.SetToneMappingScaleLinear(hdr_vec)
		end

		cam.Start3D2D(vm_pos, vm_ang, 0.01 * ratio_3D2D)
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.ClearStencil()

			// Enable stencils
			render.SetStencilEnable( true )
				surface.SetDrawColor(color_white)
				surface.DrawPoly(stencil_poly)
			render.SetStencilCompareFunction( STENCIL_EQUAL )
				surface.SetMaterial(mat_rt)
				surface.DrawTexturedRect(-2, 0, aphone.GUI.ScaledSize(405, 855))
			render.SetStencilEnable( false )
		cam.End3D2D()
		render.SetToneMappingScaleLinear(pre_hdr)
	end

	self:DrawLight(LocalPlayer(), ext_attachment)
end

// Without DrawHUD ( drawing in viewmodel), we would get big issues where the panel show himself even outside the bounds, like this : https://prnt.sc/121oske
function SWEP:DrawHUD()
	if vm_pos and !aphone:Is2D() and IsValid(aphone.MainDerma) then
		render.PushRenderTarget( rt )
			render.Clear(255, 255, 255, 255)
			// https://www.gitmemory.com/issue/Facepunch/garrysmod-issues/4662/691134213
			// https://wiki.facepunch.com/gmod/render.OverrideAlphaWriteEnable
			render.SetWriteDepthToDestAlpha(false)
			render.ClearDepth()
			render.OverrideAlphaWriteEnable(true, true)
				cam.Start2D()
					local size = aphone.MainDerma:GetPos()

					local tr = Matrix()
					tr:Translate(Vector(-size, -size, 0))
					if aphone.HorizontalApp then
						tr:Translate(Vector(mat_rt:Width() + size * 2, 0, 0))
						tr:Rotate(Angle(0, 90, 0))
					end
					cam.PushModelMatrix(tr)

					aphone.MainDerma:MoveToFront()
					aphone.MainDerma:PaintManual()

					if aphone.cursor_visible then
						local hovered_pnl = vgui.GetHoveredPanel()
						if last_open < CurTime() and !aphone.MainDerma:IsHovered() and !aphone.MainDerma:IsChildHovered() and IsValid(hovered_pnl) then
							// Try to get the mouse pos outside the phone
							local tbl_pos = vm_pos:ToScreen()
							tbl_pos.x = tbl_pos.x + gui.MouseX() / 1.5
							tbl_pos.y = tbl_pos.y + gui.MouseY() / 1.5
							input.SetCursorPos(tbl_pos.x, tbl_pos.y)
							aphone.cursor_visible = false

							gui.EnableScreenClicker(false)
							aphone.MainDerma:SetMouseInputEnabled(false)
						end

						local mousex, mousey = input.GetCursorPos()

						draw.SimpleText("d", "SVG_20_3D", lastframe_x or mousex, lastframe_y or mousey, clr, 1, 1)
						draw.SimpleText("d", "SVG_16_3D", lastframe_x or mousex, lastframe_y or mousey, color_white, 1, 1)
					end

					cam.PopModelMatrix()
				cam.End2D()
			render.SetWriteDepthToDestAlpha(true)
		render.PopRenderTarget()
	end
end

function SWEP:PrimaryAttack()
	if self:GetOwner() != LocalPlayer() then return end

	gui.EnableScreenClicker(true)

	-- I guess he won't travel +100px with his mouse in 0.03
	-- Using this to prevent the mouse reset instantly, because the setmousepos take some times/frames
	last_open = CurTime() + 0.1

	if !aphone:Is2D() then
		aphone.cursor_visible = true

		if aphone.HorizontalApp then
			input.SetCursorPos(aphone.GUI.ScaledSize(427.5, 200))
		else
			input.SetCursorPos(aphone.GUI.ScaledSize(200, 427.5))
		end
	end

	if IsValid(aphone.MainDerma) then
		aphone.MainDerma:SetMouseInputEnabled(true)
	end
end

-- I don't check if predicted, because I got issue with it on some servers, also because we don't need, even if the function 
-- is called multiples times. I check if the panel is valid
function SWEP:Holster()
	if self:GetOwner() != LocalPlayer() then return end

	if IsValid(aphone.Running_App) then
		aphone.Running_App:OnClose()
	end

	if IsValid(aphone.MainDerma) then
		aphone.MainDerma:Remove()

		if aphone.Horizontal then
			aphone.RequestAnim(1)
		end

		if !aphone:Is2D() then
			aphone.HorizontalApp = false

			// timer.simple 0 so weapon selectors, when you select a weapon, doesn't trigger mouse
			timer.Simple(0.5, function()
				if aphone.cursor_visible and (!IsValid(vgui.GetHoveredPanel()) or vgui.GetHoveredPanel():GetName() == "GModBase") then
					gui.EnableScreenClicker(false)
				end
			end)
		end
	end

	if ( IsValid( self.lamp ) ) then
		self.lamp:Remove()
		self.lamp = nil
	end
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:DrawLight(owner, tAttachment)
	if owner != LocalPlayer() then return end
	local param = aphone:GetParameters("Core", "Flashlight", false)
	local a = tAttachment.Ang + Angle(0, 90, 0)
	local p = tAttachment.Pos

	p = p + a:Up()*-0.9 + a:Right()*-1 + a:Forward()*-0.6

	if !self.lamp then
		if !param then return end
		local lamp = ProjectedTexture() -- Create a projected texture
		self.lamp = lamp -- Assign it to the entity table so it may be accessed later

		-- Set it all up
		lamp:SetTexture( "effects/flashlight001" )
		lamp:SetFarZ( 400 ) -- How far the light should shine

		lamp:SetPos( p ) -- Initial position and angles
		lamp:SetAngles( a )
		lamp:Update()
	else
		if ( IsValid( self.lamp ) ) then
			if param then
				self.lamp:SetPos( p )
				self.lamp:SetAngles( LocalPlayer():EyeAngles() )
				self.lamp:SetBrightness(4)
				self.lamp:SetEnableShadows(false)
				self.lamp:SetFarZ( 300 ) 
				self.lamp:Update()
				self.lamp:SetTexture( "effects/flashlight_border" )
			else
				self.lamp:Remove()
				self.lamp = nil
			end
		end
	end
end

function SWEP:DrawWorldModel()
	local o = self:GetOwner()

	if IsValid(o) then
		aphone.RefreshWeapon(o, self)
		self:DrawLight(o, self:GetAttachment(1))
	end

	self:DrawModel()
end

function SWEP:Reload()
	self.lastanimchange = self.lastanimchange or 0

	if self.lastanimchange < CurTime() then
		aphone.RequestAnim(aphone.Horizontal and 1 or 2)
		self.lastanimchange = CurTime() + 1
	end
end

function SWEP:SecondaryAttack() end