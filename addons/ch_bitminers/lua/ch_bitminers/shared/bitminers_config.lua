CH_Bitminers = CH_Bitminers or {}
CH_Bitminers.Config = CH_Bitminers.Config or {}
CH_Bitminers.Design = CH_Bitminers.Design or {}
CH_Bitminers.Config.MineMoneyInterval = CH_Bitminers.Config.MineMoneyInterval or {}

-- SET LANGUAGE
-- Available languages: English: en - Danish: da - German: de - Polish: pl - Russian: ru - Spanish: es - French: fr - Portuguese: pt - Chinese: cn - Turkish: tr
CH_Bitminers.Config.Language = "ru" -- Set the language of the script.

-- Bitminer Values
CH_Bitminers.Config.BitcoinRate = 7000 -- 1 bitcoin equals how much cash? (1 bitcoin = 3500)
CH_Bitminers.Config.RateRandomizeInterval = 1800 -- seconds between bitcoin rate is changed.
CH_Bitminers.Config.RateUpdateInterval = 100 -- Default 20. So it will randomize the change between -20 to +20. So it can either go down or up, but maximum 20 either way.
CH_Bitminers.Config.MinBitcoinRate = 4000 -- The lowest the bitcoin rate can hit.
CH_Bitminers.Config.MaxBitcoinRate = 10000 -- The maximum the bitcoin rate can go to.

CH_Bitminers.Config.NotifyPlayersChatRateUpdate = true -- Should all players be notified in chat when the bitcoin rate updates?

