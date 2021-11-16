-- Paramedic Essential Damage System
-- Contains hooks that scale the players damage and applies injuries.

function ADV_MEDIC_DMG_ScaleDamage( ply, hitgroup, dmginfo )
	-- Check if disabled in config
	if not CH_AdvMedic.Config.EnableInjurySystem then
		return
	end
	
	if not ply.DamageHitCount then
		ply.DamageHitCount = 0
	end
	
	if IsValid( ply ) then
		-- If injuries are disabled for certain teams, check for teams.
		if CH_AdvMedic.Config.DisableInjuriesForCertainTeams then
			if table.HasValue( CH_AdvMedic.Config.ImmuneInjuriesTeams, ply:Team() ) then
				return
			end
		end
		
		-- Add another hit to the players count.
		ply.DamageHitCount = ply.DamageHitCount + 1
		
		-- Return end if not enough hits to register injuries yet
		if ply.DamageHitCount <= CH_AdvMedic.Config.HitsBeforeInjuries then
			return
		end
		
		-- Check where players are hit, modify damage and check for injuries.
		if hitgroup == HITGROUP_HEAD then
			-- Might want to expand here later
		elseif hitgroup == HITGROUP_CHEST then
			if ply.HasInternalBleedings then
				return
			end

			ply.HasInternalBleedings = true
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You are experiencing internal bleedings. Find a paramedic as soon as possible."][CH_AdvMedic.Config.Language] )
			
			local random_bleed_damage = math.random( CH_AdvMedic.Config.DamageFromBleedingMin, CH_AdvMedic.Config.DamageFromBleedingMax )
			
			timer.Create( ply:EntIndex() .."_StartInternalBleeding", CH_AdvMedic.Config.InternalBleedingInterval, 0, function()
				ply:TakeDamage( random_bleed_damage, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
				
				if CH_AdvMedic.Config.EnableBleedingHurtSounds then
					if ply:GetPlayersSex() == "Male" then
						ply:EmitSound( "vo/npc/male01/imhurt0".. math.random( 1, 2 ) ..".wav" )
					elseif ply:GetPlayersSex() == "Female" then
						ply:EmitSound( "vo/npc/female01/imhurt0".. math.random( 1, 2 ) ..".wav" )
					end
				end
			end )
		elseif hitgroup == HITGROUP_STOMACH then
			if ply.HasInternalBleedings then
				return
			end

			ply.HasInternalBleedings = true
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You are experiencing internal bleedings. Find a paramedic as soon as possible."][CH_AdvMedic.Config.Language] )
			
			local random_bleed_damage = math.random( CH_AdvMedic.Config.DamageFromBleedingMin, CH_AdvMedic.Config.DamageFromBleedingMax )
			
			timer.Create( ply:EntIndex() .."_StartInternalBleeding", CH_AdvMedic.Config.InternalBleedingInterval, 0, function()
				ply:TakeDamage( random_bleed_damage, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
				
				if CH_AdvMedic.Config.EnableBleedingHurtSounds then
					if ply:GetPlayersSex() == "Male" then
						ply:EmitSound( "vo/npc/male01/imhurt0".. math.random( 1, 2 ) ..".wav" )
					elseif ply:GetPlayersSex() == "Female" then
						ply:EmitSound( "vo/npc/female01/imhurt0".. math.random( 1, 2 ) ..".wav" )
					end
				end
			end )
		elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			if ply.HasBrokenArm then
				return
			end
			
			ply.HasBrokenArm = true
			
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["Your arm has broken!"][CH_AdvMedic.Config.Language] )
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			if ply.HasBrokenLeg then
				return
			end
			
			-- Store players current walk/run speed for setting it once fixing injuries.
			ply.CHMedic_OldWalkSpeed = ply:GetWalkSpeed()
			ply.CHMedic_OldRunSpeed = ply:GetRunSpeed()
			
			ply.HasBrokenLeg = true
			ply:SetWalkSpeed( CH_AdvMedic.Config.BrokenLegWalkSpeed )
			ply:SetRunSpeed( CH_AdvMedic.Config.BrokenLegRunSpeed )
			
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["Your leg has broken!"][CH_AdvMedic.Config.Language] )
		end
    end
end
hook.Add( "ScalePlayerDamage", "ADV_MEDIC_DMG_ScaleDamage", ADV_MEDIC_DMG_ScaleDamage )

-- Disable equipping some weapons if they have a broken arm.
function ADV_MEDIC_DMG_EquipWeapons( ply, oldwep, newwep )
	if ply.HasBrokenArm then
		if table.HasValue( CH_AdvMedic.Config.DisallowedBrokenArmWeapons, newwep:GetClass() ) then
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You cannot equip this weapon with a broken arm!"][CH_AdvMedic.Config.Language] )
			return true
		end
	end
end
hook.Add( "PlayerSwitchWeapon", "ADV_MEDIC_DMG_EquipWeapons", ADV_MEDIC_DMG_EquipWeapons )

-- Function to fix injuries
function ADV_MEDIC_DMG_FixInjuries( ply, notify )
	if not CH_AdvMedic.Config.EnableInjurySystem then
		return
	end
	
	if ply.HasBrokenLeg then
		ply.HasBrokenLeg = false
		
		ply:SetWalkSpeed( ply.CHMedic_OldWalkSpeed or GAMEMODE.Config.walkspeed )
		ply:SetRunSpeed( ply.CHMedic_OldRunSpeed or GAMEMODE.Config.runspeed )
		
		if notify then
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["Your leg injury has been healed."][CH_AdvMedic.Config.Language] )
		end
	end
	
	if ply.HasBrokenArm then
		ply.HasBrokenArm = false
		
		if notify then
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["Your broken arm has been healed."][CH_AdvMedic.Config.Language] )
		end
	end
	
	if ply.HasInternalBleedings then
		ply.HasInternalBleedings = false
		
		if timer.Exists( ply:EntIndex() .."_StartInternalBleeding" ) then
			timer.Remove( ply:EntIndex() .."_StartInternalBleeding" )
		end
		
		if notify then
			DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["Your internal bleedings has been healed."][CH_AdvMedic.Config.Language] )
		end
	end
	
	ply.DamageHitCount = 0
end