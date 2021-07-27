module( 'gp_cardealer', package.seeall )

tbl = {}
tbl.cars = {}
tbl.doncars = {}
tbl.govcars = {}

tbl.refund = {
	['crsk_audi_rs6_avant_2016'] = { price = 4270000 },
	['crsk_bmw_750i_e38_1995'] = { price = 2150000 },
	['crsk_lada_2170priora_2008'] = { price = 1150000 },
	['crsk_mercedes_g500_2008'] = { price = 5000000 },
	['crsk_mercedes_gt63s_coupe_amg_2018'] = { price = 7000000 },
	['crsk_vaz_2107'] = { price = 600000 },
	['crsk_vaz_2109'] = { price = 750000 },
	['crsk_vaz_2114'] = { price = 950000 },
	['crsk_zaz_968m'] = { price = 400000 }
}


function add_defcar( id, class, name, model, script, price, vip, desc )
	tbl.cars[class] = {
		id = id,
		name = name,
		model = model,
		script = script,
		price = price,
		vip = vip,
		desc = desc
	}
end

function add_doncar( id, class, name, model, script, price, desc )
	tbl.doncars[class] = {
		id = id,
		name = name,
		model = model,
		script = script,
		price = price,
		desc = desc
	}
end

function add_govcar( id, class, name, model, script, check, doorgroup, skin )
	tbl.govcars[class] = {
		id = id,
		name = name,
		model = model,
		script = script,
		check = check,
		doorgroup = doorgroup,
		skin = skin
	}
end

local ts = {'а','б','в','д','е','к','л','м','н','о','п','р','с','т','у','х','ч','ш'}

function RandomNumberDef() 
	
	return table.Random( ts )..math.random( 111, 999 )..table.Random( ts )..table.Random( ts )

end
function RandomNumberPolice() 
	
	return table.Random( ts )..math.random( 1111, 9999 )

end
function RandomNumberRos() 
	
	return math.random( 1111, 9999 )..table.Random( ts )..table.Random( ts )

end



-------------------------------Доступный транспорт--------------------------
--[[/*
add_defcar( 1, 'crsk_vaz_2107', 'ВАЗ-2107',  'models/crsk_autos/avtovaz/2107.mdl', 'scripts/vehicles/crsk_autos/crsk_vaz_2107.txt', 600000, false, 'LADA 2107 (ВАЗ-2107 «Жигули») — советский и российский заднеприводный автомобиль II группы малого класса с кузовом типа седан, одна из последних моделей «классики».' )
add_defcar( 2, 'crsk_vaz_2109', 'ВАЗ-2109',  'models/crsk_autos/avtovaz/2109.mdl', 'scripts/vehicles/crsk_autos/crsk_vaz_2109.txt', 750000, false, 'ВАЗ-2109 «Спутник»/Samara (неоф. название «Девятка»[1]) — советский и российский переднеприводный автомобиль II группы малого класса с кузовом типа хэтчбек.' )
add_defcar( 4, 'crsk_lada_2170priora_2008', 'LADA Priora', 'models/crsk_autos/avtovaz/2170priora_2008.mdl', 'scripts/vehicles/crsk_autos/crsk_lada_2170priora_2008.txt', 1150000, false, 'LADA Priora — семейство бюджетных российских автомобилей III группы малого класса, выпускаемое ПАО «АвтоВАЗ».' )
add_defcar( 3, 'crsk_vaz_2114', 'ВАЗ-2114', 'models/crsk_autos/avtovaz/2114.mdl', 'scripts/vehicles/crsk_autos/crsk_vaz_2114.txt', 950000, false, 'ВАЗ-2114 (LADA Samara) — пятидверный хэтчбек Волжского автомобильного завода, рестайлинговая версия ВАЗ-2109.' )
add_defcar( 0, 'crsk_zaz_968m', 'ЗАЗ-968М', 'models/crsk_autos/zaz/968m.mdl', 'scripts/vehicles/crsk_autos/crsk_zaz_968m.txt', 400000, false, 'ЗАЗ-968 «Запорожец» («ушастый», «чебурашка») — советский автомобиль I группы малого класса, выпускавшийся Запорожским автомобильным заводом.' )

add_defcar( 5,  'crsk_bmw_750i_e38_1995', 'BMW 750i E38',  'models/crsk_autos/bmw/750i_e38_1995.mdl', 'scripts/vehicles/crsk_autos/crsk_bmw_750i_e38_1995.txt', 2150000, false, 'BMW 7-й серии (E38) — третье поколение люксовых[en] автомобилей 7-й серии, выпускавшихся с 1994 по 2001 год немецким автопроизводителем BMW.' )
add_defcar( 6, 'crsk_audi_rs6_avant_2016', 'Audi RS6',  'models/crsk_autos/audi/rs6_avant_2016.mdl', 'scripts/vehicles/crsk_autos/crsk_audi_rs6_avant_2016.txt', 4270000, false, 'Audi RS 6 – спортивный автомобиль выпускаемый подразделением Audi Sport GmbH.' )
add_defcar( 7, 'crsk_mercedes_g500_2008', 'Mercedes-benz G500', 'models/crsk_autos/mercedes-benz/g500_2008.mdl', 'scripts/vehicles/crsk_autos/crsk_mercedes_g500_2008.txt', 5000000, false, 'Mercedes-Benz G-класс, иногда именуемый G-Wagen, — серия полноразмерных внедорожников, производимых\nв Австрии фирмой Magna Steyr и продаваемых под торговой маркой Mercedes-Benz.' )



add_defcar( 8,  'crsk_mercedes_gt63s_coupe_amg_2018', 'Mercedes-AMG GT63S', 'models/crsk_autos/mercedes-benz/gt63s_coupe_amg_2018.mdl', 'scripts/vehicles/crsk_autos/crsk_mercedes_gt63s_coupe_amg_2018.txt', 7000000, false, 'Mercedes-AMG GT 4-дверное купе: пространство для еще большей индивидуальности.\n Большей универсальности. Большей спортивности.' )


add_defcar( 9, 'sim_fphys_mer_g63_amg', 'SIMF TEST CAR',  'models/crsk_autos/mercedes-benz/g63_amg_2019.mdl', 'scripts/vehicles/crsk_autos/crsk_vaz_2107.txt', 600000, false, 'TEST TEST.' )
*/]]--


