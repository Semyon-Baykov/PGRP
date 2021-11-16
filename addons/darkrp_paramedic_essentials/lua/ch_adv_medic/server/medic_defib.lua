--[[
local function CH_AdvMedic_OnBodyRemoved( pPlayer, bRevived )
    print( pPlayer )
	print( bRevived )
end
hook.Add( "CH_AdvMedic_OnBodyRemoved", "CH_AdvMedic_OnBodyRemoved", CH_AdvMedic_OnBodyRemoved )
--]]

-- DEFIB HOOKS
function ADV_MEDIC_DEFIB_PlayerSpawn( ply )
    -- Remove the players body ragdoll if it exists.
	if IsValid( ply.DeathRagdoll ) then
        ply.DeathRagdoll:Remove()
		
		-- Check if player was revived and call compatibility hook
		if ply.WasRevived then
			hook.Run( "CH_AdvMedic_OnBodyRemoved", ply, true )
			ply.WasRevived = false
		else
			hook.Run( "CH_AdvMedic_OnBodyRemoved", ply, false )
			ply.WasRevived = false
		end
		
		-- Set life alert to false for the player if they fully die and doesn't get revived.
		if ply.HasLifeAlert then
			ply.HasLifeAlert = false
		end
    end
	
	if not ply:changeAllowed( ply:Team() ) then
		ply:changeTeam( GAMEMODE.DefaultTeam, true )
	end
	
	-- Unspectate to stop ghosting your own corpse.
    ply:UnSpectate()
	
	-- Reset spawn timer
	ply.NextRespawn = 0
	
	-- Fix injuries if they've got any
	if ply:HasInjury() then
		ADV_MEDIC_DMG_FixInjuries( ply, false )
	end
	
	-- If auto life alert is enabled, then give the player a life alert.
	timer.Simple( 1, function()
		if CH_AdvMedic.Config.AutoLifeAlert then
			ply.HasLifeAlert = true
		end
	end )
end
hook.Add( "PlayerSpawn", "ADV_MEDIC_DEFIB_PlayerSpawn", ADV_MEDIC_DEFIB_PlayerSpawn )

function ADV_MEDIC_DEFIB_PlayerDisconnected( ply )
	-- Remove the players body ragdoll if it exists.
	if IsValid( ply.DeathRagdoll ) then
        ply.DeathRagdoll:Remove()
    end
end
hook.Add( "PlayerDisconnected", "ADV_MEDIC_DEFIB_PlayerDisconnected", ADV_MEDIC_DEFIB_PlayerDisconnected )

function ADV_MEDIC_DEFIB_PlayerDeath( victim, inflictor, attacker )
--print(victim:IsSecondaryUserGroup("premium"))
    -- Store the players weapon so we can give them back upon saved
	local player_weapons = victim:GetWeapons()
	
    victim.WeaponsOnKilled = {}
    for k, wep in ipairs( player_weapons ) do
        table.insert( victim.WeaponsOnKilled, wep:GetClass() )
    end
	
	-- Exit vehicle to properly spawn corpse
    if victim:InVehicle() then
		victim:ExitVehicle()
	end
	
    -- Remove default corpse
	if IsValid( victim:GetRagdollEntity() ) then
		victim:GetRagdollEntity():Remove()
	end
	
	-- Start moaning sounds if enabled
	if CH_AdvMedic.Config.EnableDeathMoaning then
		ADV_MEDIC_DEFIB_StartMoaning( victim )
	end
	
	-- Stop bleeding timer
	if timer.Exists( victim:EntIndex() .."_StartInternalBleeding" ) then
		timer.Remove( victim:EntIndex() .."_StartInternalBleeding" )
	end
	
	-- Create ragdoll
    local corpse = victim:CreateCorpse()
	local pos = victim:GetPos()
	
    -- Set the view on the ragdoll
    victim:Spectate( OBS_MODE_CHASE )
    victim:SpectateEntity( corpse )
	
	-- Network respawn countdown
	timer.Simple( 0 , function()
	--[[
		local ParamedicCount = 0
		local RequiredPlayersCounted = 0
	
		for k, ply in ipairs( player.GetAll() ) do
			RequiredPlayersCounted = RequiredPlayersCounted + 1
			
			if table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
				ParamedicCount = ParamedicCount + 1
			end
			
			if RequiredPlayersCounted == #player.GetAll() then
				-- All counted
				if ParamedicCount <= 0 then -- No medics time applied (overwrite donator times if enabled)
					--victim.NextRespawn = CurTime() + CH_AdvMedic.Config.UnconsciousIfNoMedicTime

				--else
					--print(victim:gp_VipAccess())
					--print(victim:IsSecondaryUserGroup("premium"))
					--]]
					--print(victim:IsSecondaryUserGroup("premium"))
					if victim:IsSecondaryUserGroup("premium") then
						victim.NextRespawn = CurTime() + 20
					else
						victim.NextRespawn = CurTime() + 45
					end
					
					

				--end

				net.Start( "ADV_MEDIC_DEFIB_UpdateSeconds" )
					net.WriteInt( victim.NextRespawn, 32 )
				net.Send( victim )
			--end
		--end
	end )
	
	timer.Simple( 4, function ()
		if victim:Alive() then
			victim:SetPos(pos)
			victim:Kill()
		end
	end )
