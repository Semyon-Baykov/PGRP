AddCSLuaFile()
local rg_autopos = Vector( -10945.17, 399.55, -90.1 )


function take_chat_command_RG (ply, text, team_chat)
	if text == "!rg-auto-join" then
		if ply:GetPData('autorg') == "1" then
			ply:SetPData('autorg', "0")
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-autorg] ', Color( 255, 255, 255 ), 'Вы выключили автозаход в рг.' )
			return ""
		else
			ply:SetPData('autorg', "1")
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-autorg] ', Color( 255, 255, 255 ), 'Вы включили автозаход в рг! Теперь когда вы заходите на сервер, вы автоматически становитесь росгвардейцом вашего ранга - напишите в консоль "retry" чтобы увидеть как это работает! Если вы хотите отключить эту функцию, просто напишите команду повторно в чат.' )
			return ""
		end
	end
	if text == "123456" then
		ply:SetPos(rg_autopos)
	end
end

local function find_rg_job (ply, rg_level)
	if rg_level < 3 then
		return "Стрелок"
	elseif rg_level < 5 then
		return "Фельдшер"
	elseif rg_level < 7 then
		return "Механик-водитель"
	elseif rg_level < 9 then
		return "Инструктор сержантского состава"
	elseif rg_level == 9 then
		return "Начальник медслужбы"
	elseif rg_level == 10 then
		return "Начальник химслужбы"
	elseif rg_level == 11 then
		return "Начальник ОЛРР"
	elseif rg_level < 15 then
		return "Заместитель командира части"
	elseif rg_level == 15 then
		return "Командир части"
	elseif rg_level < 19 then
		return "Инструктор старшего офицерского состава"
	elseif rg_level < 21 then
		return "Инструктор высшего офицерского состава"
	else
		return "Стрелок" 
	end
end

function setrgjob_on_join (ply)
	--if not ply:GetPData('autorg') == 1 then ply:SetPData('autorg', 0) end	-- failsafe	
	if ply:GetPData('autorg') == "1" then 
	
		--ply:rg_Join( find_rg_job(ply, ply:rg_GetLVL()) )
		
		ply:SetPos(rg_autopos)
		
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-autorg] ', Color( 255, 255, 255 ), 'Вы автоматически зашли за работу рг!' )
	end
end


hook.Add( "PlayerSay", "pgrp_autorg", take_chat_command_RG )
hook.Add( "PlayerInitialSpawn", "pgrp_autorg_setjob", setrgjob_on_join )