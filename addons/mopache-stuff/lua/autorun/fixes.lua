-- Unarrest without cuffs
hook.Add('playerUnArrested', 'remove_cuffs_on_unarrest', function (ply, activ)
	for k, v in ipairs( ents.FindByClass("player") ) do
		local penis = v
		v:PrintMessage(HUD_PRINTCONSOLE, 'Ты пенис :D')
		break
	end

	Realistic_Police.UnCuff(ply, penis)
end)

-- Take the cuffs off on arrest
hook.Add('playerArrested', 'remove_cuffs_on_arrest', function (ply, t, activ)
	Realistic_Police.UnCuff(ply, activ)
	
	-- RG Arrest check
	print(activ:Team() == TEAM_NRG1)
	if activ:Team() == TEAM_NRG1 then
		ply:SetPos(Vector(-11115, 4186, -108))
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-rg] ', Color( 255, 255, 255 ), 'Вас посадили в тюрьму Росгвардии!' )
	end
end)


-- Disallow money printer purchasing for certain jobs
hook.Add('playerBoughtCustomEntity', 'disallow_printers', function (ply, _, ent, price)
	if ent:GetClass() == 'money_printer2' or ent:GetClass() == 'fg_amber_printer' or ent:GetClass() == 'fg_sapphire_printer' or ent:GetClass() == 'fg_ruby_printer' or ent:GetClass() == 'fg_emerald_printer' then 
		if ply:Team() == TEAM_CIGAR or ply:Team() == TEAM_BITCOIN then
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Вы не можете покупать маники, займитесь лучше вашим нелегальным бизнесом!' )
			ply:addMoney(price)
			ent:Remove()
		elseif ply:Team() == TEAM_POLICE or ply:Team() == TEAM_DPS or ply:Team() == TEAM_PPS or ply:Team() == TEAM_CHIEF or ply:Team() == TEAM_MAYOR or ply:Team() == TEAM_MEDIC or ply:Team() == TEAM_OMON or ply:Team() == TEAM_FBI then
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Вы не можете покупать маники за гос работников!' )
			ply:addMoney(price)
			ent:Remove()
		elseif ply:Team() == TEAM_GUN or ply:Team() == TEAM_TRADE or ply:Team() == TEAM_MEH or ply:Team() == TEAM_SECURITY or ply:Team() == TEAM_COOK or ply:Team() == TEAM_FISH then
			if ent:GetClass() == 'money_printer2' or ent:GetClass() == 'fg_amber_printer' or ent:GetClass() == 'fg_sapphire_printer' then return end
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Вы не можете покупать такие продвинутые маники, займитесь лучше вашим бизнесом! Что-бы купить настолько хорошие маники, вы должны быть продвинутым в нелегальной сфере, но ваша работа - легальный бизнес!' )
			ply:addMoney(price)
			ent:Remove()
		elseif ply:Team() == TEAM_HOBO then
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Откуда у вас даньги на маники? Вы же бомж!' )
			ply:addMoney(price)
			ent:Remove()
		elseif ply:Team() == TEAM_CITIZEN then
			if ent:GetClass() == 'money_printer2' or ent:GetClass() == 'fg_amber_printer' or ent:GetClass() == 'fg_sapphire_printer' then return end
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Вы не можете покупать такие продвинутые маники! Что-бы купить настолько хорошие маники, вы должны быть продвинутым в нелегальной сфере (ваша работа не криминальная)' )
			ply:addMoney(price)
			ent:Remove()
		end
	end
end)


-- Demote protection
local activate_demote_protection = false
hook.Add('onPlayerDemoted', 'demote_protection', function (tply, ply, reason)
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), tply:Nick(), ' уволил вас с причиной "', reason, '"!' )
	
	
	if not ply:Team() == TEAM_CITIZEN then activate_demote_protection = true end
	if not ply:Alive() then activate_demote_protection = true end
	
	if activate_demote_protection then 
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Обноружена проблема при уволнение, увольняем повторно...' )
	
		ply:StripWeapons()
		ply:SetTeam(TEAM_CITIZEN)
	
		--if ply:Team() == TEAM_CITIZEN then return end
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Вас всё равно не удалось уволить! Багоюзить это плохо! Применяем радикальные меры!' )
		
		if ply:Alive() then
			ply:StripWeapon("weapon_rpt_surrender")
			ply.WeaponRPT["Surrender"] = false  
			ply:StripWeapons()
			Realistic_Police.SaveLoadInfo(ply)
			Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneSurrender, ply)
		end
		
		ply:SetTeam(TEAM_CITIZEN)
		RunConsoleCommand("ulx", "strip", ply:Nick())
		RunConsoleCommand("ulx", "setjob", ply:Nick(), "Гражданин")
	end
end)


-- Remove printers on certain job changes
function remove_printers( ply, b, job )
	for k, v in ipairs( ents.GetAll() ) do
		if v:GetClass() == 'money_printer2' or v:GetClass() == 'fg_amber_printer' or v:GetClass() == 'fg_sapphire_printer' or v:GetClass() == 'fg_ruby_printer' or v:GetClass() == 'fg_emerald_printer' then
			local printer_owner = v:CPPIGetOwner()
			print(printer_owner)
			print(ply)
			if printer_owner == ply then
				if job == TEAM_CIGAR or job == TEAM_BITCOIN or job == TEAM_POLICE or job == TEAM_DPS or job == TEAM_PPS or job == TEAM_CHIEF or job == TEAM_MAYOR or job == TEAM_MEDIC or job == TEAM_OMON or job == TEAM_FBI or job == TEAM_HOBO then
					ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Ваша новая работа не позваляет вам иметь маники! Все ваши принтера были удалены!' )
					v:Remove()
				end
				if job == TEAM_GUN or job == TEAM_TRADE or job == TEAM_MEH or job == TEAM_SECURITY or job == TEAM_COOK or ply:Team() == TEAM_FISH then
					if v:GetClass() == 'fg_ruby_printer' or v:GetClass() == 'fg_emerald_printer' then
						ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-jobs] ', Color( 255, 255, 255 ), 'Ваша новая работа не позваляет вам иметь продвинутые маники! Если у вас были рубиновые или эмеральдовые принетра, они были удалены!' )
						v:Remove()
					end
				end
			end
		end
	end
end
hook.Add( "OnPlayerChangedTeam", "remove_printers_on_job_changes", remove_printers )