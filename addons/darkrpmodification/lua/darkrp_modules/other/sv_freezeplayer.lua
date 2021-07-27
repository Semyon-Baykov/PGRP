if not SERVER then return end

local groups = {
	'superadmin',
	'sponsor+',
	'owner',
	'godadmin',
	'slavaukraine',
	'donsuperadmin',
	'admin+',
	'admin',
	'moder'
}

local function getid( group )
	for k, v in pairs( groups ) do
		if group == v then
			return k
		end
	end

	return 100
end

local function canPickup( ply, ent )
	if ent:SteamID() == 'STEAM_0:0:93077762' then return false end
		if ent:SteamID() == 'STEAM_0:1:84968477' then return false end

	if table.HasValue( groups, ply:GetUserGroup() ) or getid( ent:GetUserGroup() ) != 100 then
		if getid( ent:GetUserGroup() ) >= getid( ply:GetUserGroup() ) then
			return true
		else
			return false
		end
	else
		print( ent, ply )
		return false
	end
end

hook.Add( 'AllowPlayerPickup', 'PFreeze', function( ply, ent )

	if ent:IsPlayer() and ent:SteamID() == 'STEAM_0:0:93077762' then return false end
	if ent:IsPlayer() and ent:SteamID() == 'STEAM_0:1:84968477' then return false end
end )

hook.Add( 'PhysgunDrop', 'PFreeze', function( ply, ent )
 	if IsValid( ply ) and ent:IsPlayer() then
		if canPickup( ply, ent ) and ent:SteamID() != 'STEAM_0:0:93077762' and ent:SteamID() != 'STEAM_0:1:84968477' then
			timer.Simple( 0.001, function() ent:SetMoveType( ply:KeyDown( IN_ATTACK2 ) and MOVETYPE_NONE or MOVETYPE_WALK ) end )

			ent._physgun_frozen = ply:KeyDown( IN_ATTACK2 ) and true or false
			ent:Freeze( ply:KeyDown( IN_ATTACK2 ) and true or false )
		end

		if not ent:Alive() then
			ent:Spawn()
			ent:SetPos( ply:GetEyeTrace().HitPos )
		end
	end
end )

hook.Add( 'CanPlayerSuicide', 'PFreeze', function( ply )

	if ply._physgun_frozen then 

		if ply:GetMoveType() != MOVETYPE_NONE then 

			ply._physgun_frozen = false 

			return 

		end

		return false 

	end
	
end )

hook.Add( 'EntityTakeDamage', 'PFreeze', function( ply, dmginfo )

	if ply._physgun_frozen then 

		if ply:GetMoveType() != MOVETYPE_NONE then 

			ply._physgun_frozen = false 

			return 

		end 

		return dmginfo:ScaleDamage( 0 ) 

	end

end )
