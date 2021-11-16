cf = {}

-- CONFIG --

-- REMEMBER TO DOWNLOAD THE WORKSHOP CONTENT!!! https://steamcommunity.com/sharedfiles/filedetails/?id=1514815567

-- Sell Mode | Setting it to false allows selling cigarettes without bringing them to the export van.
-- Note that if you're using default sell mode you need to save spawned vans using cf_save command! Otherwise vans will disappear after server restart.
cf.InstantSellMode = false


-- Maximum default paper storage.
cf.maxPaperStorage = 300
cf.storageUpgradeBoostPaper = 75
-- Amount of paper it takes to produce one pack.
cf.paperProductionCost = 2

-- Maximum amount of tobacco machine can contain.
cf.maxTobaccoStorage = 3000
cf.storageUpgradeBoostTobacco = 7500
-- Amount of tobacco it takes to produce one pack.
cf.tobaccoProductionCost = 20


-- Engine performance multiplier after engine upgrade (1.5 makes it 50% more efficient).
cf.engineUpgradeBoost = 1.25 
-- Time (in seconds) it takes to produce one pack.
cf.timeToProduce = 3.5
-- Base amount of $ you'll get for one pack sold.
cf.sellPrice = 180
-- How often should the price change (in seconds). 
cf.priceChangeTime = 900
-- Maximum difference in pack price.
cf.maxPriceDifference = 10


-- Time (in seconds) it takes for a cigarette pack to despawn (reduces lag).
cf.cigAutoDespawnTime = 30


-- Max amount of packs that can fit into an export box.
cf.maxCigsBox = 90
-- Max amount of packs player can carry.
cf.maxCigsOnPlayer = 360

-- Machine maximum health
cf.maxMachineHealth = 300
-- Machine hp regen rate 
cf.machineRegen = 4

-- Cigarette SWEP compatibility ( REQUIRES https://steamcommunity.com/sharedfiles/filedetails/?id=793269226&searchtext=cigarette !!!)
cf.allowSwep = false

-- Should vans respawn after map cleanup
cf.AutoRespawn = true

-- Translation
cf.StorageText = "АПГРЕЙД ВМЕСТИМОСТИ"
cf.StorageDescText = "Апгрейд вместимости для AUTO-CIG"
cf.ProductionOffText = "PRODUCTION OFF"
cf.ProducingText = "PRODUCING"
cf.RefillNeededText = "НУЖНА ЗАПРАВКА"
cf.EngineText = "АПГРЕЙД СКОРОСТИ"
cf.EngineDescText = "Апгрейд скорости для AUTO-CIG"
cf.BoxText = "КОРОБКА ДЛЯ ЭКСПОРТА"
cf.BoxDescText1 = "Коробка специально для"
cf.BoxDescText2 = "экспортирования сигарет."
cf.BoxDescText3 = "Пачек внутри: "
cf.BoxDescText4 = "Стоимость: "
cf.CurrencyText = "₽"
cf.Notification1 = "Вы не можете нести больше "
cf.Notification2 = " сигарет!"
cf.Notification3 = "Вы подняли коробку с "
cf.Notification4 = " пачками сигарет!"
cf.MachineHealth = "HP"
cf.VanText = "ЭКСПОРТ СИГАРЕТ"
cf.VanDescText1 = "Даём "
cf.VanDescText2 = " за одну пачку!"
cf.SellText1 = "Вы продали "
cf.SellText2 = " пачек сигарет за "
cf.CommandText1 = "Export vans have been saved"
cf.CommandText2 = "Export vans have been loaded"

-- Fonts
if CLIENT then
	surface.CreateFont( "cf_machine_main", {
		font = "Impact",    
		size = 24
	})
	surface.CreateFont( "cf_machine_small", {
		font = "Impact",    
		size = 16,
		outline = true
	})
end