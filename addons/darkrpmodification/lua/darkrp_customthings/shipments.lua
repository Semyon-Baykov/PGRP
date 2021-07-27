---- models/weapons/w_shot_xm1014.mdl - дробовик
---- models/weapons/w_rif_galil.mdl - галил
---- models/weapons/w_pist_p228.mdl - пистолет
---- models/weapons/w_rif_ak47.mdl - калаш
---- models/weapons/w_smg_p90.mdl - пистолет пулемет





DarkRP.createShipment("Канистра с топливом", {
	model = "models/props_junk/gascan001a.mdl", 
	entity = "weapon_gpgascan",
	price = 3500,
	amount = 3,
	seperate = false,
	pricesep = 10000,
	noship = false,
	allowed = {TEAM_MEH}
})


AddCustomShipment("Шаурма", "models/hotlinekavkaz/shaurma.mdl", "ent_shava_rus", 3000, 10, false, 3000, false, {TEAM_COOK})
AddCustomShipment("Борщ", "models/arskvshborsch/borsch.mdl", "ent_borsch_rus", 3000, 10, false, 3000, false, {TEAM_COOK})
AddCustomShipment("Тушенка", "models/sngration/belorus_can.mdl", "ent_tyshenka_rus", 3000, 10, false, 3000, false, {TEAM_COOK})
----------------------------------------------------------------------------------------------------

DarkRP.createShipment("Отмычка", {
	model = "models/weapons/w_crowbar.mdl", 
	entity = "lockpick",
	price = 15000,
	amount = 3,
	seperate = false,
	pricesep = 10000,
	noship = false,
	allowed = {TEAM_TRADE}
})

DarkRP.createShipment("Fidget Spinner", {
	entity = "fidgetspinner",
	model = "models/weapons/w_fidget_spinner.mdl",
	price = 1200,
	amount = 1,
	seperate = false,
	noship = false,
	allowed = {TEAM_TRADE},
})

----------------------------------------------------------------

