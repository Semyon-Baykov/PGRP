module( 'gp_wep', package.seeall )
hook.Add( 'loadCustomDarkRPItems', 'nrgars_load', function()
 tbl = {
	
	['Комплект стрелка'] = {
        id = 1,
        desc = 'Бронежилет, АК-12, ПМ, дубинка, и светошумовая граната.',
        wpns = {'tfa_ak12','tfa_pm','stunstick', 'weapon_flashgrenade'},
        armor = 100
    },
	
	['Комплект пулеметчика'] = {
        id = 2,
        desc = 'Бронежилет, ПКМ, ПП-Кипарис, и дубинка',
        wpns = {'tfa_pkm', 'tfa_ots2', 'stunstick'},
        armor = 100
    },
	
	['Комплект медика'] = {
        id = 3,
        desc = 'Бронежилет, АК74М, ПМ, аптечка',
        wpns = {'tfa_ak74m', 'tfa_pm', 'weapon_medkit'},
        armor = 50 
    },
	
	['Комплект механика-водителя'] = {
        id = 4,
        desc = 'Бронежилет, АКС74У, ПМ, дубинка, гаечный ключ и канистра с топливом',
        wpns = {'tfa_aks74u','tfa_pm','stunstick','weapon_gpwrench','weapon_gpgascan'},
        armor = 50
    },

	['Комплект спецназа №1'] = {
		id = 5,
        desc = 'Бронежилет, АКМС, ПЛ-14, дубинка, щит, светошумовая и осколочная граната',
        wpns = {'tfa_akms', 'tfa_pl14', 'stunstick', 'riot_shield', 'weapon_flashgrenade', 'weapon_fraggrenade'},
        armor = 100
	},
	
	['Комплект спецназа №2'] = {
        id = 6,
        desc = 'Бронежилет, АЕК-971, ПЛ-14, дубинка, щит, газовая и осколочная граната',
        wpns = {'tfa_aek971', 'tfa_pl14', 'stunstick', 'riot_shield', 'weapon_gas', 'weapon_fraggrenade'},
        armor = 100
    },
	
	['Комплект спецназа-снайпера'] = {
        id = 7,
        desc = 'Бронежилет, СВУ, ПЛ-14, бинокль, дубинка, светошумовая и осколочная граната.\nПолный набор для ареста: шокер, наручники, арест-дубинка.',
        wpns = {'tfa_svu', 'tfa_pl14', 'weapon_rpw_binoculars', 'stunstick', 'weapon_flashgrenade', 'weapon_fraggrenade', 'weapon_rpt_stungun', 'weapon_rpt_handcuff', 'arrest_stick'},
        armor = 100
    },
	
	['Комплект комендата'] = {
        id = 8,
        desc = 'Бронежилет, СР-3 «Вихрь», ПМ, дубинка, и щит.\nПолный набор для ареста: шокер, наручники, арест-дубинка.',
        wpns = {'tfa_vikhr','tfa_pm', 'stunstick', 'riot_shield', 'weapon_rpt_stungun', 'weapon_rpt_handcuff', 'arrest_stick'},
        armor = 100
    },
	
	['Комплект парадный'] = {
        id = 9,
        desc = 'Бронежилет, винтовка Мосина, СКС, ППШ-41 и дубинка',
        wpns = {'tfa_mosin9130','tfa_sks','tfa_ppsh41','stunstick'},
        armor = 50
    },
	
	-- Letov
	['Комплект Маршала'] = {
		id = 10,
        desc = 'Для обученя сотрудников любого ранга и уровня обучения, Маршалу нужен набор в котором есть все вспомога-\nтельные и огнестрельные оружия. Данный набор используется только в административном аспекте - в бою он не используется.',
        wpns = {'stunstick', 'arrest_stick', 'unarrest_stick', 'weapon_rpt_handcuff', 'weapon_rpt_stungun',		'weapon_flashgrenade', 'weapon_fraggrenade', 'weapon_gas',		'weapon_medkit', 'weapon_gpwrench', 'weapon_gpgascan', 'weapon_rpw_binoculars', 'riot_shield',		'tfa_val', 'tfa_svu', 'tfa_pl14'},
        armor = 100,
		access = 20
	}
 }
end)

