-- lua_run print( Entity( 288 ):IsFlagSet( FL_STATICPROP ) )
-- lua_run print( Entity( 288 ):IsFlagSet( EFL_NO_GAME_PHYSICS_SIMULATION ) )
-- lua_run print( Entity( 288 ):GetPhysicsObject():HasGameFlag( FVPHYSICS_CONSTRAINT_STATIC ) )


-- Entity( 288 ):GetPhysicsObject():HasGameFlag( FVPHYSICS_PENETRATING )


--? Compatibilité SCars.
--- Lors du relâchement d'une entité et après avoir attendu 2 Thinks, si celle-ci interpénètre, il faut alors la suspendre.
--- Les entités étant figées reste en collision in_vehicle, ce qui est incorrect.
--- Vérifier s'il est possible de lire dans le physgun l'entité saisie afin d'utiliser une logique Think.





local NoPropKill = true
	CreateConVar( "mpp_nopropkill", "1", FCVAR_ARCHIVE, "Prevent prop killing? 0/1" )
	cvars.AddChangeCallback( "mpp_nopropkill", function( convar, oldValue, newValue )
		NoPropKill = ( tonumber( newValue )~=0 )
	end, "momo_prop_protection" )
	NoPropKill = GetConVar( "mpp_nopropkill" ):GetBool()

local NoCarKill = true
	CreateConVar( "mpp_nocarkill", NoPropKill and "1" or "0", FCVAR_ARCHIVE, "Prevent vehicle killing? 0/1" )
	cvars.AddChangeCallback( "mpp_nocarkill", function( convar, oldValue, newValue )
		NoCarKill = ( tonumber( newValue )~=0 )
	end, "momo_prop_protection" )
	NoCarKill = GetConVar( "mpp_nocarkill" ):GetBool()

local CanMoveOutOfWorld = true
	CreateConVar( "mpp_outofworld", "0", FCVAR_ARCHIVE, "Can the Physics Gun move props out of the world? 0/1" )
	cvars.AddChangeCallback( "mpp_outofworld", function( convar, oldValue, newValue )
		CanMoveOutOfWorld = ( tonumber( newValue )~=0 )
	end, "momo_prop_protection" )
	CanMoveOutOfWorld = GetConVar( "mpp_outofworld" ):GetBool()

local IgnoreEntityMove = false
	CreateConVar( "mpp_ignoremove", "0", FCVAR_ARCHIVE, "Totally ignore when an entity is grabbed with the Physics Gun? 0/1" )
	cvars.AddChangeCallback( "mpp_ignoremove", function( convar, oldValue, newValue )
		IgnoreEntityMove = ( tonumber( newValue )~=0 )
	end, "momo_prop_protection" )
	IgnoreEntityMove = GetConVar( "mpp_ignoremove" ):GetBool()

-- Anti-propkill & anti-carkill:
local propDamageTypes = bit.bor( DMG_CRUSH, DMG_VEHICLE )
hook.Add( "EntityTakeDamage", "momo_prop_protection", function( ply, dmginfo )
	if NoPropKill or NoCarKill then
		local damageType = dmginfo:GetDamageType()
		if bit.band( damageType, propDamageTypes )~=0 then
			if NoPropKill and NoCarKill then
				return true
			else
				local isDriverDamage = false
				local veh = dmginfo:GetInflictor()
				-- The attacker can be the driver as well as the vehicle, ignoring.
				if IsValid( veh ) and veh.GetDriver and IsValid( veh:GetDriver() ) then
					if type( veh )=="Vehicle" then -- genuine "Vehicle" entity
						if dmginfo:IsDamageType( DMG_VEHICLE ) then
							isDriverDamage = true
						end
					else -- SCar or equivalent, ignore DMG_VEHICLE
						isDriverDamage = true
					end
				end
				if NoPropKill then
					if not isDriverDamage then
						return true
					end
				else -- NoCarKill
					if isDriverDamage then
						return true
					end
				end
			end
		end
	end
end )

-- Anti-lag:
do
	local testRunning
	local returned
	-- This solution is bad but it ensures that denied pickup will work.
	-- This will not work when a prop is unfrozen without the physgun.
	-- If an event returns true before this hook then it will not work.
	hook.Add( "PhysgunPickup", "momo_prop_protection", function( ply, ent, ... )
		if not IgnoreEntityMove then
			if testRunning ~= ent then -- Bypass during running test! (failsafe, better than boolean)
				testRunning = ent
				returned = hook.Run( "PhysgunPickup", ply, ent, ... )
				testRunning = nil
				if returned or returned==nil then
					if not ent.momo_prop_protection then
						ent.momo_prop_protection = ent:GetCollisionGroup()
					end
					ent:SetCollisionGroup( CanMoveOutOfWorld and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_WORLD )
					return true
				else
					return false
				end
			end
		end
	end )
end
hook.Add( "PhysgunDrop", "momo_prop_protection", function( ply, ent )
	if ent.momo_prop_protection then
		ent:SetCollisionGroup( ent.momo_prop_protection )
		ent.momo_prop_protection = nil
	end
end )

print( "momo_prop_protection loaded!" )
