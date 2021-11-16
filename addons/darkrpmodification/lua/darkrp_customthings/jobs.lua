local ass = {
	['rp_bangclaw'] = {
		pos1 = Vector( 3920.191650, -1135.881958, 319.968750 ),
		pos2 = Vector( 4399.807617, -400.553375, 72.031242 )	
	},

	['rp_downtown_gp_build901'] = {
		pos1 = Vector( -38.657516, 1227.236206, -255.822769 ),
		pos2 = Vector( -2379.783447, 2230.692627, 183.600739 )	
	},
	
	['rp_downtown_v8g_gp'] = {
		pos1 = Vector( -1466.718262, -116.077827, -188.976212 ),
		pos2 = Vector( -2321.186768, 347.162811, 426.091278 )	
	},
	
	['rp_krasnogorsk_pg_v1f'] = {
		pos1 = Vector( -1466.718262, -116.077827, -188.976212 ),
		pos2 = Vector( -2321.186768, 347.162811, 426.091278 )	
	},
}

TEAM_CITIZEN = DarkRP.createJob("Гражданин", {
	color = Color(20, 150, 20, 255),
	model = {
		"models/player/Group01/Female_01.mdl",
		"models/player/Group01/Male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/Male_04.mdl",
		"models/player/Group01/Male_05.mdl",
		"models/player/Group01/Male_06.mdl",
		"models/player/Group01/Male_07.mdl",
		"models/player/Group01/Male_08.mdl",
		"models/player/Group01/Male_09.mdl",
		"models/player/Group02/male_02.mdl",
		"models/player/Group02/male_04.mdl",
		"models/player/Group02/male_06.mdl",
		"models/player/Group02/male_08.mdl"
	},
	description = [[Гражданин  базовый общественный слой, которым вы можете безпрепятственно стать.
	У вас нет предопределенной роли в жизни города.

	В зависимости от того, как вы себя ведёте, полиция может до вас докопаться.
	Остерегайтесь гопников и других криминалов, они могут вас ограбить!
	
	Вы можете придумать себе свою собственную профессию и заниматься вашим делом.]],
	weapons = {"pass_ua"},
	command = "citizen",
	max = 0,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	category = "Граждане"
})

