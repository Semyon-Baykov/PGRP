module( 'gp_wep', package.seeall )
hook.Add( 'loadCustomDarkRPItems', 'nrgars_load', function()
 tbl = {
	-- Normal
	['-<<- Наборы ->>-'] = {
		id = 1,
        desc = ' ',
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
 --[[
hook.Add( 'loadCustomDarkRPItems', 'nrgars_load', function()
 tbl = {
	['Комплект командирский'] = {
        id = 1,
        desc = 'В комплект входит: бронежилет, дубинка, бинокль, ПП-19 «Бизон» и ПМ.',
        wpns = {'tfa_bizonp19','stunstick','tfa_pm','weapon_rpw_binoculars'},
        armor = 50,
        access = 5
    },
    ['Комплект химслужбы'] = {
        id = 2,
        desc = 'В комплект входит: бронежилет, дубинка, газовая граната, ОЦ-02 «Кипарис» и ПМ.',
        wpns = {'tfa_pm','tfa_ots2','stunstick','weapon_gas'},
        armor = 50,
        access = 5
    },
    ['Комплект комендата'] = {
        id = 3,
        desc = 'В комплект входит: бронежилет, дубинка, щит, палка ареста, СР-3 «Вихрь» и ПМ.',
        wpns = {'tfa_vikhr','tfa_pm','stunstick','weapon_sexshield','arrest_stick'},
        armor = 50,
        access = 5
    },
    ['Комплект комендатуры'] = {
        id = 3,
        desc = 'В комплект входит: бронежилет, дубинка, щит, АКС74 без приклада и ПМ.',
        wpns = {'tfa_aks74y','tfa_pm','stunstick','weapon_sexshield'},
        armor = 50,
        access = 5
    },
    ['[Premium] Комплект фельдшера усиленный'] = {
        id = 4,
        desc = 'В комплект входит: бронежилет, аптечка, АКС74 без приклада и ПМ.',
        wpns = {'tfa_aks74y','tfa_pm','weapon_medkit'},
        armor = 50,
        access = 0,
        vip = true
    },
    ['Комплект фельдшера'] = {
        id = 5,
        desc = 'В комплект входит: бронежилет, аптечка и ПМ.',
        wpns = {'tfa_pm','weapon_medkit'},
        armor = 50,
        access = 0,
    },
    ['[Premium] Комплект снайпера спецназа №2'] = {
        id = 6,
        desc = 'В комплект входит: улучшенный бронежилет, дубинка, бинокль, ВСС «Винторез» и ПЛ-14.',
        wpns = {'tfa_vss','tfa_pl14','stunstick','weapon_rpw_binoculars'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект снайпера спецназа №1'] = {
        id = 7,
        desc = 'В комплект входит: улучшенный бронежилет, дубинка, бинокль, СВУ и ПЛ-14.',
        wpns = {'tfa_svu','tfa_pl14','stunstick','weapon_rpw_binoculars'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект спецназа №2'] = {
        id = 8,
        desc = 'В комплект входит: бронежилет, дубинка, АЕК-971 и ПЛ-14.',
        wpns = {'tfa_aek971','tfa_pl14','stunstick','weapon_flashgrenade'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект спецназа №1'] = {
        id = 9,
        desc = 'В комплект входит: бронежилет, дубинка, АС «Вал» и ПЛ-14.',
        wpns = {'tfa_val','tfa_pl14','stunstick','weapon_flashgrenade'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект стрелка усиленный'] = {
        id = 11,
        desc = 'В комплект входит: улучшенный бронежилет, дубинка, РПК74 и ПМ.',
        wpns = {'tfa_rpk','tfa_pm','stunstick'},
        armor = 100,
        access = 0,
        vip = true
    },
    ['Комплект снайпера'] = {
        id = 12,
        desc = 'В комплект входит: бронежилет, дубинка, СВД и ПМ.',
        wpns = {'tfa_dragunov','tfa_pm','stunstick','weapon_rpw_binoculars'},
        armor = 50
    },
    ['Комплект стрелка №3'] = {
        id = 13,
        desc = 'В комплект входит: бронежилет, дубинка, светошумовая граната, \nПП-19-01 «Витязь» и ПМ.',
        wpns = {'tfa_vityaz19','tfa_pm','stunstick','weapon_flashgrenade'},
        armor = 75,
        vip = true
    },
    ['Комплект стрелка №2'] = {
        id = 14,
        desc = 'В комплект входит: бронежилет, дубинка, АКС74 и ПМ.',
        wpns = {'tfa_aks74','tfa_pm','stunstick'},
        armor = 50,
        access = 0,
    },
    ['Комплект стрелка №1'] = {
        id = 15,
        desc = 'В комплект входит: бронежилет, дубинка, АК74М и ПМ.',
        wpns = {'tfa_ak74m','tfa_pm','stunstick'},
        armor = 50,
        access = 0,
    },
    ['Комплект механика-водителя'] = {
        id = 16,
        desc = 'В комплект входит: бронежилет, дубинка, гаечный ключ, канистра с топливом, \nАКС74У и ПМ.',
        wpns = {'tfa_aks74u','tfa_pm','stunstick','weapon_gpwrench','weapon_gpgascan'},
        armor = 50,
        access = 0,
    },
    ['Комплект общественного порядка'] = {
        id = 17,
        desc = 'В комплект входит: бронежилет, дубинка, щит, газовая и светошумовая граната.',
        wpns = {'stunstick','weapon_sexshield','weapon_flashgrenade','weapon_gas'},
        armor = 50,
        access = 0,
    },
    ['Комплект парадный'] = {
        id = 18,
        desc = 'В комплект входит: бронежилет, дубинка, Винтовка Мосина, СКС и ППШ-41',
        wpns = {'tfa_mosin9130','tfa_sks','tfa_ppsh41','stunstick'},
        armor = 50,
    },
    ['Комплект парадный командирский'] = {
        id = 18,
        desc = 'В комплект входит: бронежилет, дубинка, жезл регулировщика, бинокль, Винтовка Мосина, СКС и ППШ-41',
        wpns = {'tfa_mosin9130','tfa_sks','tfa_ppsh41','stunstick','weapon_palka','weapon_rpw_binoculars'},
        armor = 50,
        access = 5,
    },
}
end) ]]--
 
    --[[['Комплект командирский'] = {
        id = 1,
        desc = 'В комплект входит: бронежилет, дубинка, бинокль, ПП-19 «Бизон» и ПМ.',
        wpns = {'tfa_bizonp19','stunstick','tfa_pm','weapon_rpw_binoculars'},
        armor = 50,
        access = 5
    },
    ['Комплект химслужбы'] = {
        id = 2,
        desc = 'В комплект входит: бронежилет, дубинка, газовая граната, ОЦ-02 «Кипарис» и ПМ.',
        wpns = {'tfa_pm','tfa_ots2','stunstick','weapon_gas'},
        armor = 50,
        access = 5
    },
    ['Комплект комендата'] = {
        id = 3,
        desc = 'В комплект входит: бронежилет, дубинка, щит, палка ареста, СР-3 «Вихрь» и ПМ.',
        wpns = {'tfa_vikhr','tfa_pm','stunstick','weapon_sexshield','arrest_stick'},
        armor = 50,
        access = 5
    },
    ['Комплект комендатуры'] = {
        id = 3,
        desc = 'В комплект входит: бронежилет, дубинка, щит, АКС74 без приклада и ПМ.',
        wpns = {'tfa_aks74y','tfa_pm','stunstick','weapon_sexshield'},
        armor = 50,
        access = 5
    },
    ['[Premium] Комплект фельдшера усиленный'] = {
        id = 4,
        desc = 'В комплект входит: бронежилет, аптечка, АКС74 без приклада и ПМ.',
        wpns = {'tfa_aks74y','tfa_pm','weapon_medkit'},
        armor = 50,
        access = 0,
        vip = true
    },
    ['Комплект фельдшера'] = {
        id = 5,
        desc = 'В комплект входит: бронежилет, аптечка и ПМ.',
        wpns = {'tfa_pm','weapon_medkit'},
        armor = 50,
        access = 0,
    },
    ['[Premium] Комплект снайпера спецназа №2'] = {
        id = 6,
        desc = 'В комплект входит: улучшенный бронежилет, дубинка, бинокль, ВСС «Винторез» и ПЛ-14.',
        wpns = {'tfa_vss','tfa_pl14','stunstick','weapon_rpw_binoculars'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект снайпера спецназа №1'] = {
        id = 7,
        desc = 'В комплект входит: улучшенный бронежилет, дубинка, бинокль, СВУ и ПЛ-14.',
        wpns = {'tfa_svu','tfa_pl14','stunstick','weapon_rpw_binoculars'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект спецназа №2'] = {
        id = 8,
        desc = 'В комплект входит: бронежилет, дубинка, АЕК-971 и ПЛ-14.',
        wpns = {'tfa_aek971','tfa_pl14','stunstick','weapon_flashgrenade'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект спецназа №1'] = {
        id = 9,
        desc = 'В комплект входит: бронежилет, дубинка, АС «Вал» и ПЛ-14.',
        wpns = {'tfa_val','tfa_pl14','stunstick','weapon_flashgrenade'},
        armor = 100,
        vip = true
    },
    ['[Premium] Комплект стрелка усиленный'] = {
        id = 11,
        desc = 'В комплект входит: улучшенный бронежилет, дубинка, РПК74 и ПМ.',
        wpns = {'tfa_rpk','tfa_pm','stunstick'},
        armor = 100,
        access = 0,
        vip = true
    },
    ['Комплект снайпера'] = {
        id = 12,
        desc = 'В комплект входит: бронежилет, дубинка, СВД и ПМ.',
        wpns = {'tfa_dragunov','tfa_pm','stunstick','weapon_rpw_binoculars'},
        armor = 50
    },
    ['Комплект стрелка №3'] = {
        id = 13,
        desc = 'В комплект входит: бронежилет, дубинка, светошумовая граната, \nПП-19-01 «Витязь» и ПМ.',
        wpns = {'tfa_vityaz19','tfa_pm','stunstick','weapon_flashgrenade'},
        armor = 75,
        vip = true
    },
    ['Комплект стрелка №2'] = {
        id = 14,
        desc = 'В комплект входит: бронежилет, дубинка, АКС74 и ПМ.',
        wpns = {'tfa_aks74','tfa_pm','stunstick'},
        armor = 50,
        access = 0,
    },
    ['Комплект стрелка №1'] = {
        id = 15,
        desc = 'В комплект входит: бронежилет, дубинка, АК74М и ПМ.',
        wpns = {'tfa_ak74m','tfa_pm','stunstick'},
        armor = 50,
        access = 0,
    },
    ['Комплект механика-водителя'] = {
        id = 16,
        desc = 'В комплект входит: бронежилет, дубинка, гаечный ключ, канистра с топливом, \nАКС74У и ПМ.',
        wpns = {'tfa_aks74u','tfa_pm','stunstick','weapon_gpwrench','weapon_gpgascan'},
        armor = 50,
        access = 0,
    },
    ['Комплект общественного порядка'] = {
        id = 17,
        desc = 'В комплект входит: бронежилет, дубинка, щит, газовая и светошумовая граната.',
        wpns = {'stunstick','weapon_sexshield','weapon_flashgrenade','weapon_gas'},
        armor = 50,
        access = 0,
    },
    ['Комплект парадный'] = {
        id = 18,
        desc = 'В комплект входит: бронежилет, дубинка, Винтовка Мосина, СКС и ППШ-41',
        wpns = {'tfa_mosin9130','tfa_sks','tfa_ppsh41','stunstick'},
        armor = 50,
    },
    ['Комплект парадный командирский'] = {
        id = 18,
        desc = 'В комплект входит: бронежилет, дубинка, жезл регулировщика, бинокль, Винтовка Мосина, СКС и ППШ-41',
        wpns = {'tfa_mosin9130','tfa_sks','tfa_ppsh41','stunstick','weapon_palka','weapon_rpw_binoculars'},
        armor = 50,
        access = 5,
    },	--]]
