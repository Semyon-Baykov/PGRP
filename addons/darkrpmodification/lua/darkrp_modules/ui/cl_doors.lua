surface.CreateFont( 'DoorMenu', {

    font = 'ScoreboardHeader',

    size = 17,

    weight = 400

} )

surface.CreateFont( 'DoorMenu_mini', {

    font = 'ScoreboardHeader',

    size = 15,

    weight = 400
    
} )

local FrameVisible = false 

local blur = Material( 'pp/blurscreen' )

local blurffect = function( panel, layers, density, alpha )

	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetDrawColor( Color( 255, 255, 255, alpha) )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( '$blur', ( i / layers) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local function createButton( frame )

	frame:SetTall( frame:GetTall() + 110 )


    local button = vgui.Create( 'DButton', frame )

    button:SetPos( 10, frame:GetTall() - 110 )

    button:SetSize( 180, 100 )

    button:SetText( '' )

	button.OnCursorEntered = function( self ) self.hover = true end

	button.OnCursorExited = function( self ) self.hover = false end

	button.txt = ''

	button.SetText = function( self, text )

		self.txt = text

	end

	button.Paint = function( self, w, h )

    	draw.RoundedBox( 0, 0, 0, w, h,  Color( 0, 0, 0, 175 ) )

		if self.hover then

			draw.RoundedBox( 0, 0, 0, w, h,  Color( 255, 255, 255, 5 ) )

		end

		draw.SimpleText( button.txt, 'DoorMenu_mini', w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

    frame.buttonCount = ( frame.buttonCount or 0 ) + 1

    frame.lastButton = button


    return button

end

local function doorMenu( setDoorOwnerAccess, doorSettingsAccess )

	if FrameVisible then return end

	local ent = LocalPlayer():GetEyeTrace().Entity 

	if not IsValid( ent ) or not ent:isKeysOwnable() or ent:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 40000 then return end

	FrameVisible = true 

	local frame = vgui.Create( 'DFrame' )

	frame:SetSize( 200, 30 )

	frame:ShowCloseButton( false )

	frame:MakePopup()

	frame.Paint = function( self, w, h )

        blurffect( self, 5, 10, 255 )

        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )

        draw.RoundedBox( 0, 0, 0, w, 21, Color( 0, 0, 0, 150 ) )

    end

    local entType = DarkRP.getPhrase( ent:IsVehicle() and 'vehicle' or 'door' )

    frame:SetTitle( DarkRP.getPhrase( 'x_options', string.gsub( entType, "^%a", string.upper ) ) )

    frame.OnKeyCodePressed = function( self, key )

        if ( key == 93 or key == 28 ) and self.Close then

            self:Close()

            FrameVisible = true 

            timer.Simple( 0.2, function() FrameVisible = false end )

        end

    end

	frame.Close = function( self )

		FrameVisible = false 

		self:Remove()

	end

	frame.Think = function( self )

		local nent = LocalPlayer():GetEyeTrace().Entity 

		if not IsValid( nent ) or not nent:isKeysOwnable() or nent:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 40000 then

			self:Close()

		end

		if not self.Dragging then return end

		local x, y = gui.MouseX() - self.Dragging[ 1 ], gui.MouseY() - self.Dragging[ 2 ]

		x = math.Clamp( x, 0, ScrW() - self:GetWide() )

		y = math.Clamp( y, 0, ScrW() - self:GetTall() )

		self:SetPos( x, y )

	end

	local closebutton = vgui.Create( 'DButton', frame )

    closebutton:SetSize( ( ScrW() - ( ScrW() / 1.20 ) ) / 8, 15 )

    closebutton:SetPos( frame:GetWide() - closebutton:GetWide() - 3, 3 )

    closebutton:SetText( '' ) 

    closebutton:SetColor( Color( 182, 35, 29 ) )

    closebutton.Paint = function( self, w, h )

        draw.RoundedBox( 2, 0, 0, w, h, Color( 152, 25, 29 ) )

        draw.SimpleText( '✕', 'DoorMenu', w / 2, h / 2.25, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

    closebutton.DoClick = function()

    	frame:Close()

    end

    if ent:isKeysOwnedBy( LocalPlayer() ) then

        local buydoor = createButton( frame )

        buydoor:SetText( DarkRP.getPhrase( 'sell_x', entType ) .. ( ent:IsVehicle() and '' or '(' .. ent:GetNWInt( 'doorSys_count', 1 ) .. ')' ) )

        buydoor.DoClick = function() 

        	RunConsoleCommand( 'darkrp', 'toggleown' ) 

        	frame:Close() 

        end

        local AddOwner = createButton( frame )

        AddOwner:SetText( DarkRP.getPhrase( 'add_owner' ) )

        AddOwner.DoClick = function()

            local menu = DermaMenu()

            menu.found = false

            for k,v in pairs( DarkRP.nickSortedPlayers() ) do

                if not ent:isKeysOwnedBy( v ) and not ent:isKeysAllowedToOwn( v ) then

                    menu.found = true

                    menu:AddOption( v:Nick(), function() RunConsoleCommand( 'darkrp', 'addowner', v:Nick() ) end )

                end

            end

            if not menu.found then

                menu:AddOption( DarkRP.getPhrase( 'noone_available' ), function() end )

            end

            menu:Open()

        end

        local RemoveOwner = createButton( frame )

        RemoveOwner:SetText( DarkRP.getPhrase( 'remove_owner' ) )

        RemoveOwner.DoClick = function()

            local menu = DermaMenu()

            for k,v in pairs( DarkRP.nickSortedPlayers() ) do

                if ( ent:isKeysOwnedBy( v ) and not ent:isMasterOwner( v ) ) or ent:isKeysAllowedToOwn( v ) then

                    menu.found = true

                    menu:AddOption( v:Nick(), function() RunConsoleCommand( 'darkrp', 'removeowner', v:Nick() ) end )

                end

            end

            if not menu.found then

                menu:AddOption( DarkRP.getPhrase( 'noone_available' ), function() end )

            end

            menu:Open()

        end

        if not ent:isMasterOwner( LocalPlayer() ) then

            RemoveOwner:SetDisabled( true )
        end

    end

     if doorSettingsAccess then

        local DisableOwnage = createButton( frame )

        DisableOwnage:SetText( DarkRP.getPhrase( ent:getKeysNonOwnable() and 'allow_ownership' or 'disallow_ownership' ) )

        DisableOwnage.DoClick = function() 

        	frame:Close() 

        	RunConsoleCommand( 'darkrp', 'toggleownable' ) 

        end
    end

    if doorSettingsAccess and ( ent:isKeysOwned() or ent:getKeysNonOwnable() or ent:getKeysDoorGroup() or hasTeams ) or ent:isKeysOwnedBy( LocalPlayer() ) then

        local DoorTitle = createButton( frame )

        DoorTitle:SetText( DarkRP.getPhrase( 'set_x_title', entType ) )

        DoorTitle.DoClick = function()

            Derma_StringRequest( DarkRP.getPhrase( 'set_x_title', entType ), DarkRP.getPhrase( 'set_x_title_long', entType ), '', function( text )

                RunConsoleCommand( 'darkrp', 'title', text )

                if IsValid( frame ) then

                    frame:Close()

                end
            end,

            function() end, DarkRP.getPhrase( 'ok' ), DarkRP.getPhrase( 'cancel' ) )
        end
    end

    if not ent:isKeysOwned() and not ent:getKeysNonOwnable() and not ent:getKeysDoorGroup() and not ent:getKeysDoorTeams() or not ent:isKeysOwnedBy( LocalPlayer() ) and ent:isKeysAllowedToOwn( LocalPlayer() ) then
       
        local Owndoor = createButton( frame )

        Owndoor:SetText( DarkRP.getPhrase( 'buy_x', entType ) .. ( ent:IsVehicle() and '' or '(' .. ent:GetNWInt( 'doorSys_count', 1 ) .. ')' ) )

        Owndoor.DoClick = function() 

        	RunConsoleCommand( 'darkrp', 'toggleown' ) 

        	frame:Close() 

        end
    
    end

    if doorSettingsAccess then

        local EditDoorGroups = createButton( frame )

        EditDoorGroups:SetText( DarkRP.getPhrase( 'edit_door_group' ) )

        EditDoorGroups.DoClick = function()

            local menu = DermaMenu()

            local groups = menu:AddSubMenu( DarkRP.getPhrase( 'door_groups' ) )

            local teams = menu:AddSubMenu( DarkRP.getPhrase( 'jobs' ) )

            local add = teams:AddSubMenu( DarkRP.getPhrase( 'add' ) )

            local remove = teams:AddSubMenu( DarkRP.getPhrase( 'remove' ) )

            menu:AddOption( DarkRP.getPhrase( 'none' ), function()

                RunConsoleCommand( 'darkrp', 'togglegroupownable' )

                if IsValid( frame ) then frame:Close() end

            end )

            for k, v in pairs( RPExtraTeamDoors ) do

                groups:AddOption( k, function()

                    RunConsoleCommand( 'darkrp', 'togglegroupownable', k )

                    if IsValid( frame ) then frame:Close() end

                end )

            end

            local doorTeams = ent:getKeysDoorTeams()

            for k, v in pairs( RPExtraTeams ) do

                local which = ( not doorTeams or not doorTeams[ k ] ) and add or remove

                which:AddOption( v.name, function()
                	
                    RunConsoleCommand( 'darkrp', 'toggleteamownable', k )

                    if IsValid( frame ) then frame:Close() end

                end)
            end

            menu:Open()

        end

    end

    if frame.buttonCount == 1 then

        frame.lastButton:DoClick()

    elseif frame.buttonCount == 0 or not frame.buttonCount then

        frame:Close()

        FrameVisible = true

        timer.Simple( 0.3, function() FrameVisible = false end )

    end


    hook.Call( 'onKeysMenuOpened' , nil, ent, Frame)

    frame:Center()
end

timer.Simple( 1, function() 

    function DarkRP.openKeysMenu( um )

        CAMI.PlayerHasAccess( LocalPlayer(), 'DarkRP_SetDoorOwner', function( setDoorOwnerAccess )

            CAMI.PlayerHasAccess( LocalPlayer(), 'DarkRP_ChangeDoorSettings', fp{ doorMenu, setDoorOwnerAccess } )

        end )
    end


    usermessage.Hook( 'KeysMenu', DarkRP.openKeysMenu )
    
    GAMEMODE.ShowTeam = DarkRP.openKeysMenu 

end  )
