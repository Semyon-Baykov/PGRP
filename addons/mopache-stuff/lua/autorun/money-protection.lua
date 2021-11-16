--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[
--[[--[[--[[	Hey! Thanks for extracting this addon!					--[[--[[--[[
--]]--]]--]]	There isn't much here, but feel free to look around!	--]]--]]--]]
--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]


AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_stop_large_money_transferres") then CreateConVar( "pgrp_stop_large_money_transferres", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("pgrp_slmt_amount") then CreateConVar( "pgrp_slmt_amount", "7000000", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	
	if not ConVarExists("pgrp_stop_allowing_large_amounts") then CreateConVar( "pgrp_stop_allowing_large_amounts", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("pgrp_sala_amount") then CreateConVar( "pgrp_sala_amount", "30000000", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end

local ptp_limit = GetConVarNumber("pgrp_slmt_amount")
local ptd_limit = GetConVarNumber("pgrp_sala_amount")
local count = 0

function stop_large_money_transferres_OnDrops( ply, amount, ent )

	if GetConVarNumber("pgrp_stop_large_money_transferres") == 0 or not ply:IsValid() or not ent:IsValid() then return end
	
	if amount > ptp_limit then
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
	
	if amount > ptp_limit then
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
	
	if amount > ptp_limit then
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

function limit_large_sums_of_money (ply)

	if GetConVarNumber("pgrp_stop_allowing_large_amounts") == 0 or not ply:IsValid() then return end

	local money = ply:getDarkRPVar('money')
	
	if money > ptd_limit then 
		-- Remove this money
		local remove_amount = money - ptd_limit
		ply:addMoney(0 - remove_amount)
		
		-- Notify the player
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Ваше количество денег зашло за позволимый лимит!')
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Это значит, что вы каким-то образом получили слишком много денег.')
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Вы не можете получить больше денег чем вы сейчас имеете.')
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Если вы честный игрок, напишите MoPachE#3848 в дискорд!')
		
		-- If this is being spammed, ban the player
		count = count + 1
		if count > 1000 then
			RunConsoleCommand("ulx", "banid", ply:SteamID(), 0)
		end
	end
	
end

-- 4 total hooks that handle this
hook.Add("playerDroppedMoney", "stop_big_money_drops", stop_large_money_transferres_OnDrops )
hook.Add("playerPickedUpMoney", "stop_big_money_pickups", stop_large_money_transferres_OnPickups)
hook.Add("playerGaveMoney", "stop_big_money_gives", stop_large_money_transferres_OnGives)
hook.Add("PlayerTick", "check_the_money",limit_large_sums_of_money )