add_defcar( 1, 'sim_fphys_vaz_2101', 			'ВАЗ-2101', 					'models/crsk_autos/avtovaz/2101.mdl', 						'yea', 		500000, 	false, 'ВАЗ-2101 «Жигули» — советский заднеприводный легковой автомобиль малого класса с кузовом типа седан.' )
add_defcar( 2, 'sim_fphys_vaz_2107', 			'ВАЗ-2107', 					'models/crsk_autos/avtovaz/2107.mdl', 						'script', 	600000, 	false, 'LADA 2107 (ВАЗ-2107 «Жигули») — советский и российский заднеприводный автомобиль II группы малого класса с кузовом типа седан' )
add_defcar( 3, 'sim_fphys_vaz_2109', 			'ВАЗ-2109', 					'models/crsk_autos/avtovaz/2109.mdl', 						'script', 	720000, 	false, 'ВАЗ-2109 «Спутник» — советский и российский переднеприводный автомобиль II группы малого класса с кузовом типа хэтчбек.' )
add_defcar( 4, 'sim_fphys_vaz-2114', 			'ВАЗ-2114', 					'models/crsk_autos/avtovaz/2114.mdl', 						'script', 	790000, 	false, 'ВАЗ-2114 — пятидверный хэтчбек Волжского автомобильного завода, рестайлинговая версия ВАЗ-2109' )
add_defcar( 5, 'sim_fphys_vaz-2115', 			'ВАЗ-2115', 					'models/crsk_autos/avtovaz/2115.mdl', 						'script', 	800000, 	false, 'ВАЗ-2115 — субкомпактный переднеприводный автомобиль с кузовом типа седан' )
add_defcar( 6, 'sim_fphys_lada_priora',			'LADA Priora', 					'models/crsk_autos/avtovaz/2170priora_2008.mdl', 			'script', 	900000, 	false, 'LADA Priora — семейство российских автомобилей III группы малого класса' )
add_defcar( 7, 'sim_fphys_uaz_patriot', 		'UAZ Patriot', 					'models/crsk_autos/uaz/patriot_2014.mdl', 					'script', 	1100000, 	false, 'УАЗ-3163 «Patriot» — полноприводный автомобиль повышенной проходимости (внедорожник).' )
add_defcar( 8, 'sim_fphys_uaz-452', 			'UAZ-452 ', 					'models/lonewolfie/uaz_452.mdl', 							'script', 	1200000, 	false, 'УАЗ-452 «Буханка» - иконная машина, о прочности и проходимости которой ведут легенды. Данный транспорт вмещает 7 пассажиров.' )
add_defcar( 9, 'sim_fphys_mer_w140', 			'Mercedes-benz W140', 			'models/crsk_autos/mercedes-benz/500se_w140_1992.mdl', 		'script', 	1500000, 	false, 'Mercedes-Benz W140 — серия флагманских моделей S-класса немецкой торговой марки Mercedes Benz.' )
add_defcar( 10, 'sim_fphys_sub_wrxsti_2015', 	'Subaru Impreza WRX STI', 		'models/crsk_autos/subaru/wrx_sti_2015.mdl', 				'script', 	3500000, 	false, 'Subaru Impreza WRX STI — более мощная и динамичная модификация седана Subaru WRX' )
add_defcar( 11, 'sim_fphys_bmw_m5f90', 			'BMW M5 F90', 					'models/skyautomotive/bmw_m5_f90.mdl', 						'script', 	6000000, 	false, 'BMW M5 — доработанная подразделением BMW Motorsport версия автомобиля BMW пятой серии.' )
add_defcar( 12, 'sim_fphys_toy_land200', 		'Toyota Land Cruiser 200', 		'models/crsk_autos/toyota/landcruiser_200_2013.mdl', 		'script', 	5700000, 	false, 'Toyota Land Cruiser 200 (яп. トヨタ ランドクルーザー Toyota Rando-kurūzā) — вседорожник, выпускаемый японской компанией Toyota Motor Corporation с 1951 года.' )
add_defcar( 13, 'sim_fphys_mer_g63_amg', 		'Mercedes-benz G63 AMG', 		'models/crsk_autos/mercedes-benz/g63_amg_2019.mdl', 		'script', 	5200000, 	false, 'Mercedes-Benz G-класс, иногда именуемый G-Wagen — серия полноразмерных внедорожников' )
add_defcar( 14, 'sim_fphys_mer_c63s', 			'Mercedes-benz C63S W205 AMG', 	'models/crsk_autos/mercedes-benz/c63s_amg_coupe_2016.mdl', 	'script', 	7500000, 	false, 'Вы предпочитаете автомобили, заряженные по максимуму? В каждой детали его экстерьера читается любовь к высоким скоростям, и он готов продемонстрировать свои выдающиеся возможности, как только представится подходящий случай.' )
add_defcar( 15, 'sim_fphys_aud_r8', 			'Audi R8', 						'models/skyautomotive/audir8_17.mdl', 						'script', 	8700000, 	false, 'Audi R8 — среднемоторный полноприводный спортивный автомобиль, производимый немецким автопроизводителем Audi' )
-- add_defcar( 16, 'sim_fphys_mayb_s650_w222', 	'Mercedes-Maybach W222', 		'models/dk_cars/mercedes/benzw222/maybach.mdl', 			'script', 	11000000, 	false, 'Mercedes-Benz W222 — шестое поколение флагманской серии представительских автомобилей S-класса немецкой марки Mercedes-Benz' )
add_defcar( 17, 'sim_fphys_rolls_phantom_viii', 'Rolls-Royce Phantom', 			'models/crsk_autos/rolls-royce/phantom_viii_2018.mdl', 		'script', 	13000000, 	false, 'Rolls-Royce Phantom — автомобиль представительского класса, производимый компанией Rolls-Royce Motor Cars, дочерней компанией BMW' )