-- CH_Bitminers.Config.MineMoneyInterval[[AMOUNT OF MINERS] = INTERVAL BETWEEN MINING MONEY
-- Here it illustrates that having 1 miner will take 15 seconds before it mines bitcoins. The more miners, the less interval.
-- YOU DON'T NECESSARILY NEED TO MODIFY THIS
CH_Bitminers.Config.MineMoneyInterval[1] = 		20
CH_Bitminers.Config.MineMoneyInterval[2] = 		19
CH_Bitminers.Config.MineMoneyInterval[3] = 		18
CH_Bitminers.Config.MineMoneyInterval[4] = 		17
CH_Bitminers.Config.MineMoneyInterval[5] = 		16
CH_Bitminers.Config.MineMoneyInterval[6] = 		15
CH_Bitminers.Config.MineMoneyInterval[7] = 		14
CH_Bitminers.Config.MineMoneyInterval[8] = 		13
CH_Bitminers.Config.MineMoneyInterval[9] = 		12
CH_Bitminers.Config.MineMoneyInterval[10] = 	11
CH_Bitminers.Config.MineMoneyInterval[11] = 	10
CH_Bitminers.Config.MineMoneyInterval[12] = 	9
CH_Bitminers.Config.MineMoneyInterval[13] = 	8
CH_Bitminers.Config.MineMoneyInterval[14] = 	7
CH_Bitminers.Config.MineMoneyInterval[15] = 	6
CH_Bitminers.Config.MineMoneyInterval[16] = 	5

-- Removing Entities
CH_Bitminers.Config.RemoveEntsOnDC = true -- Should bitminer entities be removed once a player disconnects?
CH_Bitminers.Config.RemoveEntsOnTeamChange = true -- Should bitminer entities be removed when a player changes his job?

-- Bitminer Shelf
CH_Bitminers.Config.MaxBitcoinsMined = 10 -- How many bitcoins can a bitminer maximum contain
CH_Bitminers.Config.BitcoinsMinedPer = 0.07 -- Amount of bitcoins mined on each interval
CH_Bitminers.Config.WattsRequiredPerMiner = 1200 -- Amount of watts required per miner in order to properly mine bitcoins most optimal

CH_Bitminers.Config.ShelfHealth = 150 -- Amount of health before it destroys.
CH_Bitminers.Config.ShelfStartTemperature = 20 -- Temperature the shelf spawns with.

CH_Bitminers.Config.ShelfExplosion = true -- Should the shelf cause an explosion if it takes too much damage or overheats?
CH_Bitminers.Config.NotifyOwnerOverheating = true -- Should the owner of the shelf be notified when the mining shelf overheats?

CH_Bitminers.Config.ShowScreenDistance = 50000 -- Distance between player and shelf for showing screen

CH_Bitminers.Config.ShelfMiningSoundLevel = 50 -- Sound level of the shelf mining sound. (0 = muted)

-- Fuel Canisters
CH_Bitminers.Config.FuelCanSmallAmount = 50 -- Amount of fuel the small canister contains (max is 100)
CH_Bitminers.Config.FuelCanMediumAmount = 75 -- Amount of fuel the medium canister contains (max is 100)
CH_Bitminers.Config.FuelCanLargeAmount = 100 -- Amount of fuel the large canister contains (max is 100)

-- Fuel Generator
CH_Bitminers.Config.GeneratorWattsInterval = 3 -- Interval for the fuel generator to generate watts in seconds.
CH_Bitminers.Config.FuelGeneratorHealth = 150 -- Amount of health before it destroys.
CH_Bitminers.Config.FuelGeneratorExplosion = false -- Should the fuel generator cause an explosion if it takes too much damage?

CH_Bitminers.Config.FuelConsumptionRate = 7 -- Every x second the generator will consume a random amount of fuel
CH_Bitminers.Config.FuelConsumptionMin = 2 -- Every FuelConsumptionRate it will consume this minimum amount of fuel (it's randomized)
CH_Bitminers.Config.FuelConsumptionMax = 4 -- Every FuelConsumptionRate it will consume this maximum amount of fuel (it's randomized)

CH_Bitminers.Config.GeneratorSmokeEffect = false -- Display smoke effect coming out of generator when turned on.
CH_Bitminers.Config.FuelGeneratorSoundLevel = 75 -- Sound level of the fuel generator when powered on. (0 = muted)

CH_Bitminers.Config.GeneratorWattsMin = 75 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.GeneratorWattsMax = 115 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

-- Solar Panel
CH_Bitminers.Config.SolarPanelWattsInterval = 4 -- Interval for the solar panel to generate watts in seconds.
CH_Bitminers.Config.SolarPanelHealth = 100 -- Amount of health before it destroys.
CH_Bitminers.Config.SolarPanelExplosion = false -- Should the solar panel cause an explosion if it takes too much damage?

CH_Bitminers.Config.SolarPanelWattsMin = 100 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.SolarPanelWattsMax = 140 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

CH_Bitminers.Config.CollectDirtInterval = 30 -- Amount of seconds between collecting more dirt on the solar panel.
CH_Bitminers.Config.CollectDirtMin = 1 -- Minimum amount of dirt collected per interval.
CH_Bitminers.Config.CollectDirtMax = 3 -- Maximum amount of dirt collected per interval.
CH_Bitminers.Config.ShowDirt3D2D = 25000 -- -- Distance between player and solar panel for showing dirt 3d2d.

-- RTG Generator
CH_Bitminers.Config.RTGWattsInterval = 5 -- Interval for the RTG to generate watts in seconds.
CH_Bitminers.Config.RTGGeneratorHealth = 300 -- Amount of health before it destroys.
CH_Bitminers.Config.RTGGeneratorExplosion = false -- Should the RTG cause an explosion if it takes too much damage? (NOTE: large explosion)

CH_Bitminers.Config.RTGRadiationEnabled = true -- Enable/disable the damage dealt by radiation.
CH_Bitminers.Config.RTGRadiationDamageOwnerOnly = false -- If enabled, should the radiation only damage the owner of the RTG? false = damage everyone, true = owner only

CH_Bitminers.Config.RTGRadiationInterval = 5 -- Amount of seconds between giving damage to players nearby.
CH_Bitminers.Config.RTGRadiationDistance = 50000 -- Distance from players to RGT before doing damage.

CH_Bitminers.Config.RTGWattsMin = 200 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.RTGWattsMax = 250 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

-- Watts Decrease System
CH_Bitminers.Config.WattsDecreaseInterval = 5 -- Every 5th second it will decrease the watts if not powered/plugged in with a cable.
CH_Bitminers.Config.DecreaseAmountMin = 20 -- Minimum amount decreased every 5th second.
CH_Bitminers.Config.DecreaseAmountMax = 40 -- Minimum amount decreased every 5th second.

-- Power Cable
CH_Bitminers.Config.CableRopeLenght = 100 -- Lenght of the rope between the two ends of the power cable.

-- Cooling System & Upgrades
CH_Bitminers.Config.TemperatureInterval = 20 -- Interval between updating temperature on miners in seconds
CH_Bitminers.Config.TempToAddPerMiner = 0.3 -- Temperature added per miner on the shelf.

CH_Bitminers.Config.TempToTakePerCooling = 1 -- Temperature removed from shelf per cooling upgrade installed.
CH_Bitminers.Config.TempToTakeWhenOff = 10 -- Temperature to remove every interval if the shelf is turned off.

-- Donator Features
CH_Bitminers.Config.MaxBitminersInstalled = {
	-- { IsSecondaryUserGroup "premium", MaxBitminers = 16 },
	{ UserGroup = "user", MaxBitminers = 16 },
}

-- Health Options (Additional)
CH_Bitminers.Config.PowerCombinerHealth = 75
CH_Bitminers.Config.PowerCableHealth  = 50
CH_Bitminers.Config.FuelCanisterHealth = 75
CH_Bitminers.Config.CoolingUpgradesHealth = 100
CH_Bitminers.Config.SingleMinerHealth = 100
CH_Bitminers.Config.RGBUpgradeHealth = 75
CH_Bitminers.Config.UPSUpgradeHealth = 75
CH_Bitminers.Config.DirtCleaning = 50

-- 3RD PARTY SUPPORT
CH_Bitminers.Config.CreateFireOnExplode = false -- ONLY WORKS WITH MY FIRE SYSTEM https://www.gmodstore.com/market/view/302

CH_Bitminers.Config.DarkRPLevelSystemEnabled = false -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
CH_Bitminers.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
CH_Bitminers.Config.EXP2SystemEnabled = false -- Elite XP System (EXP2) by Axspeo https://www.gmodstore.com/market/view/4316

CH_Bitminers.Config.WithdrawXPAmount = 400 -- Amount of XP to receive when exchanging bitcoins.

-- Bitminer Entities (NOT NECESSARY TO EDIT THIS)
CH_Bitminers.ListOfEntities = {
	"ch_bitminer_power_cable",
	"ch_bitminer_power_cable_end",
	"ch_bitminer_power_combiner",
	"ch_bitminer_power_generator",
	"ch_bitminer_power_generator_fuel_small",
	"ch_bitminer_power_generator_fuel_medium",
	"ch_bitminer_power_generator_fuel_large",
	"ch_bitminer_power_rtg",
	"ch_bitminer_power_solar",
	"ch_bitminer_shelf",
	"ch_bitminer_upgrade_clean_dirt",
	"ch_bitminer_upgrade_cooling1",
	"ch_bitminer_upgrade_cooling2",
	"ch_bitminer_upgrade_cooling3",
	"ch_bitminer_upgrade_miner",
	"ch_bitminer_upgrade_rgb",
	"ch_bitminer_upgrade_ups"
}