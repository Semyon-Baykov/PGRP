CreateClientConVar( "sg_roundedavatars", 1, true, false )

local cos, sin, rad, render, draw, gui, GetConVar = math.cos, math.sin, math.rad, render, draw, gui, GetConVar

local PANEL = {}

function PANEL:Init()
    self.Avatar = vgui.Create( "AvatarImage", self )

    self.Button = vgui.Create( "DButton", self )
    self.Button:SetText ""
    self.Button.Paint = function( s, w, h )
    end
    self.Button.DoClick = function( s )
        gui.OpenURL( "http://steamcommunity.com/profiles/" .. self.ply )
    end

    self.mask = 32
    self.ply = nil

    self.circle = {}

    self.rounded = GetConVar( "sg_roundedavatars" ):GetBool()

    if self.rounded then
        self.Avatar:SetPaintedManually( true )
    end
end

function PANEL:PerformLayout( w, h )
    self.Avatar:SetSize( w, h )
    self.Button:SetSize( w, h )

    self.mask = w / 2

    local c = 0

    for i = 1, 360 do
        c = rad( i * 720 ) / 720

        self.circle[ i ] = {
            x = w / 2 + cos( c ) * self.mask,
            y = h / 2 + sin( c ) * self.mask
        }
    end
end

function PANEL:SetPlayer( steamid )
    self.ply = steamid

    self.Avatar:SetSteamID( steamid, self:GetWide() )
end

function PANEL:Paint( w, h )
    if self.rounded then
        render.ClearStencil()
        render.SetStencilEnable( true )

        render.SetStencilWriteMask( 1 )
        render.SetStencilTestMask( 1 )

        render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
        render.SetStencilPassOperation( STENCILOPERATION_ZERO )
        render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
        render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
        render.SetStencilReferenceValue( 1 )

        draw.NoTexture()
        surface.SetDrawColor( Color( 255, 255, 255 ) )
        surface.DrawPoly( self.circle )

        render.SetStencilFailOperation( STENCILOPERATION_ZERO )
        render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
        render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
        render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
        render.SetStencilReferenceValue( 1 )

        self.Avatar:SetPaintedManually( false )
        self.Avatar:PaintManual()
        self.Avatar:SetPaintedManually( true )

        render.SetStencilEnable( false )
        render.ClearStencil()
    end
end

vgui.Register( "SG_Avatar", PANEL )