---------------------------------Донат транспорт-------------------------------
--add_doncar( 1, 'crsk_bmw_z4e89', 'BMW Z4', 'models/crsk_autos/bmw/z4e89_2012.mdl', 'scripts/vehicles/crsk_autos/crsk_bmw_z4e89.txt', 250, 'BMW Z4 — двухместный родстер, выпускавшийся немецкой компанией BMW.' )
------------------------Государственный транспорт------------------------
hook.Add( 'loadCustomDarkRPItems', 'gpcard_load', function()
	add_govcar(1, "sim_fphys_vaz-2114_pol", "ВАЗ-2114", "models/crsk_autos/avtovaz/2114_trafficpolice.mdl", "scripts/vehicles/crsk_autos/crsk_vaz_2114.txt", function( ply ) return ply:Team() == TEAM_DPS end, "Полиция", 0)
	add_govcar(2, "sim_fphys_uaz_patriot_pol", "УАЗ Патриот", "models/crsk_autos/uaz/patriot_2014_police.mdl", "scripts/vehicles/crsk_autos/crsk_uaz_patriot_2014.txt", function( ply ) return ply:isCP() == true end, "Полиция", 0)
	add_govcar(3, "sim_fphys_uaz_patriot", "УАЗ Патриот", "models/crsk_autos/uaz/patriot_2014_investigation.mdl", "scripts/vehicles/crsk_autos/crsk_uaz_patriot_2014.txt", function( ply ) return ply:rg_IsCMD() or ply:GetNWString( 'nrg_access_veh', false ) end, "Росгвардия", 0)
end)
