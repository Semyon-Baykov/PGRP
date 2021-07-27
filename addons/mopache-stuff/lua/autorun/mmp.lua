AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_stop_large_money_transferres") then CreateConVar( "pgrp_stop_large_money_transferres", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end

local limit = 8000000	-- 8kk


function stop_large_money_transferres_OnDrops( ply, amount, ent )
	
	if GetConVarNumber("pgrp_stop_large_money_transferres") == 0 or not ply:IsValid() or not ent:IsValid() then return end
	
	if amount > limit then
		-- Remove this money
		ent:Remove()
		ply:addMoney(amount)
		
		-- Notify the player
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Деньги которые вы выкинули были удалены и возвращены вам обратно! Они зашли за лимит!' )
		-- Notify the admins 
		local sid = ply:SteamID()
		local nick = ply:Nick()
		for k, v in ipairs( ents.FindByClass("player") ) do
			if v:gp_IsAdmin() then 
				v:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Игрок ', nick, ' [', sid, '] заспавнил огромное количество денег! Проследите за ним!' )
			end
		end
	end
	
end

function stop_large_money_transferres_OnPickups( ply, amount, ent )
	
	if GetConVarNumber("pgrp_stop_large_money_transferres") == 0 or not ply:IsValid() then return end
	
	if amount > limit then
		-- Remove this money
		local remove_amount = 0 - amount
		ply:addMoney(remove_amount)
		
		-- Notify the player
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Деньги которые вы подобрали были удалены! Они зашли за лимит!' )
		-- Notify the admins
		local sid = ply:SteamID()
		local nick = ply:Nick()
		for k, v in ipairs( ents.FindByClass("player") ) do
			if v:gp_IsAdmin() then 
				v:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Игрок ', nick, ' [', sid, '] попытался подобрать огромное количество денег! Проследите за игроками!' )
			end
		end
	end
	
end

function stop_large_money_transferres_OnGives( ply, target, amount)

	if GetConVarNumber("pgrp_stop_large_money_transferres") == 0 or not ply:IsValid() or not target:IsValid() then return end
	
	if amount > limit then
		-- Remove this money
		local remove_amount = 0 - amount
		target:addMoney(remove_amount)
		ply:addMoney(amount)
		
		-- Notify the players
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Передаваемые вами деньги слишком большие! Деньги были возвращены!' )
		target:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Деньги которые вам передали зашли за лимит! Эти деньги были сняты и возвращены!' )
		
		-- Notify the admins
		local s_sid = ply:SteamID()
		local s_nick = ply:Nick()
		local t_sid = target:SteamID()
		local t_nick = target:Nick()
		for k, v in ipairs( ents.FindByClass("player") ) do
			if v:gp_IsAdmin() then 
				v:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Игрок ', s_nick, ' [', s_sid, '] попытался дать другому игроку огромное количество денег! Проследите за ним!\n', Color( 255, 200, 200 ), 'Игрок принимающий бабло: ', t_nick, ' ', t_sid )
			end
		end
	end
	
end


-- 3 total hooks that handle this
hook.Add("playerDroppedMoney", "stop_big_money_drops", stop_large_money_transferres_OnDrops )
hook.Add("playerPickedUpMoney", "stop_big_money_pickups", stop_large_money_transferres_OnPickups)
hook.Add("playerGaveMoney", "stop_big_money_gives", stop_large_money_transferres_OnGives)