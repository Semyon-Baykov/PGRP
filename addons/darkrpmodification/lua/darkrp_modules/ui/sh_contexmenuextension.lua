C_LANGUAGE_SCREENGRAB 				= "Screengrab"
C_LANGUAGE_AESP 					= "AESP"
C_LANGUAGE_LOGS 					= "Logs"

C_LANGUAGE_MONEY_CHEQUE 			= "Выписать денежный чек"
C_LANGUAGE_MONEY_DROP 				= "Выбросить деньги на землю"
C_LANGUAGE_MONEY_GIVE 				= "Дать денег игроку, на которого вы смотрите"
C_LANGUAGE_DROP 					= "Выбросить текущее оружие"
C_LANGUAGE_REQUEST_LICENSE 			= "Запросить лицензию на оружие"
C_LANGUAGE_WRITE 					= "Написать записку"

C_LANGUAGE_DEMOTE 					= "Голосование на увольнение"
C_LANGUAGE_RPNAME 					= "Изменить своё имя"
C_LANGUAGE_CUSTOM_JOB 				= "Изменить название профессии"
C_LANGUAGE_UNOWN_ALL 				= "Продать все свои двери"


C_LANGUAGE_WANTED 					= "Выдать розыск игроку"
C_LANGUAGE_UNWANTED 				= "Снять розыск игроку"
C_LANGUAGE_WARRANT 					= "Запросить ордер на обыск"
C_LANGUAGE_GIVE_LICENSE 			= "Выдать лицензию на оружие"
C_LANGUAGE_AGENDA 					= "Изменить повестку дня"


C_LANGUAGE_MONEY 					= "Дать денег"
C_LANGUAGE_WARRANT_PROP 			= "Запросить обыск на владельца"


C_LANGUAGE_LOCKDOWN 				= "Включить комендантский час"
C_LANGUAGE_UNLOCKDOWN 				= "Выключить комендантский час"
C_LANGUAGE_LOTTERY 					= "Начать денежную лотерею"
C_LANGUAGE_PLACELAWS 				= "Разместить доску c законами"
C_LANGUAGE_ADDLAW 					= "Добавить новый закон"
C_LANGUAGE_REMOVELAW 				= "Убрать закон"
C_LANGUAGE_BROADCAST 				= "Написать оповещение"

C_LANGUAGE_WRITE_DESCRIPTION 		= "Введите текст записки"
C_LANGUAGE_AGENDA_DESCRIPTION 		= "Введите новоую повестку"
C_LANGUAGE_BROADCAST_DESCRIPTION 	= "Введите текст оповещения"
C_LANGUAGE_REMOVELAW_DESCRIPTION 	= "Введите номер закона"
C_LANGUAGE_ADDLAW_DESCRIPTION 		= "Введите новый закон"
C_LANGUAGE_ENTER_REASON 			= "Введите причину"
C_LANGUAGE_ENTER_AMOUNT 			= "Введите количество"
C_LANGUAGE_CUSTOM_JOB_DESCRIPTION 	= "Введите новое название"
C_LANGUAGE_RPNAME_DESCRIPTION 		= "Введите новое имя"


properties.Add("givemoney", {
	MenuLabel = C_LANGUAGE_MONEY,
	Order = 1,
	MenuIcon = "icon16/money.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ply:GetPos():Distance(ent:GetPos()) < 200
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_MONEY, C_LANGUAGE_ENTER_AMOUNT, nil, function(a)
			if !tonumber(a) then return end
			self:MsgStart()
				net.WriteEntity(ent)
				net.WriteFloat(tonumber(a))
			self:MsgEnd()
		end)
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()
		local amount = math.Round(net.ReadFloat())
		print(amount)

		if !(self:Filter(ent, ply) && amount) then return end

		if not ply:canAfford(amount) then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))

			return ""
		end

		ply:addMoney(-amount)
		ent:addMoney(amount)

		ULogs.AddLog( 13, ULogs.PlayerInfo( ply ) .. " передал "..DarkRP.formatMoney(amount)..' игроку '..ent:Nick()..'('..ent:SteamID()..')',
		ULogs.Register( 13, ply ) )

		DarkRP.notify(ent, 0, 4, DarkRP.getPhrase("has_given", ply:Nick(), DarkRP.formatMoney(amount)))
		DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_gave", ent:Nick(), DarkRP.formatMoney(amount)))
	end
})

properties.Add("demote", {
	MenuLabel = C_LANGUAGE_DEMOTE,
	Order = 2,
	MenuIcon = "icon16/user_delete.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer()
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_DEMOTE, C_LANGUAGE_ENTER_REASON, nil, function(a)
			RunConsoleCommand("darkrp", "demote", ent:UserID(), a)
		end)
	end
})

properties.Add("wanted", {
	MenuLabel = C_LANGUAGE_WANTED,
	Order = 3,
	MenuIcon = "icon16/flag_red.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && !ent:isWanted() && GAMEMODE.CivilProtection[ply:Team()]
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_WANTED, C_LANGUAGE_ENTER_REASON, nil, function(a)
			RunConsoleCommand("darkrp", "wanted", ent:UserID(), a)
		end)
	end
})

properties.Add("unwanted", {
	MenuLabel = C_LANGUAGE_UNWANTED,
	Order = 4,
	MenuIcon = "icon16/flag_green.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ent:isWanted() && ply:isCP()
	end,
	Action = function( self, ent )
		RunConsoleCommand("darkrp", "unwanted", ent:UserID())
	end
})

properties.Add("warrant", {
	MenuLabel = C_LANGUAGE_WARRANT,
	Order = 5,
	MenuIcon = "icon16/door_in.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ply:isCP()
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_WARRANT, C_LANGUAGE_ENTER_REASON, nil, function(a)
			RunConsoleCommand("darkrp", "warrant", ent:UserID(), a)
		end)
	end
})

properties.Add("givelicense", {
	MenuLabel = C_LANGUAGE_GIVE_LICENSE,
	Order = 6,
	MenuIcon = "icon16/page_add.png",

	Filter = function( self, ent, ply )
		local noMayorExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isMayor), player.GetAll}
		local noChiefExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isChief), player.GetAll}

		local canGiveLicense = fn.FOr{
			ply.isMayor, -- Mayors can hand out licenses
			fn.FAnd{ply.isChief, noMayorExists}, -- Chiefs can if there is no mayor
			fn.FAnd{ply.isCP, noChiefExists, noMayorExists} -- CP's can if there are no chiefs nor mayors
		}

		if not canGiveLicense(ply) then
			return false
		end

		return IsValid( ent ) && ent:IsPlayer() && !ent:getDarkRPVar("HasGunlicense")
	end,
	Action = function( self, ent )
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()

		if !(self:Filter(ent, ply)) then return end

		DarkRP.notify(ent, 0, 4, DarkRP.getPhrase("gunlicense_granted", ply:Nick(), ent:Nick()))
		DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("gunlicense_granted", ply:Nick(), ent:Nick()))
		ent:setDarkRPVar("HasGunlicense", true)
	end
})

properties.Add("warrantbyprop", {
	MenuLabel = C_LANGUAGE_WARRANT_PROP,
	Order = 5,
	MenuIcon = "icon16/door_in.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && IsValid(ent:CPPIGetOwner()) && ent:CPPIGetOwner():IsPlayer() && ply:isCP()
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_WARRANT, C_LANGUAGE_ENTER_REASON, nil, function(a)
			RunConsoleCommand("darkrp", "warrant", ent:CPPIGetOwner():UserID(), a)
		end)
	end
})