--[[
module( 'gp_wep', package.seeall )
hook.Add( 'loadCustomDarkRPItems', 'nrgars_load', function()
 tbl = {
	-- Normal
	['Комплект спецназа №1'] = {
		id = 1,
        desc = 'Бронежилет, ',
        wpns = {'weapon_fists'},
        armor = 50,
		access = 100
	},
	
	['Комплект рядового'] = {
        id = 2,
        desc = 'В комплект входит: бронежилет, дубинка, АКС74, ПМ',
        wpns = {'tfa_aks74','tfa_pm','stunstick'},
        armor = 50
    },
	
	['Комплект медика'] = {
        id = 3,
        desc = 'В комплект входит: бронежилет, АК74М, ПМ, аптечка',
        wpns = {'tfa_ak74m','tfa_pm','weapon_medkit'},
        armor = 50 
    },
	
	['Комплект стрелка'] = {
        id = 4,
        desc = 'В комплект входит: бронежилет, дубинка, РПК74, ПМ',
        wpns = {'tfa_rpk','tfa_pm','stunstick'},
        armor = 75
    },
	
	['Комплект комендата'] = {
        id = 5,
        desc = 'В комплект входит: бронежилет, дубинка, щит, СР-3 «Вихрь» и ПМ.\nВ комлект также входят наручники, шокер, и арест-дубинка.',
        wpns = {'tfa_vikhr','tfa_pm','stunstick','riot_shield','arrest_stick','weapon_rpt_handcuff','weapon_rpt_stungun'},
        armor = 50
    },
	
	['Комплект механика-водителя'] = {
        id = 6,
        desc = 'В комплект входит: бронежилет, дубинка, гаечный ключ, канистра с топливом, \nАКС74У и ПМ.',
        wpns = {'tfa_aks74u','tfa_pm','stunstick','weapon_gpwrench','weapon_gpgascan'},
        armor = 50
    },
	
	['Комплект общественного порядка'] = {
        id = 7,
        desc = 'В комплект входит: бронежилет, дубинка, щит, газовая и\n световая граната.',
        wpns = {'weapon_flashgrenade','weapon_gas','stunstick','riot_shield'},
        armor = 100
    },
	
	 ['Комплект парадный'] = {
        id = 8,
        desc = 'В комплект входит: бронежилет, дубинка, Винтовка Мосина, СКС и ППШ-41.',
        wpns = {'tfa_mosin9130','tfa_sks','tfa_ppsh41','stunstick'},
        armor = 50
    },
	
	['Комплект снайпера'] = {
        id = 10,
        desc = 'В комплект входит: бронежилет, дубинка, СВД, ПМ, и бинокль.',
        wpns = {'tfa_dragunov','tfa_pm','stunstick','weapon_rpw_binoculars'},
        armor = 50
    },
	
	-- Premium
	['-<<- Premium Наборы ->>-'] = {
		id = 11,
        desc = ' ',
        wpns = {'weapon_fists'},
        armor = 0,
		access = 100
	},
	
	['[Premium] Комплект спецназа №1'] = {
        id = 12,
        desc = 'В комплект входит: бронежилет, дубинка, АКМС, ПЛ-14, и светошумовая граната,\n осколочная граната, и щит.',
        wpns = {'stunstick','riot_shield', 'weapon_flashgrenade', 'tfa_akms', 'tfa_pl14', 'weapon_fraggrenade'},
        armor = 100
    },
	
	['[Premium] Комплект спецназа №2'] = {
        id = 13,
        desc = 'В комплект входит: бронежилет, дубинка, АЕК-971, ПЛ-14, и светошумовая граната,\n осколочная граната, и щит.',
        wpns = {'stunstick','riot_shield', 'weapon_flashgrenade', 'tfa_aek971', 'tfa_pl14', 'weapon_fraggrenade'},
        armor = 100
    },
	
	['[Premium] Комплект стрелка - усиленный'] = {
        id = 14,
        desc = 'В комплект входит: бронежилет, дубинка светошумовая граната, АК-12, и ПМ',
        wpns = {'stunstick', 'tfa_pm', 'weapon_flashgrenade', 'tfa_ak12'},
        armor = 100
    },
	
	['[Premium] Комплект пулеметчика'] = {
        id = 15,
        desc = 'В комплект входит: бронежилет, дубинка, ПКМ, и ПМ',
        wpns = {'stunstick', 'tfa_pm', 'tfa_pkm'},
        armor = 100
    },
	
	['[Premium] Комплект спецназа снайпера'] = {
        id = 16,
        desc = 'В комплект входит: бронежилет, дубинка, СВУ, ПЛ-14,\nи бинокль. В комлект также входят наручники, шокер, и арест-дубинка.',
        wpns = {'stunstick', 'arrest_stick', 'tfa_svu', 'tfa_pl14', 'weapon_rpw_binoculars','weapon_rpt_handcuff','weapon_rpt_stungun'},
        armor = 100
    },
 }
end)
--]]