TEAM_POLICE = DarkRP.createJob("Сотрудник Полиции", {
  	color = Color(25, 25, 170, 255),
  	model = {
  "models/player/kerry/policeru_02_patrol.mdl",
  "models/player/kerry/policeru_02.mdl",
  "models/player/kerry/policeru_06.mdl",
  "models/player/kerry/policeru_07.mdl",
  },
  description = [[Вы обычный сотрудник полиции. Патрулируйте город и охраняйте ОМВД. Вы подичняетесь мэру и начальнику.
  У вас есть право арестовать преступника или даже применить летальное оружие.
  
  Что-бы взять доступ к обыску или подать гражданина в розыск, используйте опции в C-menu (зажмите C)
  
  Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
  weapons = { "arrest_stick", "stunstick", "door_ram", "tfa_pm",  "wep_jack_job_drpradio", "pass_mvd", "tfa_ots2", "weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun"},	-- weaponchecker
  command = "cp",
  max = 6,
  salary = 1000,
  admin = 0,
  vote = true,
  hasLicense = true,
  canStartVote = function( ply )

  	for k, v in pairs( ents.FindInBox( ass[game.GetMap()].pos1, ass[game.GetMap()].pos2 ) ) do

		if ply == v then

			return true

		end

	end

	return false

	end,
	canStartVoteReason = 'Вы должны нахоидться в отделе МВД чтобы начать голосование!',
  category = "Правопорядок"
})

TEAM_DPS = DarkRP.createJob("Сотрудник ДПС", {
  	color = Color(0, 178, 255, 255),
  	model = {
  "models/player/wisay/dpsment.mdl",},
  description = [[Вы Сотрудник Дорожно-патрульной Службы, следите за дорожным движением и берите деревянные с нарушителей. Вы подичняетесь мэру и начальнику.
  У вас есть право арестовать преступника или даже применить летальное оружие.
  
  Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
  weapons = { "arrest_stick", "stunstick", "door_ram", "tfa_pm", "wep_jack_job_drpradio", "weapon_palka", "pass_mvd", "tfa_ots2", "weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun"},
  command = "dps",
  max = 2,
  salary = 900,
  admin = 0,
  vote = true,
  hasLicense = true,
  category = "Правопорядок",
  NeedToChangeFrom = {TEAM_POLICE},
})

TEAM_PPS = DarkRP.createJob("Сотрудник ППС", {
	color = Color(0, 140, 255, 255),
	model = { "models/player/kerry/policeru_06_patrol.mdl",
			"models/player/kerry/policeru_07_patrol.mdl",
			"models/player/kerry/policeru_03_patrol.mdl",
			"models/player/kerry/policeru_04_patrol.mdl",
			},
	description = [[
	 Вы имеете более сильное оружие для борьбы с преступностью в отличии от обычного сотрудника полиции. Патрулируйте город и штурмуйте здания. Вы подичняетесь мэру и начальнику.
	 У вас есть право арестовать преступника или даже применить летальное оружие.
	 
	 Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
	weapons = { "arrest_stick", "stunstick", "door_ram", "tfa_pm",  "tfa_aks74u", "wep_jack_job_drpradio", "pass_mvd", "weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun"},
	command = "pps",
	max = 2,
	salary = 1250,
	admin = 0,
	vip = 0,
	vote = true,
	hasLicense = true,
	--customCheck = function(ply) return ply:gp_VipAccess() end,
 	category = "Правопорядок",
 	NeedToChangeFrom = {TEAM_POLICE},
	PlayerSpawn = function(ply)
        ply:SetArmor(100)
    end
})

TEAM_CHIEF = DarkRP.createJob("Начальник Полиции", {
  color = Color(20, 20, 255, 255),
  model = {
  "models/player/kerry/policeru_01.mdl",
  "models/player/kerry/policeru_02.mdl",
  "models/player/kerry/policeru_03.mdl",
  "models/player/kerry/policeru_05.mdl",
  "models/player/kerry/policeru_06.mdl",
  "models/player/kerry/policeru_07.mdl",
  },
  description = [[Начальник Полиции является главным среди полицейских, только мэр может вам приказывать. Координируйте действия сотрудников Полиции, наводя порядок в городе.
  У вас есть право арестовать преступника или даже применить летальное оружие.
	 
	Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
  weapons = { "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "tfa_pm", "wep_jack_job_drpradio", "pass_mvd", "tfa_vityaz19", "weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun"},
  command = "chief",
  max = 1,
  salary = 2000,
  admin = 0,
  vote = false,
  hasLicense = true,
  chief = true,
  NeedToChangeFrom = {TEAM_POLICE},
  category = "Правопорядок"
})

TEAM_MAYOR = DarkRP.createJob("Мэр", {
	color = Color(150, 20, 20, 255),
	model = "models/player/breen.mdl",
	description = [[Мэр города создает законы, чтобы улучшить жизнь людей в городе, а также управляет работой Полиции и информирует РГ.
	Если вы мэр, то вы можете создавать или принимать ордера на обыск игроков.
	Во время Комендантского часа все люди должны быть в своих домах, а полицейские должны патрулировать город.
	
	Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
	weapons = {"pass_ua","wep_jack_job_drpradio"},
	command = "mayor",
	max = 1,
	salary = 2500,
	admin = 0,
	vote = true,
	hasLicense = true,
	mayor = true,
	category = "Правопорядок",
	PlayerDeath = function(ply, weapon, killer)

   		if ply:Team() == TEAM_MAYOR then

    		ply:changeTeam( GAMEMODE.DefaultTeam, true )

    		SetGlobalEntity( 'SESMayor', nil )

	    	for k,v in pairs( player.GetAll() ) do

	    		v:PrintMessage( HUD_PRINTCENTER, "Мэр был убит!" )

	    	end

    	end

    end
})

TEAM_GANG = DarkRP.createJob("Гопник", {
	color = Color(75, 75, 75, 255),
	model = {
		"models/player/kerry/gopnik_01.mdl",
		"models/player/kerry/gopnik_02.mdl",
		"models/player/kerry/gopnik_03.mdl",
		"models/player/kerry/gopnik_04.mdl",
		"models/player/kerry/gopnik_05.mdl",
		"models/player/kerry/gopnik_06.mdl",
		"models/player/kerry/gopnik_07.mdl"
	},
	description = [[Низшая каста в криминальном мире.
	А.У.Е. Жизнь ворам, хуй мусорам. Ходу ВОРОВСКОМУ, смерти мусорскому. Часик в радость, чифир в сладость. Вы занимаетесь преступной деятельностью.
	
	Знайте, полицейские и росгвардейцы могут накатить на вас бочку, посадить в тюрягу, или даже убить.
	У вас есть возможность ставить все виды маников, но будьте острожны!
	
	Лучше всего скооперироваться в банде!]],
	weapons = {"pass_ua"},
	command = "gangster",
	max = 15,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	category = "Криминал"
})

TEAM_NARK = DarkRP.createJob("Наркобарон", {
color = Color(100, 200, 0, 255),
model = {"models/player/soldier_stripped.mdl"},
description = [[Постройте нарколабораторию и наймите охрану, скупщик мета находится на рынке.]],
weapons = { "selfportrait_camera"},
command = "makaveli",
max = 3,
salary = GAMEMODE.Config.normalsalary,
admin = 0,
vote = false,
category = "Криминал"
})

TEAM_MOB = DarkRP.createJob("Глава банды", {
	color = Color(25, 25, 25, 255),
	model = "models/player/kerry/boss.mdl",
	description = [[Глава банды является самым авторитетным преступником в городе.
	Он даёт задания своим подчинённым бандитам или работает в одиночку.
	Он обладает способностью взламывать квартиры и выпускать из тюрем людей.]],
	weapons = { "lockpick_prem", "unarrest_stick","pass_ua"},
	command = "mobboss",
	max = 1,
	salary = GAMEMODE.Config.normalsalary * 1.34,
	admin = 0,
	vote = false,
	category = "Криминал"
})

TEAM_GUN = DarkRP.createJob("Продавец оружия", {
	color = Color(255, 140, 0, 255),
	model = {
		"models/player/monk.mdl",
		"models/player/alyx.mdl"
	},
	description = [[Продавец оружия является единственным человеком, который может продавать легальное оружие другим людям.
	Удостовертесь в том, что вы продаете оружие с лицензией, иначе вас могут арестовать!]],
	weapons = {"pass_ua"},
	command = "gundealer",
	max = 3,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	category = "Бизнес"
})

TEAM_TRADE = DarkRP.createJob("Торговец", {
	color = Color(0, 64, 32, 255),
	model = "models/player/mossman.mdl",
	description = [[Продавайте различные полезные приспособления (отмычки, вейпы и др.).
	Перекупайте вещи, оружие. Откройте магазин и начните продажу товаров.]],
	weapons = {"pass_ua"},
	command = "trader",
	max = 3,
	salary = GAMEMODE.Config.normalsalary * 1.11,
	admin = 0,
	vote = false,
	category = "Бизнес"
})

TEAM_MEH = DarkRP.createJob("Автомастер", {
	color = Color(159, 151, 1, 255),
	model = "models/player/hostage/hostage_02.mdl",
	description = [[Ремонтируйте и заправляйте автомобили.]],
	weapons = {"pass_ua", "weapon_gpwrench"},
	command = "meh",
	max = 3,
	salary = GAMEMODE.Config.normalsalary * 1.11,
	admin = 0,
	vote = false,
	category = "Бизнес"
})

TEAM_SECURITY = DarkRP.createJob("Охранник", {
	color = Color(0, 140, 255, 255),
	model = "models/player/odessa.mdl",
	description = [[Нанимайтесь в охрану магазинов и предприятий.
	Вы должны защищать заведение от хулиганов и мелких воров.
	При сложной ситуации вызывайте полицию.
	По умолчанию вам даётся только дубинка, так что особо не рискуйте, действуйте осторожно.]],
	weapons = { "stunstick","pass_ua"},
	command = "security",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	category = "Бизнес"
})

TEAM_MEDIC = DarkRP.createJob("Сотрудник МЧС", {
	color = Color(47, 79, 79, 255),
	model = {
	-- Мужики и девочки
		"models/player/kerry/russian_mes.mdl",
		"models/player/kerry/russian_mes2.mdl",
		"models/player/kerry/russian_mes3.mdl",
		"models/player/kerry/russian_mes4.mdl",
		"models/player/kerry/russian_mes5.mdl",
		"models/player/kerry/russian_mes6.mdl",
		"models/player/kerry/russian_mes7.mdl"
	},
	description = [[Вы сотрудник Министерства Черезвычайных Ситуация. Ваша задача лечить граждан в офисе МЧС и тушить пожары.]],
	weapons = {"pass_ua","fire_axe","fire_extinguisher"},
	command = "medic",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	medic = true,
	 canStartVote = function( ply )

  	for k, v in pairs( ents.FindInBox( Vector( 822.802063, -4530.663574, 181.031250 ), Vector( 2269.094727, -5603.699219, -152.416473) ) ) do

		if ply == v then

			return true

		end

	end

	return false

	end,
	canStartVoteReason = 'Вы должны нахоидться в отделе МВД чтобы начать голосование!',
	category = "Городские службы"
})

TEAM_HOBO = DarkRP.createJob("Бездомный", {
	color = Color(80, 45, 0, 255),
	model = "models/jessev92/kuma/characters/saddam_ply.mdl",
	description = [[Вы безработный, у вас нет дома.
	Вы вынуждены просить еду и деньги.
	Постройте дом из дощечек и мусора, чтобы укрыться от холода и мусоров во время комендатского часа.
	Вы можете поставить ведро и написать на нём просьбу, чтобы вам подавали денег.
	Проявите фантазию, устройте цирковое представление, спойте. Таким образом вы можете получить больше денег.]],
	weapons = { "weapon_bugbait"},
	command = "hobo",
	max = 0,
	salary = 0,
	admin = 0,
	vote = false,
	candemote = true,
	hobo = true,
	category = "Граждане"
})

TEAM_MERC = DarkRP.createJob("Наемный убийца", {
	color = Color(128, 64, 64, 255),
	model = {
		"models/player/mossman_arctic.mdl",
		"models/player/leet.mdl",
	},
	description = [[Наемный убийца выполняет различные заказы за определенную плату.
	Заказы могут быть какими угодно: убийство, кража, разведка и любые другие.
	Покупать услуги наемника могут как бандиты, так и полиция и другие граждане.
	Но любой заказ должен иметь адекватную причину, спрашивайте её перед заказом.]],
	weapons = {"pass_ua"},
	command = "merc",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	category = "Криминал"
})

TEAM_COOK = DarkRP.createJob("Повар", {
    color = Color(238, 99, 99, 255),
	model = {"models/fearless/chef1.mdl","models/fearless/chef2.mdl"},
    description = [[Повар - это большая ответственность, нужно накормить всех людей вашего города.
    Вы можете купить печку и готовить хлеб. Вам предстоит открыть свой ресторан или кафе и принимать клиентов.
    Также наймите обязательно охрану от особо буйных посетителей.]],
    weapons = {"pass_ua"},
    command = "cook",
    max = 4,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    cook = true,
category = "Бизнес"
})

TEAM_FISH = DarkRP.createJob("Рыбак", {
    color = Color(255, 196, 0, 255),
	model = "models/player/zelpa/fisherman.mdl",
    description = [[Рыбак ловит рыбу на озере и продаёт её НПС.
	Пройдите к небольшому причалу что-бы получить удочку или ловушки. Там вы сможете понять что вам можно поймать и каким образом.
	
	Ваша работа полностью легальна, но некоторые менты могут к вам докопаться что вы рыбачите без лицензии!]],
    weapons = {"pass_ua"},
    command = "fisherman",
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
	category = "Граждане"
})
--------------------------------------------------------------------------------------------------------------------------------------
TEAM_ADMIN = DarkRP.createJob("Администратор", {
   color = Color(219, 0, 0, 255),
   model = {"models/player/gman_high.mdl"},
   description = [[Давайте по шапке всем нарушителям.]],
   weapons = {'weapon_keypadchecker', "unarrest_stick", "med_kit"},
   command = "admin",
   max = 0,
   salary = 0,
   admin = 0,
   vote = false,
   hasLicense = false,
   candemote = false,
	customCheck = function(ply) return ply:gp_IsAdmin() end,
	category = "Администрация"
})

TEAM_OMON = DarkRP.createJob("Сотрудник ОМОН", {
    color = Color(0, 80, 225, 255),
  model = {'models/player/kerry/policeru_01_omon.mdl','models/player/kerry/policeru_02_omon.mdl','models/player/kerry/policeru_03_omon.mdl','models/player/kerry/policeru_04_omon.mdl', 'models/player/kerry/policeru_05_omon.mdl', 'models/player/kerry/policeru_06_omon.mdl', 'models/player/kerry/policeru_07_omon.mdl'},
    description = [[Вы Сотрудник Отряда мобильного особого назначения. Разгоняйте митинги Подвального и помогаете в штурмах полиции, когда она не справляется. 
    Вам желательно работать только с полицией, потому что, вы сильные, но не в силах заполнять рапорт и проводить обыск один. 
	
    Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
    weapons = {'weapon_flashgrenade','weapon_gas','wep_jack_job_drpradio','stunstick','door_ram','tfa_pl14','tfa_vss','tfa_val','riot_shield', "pass_mvd", "weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun"},
    command = "omon",
    max = 4,
    salary = 1250,
    admin = 0,
    vip = 1,
    vote = false,
	hasLicense = true,
  	customCheck = function( ply ) return ply:IsSecondaryUserGroup "premium" end,
  CustomCheckFailMsg = "Вы должны быть Premium! | После покупки, введите !premium в чат",
  category = "Premium работы",
  PlayerSpawn = function(ply)
        ply:SetArmor(100)
    end
})

TEAM_JESUS = DarkRP.createJob('есус', {
	color = Color(245,183,255),
	model = 'models/player/jesus/jesus.mdl',
	description = [[ Рассказывай охуительные истории бабкам в церкви о том как ты получал из воды винишко, бегая после этого от активистов "Лев Против" и мусоров. 
	А также отпускай грехи бомжам, которые наблевали в церкви, когда перепили боярышника. ]],
	weapons = {'weapon_hl2pipe'},
	command = 'jesus',
	max = 1,
	salary = 0,
	admin = 0,
	vote = false,
	vip = 1,
	hasLicense = false,
	customCheck = function( ply ) return ply:IsSecondaryUserGroup "premium" end,
	CustomCheckFailMsg = 'Вы должны быть Premium! (После покупки, введите !premium в чат!)',
	category = "Premium работы"
})

TEAM_CHECEN = DarkRP.createJob("Чеченец", {
    color = Color(105, 213, 120, 255),
	model = {"models/jessev92/kuma/characters/osama_ply.mdl"},
    description = [[ Вы уроженец Чеченской Республики, выполняйте намаз, поясняйте за крутость Чечни. И ищите Мэддисона и Вольнова (кто не понял, тот поймет).]],
    weapons = {'weapon_jihadbomb',"weapon_slovarb"},
    command = "chechen",
    max = 1,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
		vip = 1,
		customCheck = function( ply ) return ply:IsSecondaryUserGroup "premium" end,
		CustomCheckFailMsg = "Вы должны быть Premium! | После покупки, введите !premium в чат",
		category = "Premium работы"

	--category = "Бизнес"
})

TEAM_FBI = DarkRP.createJob("Сотрудник ФСБ", {
  color = Color(84, 0, 255, 255),
  model = {
    "models/player/kerry/fsb_01.mdl",
    "models/player/kerry/fsb_02.mdl",
    "models/player/kerry/fsb_03.mdl",
    "models/player/kerry/fsb_04.mdl",
    "models/player/kerry/fsb_05.mdl",
    "models/player/kerry/fsb_06.mdl",
  },
  description = [[
  Вы агент Федеральной службы безопасности, ваша задача обеспечивать борьбу с коррупцией, экстремизмом, терроризмом и бандформированиями.
  У вас есть полномочия следить за гражданами в целях общественной безопасности и раскрытия преступлений, а также проводить спецальные операции при поддержке дополнительных полицейских структур.
  
  Для более эффективной работы правоохрнаительных органов используйте рацию (C для настройки, B для использования).]],
  weapons = {"arrest_stick","unarrest_stick","stunstick","door_ram","tfa_pl14","weapon_flashgrenade","wep_jack_job_drpradio","pass_fsb", "tfa_ak74m", "weapon_rpt_finebook", "weapon_rpt_handcuff", "weapon_rpt_stungun"},
  command = "fsb",
  max = 1,
  salary = 1250,
  admin = 0,
  vip = 1,
  vote = false,
  hasLicense = true,
  customCheck = function( ply ) return ply:IsSecondaryUserGroup "premium" end,
  CustomCheckFailMsg = "Вы должны быть Premium! | После покупки, введите !premium в чат",
  category = "Premium работы",
  PlayerSpawn = function(ply)
      ply:SetArmor(100)
  end	
})

TEAM_PARK = DarkRP.createJob("Руфер", {
	color = Color(237, 233, 5, 255),
	model = "models/player/p2_chell.mdl",
	description = [[
	Ты руфер. И пока молодой нужно залезть на каждую крышу, доебаться до каждого бомжа и побегать от мусоров.
	Ваше развлечение всегда могут похерить люди в погонах, так что будьте аккуратны.
	
	Хорошая работа для посика пасхалок)))]],
	weapons = {"climb_swep2","pass_ua"},
	command = "park",
	max = 0,
	salary = 25,
	admin = 0,
	vip = 1,
	vote = false,
	hasLicense = false,
	customCheck = function( ply ) return ply:IsSecondaryUserGroup "premium" end,
	CustomCheckFailMsg = "Вы должны быть Premium! | После покупки, введите !premium в чат",
	category = "Premium работы"
})

TEAM_GANGVIP = DarkRP.createJob("Гангстер", {
	color = Color(75, 75, 75, 255),
	model = {
	"models/player/arctic.mdl",
	"models/player/phoenix.mdl",
	},
	description = [[
	Вы круче бандитов.
	Убиваете, воруйте и вымогайте деньги.
	Вы имеете отмычку для взлома укрепленных баз.]],
	weapons = {"lockpick_prem","pass_ua"},
	command = "gangstervip",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vip = 1,
	vote = false,
	customCheck = function( ply ) return ply:IsSecondaryUserGroup "premium" end,
	CustomCheckFailMsg = "Вы должны быть Premium! | После покупки, введите !premium в чат",
	category = "Premium работы"
})

/*
TEAM_IZNAS = DarkRP.createJob("Маньяк", {
	color = Color(255, 20, 147, 255),
	model = {
		"models/player/sgg/jason_v.mdl"
	},
	description = [[
	Вы профессиональный дровосек, а по совместительству эксперт в области расчленения людей.
	Брошенный дом, эй
	Всеми заброшенный дом, эй
	...
	Эта штука со мной, я зову ее бензопилой
	И она делает боль.]],
	weapons = {"pass_ua","weapon_chainsaw_new"},
	command = "nasilovat",
	max = 1,
	vip = 1,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	customCheck = function(ply) return ply:gp_VipAccess() end,
	category = "Premium работы"
})
*/

TEAM_NRG1 = DarkRP.createJob("Сотрудник росгвардии", {
    color = Color(60, 120, 70, 255),
    model = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
    description = [[ ]],
    weapons = {"pass_guard", "weaponchecker"},
    command = "nrg1",
    max = 0,
    salary = 80,
    admin = 0,
    vote = false,
		rosg = true,
  category = "Бизнес"
})
TEAM_NRG2 = DarkRP.createJob("Офицер росгвардии", {
    color = Color(60, 120, 70, 255),
    model = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
    description = [[ ]],
    weapons = {"pass_guard","weaponchecker"},
    command = "nrg2",
    max = 0,
    salary = 1750,
    admin = 0,
    vote = false,
		rosg = true,
  category = "Бизнес"
})
TEAM_NRG3 = DarkRP.createJob("Старший офицер росгвардии", {
    color = Color(60, 120, 70, 255),
    model =  {"models/player/kerry/general.mdl"},
    description = [[ ]],
    weapons = {"pass_guard","weaponchecker"},
    command = "nrg3",
    max = 0,
    salary = 5000,
    admin = 0,
    vote = false,
		rosg = true,
  category = "Бизнес"
})
TEAM_NRG4 = DarkRP.createJob("Маршал росгвардии", {
    color = Color(60, 120, 70, 255),
    model =  {"models/player/gesource_ourumov.mdl"},
    description = [[ ]],
    weapons = {"pass_guard","weaponchecker"},
    command = "nrg4",
    max = 0,
    salary = 10000,
    admin = 0,
    vote = false,
		rosg = true,
  category = "Бизнес"
})

/*
TEAM_FISH = DarkRP.createJob("Рыбак", {
	color = Color(140, 56, 255),
	model = "models/player/eli.mdl",
	description = [[Вы - рыбак, у вас есть удочка..]],
	weapons = {"pass_ua", "weapon_fishing_rod"},
	command = "fishman",
	max = 4,
	salary = GAMEMODE.Config.normalsalary * 1.11,
	admin = 0,
	vote = false,
	category = "Бизнес"
})
*/

TEAM_BITCOIN = DarkRP.createJob("Биткойн Майнер", {
	color = Color(182, 182, 182, 255),
	model = "models/player/kleiner.mdl",
	description = [[Вы - биткойн майнер. Ваша цель намайнить как можно больше биткойнов с помощью предметов которые будут вам доступны в F4-menu. 
	Для начала можно купить обычный генератор что-бы добывать електричество и полку битмайнера. 
	Ваш бизнес медленно окупается, но когда у вас появится достаточное количство майнеров - вы богаты!
	
	Ваш бизнес нелегален и менты надают вам по шапке если найдут!]],
	weapons = {"pass_ua", "ch_bitminers_tablet", "ch_bitminers_repair_wrench"},
	command = "bitminer",
	max = 5,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = true,
	CustomCheckFailMsg = "Данная работа будет доступна в 3:30 по МСК!",
	category = "Нелегальный Бизнес"
})

TEAM_CIGAR = DarkRP.createJob("Фарцовщик сигарет", {
	color = Color(95, 127, 63, 255),
	model = "models/player/witness.mdl",
	description = [[
	Вы изготавливаете сигареты чтобы заработать на раке лёгких с помощью предметов из F4-menu.
	Ваш бизнес прост - вы просто сидите и заправляете автомат табаком и бумагой и ждёте прибыль.
	Сигареты можно продать в миниван на рынке!
	
	Ваш бизнес нелегален и менты надают вам по шапке если найдут!
	]],
	weapons = {"pass_ua"},
	command = "cigarmaker",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = true,
	category = "Нелегальный Бизнес"
})

TEAM_EVENT = DarkRP.createJob("Ивентор", {
	color = Color(219, 0, 0, 255),
	model = "models/player/combine_super_soldier.mdl",
	description = [[Создавайте ивенты игрокам и выдавайте за них призы!]],
	weapons = {'med_kit', 'weapon_vape_medicinal'},
	command = "eventor",
	max = 0,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = true,
	customCheck = function(ply) return ply:gp_IsAdmin() end,
	category = "Администрация"
})

TEAM_CITYWORKER = DarkRP.createJob("Работник ЖКХ", {
	color = Color(63, 79, 127, 255),
	model = {"models/player/group03/male_09.mdl", "models/player/group03/male_08.mdl", "models/player/group03/male_07.mdl", "models/player/group03/male_06.mdl", "models/player/group03/male_03.mdl", "models/player/group03/male_04.mdl"},
	description = [[
	По городу произошли происшествия:
	- Трубы потекли
	- Сломалась проводка
	- Случились обвалы
	
	Ваша задача ходить по городу и чинить эти неполадки! За работу вам не скромненько платят!
	]],
	weapons = {'pass_ua', "cityworker_pliers", "cityworker_shovel", "cityworker_wrench"},
	command = "jkh",
	max = 6,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = true,
	category = "Граждане"
})

TEAM_KINOLOG = DarkRP.createJob("Кинолог", {
	color = Color(63, 79, 127, 255),
	model = {"models/gai_5.mdl"},
	description = [[
	НАПИСАТЬ DESCRIPTION!!!
	]],
	weapons = {'pass_ua'},
	command = "kinolog",
	max = 1,
	salary = 500,
	admin = 0,
	vote = true,
	hasLicense = true,
	candemote = true,
	category = "Правопорядок",
	canStartVote = function( ply )
		for k, v in ipairs( ents.FindByClass("player") ) do
			if v:Team() == TEAM_KINOLOGDOG then 
				return true
			end
		end
		return false
	  end,
	  canStartVoteReason = 'На сервере должна быть собака!'
})

TEAM_KINOLOGDOG = DarkRP.createJob("Собака Кинолога", {
	color = Color(63, 79, 127, 255),
	model = {"models/jwk987/animal/riley.mdl"},
	description = [[
	НАПИСАТЬ DESCRIPTION!!!
	]],
	weapons = {},
	command = "kinologdog",
	max = 1,
	salary = 0,
	admin = 0,
	vote = true,
	hasLicense = false,
	candemote = true,
	category = "Правопорядок",
	canStartVote = function( ply )
		for k, v in pairs( ents.FindInBox( ass[game.GetMap()].pos1, ass[game.GetMap()].pos2 ) ) do
		  if ply == v then
			  return true
		  end
	  	end
	  	return false
	end,
	canStartVoteReason = 'Вы должны нахоидться в отделе МВД чтобы начать голосование!'
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN


--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
	[TEAM_POLICE] = true,
	[TEAM_FBI] = true,
	[TEAM_CHIEF] = true,
	[TEAM_MAYOR] = true,
	[TEAM_PPS] = true,
	[TEAM_OMON] = true,
	[TEAM_DPS] = true
}



--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MERC)
