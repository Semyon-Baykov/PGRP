--[[
DelMods = DelMods or {}
DelMods.apac = {
	physgun_stop_motion_on_drop = false, // Whenever a prop is dropped, it's motion will halt. This will prevent prop "throwing"
	physgun_disallow_pushing = true, // Disable collisions on players while entity is picked up
	physgun_prop_transparancy = false, // Make prop transparent while its picked up (to help indicate the collision above)
	deny_entity_damage = true, // Whether entities can crush people (drop prop on head)
	deny_player_owned_prop_damage_only = false, // Whether only player owned props are blocked from doing damage
	delay_entity_damage = 15, // if deny_entity_damage is disabled, this is the amount of seconds a prop has to be untouched by a player before it starts doing crush damage.
	deny_vehicle_damage = true, // If enabled, vehicles should do no damage to players anymore.
}

local hookrun = 0
local hookrundelay = 0.05
hook.Add( "PhysgunPickup", "apacPhysgunPickup", function(ply, ent)
	if ent:IsPlayer() then return end
	if !ent:IsValid() then return false end
	if hookrun + hookrundelay > CurTime() then return end
	hookrun = CurTime()

	local can = hook.Call("PhysgunPickup", nil, ply, ent)

	if not can and can ~= nil then return false end


	local props = ent:IsConstrained() and constraint.GetAllConstrainedEntities(ent) or {}
	table.insert(props, ent)
	for k, v in pairs(props) do
		v.lm = CurTime()
		if timer.Exists("apacDontLockMeIn" .. " - " .. tostring(ent:EntIndex()) .. " - " .. tostring(ent:GetCreationTime())) then
			timer.Destroy("apacDontLockMeIn" .. " - " .. tostring(ent:EntIndex()) .. " - " .. tostring(ent:GetCreationTime()))
		end
		if ply:GetGroundEntity() == v then
			ply:SetPos(ply:GetPos())
		end
		if not DelMods.apac.physgun_disallow_pushing then return end
		if not v:IsPlayer() then
			if DelMods.apac.physgun_prop_transparancy then
				if not v.renderMode then v.renderMode = v:GetRenderMode() end
				v.OldColor = v:GetColor()
				v:SetColor(Color(v.OldColor.r, v.OldColor.g, v.OldColor.b, 200))
				v:SetRenderMode(1)
			end
			v.OldColGroup = v:GetCollisionGroup()
			v:SetCollisionGroup(20)
		end
	end
end)

local function dontLockMeIn(ent)
	if ent:IsPlayer() then return end
	if not IsValid(ent) then return end
	local colliding = ents.FindInSphere(ent:LocalToWorld(ent:OBBCenter()), ent:BoundingRadius())
	for k, v in pairs(colliding) do
		if v:IsVehicle() and not ent:IsVehicle() or (v:IsPlayer() and v:GetVehicle() ~= NULL) then
			if ent:IsVehicle() then return end
			ent:Remove()
			return false
		end
		if v:IsPlayer() and not v:InVehicle() and not tobool(v:GetObserverMode()) then
			if ent:NearestPoint(v:NearestPoint(ent:GetPos())):Distance(v:NearestPoint(ent:GetPos())) <= 20 then
				timer.Create("apacDontLockMeIn" .. " - " .. tostring(ent:EntIndex()) .. " - " .. tostring(ent:GetCreationTime()), 0.1, 1, function() dontLockMeIn(ent) end)
				return false
			end
		end
	end

	if ent.OldColGroup != nil then
		if ent.OldColGroup == 20 then ent.OldColGroup = 0 end
		if DelMods.apac.physgun_prop_transparancy and ent.OldColor then
			ent:SetColor(Color(ent.OldColor.r,ent.OldColor.g,ent.OldColor.b,ent.OldColor.a))
			ent:SetRenderMode(ent.renderMode or 0)
		end
		ent:SetCollisionGroup(ent.OldColGroup)
		ent.OldColGroup = nil
	end
	return true
end

hook.Add( "PhysgunDrop", "apacPhysgunDrop", function(ply, ent)
	if !ent:IsValid() then return false end

	ent.lm = CurTime()
	if not DelMods.apac.physgun_disallow_pushing then return end

	local props = ent:IsConstrained() and constraint.GetAllConstrainedEntities(ent) or {}
	table.insert(props, ent)
	for _, prop in pairs(props) do
		if prop.OldColGroup then
			dontLockMeIn(prop)
		end
	end
	if not DelMods.apac.physgun_stop_motion_on_drop then return end
	for k, v in pairs(props) do
		local phys = v:GetPhysicsObject()
		--if not v:IsPlayer() then v:SetMoveType(MOVETYPE_NONE) end
		if phys:IsValid() and phys:IsMotionEnabled() then
			if ply.buildermod and ply.buildermod == true then return end
			phys:EnableMotion( false )
			--phys:Sleep()
		end
	end
end)

hook.Add("OnPhysgunFreeze", "apacPhysgunFreezing", function(weapon, physobj, ent)
	if !ent:IsValid() then return false end
	ent.lm = CurTime()
	--print("job")
	--weapon:GetOwner():SendLua('print("job")')
	local props = ent:IsConstrained() and constraint.GetAllConstrainedEntities(ent) or {}
	table.insert(props, ent)
	for _, prop in pairs(props) do
		local colliding = ents.FindInSphere(prop:LocalToWorld(prop:OBBCenter()), prop:BoundingRadius())
		for k, v in pairs(colliding) do
			--weapon:GetOwner():SendLua('print("job3")')
			if v:IsVehicle() or (v:IsPlayer() and v:GetVehicle() ~= NULL) then
				prop:Remove()
				return false
			end
			if (v:IsPlayer() ) and v:GetObserverMode() then
				--weapon:GetOwner():SendLua('print("job2")')

				if prop:NearestPoint(v:NearestPoint(prop:GetPos())):Distance(v:NearestPoint(prop:GetPos())) <= 20 then
					weapon:GetOwner():SendLua( "notification.AddLegacy( 'Вы не можете заморозить проп т.к он может застрять в игроке!', NOTIFY_ERROR, 5 )" )
					return false
				end
			end
			
		end
	end
end)

hook.Add("CanPlayerUnfreeze", "apacPhysgunUnfreeze", function( ply, ent, physobj )
	if ply.buildermod and ply.buildermod == true then return true end
	return false
end)

hook.Add("GravGunOnDropped", "apacGravGunOnDropped", function(ply, ent)
	ent.lm = CurTime()
end)

hook.Add("GravGunOnPickedUp", "apacGravGunOnPickedUp", function(ply, ent)
	ent.lm = CurTime()
end)

hook.Add("OnEntityCreated", "apacOnEntityCreated", function(ent)
	// lm => last modified, to be used in player damage hooks, to determine if it should or could make damage
	if IsValid(ent) then
		ent.lm = CurTime()
	end
end)

	/*
		There is no universal method of attaining owner of an entity, or even if the entity was created by a player. Thus, we tag the entities ourselves.
		NB: Still relies on sandbox, so gamemode has to derive from sandbox for this to work. Yet, gamemodes not derived from sandbox are likely to have a completely different
	*/
local function addOwnershipTag(ply, ent, _)
	if IsValid(_) then ent = _ end
	if IsValid(ent) then
		if not ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' then
			ent.EntityOwner = ply:UniqueID()
		end
		if not DelMods.apac.physgun_disallow_pushing then return end
		if not ent.OldColGroup and not ent:IsPlayer() then
			if DelMods.apac.physgun_prop_transparancy then
				if not ent.renderMode then ent.renderMode = ent:GetRenderMode() end
				ent.OldColor = ent:GetColor()
				ent:SetColor(Color(ent.OldColor.r, ent.OldColor.g, ent.OldColor.b, 200))
				ent:SetRenderMode(1)
			end
			ent.OldColGroup = ent:GetCollisionGroup()
			ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end
		dontLockMeIn(ent)
	end
end
hook.Add("PlayerSpawnedEffect", "apacTagEffect", addOwnershipTag)
hook.Add("PlayerSpawnedNPC", "apacTagNPC", addOwnershipTag)
hook.Add("PlayerSpawnedProp", "apacTagProp", addOwnershipTag)
hook.Add("PlayerSpawnedRagdoll", "apacTagRagdoll", addOwnershipTag)
hook.Add("PlayerSpawnedSENT", "apacTagSENT", addOwnershipTag)
hook.Add("PlayerSpawnedSWEP", "apacTagSWEP", addOwnershipTag)
hook.Add("PlayerSpawnedVehicle", "apacTagVehicle", addOwnershipTag)

hook.Add("EntityTakeDamage", "apacPreventPropDamage", function(target, damageinfo)
	local attacker = damageinfo:GetAttacker()
	if not attacker:IsPlayer() and (not DelMods.apac.deny_player_owned_prop_damage_only or tonumber(attacker.EntityOwner)) then
		if not damageinfo:IsFallDamage() and damageinfo:GetDamageType() == DMG_CRUSH then // Incoming damage is from a crush, and is not from a fall..
			if DelMods.apac.deny_entity_damage then
				damageinfo:ScaleDamage(0)
			else
				if attacker:IsWorld() or (attacker.lm and (attacker.lm + DelMods.apac.delay_entity_damage) > CurTime()) then
					damageinfo:ScaleDamage(0)
				end
			end
		end
	end

	if DelMods.apac.deny_vehicle_damage then
		if target:IsPlayer() and (attacker:IsVehicle() or (bit.band(damageinfo:GetDamageType(), DMG_VEHICLE) != 0)) then
			damageinfo:SetDamage(0)
			damageinfo:ScaleDamage(0)
			damageinfo:SetDamageForce(Vector(0,0,0))
		end
	end

end)



local function propSpawn(ply, model, ent)
	if not DelMods.apac.physgun_stop_motion_on_drop then return end
	local phys = ent:GetPhysicsObject()
	
	if IsValid( phys ) then
		if ply.buildermod and ply.buildermod == true then return end
		phys:EnableMotion( false )
		--phys:Sleep()
	end
end
hook.Add("PlayerSpawnedProp", "apacGhost", propSpawn)
hook.Add("PlayerSpawnedEffect", "apacGhost", propSpawn)
hook.Add("PlayerSpawnedRagdoll", "apacGhost", propSpawn)

]]--