DarkRP.createShipment("Honey Badger", {
	model = "models/weapons/tfa_w_aac_honeybadger.mdl",
	entity = "tfa_honeybadger",
	price = 50000,
	amount = 5,
	seperate = false,
	pricesep = 105000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("MP7", {
	model = "models/weapons/tfa_w_mp7_silenced.mdl", 
	entity = "tfa_mp7",
	price = 60000,
	amount = 5,
	seperate = false,
	pricesep = 70000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("ПП-19 «Бизон»", {
	model = "models/weapons/tfa_w_pp19_bizon.mdl", 
	entity = "tfa_bizonp19",
	price = 40000,
	amount = 5,
	seperate = false,
	pricesep = 70000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("P90", { 
	model = "models/weapons/tfa_w_fn_p90.mdl",
	entity = "tfa_smgp90",
	price = 45000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("KRISS Vector", {
	model = "models/weapons/tfa_w_kriss_vector.mdl",
	entity = "tfa_vector",
	price = 65000,
	amount = 5,
	seperate = false, 
	pricesep = 50000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("MP5", {
	model = "models/weapons/tfa_w_hk_mp5.mdl", 
	entity = "tfa_mp5",
	price = 40000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})


DarkRP.createShipment("HK UMP-45", {
	model = "models/weapons/tfa_w_hk_ump45.mdl", 
	entity = "tfa_ump45",
	price = 30000,
	amount = 5,
	seperate = false,
	pricesep = 50000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("HK USC", {
	model = "models/weapons/tfa_w_hk_usc.mdl", 
	entity = "tfa_usc",
	price = 25000,
	amount = 5,
	seperate = false,
	pricesep = 50000,
	noship = false,
	allowed = {TEAM_GUN}
})


DarkRP.createShipment("KAC PDW", {
	model = "models/weapons/tfa_w_kac_pdw.mdl", 
	entity = "tfa_kac_pdw",
	price = 27000,
	amount = 5,
	seperate = false,
	pricesep = 60000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("IMI UZI", {
	model = "models/weapons/tfa_w_uzi_imi.mdl",
	entity = "tfa_uzi", 
	price = 22000,
	amount = 5,
	seperate = false,
	pricesep = 50000,
	noship = false,
	allowed = {TEAM_GUN}
})

----------------------------------------------------------------

DarkRP.createShipment("Desert Eagle", {
	model = "models/weapons/w_erec_deagle.mdl",
	entity = "tfa_deagle",
	price = 55000,
	amount = 5,
	seperate = false,
	pricesep = 60000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Colt M1911", {
	model = "models/weapons/w_pigg_m19111.mdl",
	entity = "tfa_m1911",
	price = 15000,
	amount = 5,
	seperate = false,
	pricesep = 60000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("M92FS Beretta", {
	model = "models/weapons/w_trh_92fs.mdl",
	entity = "tfa_m92beretta",
	price = 12000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Browning Hi-Power", {
	model = "models/weapons/w_baseplategsh18.mdl",
	entity = "tfa_browning_hp",
	price = 11000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("P229", {
	model = "models/weapons/tfa_w_sig_229r.mdl",
	entity = "tfa_sig_p229r",
	price = 10000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Colt Python", {
	model = "models/weapons/tfa_wcolt_python.mdl",
	entity = "tfa_coltpython",
	price = 12000,
	amount = 5,
	seperate = false,
	pricesep = 60000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("S&W Model 3 Russian", {
	model = "models/weapons/tfa_w_model_3_rus.mdl",
	entity = "tfa_model3russian",
	price = 15000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("SW Model 627", {
	model = "models/weapons/tfa_w_sw_model_627.mdl",
	entity = "tfa_model627",
	price = 9000,
	amount = 5,
	seperate = false,
	pricesep = 40000,
	noship = false,
	allowed = {TEAM_GUN}
})
-------------------------------------------- 

DarkRP.createShipment("SCAR", {
    model = "models/weapons/w_rif_xoma_x4_scarh.mdl",
    entity = "tfa_scar",
    price = 70000,
    amount = 10,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
})

DarkRP.createShipment("AK-74", {
	model = "models/weapons/tfa_w_tct_ak47.mdl",
	entity = "tfa_ak74",
	price = 55000,
	amount = 5,
	seperate = false,
	pricesep = 10000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("AK-47", {
	model = "models/weapons/tfa_w_ak47_tfa.mdl",
	entity = "tfa_ak47",
	price = 52000,
	amount = 5,
	seperate = false,
	pricesep = 10000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("СКС", {
    model = "models/tnb/weapons/w_sks.mdl",
    entity = "tfa_sks",
    price = 50000,
    amount = 5,
    separate = false,
    pricesep = 0,
    noship = false,
    allowed = {TEAM_GUN},
})

DarkRP.createShipment("AH-94", {
	model = "models/weapons/w_rif_an94.mdl",
	entity = "tfa_an94",
	price = 40000,
	amount = 5,
	seperate = false,
	pricesep = 10000,
	noship = false,
	allowed = {TEAM_GUN}
})

-------------------------------------------- 

DarkRP.createShipment("СВД", {
	model = "models/weapons/tfa_w_svd_dragunov.mdl", 
	entity = "tfa_dragunov",
	price = 400000,
	amount = 5,
	seperate = false,
	pricesep = 45000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("СВТ-40", {
	model = "models/weapons/tfa_w_svt_40.mdl",
	entity = "tfa_svt40",
	price = 350000,
	amount = 5,
	seperate = false,
	pricesep = 80000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Винтовка Мосина", {
	model = "models/red orchestra 2/russians/weapons/mn9130.mdl",
	entity = "tfa_mosin9130",
	price = 170000,
	amount = 5,
	seperate = false,
	pricesep = 80000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("Сайга-12", {
	model = "models/pwb/weapons/w_saiga_12.mdl",
	entity = "tfa_saiga12",
	price = 300000,
	amount = 5,
	seperate = false,
	pricesep = 80000,
	noship = false,
	allowed = {TEAM_GUN}
})

DarkRP.createShipment("C4", {
	model = "models/weapons/w_c4.mdl",
	entity = "wep_c4",
	price = 70000,
	amount = 1,
	seperate = false,
	pricesep = 70000,
	noship = false,
	allowed = {TEAM_GUN}
})