end
hook.Add( "PlayerDeath", "ADV_MEDIC_DEFIB_PlayerDeath", ADV_MEDIC_DEFIB_PlayerDeath )

-- Determine if the player can respawn
function ADV_MEDIC_DEFIB_PlayerDeathThink( ply )
    if ply.NextRespawn and ply.NextRespawn > CurTime() then
		return false
	end
	
	if not CH_AdvMedic.Config.ClickToRespawn then
		if ply.NextRespawn and ply.NextRespawn < CurTime() then
			ply:Spawn()
		end
	end
end
hook.Add( "PlayerDeathThink", "ADV_MEDIC_DEFIB_PlayerDeathThink", ADV_MEDIC_DEFIB_PlayerDeathThink )

local function ADV_MEDIC_DEFIB_CanSeeChat( ply, text, teamchat )
	if not ply:Alive() then
		if CH_AdvMedic.Config.DisableChatWhenDead then
			if ply:IsAdmin() then
				if text == CH_AdvMedic.Config.AdminReviveCommand then
					ply.WasRevived = true
					ply:Spawn()
					
					if IsValid( ply.DeathRagdoll ) then
						ply:SetPos( ply.DeathRagdoll:GetPos() )
					end
					
					for k, v in ipairs( ply.WeaponsOnKilled ) do
						ply:Give( v )
					end
					
					return ""
				elseif text != "/afk" then
					return ""
				end
			elseif text != "/afk" then
				return ""
			end
		elseif ply:IsAdmin() then
			if text == CH_AdvMedic.Config.AdminReviveCommand then
				ply.WasRevived = true
				ply:Spawn()
				
				if IsValid( ply.DeathRagdoll ) then
					ply:SetPos( ply.DeathRagdoll:GetPos() )
				end
				
				for k, v in ipairs( ply.WeaponsOnKilled ) do
					ply:Give( v )
				end
				
				return
			end
		end
	end
end
hook.Add( "PlayerSay", "ADV_MEDIC_DEFIB_CanSeeChat", ADV_MEDIC_DEFIB_CanSeeChat )

-- Dead players can hear alive players voices within a distance https://wiki.facepunch.com/gmod/GM:PlayerCanHearPlayersVoice
local function ADV_MEDIC_DEFIB_CanHearVoice( listener, talker )
    if not listener:Alive() and IsValid( listener.DeathRagdoll ) then
        if listener.DeathRagdoll:GetPos():DistToSqr( talker:GetPos() ) < CH_AdvMedic.Config.DeadCanHearPlayersVoiceDistance then
            return true
        else
            return false
        end
    end
end
hook.Add( "PlayerCanHearPlayersVoice", "ADV_MEDIC_DEFIB_CanHearVoice", ADV_MEDIC_DEFIB_CanHearVoice )

local function ADV_MEDIC_DEFIB_CanGoAFK( ply, afk )
	if ply.NextRespawn and ply.NextRespawn > CurTime() then
		return false
	end
end
hook.Add( "canGoAFK", "ADV_MEDIC_DEFIB_CanSeeChat", ADV_MEDIC_DEFIB_CanGoAFK )

local function ADV_MEDIC_DEFIB_PlayerChangeTeam( ply )
	if ply.NextRespawn and ply.NextRespawn > CurTime() then
		DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You can't change your team while you're unconscious!"][CH_AdvMedic.Config.Language] )
		return false
	end
end
hook.Add( "playerCanChangeTeam", "ADV_MEDIC_DEFIB_PlayerChangeTeam", ADV_MEDIC_DEFIB_PlayerChangeTeam )

-- Player Death Moaning
function ADV_MEDIC_DEFIB_StartMoaning( ply )
	if IsValid( ply ) then
		local Gender = "male" -- return to male in-case no sex is found (model not found in male or female list)
		
		if ply:GetPlayersSex() == "Male" then
			Gender = "male"
		elseif ply:GetPlayersSex() == "Female" then
			Gender = "female"
		end
	
		ply.MoanFile = "vo/npc/" .. Gender .. "01/moan0" .. math.random( 1, 5 ) .. ".wav"
		ply:EmitSound( ply.MoanFile )

		timer.Simple( math.random( 5, 10 ), function()
			if IsValid( ply ) and not ply:Alive() then
				ADV_MEDIC_DEFIB_StartMoaning( ply )
			end
		end )
	end
end