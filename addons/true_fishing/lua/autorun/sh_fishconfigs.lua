
/*
WARNING: DO NOT MODIFY THIS FILE FOR CONFIGURATION. USE THE IN-GAME CONFIGURATION MENU!
*/

FISH_DAMSELFISH = 1
FISH_GOLDFISH = 2
FISH_SNAPPER = 3
FISH_RAINBOW = 4
FISH_GOLDENFISH = 5
FISH_CATFISH = 6
FISH_BASSFISH = 7
FISH_JUNK = 8

FISH_HIGHNUMBER = 8

local FishModels = {}
FishModels[FISH_DAMSELFISH] = "models/props/prop_damselfish.mdl"
FishModels[FISH_GOLDFISH] = "models/props/de_inferno/GoldFish.mdl"
FishModels[FISH_SNAPPER] = "models/props/CS_militia/fishriver01.mdl"
FishModels[FISH_RAINBOW] = "models/FoodNHouseholdItems/fishrainbow.mdl"
FishModels[FISH_GOLDENFISH] = "models/karasik/karasik.mdl"
FishModels[FISH_CATFISH] = "models/FoodNHouseholdItems/fishcatfish.mdl"
FishModels[FISH_BASSFISH] = "models/FoodNHouseholdItems/fishbass.mdl"
FishModels[FISH_JUNK] = {"models/props_junk/garbage_metalcan001a.mdl",
"models/props_junk/garbage_metalcan002a.mdl",
"models/props_junk/garbage_milkcarton001a.mdl",
"models/props_junk/garbage_milkcarton002a.mdl",
"models/props_junk/garbage_newspaper001a.mdl",
"models/props_junk/garbage_plasticbottle001a.mdl",
"models/props_junk/garbage_plasticbottle002a.mdl",
"models/props_junk/garbage_plasticbottle003a.mdl"}
function TrueFishGetFishModel(int)
	return int == FISH_JUNK and FishModels[int][math.random(#FishModels[int])] or FishModels[int]
end

local FishNames = {}
FishNames[FISH_DAMSELFISH] = "_"
FishNames[FISH_GOLDFISH] = "Карась"
FishNames[FISH_SNAPPER] = "Лещ"
FishNames[FISH_RAINBOW] = "Форель"
FishNames[FISH_GOLDENFISH] = "Швайнкарасик"
FishNames[FISH_CATFISH] = "Сом"
FishNames[FISH_BASSFISH] = "Украiнская Щука"
FishNames[FISH_JUNK] = "Мусор"
function TrueFishGetFishName(int)
	return FishNames[int]
end

FISH_GEAR_BAIT = 1
FISH_GEAR_MEDIUMCAGE = 2
FISH_GEAR_LARGECAGE = 3
FISH_GEAR_CONTAINER = 4
FISH_GEAR_ROD = 5
FISH_GEAR_FISHFINDER = 6

FISH_GEAR_HIGHNUMBER = 6

local GearModels = {}
GearModels[FISH_GEAR_BAIT] = "models/props_junk/garbage_bag001a.mdl"
GearModels[FISH_GEAR_MEDIUMCAGE] = "models/props_junk/wood_crate002a.mdl"
GearModels[FISH_GEAR_LARGECAGE] = "models/hunter/blocks/cube075x2x1.mdl"
GearModels[FISH_GEAR_CONTAINER] = "models/props_junk/cardboard_box001a.mdl"
GearModels[FISH_GEAR_ROD] = "models/fishing/pole.mdl"
GearModels[FISH_GEAR_FISHFINDER] = "models/props_lab/monitor01b.mdl"
function TrueFishGetGearModel(int)
	return GearModels[int]
end

if CLIENT then
	local GearMaterials = {}
	GearMaterials[FISH_GEAR_BAIT] = "models/flesh"
	GearMaterials[FISH_GEAR_MEDIUMCAGE] = "!CagePotMaterial"
	GearMaterials[FISH_GEAR_LARGECAGE] = "!CagePotMaterial"
	GearMaterials[FISH_GEAR_CONTAINER] = "phoenix_storms/bluemetal"
	function TrueFishGetGearMaterial(int)
		return GearMaterials[int]
	end
end

local GearNames = {}
GearNames[FISH_GEAR_BAIT] = "Приманка"
GearNames[FISH_GEAR_MEDIUMCAGE] = "Верша"
GearNames[FISH_GEAR_LARGECAGE] = "Большая Верша"
GearNames[FISH_GEAR_CONTAINER] = "Куллер для рыбы"
GearNames[FISH_GEAR_ROD] = "Спининг"
GearNames[FISH_GEAR_FISHFINDER] = "Эхолот"
function TrueFishGetGearName(int)
	return GearNames[int]
end

local GearEntity = {}
GearEntity[FISH_GEAR_BAIT] = "fish_bait"
GearEntity[FISH_GEAR_MEDIUMCAGE] = "fishing_pot_medium"
GearEntity[FISH_GEAR_LARGECAGE] = "fishing_pot_large"
GearEntity[FISH_GEAR_CONTAINER] = "fish_container"
function TrueFishGetGearEntityName(int)
	return GearEntity[int]
end

FISH_MAX_DEPTH = 999

TrueFish = TrueFish or {

OPTIMIZED_FISHING = true,
CAGE_NO_FISH_MODEL = false,
CAGE_BUOY_SPLASHING = true,
MEDIUM_CAGE_FISH_LIMIT = 10,
LARGE_CAGE_FISH_LIMIT = 15,
FISH_CONTAINER_LIMIT = 15,
CONTAINERS_DISABLED = false,
MEDIUM_CAGE_LIMIT = 2,
LARGE_CAGE_LIMIT = 2,
CONTAINER_LIMIT = 2,
CAGE_SHARED_LIMIT = true,
MEDIUM_JUNK_CHANCE = 11,
LARGE_JUNK_CHANCE = 10,
ROD_NO_CONTAINER = false,
FISH_CARRY_LIMIT = 20,
ROD_PHYSICS_FISHING = false,
ROD_SEPERATE_CATCH_TIME_ENABLED = false,
ROD_SEPERATE_CATCH_TIME = 5,
ROD_CATCH_WINDOW = 0.33,
ROD_FISH_BAIT_AMOUNT = 5,
ROD_JUNK_CHANCE = 5,
ROD_MONEYBAG_CHANCE = 1,
ROD_MONEYBAG_MONEY = 500,
CAN_PHYSGUN_GEAR = false,
FISH_CONTAINER_OWNER_DISCARD = false,
FISH_BAIT_AUTOREMOVE = 0,

LOCALISATION_LANGUAGE = "English",
FISHING_JOB_RESTRICTION = "None",

FISH_CATCH_TIME = {
[FISH_DAMSELFISH] = {6 ,10},
[FISH_GOLDFISH] = {5 ,11},
[FISH_SNAPPER] = {7 ,17},
[FISH_RAINBOW] = {8 ,16},
[FISH_GOLDENFISH] = {10 ,19},
[FISH_CATFISH] = {13 ,22},
[FISH_BASSFISH] = {10 ,30}
},

FISH_DEPTH = {
[FISH_DAMSELFISH] = {0 ,224},
[FISH_GOLDFISH] = {0 ,525},
[FISH_SNAPPER] = {30 ,525},
[FISH_RAINBOW] = {500 ,672},
[FISH_GOLDENFISH] = {670 ,780},
[FISH_CATFISH] = {600 ,800},
[FISH_BASSFISH] = {666 ,999}
},

FISH_ENABLED = {
[FISH_DAMSELFISH] = true,
[FISH_GOLDFISH] = true,
[FISH_SNAPPER] = true,
[FISH_RAINBOW] = true,
[FISH_GOLDENFISH] = true,
[FISH_CATFISH] = true,
[FISH_BASSFISH] = true,
[FISH_JUNK] = true
},

FISH_PRICE = {
[FISH_DAMSELFISH] = 50,
[FISH_GOLDFISH] = 50,
[FISH_SNAPPER] = 65,
[FISH_RAINBOW] = 80,
[FISH_GOLDENFISH] = 85,
[FISH_CATFISH] = 95,
[FISH_BASSFISH] = 110,
[FISH_JUNK] = 10,
},

GEAR_PRICE = {
[FISH_GEAR_BAIT] = 50,
[FISH_GEAR_MEDIUMCAGE] = 750,
[FISH_GEAR_LARGECAGE] = 1500,
[FISH_GEAR_CONTAINER] = 200,
[FISH_GEAR_ROD] = 250,
[FISH_GEAR_FISHFINDER] = 150,
},

GEAR_ENABLED = {
[FISH_GEAR_BAIT] = true,
[FISH_GEAR_MEDIUMCAGE] = true,
[FISH_GEAR_LARGECAGE] = true,
[FISH_GEAR_CONTAINER] = true,
[FISH_GEAR_ROD] = true,
[FISH_GEAR_FISHFINDER] = true,
},

}

// example: TrueFishAddFish("GOLDFISH2", "Gold Fish", "models/props/de_inferno/GoldFish.mdl", {10, 20}, {100, 150}, 50)
function TrueFishAddFish(variableName, name, model, catchTime, depth, price, notDisabled)
	FISH_HIGHNUMBER = FISH_HIGHNUMBER + 1
	_G["FISH_"..variableName] = FISH_HIGHNUMBER
	FishNames[FISH_HIGHNUMBER] = name
	FishModels[FISH_HIGHNUMBER] = model
	TrueFish.FISH_CATCH_TIME[FISH_HIGHNUMBER] = catchTime
	TrueFish.FISH_DEPTH[FISH_HIGHNUMBER] = depth
	TrueFish.FISH_PRICE[FISH_HIGHNUMBER] = price
	TrueFish.FISH_ENABLED[FISH_HIGHNUMBER] = !notDisabled
end

function TrueFishCalculateFish(depth, fullTable)
	local tbl = {}
	for i=1, FISH_HIGHNUMBER do
		if i != FISH_JUNK and TrueFish.FISH_ENABLED[i] and depth > TrueFish.FISH_DEPTH[i][1] and depth < TrueFish.FISH_DEPTH[i][2] then
			tbl[#tbl+1] = i 
		end
	end

	return fullTable and tbl or tbl[math.random(#tbl)]
end
