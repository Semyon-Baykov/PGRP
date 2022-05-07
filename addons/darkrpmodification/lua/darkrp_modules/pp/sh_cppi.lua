-- PP ENUMS
CPPI_TOOLGUN = 1
CPPI_PHYSGUN = 2
CPPI_PROPERTY = 3
CPPI_PUSH = 4

CPPI = CPPI or {}
CPPI.CreditFormat = "%s CPPI.\n(C) CakeRP Team"

local PLAYER = FindMetaTable( "Player" )
local ENTITY = FindMetaTable( "Entity" )

-- Get name
function CPPI:GetName()
	return "Unnamed"
end

function CPPI:GetCredits()
	return self.CreditFormat:format( self:GetName() )
end

function CPPI:PrintLogo()
	print( string.format( '=============================================\n%s\n=============================================', self:GetCredits() ) )
end

-- Get interface version of CPPI
function CPPI:GetInterfaceVersion()
	return 1.0
end

-- Get version of CPPI
function CPPI:GetVersion()
	return tostring( self:GetInterfaceVersion() )
end

-- Get name from UID
function CPPI:GetNameFromSID( sid )
	return player.GetBySteamID(sid or "")
end

-- Get friends from a player
function PLAYER:CPPIGetFriends()
	return self.CPPI_Friends or {}
end

-- Get the owner of an entity
function ENTITY:CPPIGetOwner()
	return self:GetNWEntity( 'CPPI_Owner' )
end

if CLIENT then

	CPPI.Friends = {}

	hook.Add( 'HUDPaint', 'CPPIOwnerDisplay', function()
		
		local ent = LocalPlayer():GetEyeTrace().Entity
		
		if IsValid( ent ) then
			
			local owner = ent:CPPIGetOwner()
			
			local owner_name = "World/Disconnected"
			
			if IsValid( owner ) then
				
				owner_name = owner:GetName()
				
			end
			
			draw.WordBox( 6, 5, ScrH() * 0.48, owner_name, "DermaDefault", Color( 0, 0, 0, 140 ), Color( 255,255,255 ) )
			
		end
		
	end)
	
	net.Receive( 'cppi_friends', function()
		CPPI.Friends = net.ReadTable()
	end)
	
	local menu, header, listbox
	
	function CPPI.FriendsMenu()
		if IsValid( menu ) then menu:Remove() end
		
		menu = vgui.Create( "gpFrame" )
		menu:SetSize( 300, 400 )
		menu:SetPos( 5, ScrH() * 0.5 - 200 )
		menu:SetTitle( '' )
		
		header = menu:Add( "DPanel" )
		header:Dock( TOP )
		header:SetTall( 50 )
		
		header.PaintOver = function( self, w, h )
			draw.DrawText( 'Друзья', 'HUDSELECTIONTEXT', 5, 5, Color( 0,0,0 ) )
			draw.DrawText( 'Разрешить доступ к своим предметам', 'DermaDefault', 5, 20, Color( 0,0,0 ) )
		end
		
		listbox = menu:Add( "DListView" )
		listbox:Dock(FILL)
		listbox:AddColumn(""):SetFixedWidth( 24 )
		listbox:AddColumn("")
		listbox:SetDataHeight( 24 )
	
		listbox.VBar:SetWide(4) 
		
		function listbox:AddPlayer(ply)
			
			local line = self:AddLine( "", ply:GetName() )
			
			local av, profile, isfriend
			
			av = line:Add( 'AvatarImage' )
			av:SetPos( 3, 3 )
			av:SetSize( 18, 18 )
			av:SetPlayer( ply )
			
			profile = av:Add( "DButton" )
			profile:Dock(FILL)
			profile:SetText("")
			profile.Paint = nil
			
			profile.DoClick = function()
				ply:ShowProfile()
			end
			
			isfriend = line:Add( "DButton" )
			isfriend:Dock( RIGHT )
			isfriend:DockMargin( 2, 2, 14, 2 )
			isfriend:SetText("")
			isfriend:SetWide( 18 )
			
			isfriend.Paint = function(_,w,h)
				local ico = Material( 'icon16/bullet_red.png' )
				
				if CPPI.Friends[ ply ] then
					ico = Material( 'icon16/tick.png' )
				end
				
				surface.SetMaterial( ico )
				surface.SetDrawColor( 255,255,255,255 )
				surface.DrawTexturedRect( 1, 1, 16, 16 )
			end
			
			isfriend.DoClick = function()
				RunConsoleCommand( 'cppi_' .. ( CPPI.Friends[ ply ] and 'remove' or 'add' ) ..'friend', ply:SteamID() )
			end
			
		end
		
		for k,v in ipairs( player.GetHumans() ) do
			
			listbox:AddPlayer( v )
			
		end
		
	end
	
	concommand.Add( 'cppi_friends', CPPI.FriendsMenu )
	
	return
end

util.AddNetworkString( 'cppi_friends' )

function CPPI.SetupOwner( self, owner )
	self:SetNWEntity( "CPPI_Owner", owner )
	self.OwnerID = (IsValid( owner ) and owner:IsPlayer()) and owner:SteamID() or "world"
end

function CPPI.OwnEntity( ent, owner )
	CPPI.SetupOwner( ent, owner )
	table.foreach( constraint.GetAllConstrainedEntities( ent ), function( _, cent )
		if cent:CPPIGetOwner() then return end
		CPPI.SetupOwner( cent, owner )
	end )
end

function PLAYER:UpdateFriends()
	net.Start( 'cppi_friends' )
	net.WriteTable( self.Friends or {} )
	net.Send( self )
end

function PLAYER:CheckFriend( ply )
	self.Friends = self.Friends or {}
	return self.Friends[ply] == true
end

function PLAYER:AddFriend( ply )
	self.Friends = self.Friends or {}
	self.Friends[ply] = true
	
	self:UpdateFriends()
end

function PLAYER:RemoveFriend( ply )
	self.Friends = self.Friends or {}
	self.Friends[ply] = nil
	
	self:UpdateFriends()
end

concommand.Add( 'cppi_addfriend', function( ply, _, args )
	if ply.cppi_cmdcd and ply.cppi_cmdcd > CurTime() then return end
	local sid = args[1]
	local pl = player.GetBySteamID( sid )
	if IsValid( pl ) and pl:IsPlayer() then
		ply:AddFriend( pl )
	end
	
	ply.cppi_cmdcd = CurTime() + 1
end)

concommand.Add( 'cppi_removefriend', function( ply, _, args )
	if ply.cppi_cmdcd and ply.cppi_cmdcd > CurTime() then return end
	local sid = args[1]
	local pl = player.GetBySteamID( sid )
	if IsValid( pl ) and pl:IsPlayer() then
		ply:RemoveFriend( pl )
	end
	
	ply.cppi_cmdcd = CurTime() + 1
end)

function ENTITY:CPPISetOwner( ply )
	return CPPI.OwnEntity( self, ply )
end

-- Physgun Access
function ENTITY:CPPICanPhysgun( ply )
	return CPPI.CanAccess( CPPI_PHYSGUN, ply, self )
end

-- Can tool
function ENTITY:CPPICanTool( ply, tool )
	return CPPI.CanAccess( CPPI_TOOLGUN, ply, self, tool )
end

-- Can punt
function ENTITY:CPPICanPunt( ply )
	return CPPI.CanAccess( CPPI_PUSH, ply, self )
end

-- Can Use
function ENTITY:CPPICanPickup( ply )
	return true -- why not
end

