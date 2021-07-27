if SERVER then return end

SNotify = SNotify or {}

SNotify.notifications = {}

SNotify.Font = 'Notify'

SNotify.MoveTime = 0.5

SNotify.MaxWidth = ScrW() / 4.5

SNotify.StartHeight = ScrH() - 250

SNotify.TypeColors = {

	--[ -1 ] = Color( 22, 160, 133, 175 ),
	
	[ 0 ] = Color( 0, 176, 52, 200 ),

	[ 1 ] = Color( 223, 0, 36, 200 ),

	[ 2 ] = Color( 0, 168, 236, 200 ),

	[ 3 ] = Color( 0, 168, 236, 200 ),

	[ 4 ] = Color( 0, 168, 236, 200 ),

	[ 10 ] = Color( 0, 0, 0, 200 )

}

surface.CreateFont( 'Notify', {

	font = 'Roboto',

	size = 22,

	weight = 350,

} )

local function drawNotify( id )

	local notify = SNotify.notifications[ id ]


	local text = notify.text

	local type = notify.type


	local x, y = notify.x, notify.y 

	local w, h = notify.w, notify.h

	surface.SetFont( 'Notify' )

	local space_w, space_h = surface.GetTextSize( ' ' )

	draw.RoundedBox( 4, x, y, w, h, ( SNotify.TypeColors[ type ] or SNotify.TypeColors[ 0 ] ) )

	for k, v in pairs( notify.text ) do

		draw.SimpleTextOutlined( v, SNotify.Font, x + 5, y + 5 + ( space_h * ( k - 1 ) ), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black )

	end

end

function notification.AddLegacy( text, type, time )

	local notify = {

		x = ScrW(),

		y = SNotify.StartHeight,

		w = SNotify.MaxWidth,

		h = 0,

		text = DarkRP.textWrap( text, SNotify.Font, SNotify.MaxWidth - 10 ):Split( '\n' ),

		type = type,

		time = CurTime() + time

	}

	notify.lines = #notify.text

	notify.h = notify.lines * 22 + 10 + 4

	table.insert( SNotify.notifications, 1, notify )

end

function notification.AddProgress( id, text )
	
	local notify = {

		x = ScrW(),

		y = SNotify.StartHeight,

		w = SNotify.MaxWidth,

		h = 0,

		text = string.Split( DarkRP.textWrap( text, SNotify.Font, SNotify.MaxWidth - 10 ), '\n' ),

		type = 2,

		time = math.huge,

		id = id

	}

	notify.lines = #notify.text

	notify.h = notify.lines * 22 + 10

	table.insert( SNotify.notifications, 1, notify )

end

function notification.Kill( id )

	for k, v in ipairs( SNotify.notifications ) do

		if v.id == id then v.time = 0 end

	end

end

hook.Add( 'HUDPaint', 'SNotify', function() 

	if hook.Run( 'HUDShouldDraw', 'SNotify' ) == false then return end

	local h = SNotify.StartHeight

	for k, v in pairs( SNotify.notifications ) do

		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - SNotify.MaxWidth - 10 or ScrW() + 1 )

		v.y = Lerp( FrameTime() * 10, v.y, h - v.h )

		h = h - v.h - 5

		if h <= 100 then continue end

		drawNotify( k )

		if v.time + 0.5 < CurTime() then

			table.remove( SNotify.notifications, k )

		end

	end

end )

----------------------------------------------------------------

SVoiceNotify = SVoiceNotify or {}

SVoiceNotify.MaxWidth = 250

SVoiceNotify.PlayerVoicePanels = {}

SVoiceNotify.XPosition = ScrW() - SNotify.MaxWidth - 10 - ( 20 + SVoiceNotify.MaxWidth )

----------------------------------------------

surface.CreateFont( 'SNotify', {

    font = 'Roboto',

    size = 22,

    weight = 300,

    antialias = true,

    shadow = true,

    extended = true,

} )

----------------------------------------------

local PANEL = {}

function PANEL:Init()

    self.Avatar = vgui.Create( 'AvatarImage', self )

    self.Avatar:Dock( LEFT )

    self.Avatar:SetSize( 32, 32 )


    self.Color = Color( 0, 0, 0 )


    self:SetSize( SVoiceNotify.MaxWidth, 40 )

    self:DockPadding( 4, 4, 4, 4 )

    self:DockMargin( 2, 2, 2, 2 )

    self:Dock( BOTTOM )

end

function PANEL:Setup( ply )

    self.ply = ply 

    self.Color = team.GetColor( self.ply:Team() )

    self.Avatar:SetSteamID( ply:SteamID64() )

    self:InvalidateLayout()

end

function PANEL:Paint( w, h )

    if not IsValid( self.ply ) or not IsValid( self ) then return end

    draw.RoundedBox( 4, 0, 0, w, h, team.GetColor( self.ply:Team() ) )

    draw.SimpleText( self.ply:GetNWBool('gp_radio_translation') and '[Рация] '..self.ply:Nick() or self.ply:Nick(), 'SNotify', 40, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

end

function PANEL:Think()

    if IsValid( self ) and self.fadeAnim then

        self.fadeAnim:Run()

    end

end

function PANEL:FadeOut( anim, delta, data )   

    if anim.Finished then   

    	self:Remove()

    else
    
   		self:SetAlpha( 255 - ( 255 * ( delta * 2 ) ) )

   	end

end

derma.DefineControl( 'VoiceNotify', '', PANEL, 'DPanel' ) 



local function HookVoiceVGUI()

    timer.Simple( 0, function()

        g_VoicePanelList:SetPos( SVoiceNotify.XPosition, 200 )

        g_VoicePanelList:SetSize( SVoiceNotify.MaxWidth + 6, ScrH() - ( 22.5 + 200 ) )

        g_VoicePanelList.Think = function( self ) 
                
            local x, y = g_VoicePanelList:GetPos()

            g_VoicePanelList:SetPos( Lerp( FrameTime() * 10, x, ScrW() - SNotify.MaxWidth - 10 - ( ( #SNotify.notifications != 0 and ( 10 + SVoiceNotify.MaxWidth ) or ( SVoiceNotify.MaxWidth - SNotify.MaxWidth ) ) ) ), 200 )

        end

        g_VoicePanelList.OriginalAdd = g_VoicePanelList.Add

        g_VoicePanelList.Add = function( self )

            return g_VoicePanelList.OriginalAdd( self, 'VoiceNotify' )

        end

    end )
end

hook.Add( 'InitPostEntity', 'SVoiceNotify', HookVoiceVGUI )
