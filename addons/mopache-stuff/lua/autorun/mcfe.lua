AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_player_freeze_ents") then CreateConVar( "pgrp_player_freeze_ents", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end


function freeze_certain_ents (ply, ent)
	if not IsValid(ent) or not IsValid(ply) then return end

	local class = ent:GetClass()
	local PhysObj = ent:GetPhysicsObject()
	
	if GetConVarNumber("pgrp_player_freeze_ents") == 1 then
		if class == "ch_bitminer_shelf" or class == "ch_bitminer_power_generator" or class == "ch_bitminer_power_combiner" or class == "ch_bitminer_power_rtg" or class == "ch_bitminer_power_solar"  or class == "eml_stove" then
			PhysObj:EnableMotion(false)
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Предмет успешно зафрижен! Используйте !entunfreeze что-бы его расфризить!' )
		else
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Данный предмет нельзя зафризить!' )
		end
	else
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Данная функция временно отключена!' )
	end
end

function unfreeze_certain_ents (ply, ent)
	if not IsValid(ent) or not IsValid(ply) then return end

	local class = ent:GetClass()
	local PhysObj = ent:GetPhysicsObject()
	
	if GetConVarNumber("pgrp_player_freeze_ents") == 1 then
		if class == "ch_bitminer_shelf" or class == "ch_bitminer_power_generator" or class == "ch_bitminer_power_combiner" or class == "ch_bitminer_power_rtg" or class == "ch_bitminer_power_solar"  or class == "eml_stove" then
			PhysObj:EnableMotion(true)
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Предмет успешно расфрижен! Используйте !entfreeze что-бы его вновь заморозить!' )
		else
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Данный предмет нельзя расфризить!' )
		end
	else
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Данная функция временно отключена!' )
	end
end

function take_chat_command (ply, text, teamChat)
	if IsValid(ply) then	
	
		--See what entity this is
		local ent = ply:GetEyeTrace().Entity
		
		--Call the function
		if text == "!entfreeze" then
			freeze_certain_ents(ply, ent)
			if not IsValid(ent) then ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Вы должны смотреть на какой-либо предмет!' ) end
			return ""
		elseif text == "!entunfreeze" then
			unfreeze_certain_ents(ply, ent)
			if not IsValid(ent) then ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-entfreeze] ', Color( 255, 255, 255 ), 'Вы должны смотреть на какой-либо предмет!' ) end
			return ""
		end
		
	end
end


hook.Add( "PlayerSay", "player_freeze_ents", take_chat_command )