module( 'gp_rg', package.seeall )

local function mat(texture) 
    return texture
end

local lvls_tbl = {}

local meta = FindMetaTable( 'Player' )


tbl = {
    ['Рядовой'] = {
        lvl = 1,
        icon = mat('ranksys/rg1.png'),
        models = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
        body = 0,
        jobs = {
            ['Стрелок'] = {
                desc = 'Задача стрелка состоит в выполнении боевых задач по \nпоражению живых сил противника в ближнем бою.'
            }
        },
        dn = {'Помощник дежурного по КПП', 'Помощник дежурного по казарме', 'Помощник военного коменданта', 'Не назначено'}
    },
    ['Ефрейтор'] = {
        lvl = 2,
        icon = mat('ranksys/rg2.png'),
        models = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
        body = 1,
        jobs = {
            ['Стрелок'] = {
                desc = 'Задача стрелка состоит в выполнении боевых задач по \nпоражению живых сил противника в ближнем бою.'
            }
        },
        dn = {'Помощник дежурного по КПП', 'Помощник дежурного по казарме', 'Помощник военного коменданта', 'Не назначено'}
    },
    ['Младший сержант'] = {
        lvl = 3,
        icon = mat('ranksys/rg3.png'),
        models = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
        body = 2,
        jobs = {
            ['Стрелок'] = {
                desc = 'Задача стрелка состоит в выполнении боевых задач по \nпоражению живых сил противника в ближнем бою.'
            },
            ['Фельдшер'] = {
                desc = 'Задача фельдшера состоит в оказании медицинской помощи военнослужащим.'
            }
        },
        dn = {'Помощник дежурного по КПП', 'Помощник дежурного по казарме', 'Помощник военного коменданта', 'Не назначено'}
    },
    ['Сержант'] = {
        lvl = 4,
        icon = mat('ranksys/rg4.png'),
        models = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
        body = 3,
        jobs = {
            ['Стрелок'] = {
                desc = 'Задача стрелка состоит в выполнении боевых задач по \nпоражению живых сил противника в ближнем бою.'
            },
            ['Фельдшер'] = {
                desc = 'Задача фельдшера состоит в оказании медицинской помощи военнослужащим.'
            }
        },
        dn = {'Помощник дежурного по КПП', 'Помощник дежурного по казарме', 'Помощник военного коменданта', 'Не назначено'}
    },
    ['Старший сержант'] = {
        lvl = 5,
        icon = mat('ranksys/rg5.png'),
        models = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
        body = 4,
        jobs = {
            ['Стрелок'] = {
                desc = 'Задача стрелка состоит в выполнении боевых задач по \nпоражению живых сил противника в ближнем бою.'
            },
            ['Фельдшер'] = {
                desc = 'Задача фельдшера состоит в оказании медицинской помощи военнослужащим.'
            },
            ['Механик-водитель'] = {
                desc = 'Задача механика-водителя состоит в перевозке грузов и военнослужащих, а также обслуживании автопарка.'
            }
        },
        dn = {'Помощник дежурного по КПП', 'Помощник дежурного по казарме', 'Помощник военного коменданта', 'Не назначено'}
    },
    ['Старшина'] = {
        lvl = 6,
        icon = mat('ranksys/rg6.png'),
        models = {"models/player/kerry/solder.mdl","models/player/kerry/solder_2.mdl","models/player/kerry/solder_3.mdl","models/player/kerry/solder_4.mdl"},
        body = 5,
        jobs = {
            ['Старший стрелок'] = {
                desc = 'Задача старшего стрелка помимо выполнении боевых задач по \nпоражению живых сил противника, командование стрелками.'
            },
            ['Механик-водитель'] = {
                desc = 'Задача механика-водителя состоит в перевозке грузов и военнослужащих, а также обслуживании автопарка.'
            }
        },
        dn = {'Помощник дежурного по КПП', 'Помощник дежурного по казарме', 'Помощник военного коменданта', 'Не назначено'}
    },
    ['Прапорщик'] = {
        lvl = 7,
        icon = mat('ranksys/rg7.png'),
        models = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
        body = 0,
        jobs = {
            ['Инструктор сержантского состава'] = {
                desc = 'Задача инструктора сержантского состава состоит в обучении военной науки \nи аттестации рядового состава на сержантское звание, а также обучение сержантов.'
            },
            ['Инспектор ОЛРР'] = {
                desc = 'Задача инспектора отдела по лицензионно-разрешительной работе заключается \nв выдаче лицензий на оружие гражданам.'
            }
        },
        dn = {'Дежурный по КПП', 'Дежурный по казарме', 'Не назначено'}
    },
    ['Старший прапорщик'] = {
        lvl = 8,
        icon = mat('ranksys/rg8.png'),
        models = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
        body = 1,
        jobs = {
            ['Инструктор сержантского состава'] = {
                desc = 'Задача инструктора сержантского состава состоит в обучении военной науки \nи аттестации рядового состава на сержантское звание, а также обучение сержантов.'
            },
            ['Начальник склада'] = {
                desc = 'Задача начальника склада состоит в охране и обеспечении работоспособности \nсклада.'
            }
        },
        dn = {'Дежурный по КПП', 'Дежурный по казарме', 'Не назначено'}
    },
    ['Младший лейтенант'] = {
        lvl = 9,
        icon = mat('ranksys/rg9.png'),
        models = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
        body = 2,
        jobs = {
            ['Начальник медслужбы'] = {
                desc = 'Задача начальника медицинской службы состоит в командовании фельдшерами.'
            }
        },
        dn = {'Дежурный по КПП', 'Дежурный по казарме', 'Военный комендант', 'Не назначено'}
    },
    ['Лейтенант'] = {
        lvl = 10,
        icon = mat('ranksys/rg10.png'),
        models = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
        body = 3,
        jobs = {
            ['Начальник химслужбы'] = {
                desc = 'Задача начальника химической службы состоит в предоставлении защиты \nдля военнослужащих от РХБ опасности.'
            }
        },
        dn = {'Дежурный по КПП', 'Дежурный по казарме', 'Военный комендант', 'Не назначено'}
    },
    ['Старший лейтенант'] = {
        lvl = 11,
        icon = mat('ranksys/rg11.png'),
        models = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
        body = 4,
        jobs = {
            ['Начальник ОЛРР'] = {
                desc = 'Задача начальника отдела по лицензионно-разрешительной работе заключается \nв выдаче лицензий на оружие гражданам и командовании инспекторами.'
            }
        },
        dn = {'Дежурный по КПП', 'Дежурный по казарме', 'Военный комендант', 'Не назначено'}
    },
    ['Капитан'] = {
        lvl = 12,
        icon = mat('ranksys/rg12.png'),
        models = {"models/player/kerry/officer.mdl","models/player/kerry/officer_3.mdl","models/player/kerry/officer_4.mdl","models/player/kerry/officer_5.mdl"},
        body = 5,
        jobs = {
            ['Заместитель командира части'] = {
                desc = 'Задача заместителя командира части состоит в помощи командиру части \nили его замещения.'
            }
        },
        dn = {'Военный комендант', 'Дежурный по в/ч', 'Не назначено'}
    },
    ['Майор'] = {
        lvl = 13,
        icon = mat('ranksys/rg13.png'),
        models =  {"models/player/kerry/general.mdl"},
        body = 0,
        jobs = {
            ['Инструктор младшего офицерского состава'] = {
                desc = 'Задача инструктора младшего офицерского состава состоит в обучении \nвоенной науки и аттестации прапорщиков на офицерское звание, \nа также обучение младшего офицерского состава.'
            },
            ['Заместитель командира части'] = {
                desc = 'Задача заместителя командира части состоит в помощи командиру части \nили его замещения.'
            }
        },
        dn = {'Военный комендант', 'Дежурный по в/ч', 'Не назначено'}
    },
    ['Подполковник'] = {
        lvl = 14,
        icon = mat('ranksys/rg14.png'),
        models =  {"models/player/kerry/general.mdl"},
        body = 1,
        jobs = {
            ['Инструктор младшего офицерского состава'] = {
                desc = 'Задача инструктора младшего офицерского состава состоит в обучении \nвоенной науки и аттестации прапорщиков на офицерское звание, \nа также обучение младшего офицерского состава.'
            },
            ['Заместитель командира части'] = {
                desc = 'Задача заместителя командира части состоит в помощи командиру части \nили его замещения.'
            }
        },
        dn = {'Военный комендант', 'Дежурный по в/ч', 'Не назначено'}
    },
    ['Полковник'] = {
        lvl = 15,
        icon = mat('ranksys/rg15.png'),
        models =  {"models/player/kerry/general.mdl"},
        body = 2,
        jobs = {
            ['Инструктор младшего офицерского состава'] = {
                desc = 'Задача инструктора младшего офицерского состава состоит в обучении \nвоенной науки и аттестации прапорщиков на офицерское звание, \nа также обучение младшего офицерского состава.'
            },
            ['Командир части'] = {
                desc = 'Задача командира части состоит в командовании подразделениями части.'
            }
        }
    },
    ['Генерал-майор'] = {
        lvl = 16,
        icon = mat('ranksys/rg16.png'),
        models = {'models/player/kerry/general_2.mdl'},
        body = 0,
        jobs = {
            ['Инструктор старшего офицерского состава'] = {
                desc = 'Задача инструктора старшего офицерского состава состоит в обучении \nвоенной науки и аттестации офицеров на генеральское звание, \nа также обучение старшего офицерского состава.'
            },
            ['Командир дивизии'] = {
                desc = 'Задача командира дивизии состоит в командовании подразделениями дивизии.'
            }
        }
    },
    ['Генерал-лейтенант'] = {
        lvl = 17,
        icon = mat('ranksys/rg17.png'),
        models = {'models/player/kerry/general_2.mdl'},
        body = 1,
        jobs = {
            ['Инструктор старшего офицерского состава'] = {
                desc = 'Задача инструктора старшего офицерского состава состоит в обучении \nвоенной науки и аттестации офицеров на генеральское звание, \nа также обучение старшего офицерского состава.'
            },
            ['Командир корпуса'] = {
                desc = 'Задача командира корпуса состоит в командовании подразделениями корпуса.'
            }
        }
    },
    ['Генерал-полковник'] = {
        lvl = 18,
        icon = mat('ranksys/rg18.png'),
        models = {'models/player/kerry/general_2.mdl'},
        body = 2,
        jobs = {
            ['Инструктор старшего офицерского состава'] = {
                desc = 'Задача инструктора старшего офицерского состава состоит в обучении \nвоенной науки и аттестации офицеров на генеральское звание, \nа также обучение старшего офицерского состава.'
            },
            ['Командующий армией'] = {
                desc = 'Задача командующего армией состоит в командовании подразделениями армии.'
            }
        }
    },
    ['Генерал армии'] = {
        lvl = 19,
        icon = mat('ranksys/rg19.png'),
        models = { 'models/player/kerry/general_2.mdl'},
        body = 2,
        jobs = {
            ['Инструктор высшего офицерского состава'] = {
                desc = 'Задача инструктора высшего офицерского состава состоит в обучении \nвоенной науки высшего офицерского состава.'
            },
            ['Командующий округом'] = {
                desc = 'Задача командующего округом войск национальной гвардии состоит в \nкомандовании подразделениями округа.'
            }
        }
    },
    ['Маршал'] = {
        lvl = 20,
        icon = mat('ranksys/rg20.png'),
        models =  {"models/player/gesource_ourumov.mdl"},
        jobs = {
            ['Инструктор высшего офицерского состава'] = {
                desc = 'Задача инструктора высшего офицерского состава состоит в обучении \nвоенной науки высшего офицерского состава.'
            },
            ['Командующий'] = {
                desc = 'Задача командующего федеральной службы войск национальной \nгвардии состоит в командовании росгвардией.'
            }
        }
    }
}

local a = 80

function _addLvL(xp, rt)
    table.insert(lvls_tbl, {
        xp = xp,
        rt = rt
    })
end

for k, v in SortedPairsByMemberValue(tbl, 'lvl', false) do
    a = math.Round(a * 1.5)
    _addLvL(a, k)
end




--

function meta:rg_GetLVL()

    return tonumber(self:GetNWInt( 'rg_lvl', 1 ))

end

function meta:rg_GetUP() --get exp to up

    local lvl = self:rg_GetLVL()

    return lvls_tbl[lvl+1].xp

end

function meta:rg_GetRank()

    for k,v in pairs( tbl ) do
        
        if v.lvl == self:rg_GetLVL() then
            return k
        end

    end

end

function meta:IsNRG()
    
    return self:Team() == TEAM_NRG1

end

function meta:rg_IsCMD()

    return self:rg_GetLVL() >= 13 and self:IsNRG()

end

function meta:rg_GetWarnCount()

    return #util.JSONToTable( self:getDarkRPVar('rg_warn') or '[]' ) 

end

function meta:rg_GetRep()

    return self:GetNWInt( 'rg_rep', 0 )

end