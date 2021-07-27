local PANEL = {}

local stencil_writemask = render.SetStencilWriteMask
local stencil_testmask = render.SetStencilTestMask
local stencil_id = render.SetStencilReferenceValue
local stencil_fail = render.SetStencilFailOperation
local stencil_zfail = render.SetStencilZFailOperation
local stencil_compare = render.SetStencilCompareFunction
local stencil_pass = render.SetStencilPassOperation

function PANEL:Init()
	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:SetPaintedManually(true)
	self.avatar:Dock(FILL)
	self.avatar:SetMouseInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self:aphone_RemoveCursor()
end

function PANEL:SetPlayer(p, s)
	self.avatar:SetPlayer(p, s)
end

function PANEL:PerformLayout()
	self.border_poly = nil
end

local stencil_clr = Color(1, 1, 1, 1)
function PANEL:Paint(w, h)
	if !self.border_poly then
		self.border_poly = aphone.GUI.GenerateCircle(w / 2, h / 2, h < w and h/2 or w / 2)
	end

	// Reset
	if self.ignorestencil then
		render.ClearStencil()
		render.SetStencilEnable(true)
	end
	stencil_writemask( 0xFF )
	stencil_testmask( 0xFF )
	stencil_fail( STENCIL_KEEP )
	stencil_zfail( STENCIL_KEEP )
	stencil_id( 1 )

	// Stencil
	stencil_compare( self.ignorestencil and STENCIL_ALWAYS or STENCIL_EQUAL )
	stencil_pass( self.ignorestencil and STENCIL_REPLACE or STENCIL_INCRSAT )

		draw.NoTexture()
		surface.SetDrawColor(stencil_clr)
		surface.DrawPoly(self.border_poly)

	stencil_id( self.ignorestencil and 1 or 2)
	stencil_pass( self.ignorestencil and STENCIL_KEEP or STENCIL_DECRSAT )
	stencil_compare(STENCIL_EQUAL)

		self.avatar:PaintManual()

	// Get settings back
	// Ignore stencil is only used in call panel actually
	if !self.ignorestencil then
		stencil_id( 1 )
		stencil_pass( STENCIL_REPLACE )
	else
		render.SetStencilEnable(false)
	end
end

vgui.Register("aphone_CircleAvatar", PANEL)