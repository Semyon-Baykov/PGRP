CH_FireSystem = CH_FireSystem or {}
CH_FireSystem.Config = CH_FireSystem.Config or {}
CH_FireSystem.Config.FiretruckModels = CH_FireSystem.Config.FiretruckModels or {}

-- Set Language
-- Available languages: English: en - French: fr - Danish: da - German: de - Russian: ru - Spanish: es - Chinese: cn
CH_FireSystem.Config.Language = "ru" -- Set the language of the script.

--[[
	General Config
--]]
CH_FireSystem.Config.MaterialTypes = { -- Full list of material types (ground types), that fire can spread on. For example: wood, grass, carpet.
	MAT_DIRT,
	MAT_WOOD,
	MAT_COMPUTER,
	MAT_FOLIAGE,
	MAT_PLASTIC,
	MAT_SAND,
	MAT_SLOSH,
	MAT_TILE,
	MAT_GRASS,
	MAT_VENT,
	'wood/woodfloor007a',
	'de_train/train_grass_floor_01',
	'nature/blendmilground004_2',
	'agency/floor/woodpanel01',
	'props/carpetfloor004a',
	'de_piranesi/marblefloor04',
	'concrete/concretefloor001a',
	'wood/woodfloor001a',
	'wood/woodfloor005a',
	'wood/milroof005',
	'wood/milroof001',
	'carpet/offflrb' -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}
-- List of potential MAT enums: https://wiki.garrysmod.com/page/Enums/MAT

CH_FireSystem.Config.AllowedTeams = { -- This is a list of fire fighter teams. You can add fire chief and stuff like that, and they can do the things fire fighters can.
	-- Please note that this table has to be set up as the one above. If you add more teams, you must add a comma to the team at the top. Only the last team should not have a comma. By default there is only one team, so no comma is needed.
	"Сотрудник МЧС",
}

CH_FireSystem.Config.MaxFires = 4 -- Maximum amount of fires that can spawn/spread. [Default = 250]
CH_FireSystem.Config.RandomFireInterval = 300 -- Interval between random fires are generated around the map. [Default = 300 (5 minutes)]
CH_FireSystem.Config.RemoveAllOnLastDC = true -- Remove all fires when there are no more players on the server (to prevent lag?). [Default = false]
CH_FireSystem.Config.SpreadInterval = 999 -- Time between fire spreads (in seconds). [Default = 120 (2 minutes)]
CH_FireSystem.Config.ExtinguishPay = 500 -- Payment for turning off a fire. [Default = 10]
CH_FireSystem.Config.NotifyOnExtinguish = true -- Send the player a notification that they've received money for extinguishing fire. [Default = true]
CH_FireSystem.Config.AutoTurnOff = 120 -- Fire will automatically turn off after x seconds. 0 and it will burn until put out with extinguisher. [Default = 600/10 minutes]
CH_FireSystem.Config.RandomizeFireSpawn = true -- Will randomize if a fire spawns or not when CH_FireSystem.Config.RandomFireInterval hits 0. true is enabled, false is disabled. [Default = true]
CH_FireSystem.Config.FireFightersRequired = 1 -- How many fire fighters are required before fires will start? [Default = 1]

CH_FireSystem.Config.EnableSmokeEffect = false -- Disable/Enable the smoke effect that emits from fire (true/false) [Default = false]

CH_FireSystem.Config.ExtinguishAllFiresOnFFLeave = true -- Should all fires turn off when the last fire fighter leave their job. [Default = true]

--[[
	Fire Damage Config
--]]
CH_FireSystem.Config.FireFighterDamage = 5 -- The amount of damage fire fighters should take from standing in fire. [Default = 2]
CH_FireSystem.Config.FireDamage = 15 -- The amount of damage everyone else should take from standing in fire. [Default = 4]
CH_FireSystem.Config.VehicleDamage = 5 -- The amount of damage vehicles should take from being in fire. [Default = 6]
CH_FireSystem.Config.DamageInterval = 1 -- The amount of time between taking damage when standing in fire (in seconds). [Default = 0.5]
CH_FireSystem.Config.RemovePropTimer = 10 -- Time amount of seconds before a prop is removed after it ignites (if it is not extinguished). [Default = 10]

CH_FireSystem.Config.BurntPropColor = Color(120, 120, 120, 255) -- If a prop hits the fire, it will set on fire and turn into this color (burnt color). [Default = Color(120, 120, 120, 255)]
CH_FireSystem.Config.IgniteProps = true -- Should props ignite when touched by fire? [Default = true]  
CH_FireSystem.Config.SetPlayersOnFire = false -- Should players actually ignite when touched by fire? [Default = true]
CH_FireSystem.Config.PlayerOnFireDuration = 10 -- Amount of seconds the player should be on fire? [Default = 10]

CH_FireSystem.Config.EnableSmokeDamage = false -- Basically changes the distance between fire and player before damage is taken. For realistic, say it's the smoke "killing" the player.

--[[
	Firetruck NPC Config
--]]
CH_FireSystem.Config.NPCModel = "models/odessa.mdl" -- This is the model of the NPC to get a firetruck from.
CH_FireSystem.Config.MaxTrucks = 1 -- The maximum amount of firetrucks allowed in total on the server.
CH_FireSystem.Config.UseRequiredULXRanks = false -- Should the firetrucks be restricted by ulx ranks? [Default = true]

CH_FireSystem.Config.NPCDisplayName = "_" -- NAME (text for overhead display)
CH_FireSystem.Config.NPCDisplayDescription = "_" -- Text for overhead display
CH_FireSystem.Config.OverheadTextDisplay = false -- Should the new overhead text display show?
CH_FireSystem.Config.OverheadSpinningBubble = false -- Should the chat bubble model spin on top of the firetruck NPC?
CH_FireSystem.Config.DistanceTo3D2D = 400000 -- Distance between player and supply crate/money bag before text appears.

--[[
	Fire Axe Config
--]]
CH_FireSystem.Config.AxeFireRange = 450 -- If there is fire within this range of the door, firefighters can open it. [Default = 450]
CH_FireSystem.Config.AxePlayerDamage = 10 -- How much damage should the fire axe do to players. [Default = 5 (0 for disabled)]

--[[
	Fire Pyro Job
--]]
CH_FireSystem.Config.EnablePyroJob = false -- If you want to enable the pyro job and the cheap molotov cocktail, set this to true. If not, set it to false. [Default = true]

--[[
	Fire Extinguisher Citizen
--]]
CH_FireSystem.Config.FireExtRemoveTimer = 180 -- The amount of seconds before the fire fighter is removed from the citizen after he start using it. [Default = 20 (Recommended)]
CH_FireSystem.Config.ExtinguishCitizenPay = 4 -- Payment for turning off a fire as a non-firefighter. [Default = 4]

--[[
	Fire Extinguish Config
--]]
CH_FireSystem.Config.ExtinguisherRandomSpeed = math.random( 3, 5 ) -- Modify the amount of "damage" the extinguisher will do to fire. Default means between 1 and 3. To make it faster put for example math.random( 3, 5 )
CH_FireSystem.Config.HoseRandomSpeed = math.random( 4, 6 ) -- Modify the amount of "damage" the fire hose will do to fires. Keep in mind the "Weapons DLC" is required to get the fire hose.

--[[
	Fire Extinguisher Cabinet
--]]
CH_FireSystem.Config.CabinetCooldown = 15 -- Cooldown between taking a fire extinguisher from the cabinet. IN SECONDS