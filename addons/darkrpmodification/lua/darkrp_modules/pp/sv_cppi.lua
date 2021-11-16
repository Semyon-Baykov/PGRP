CPPI.ServerLog = function( ... )
	local t = {...}
	print( '[PropProtect] ', string.format( string.rep( '%s', #t, ' ' ), ... ) )
end
---------------------------------------------------------------------------
CPPI.EntityTable = {}

CPPI.CleanupPlayer = function( steamid )
	local v = CPPI.EntityTable[ steamid ]
	if not v then return end
	CPPI.ServerLog( 'Removing', #v.Entities, 'props belongs to', v.OwnerName, '('..steamid..')'  )
	for id, prop in pairs( v.Entities ) do
		if IsValid( prop ) then prop:Remove() end
	end
end

CPPI.Cleanup = function( ply )
	local sid = type( ply ) == 'string' and ply or ply:SteamID()
	if sid == 'disconnected' then
		for k,v in pairs( CPPI.EntityTable ) do
			if not player.GetBySteamID( k ) then
				CPPI.CleanupPlayer( k )
			end
		end
		return
	end
	CPPI.CleanupPlayer( sid )
end

CPPI.AddCleanup = function( ply, ent )
	local sid = ply:SteamID()
	CPPI.EntityTable[sid] = CPPI.EntityTable[sid] or { OwnerName = ply:GetName(), Entities = {} }
	table.insert( CPPI.EntityTable[sid].Entities, ent )
end

hook.Add( 'PlayerDisconnected', 'Cleanup Disconnected', function( ply )
	local sid = ply:SteamID()
	CPPI.ServerLog( tostring(ply), '=>', 'cleanup in 60 seconds' )
	timer.Create( sid .. '_cleanup', 60, 1, function()
		if sid == 'STEAM_0:0:70383703' then return end
		CPPI.CleanupPlayer( sid )
	end)
end)

hook.Add( 'PlayerInitialSpawn', 'Cleanup Disconnected', function( ply )
	local sid = ply:SteamID()
	if timer.Exists( sid .. '_cleanup' ) then
		CPPI.ServerLog( tostring(ply), '=>', 'cleanup aborted' )
		timer.Destroy( sid .. '_cleanup' )
	end
end)


local function isadmin( ply )

	return ply:GetUserGroup() == 'donsuperadmin' or ply:GetUserGroup() == 'owner' or ply:GetUserGroup() == 'superadmin' or ply:GetUserGroup() == 'sponsor+' or ply:GetUserGroup() == 'nab_moder+' or ply:GetUserGroup() == 'nab_moder-' or ply:GetUserGroup() == 'nab_admin' or ply:GetUserGroup() == 'rukovoditel'

end
---------------------------------------------------------------------------
CPPI.HandleOwner = function( type, ply, ent )
	--if ply:IsSuperAdmin() then return true end
	if not IsValid(ent) then return true end
	local owner = ent:CPPIGetOwner()
	if ent.ppwhite and ply == owner then return true end
	if isadmin(ply) and not ent:CreatedByMap() and not ent.DarkRPItem and not ent.perma and not string.find( tostring(ent), 'func_' ) and not string.find( tostring(ent), 'NPC' ) and not ( (ent:GetClass() == 'player' or ent:GetClass() == "brax_atm" )  and type == CPPI_TOOLGUN ) then return true end
	if not ent.DarkRPItem and ply == owner or (IsValid( owner) and owner:CheckFriend( ply, type )) then return true end
	if hook.Run( 'CPPIHandleTouch', type, ply, ent ) == true then return true end

	return false
end

CPPI.HandlePhysgun = function( ply, ent )
	return CPPI.HandleOwner( CPPI_PHYSGUN, ply, ent )
end

local tool_blacklist = {
	['wire_textreceiver'] = true,
	['simfphyssoundeditor'] = true, 
	['simfphyssuspensioneditor'] = true,
	['simfphysgeareditor'] = true,
	['simfphysduplicator'] = true,
	['simfphyseditor'] = true,
	['simfphyswheeleditor'] = true
}

CPPI.HandleToolgun = function( ply, trace, tool )
	local entity = trace.Entity
	if tool == 'creator' and not ply:IsSuperAdmin() then return end
	if tool_blacklist[tool] and not ply:IsSuperAdmin() then
		ply:ChatAddText( Color( 255, 104, 0 ), tool..' запрещен для вашего ранга.' )
		print( ply:Nick()..' try use tool '..tool )
		return false
	end
	return CPPI.HandleOwner( CPPI_TOOLGUN, ply, entity )
end

CPPI.HandleProperty = function( ply, property, ent )
	return CPPI.HandleOwner( CPPI_PROPERTY, ply, ent )
end

CPPI.HandlePush = function(ply)
	return ply:GetUserGroup() == 'superadmin'
end

CPPI.CanAccess = function( type, ply, self, add )
	local handle = (type == CPPI_PHYSGUN and CPPI.HandlePhysgun) or
	(type == CPPI_PROPERTY and CPPI.HandleProperty) or
	(type == CPPI_TOOLGUN and CPPI.HandleToolgun) or
	(type == CPPI_PUSH and CPPI.HandlePush)

	return handle( ply, self, add )

end

--------------------------------------------------------------------------

hook.Add( "PhysgunPickup", "pprotect_touch", function(ply, ent)
	if not CPPI.HandlePhysgun( ply, ent ) then
		return false
	end
end)

hook.Add( "CanTool", "pprotect_tool", function( ply, trace, tool )
	if trace.Entity:GetClass() == 'gmod_wire_expression2' and ply != trace.Entity:CPPIGetOwner() and not trace.Entity:CPPIGetOwner():CheckFriend( ply ) then return false end
	if tool == 'paint' then
		return false
	end
	if not CPPI.HandleToolgun( ply, trace, tool ) then
		return false
	end
end)

hook.Add( "CanProperty", "pprotect_property", function(ply,property,ent)
	if not CPPI.HandleProperty( ply, property, ent ) then
		return false
	end
end )

hook.Add( "GravGunPunt", "pprotect_push", CPPI.HandlePush )
-------------------------------------------------------------------------
if UndoCreate then return end
EntTable, UndoCreate, UndoEntity, UndoPlayer, UndoFinish = nil, undo.Create, undo.AddEntity, undo.SetPlayer, undo.Finish
function undo.Create( PrintName )
	EntTable = { PrintName = PrintName, Entities = {}, Owner = nil }
	UndoCreate( PrintName )
end

function undo.AddEntity( ent )
	if ent ~= nil and IsEntity( ent ) and ent:GetClass() ~= "phys_constraint" then
		table.insert( EntTable.Entities, ent )
	end
	UndoEntity( ent )
end

function undo.SetPlayer( ply )
	EntTable.Owner = ply
	UndoPlayer( ply )
end

function undo.Finish()
	local ent, typ, ply = EntTable.Entities, EntTable.PrintName, EntTable.Owner

	if !ent or !ply:IsPlayer() then return end

	if ply.duplicate == true and typ != "Duplicator" and !string.find( typ, "AdvDupe" ) then ply.duplicate = false end

	table.foreach( ent, function( k, e )
		-- Check Entity
		if !e:IsValid() then return end

		-- Set Owner
		e:CPPISetOwner( ply )

		-- Do the hustle
		CPPI.AddCleanup( ply, e )

		-- PropInProp-Protection
		local pobj = e:GetPhysicsObject()

		if !IsValid( pobj ) then return end

		if pobj:IsPenetrating() then
			e:Remove()
		end
	end )

	EntTable = nil
	UndoFinish()
end
