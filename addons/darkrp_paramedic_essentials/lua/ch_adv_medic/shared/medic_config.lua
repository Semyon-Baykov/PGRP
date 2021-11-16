CH_AdvMedic = CH_AdvMedic or {}
CH_AdvMedic.Config = CH_AdvMedic.Config or {}
CH_AdvMedic.Config.Design = CH_AdvMedic.Config.Design or {}

-- SET LANGUAGE
-- Available languages: English: en - French: fr - Danish: da - German: de - Russian: ru - Spanish: es - Portuguese: pl - Chinese: cn - Turkish: tr
CH_AdvMedic.Config.Language = "ru" -- Set the language of the script.

-- General Config
CH_AdvMedic.Config.AllowedTeams = { -- This is a list of paramedic teams. They can access the ambulance NPC and get the new health kit.
	"Сотрудник МЧС"
}

CH_AdvMedic.Config.DeadCanHearPlayersVoiceDistance = 250000 -- Dead players can hear alive players voices within a distance

CH_AdvMedic.Config.NotificationTime = 6 -- Amount of seconds notifications display for this addon.

-- Recharge Stations
CH_AdvMedic.Config.DefaultCharges = 15 -- Amount of charges the recharge stations has when they spawns on startup.
CH_AdvMedic.Config.RegainTime = 20 -- Amount of minutes between the recharge stations regains their 10 recharges.
CH_AdvMedic.Config.RegainCharges = 15 -- Amount of charges the recharge stations regain after the 'RegainTime'
CH_AdvMedic.Config.NotifyMedics = true -- Should all the teams in the table above be notified when it has regained it's recharges. 

-- Health Kit
CH_AdvMedic.Config.MedkitHealDelay = 1.7 -- Amount of seconds between healing yourself/others. [Default = 1.7]
CH_AdvMedic.Config.MinHealthToGive = 10 -- Minimum amount of health to give when healing others/yourself.
CH_AdvMedic.Config.MaxHealthToGive = 25 -- Maximum amount of health to give when healing others/yourself.
CH_AdvMedic.Config.MinimumCharge = 25 -- Percentage % the medkit must be below before the medics can recharge.

CH_AdvMedic.Config.HealDistanceToTarget = 6000 -- Distance between the medic and target to heal them?

-- Defibrillator Config
CH_AdvMedic.Config.DefibrillatorDelay = 2 -- Amount of seconds between using the defibrillator swep.(Don't go below 2!)
CH_AdvMedic.Config.UnconsciousTime = 45 -- Amount of seconds a player is unconscious if killed.
CH_AdvMedic.Config.UnconsciousIfNoMedicTime = 45 -- Amount of seconds a player is unconscious if killed while there are no medics.

CH_AdvMedic.Config.BecomeDarkerWhenDead = true -- Should the screen go more and more dark/black once you get knocked unconscious?
CH_AdvMedic.Config.DarkestAlpha = 210 -- How dark will it get once you die? All black alpha is 255

CH_AdvMedic.Config.RevivalReward = 250 -- How much a medic earns from reviving a player WITHOUT a life alert.

CH_AdvMedic.Config.EnableDeathMoaning = false -- Should players emit death moaning sounds while laying unconscious?
CH_AdvMedic.Config.DisableChatWhenDead = false -- Should the dead player be able to use their chat while unconscious?

CH_AdvMedic.Config.ClickToRespawn = false -- Should the player click to respawn after the time runs out or instantly respawn?

CH_AdvMedic.Config.RevivalFailChance = 25 -- How high is the chance that a revival attempt will fail? 25% fail chance by default.

CH_AdvMedic.Config.ReviveDistanceToTarget = 8000 -- Distance between the medic and target/body to revive them?

-- Life Alert
CH_AdvMedic.Config.LifeAlertIcon = Material( "icon16/heart_delete.png" ) -- The icon to appear on the player when dead if he/she has a life alert. LIST HERE: http://www.famfamfam.com/lab/icons/silk/preview.php
CH_AdvMedic.Config.LifeAlertRevivalReward = 500 -- How much a medic earns from reviving a player WITH a life alert.
CH_AdvMedic.Config.LifeAlertNotifyMedic = true -- Notify paramedics about location of dead bodies with life alerts.
CH_AdvMedic.Config.AutoLifeAlert = false -- Enabling this will "give" every player a life alert automatically and remove it from the F4 menu.

CH_AdvMedic.Config.LifeAlertDistance = true -- Should the life alert icon and distance show on bodies with a life alert?
CH_AdvMedic.Config.LifeAlertHalo = true -- Should bodies with a life alert glow with a red halo for medics to see on the map?
CH_AdvMedic.Config.LifeAlertHaloColor = Color( 255, 0, 0, 255 ) -- Color of the halo on dead bodies.

-- Ambulance NPC Configuration
CH_AdvMedic.Config.VehicleModel = "models/lonewolfie/ford_f350_ambu.mdl" -- This is the model for the ambulance.
CH_AdvMedic.Config.VehicleScript = "scripts/vehicles/lwcars/ford_f350_ambu.txt" -- This is the vehicle script for the vehicle.
CH_AdvMedic.Config.VehicleSkin = 0 -- 0 = default, 1 = evo city, 2 = rockford, 3 = paralake, 4 = all white, 5 = zebra, 6 = spirals, 7 = camoflage, 8 = all black
CH_AdvMedic.Config.AmbulanceHealth = 0 -- The amount of health the ambulance has.

CH_AdvMedic.Config.NPCModel = "models/kleiner.mdl" -- This is the model of the NPC to get a ambulance from.
CH_AdvMedic.Config.MaxTrucks = 0 -- The maximum amount of ambulances allowed.

-- Health NPC Configuration
CH_AdvMedic.Config.HealthNPCModel = "models/breen.mdl" -- This is the model of the NPC to regain health.
CH_AdvMedic.Config.HealthPrice = 10000 -- This is the price for full health via the NPC.
CH_AdvMedic.Config.ArmorPrice = 0 -- This is the price for full armor via the NPC.

CH_AdvMedic.Config.OnlyWorkIfNoMedics = true -- Only allow players to heal/armor via the NPC if there are NO medics. Else defaults to config below!
CH_AdvMedic.Config.RequiredMedics = 1 -- Amount of players from the teams in the table (CH_AdvMedic.Config.AllowedTeams). Default is 1 required medic/paramedic/doctor available before you can use the health npc.
CH_AdvMedic.Config.MaximumArmor = 0 -- Maximum amount of armor the armor kit entities can heal a player to.

CH_AdvMedic.Config.NPCSellHealth = true -- Should the health NPC sell health or not? Allows you to disable it if set to false.
CH_AdvMedic.Config.NPCSellArmor = false -- Should the health NPC sell armor or not? Allows you to disable it if set to false.

-- Rank Death Times
CH_AdvMedic.Config.EnableRankDeathTimes = false -- If this feature should be enabled or not (Works only with ULX, SAM & ServerGuard).

CH_AdvMedic.Config.RankDeathTime = {
	{ UserGroup = "user", Time = 45 },
	{ UserGroup = "vip", Time = 30 }
}

-- Chat Commands
CH_AdvMedic.Config.AdminReviveCommand = "!revive" -- Command for admins to revive themselves when unconscious

-- Damage and Injuries System
CH_AdvMedic.Config.EnableInjurySystem = false -- Should the injury system be enabled or not?
CH_AdvMedic.Config.HitsBeforeInjuries = 3 -- Amount of hits from bullets the player can take before he will start to get injured.

CH_AdvMedic.Config.DisableInjuriesForCertainTeams = true -- If this is enabled, the teams below WILL NOT receive injuries when damaged.
CH_AdvMedic.Config.ImmuneInjuriesTeams = { -- The teams that won't get injuried if the config above is enabled.
	"Администратор",
	"есус",
	"Ивентор"
}

CH_AdvMedic.Config.MinHealthFixInjury = 75 -- When healing what's the minimum amount of health a player must have before an injury is fixed.

CH_AdvMedic.Config.BrokenLegWalkSpeed = 100 -- Changes the players walk speed when their leg is broken. Default in DarkRP is 160.
CH_AdvMedic.Config.BrokenLegRunSpeed = 120 -- Same as above but for run speed. Default in DarkRP is 240.

CH_AdvMedic.Config.InternalBleedingInterval = 15 -- Interval between bleedings taking damage from the player slowly.
CH_AdvMedic.Config.DamageFromBleedingMin = 2 -- Minimum amount of damage taken every time the player bleeds from injury.
CH_AdvMedic.Config.DamageFromBleedingMax = 10 -- Maximum amount of damage taken every time the player bleeds from injury.
CH_AdvMedic.Config.EnableBleedingHurtSounds = true -- Should the "im hurt" sounds be enabled when a person is bleeding from injury.

CH_AdvMedic.Config.DisallowedBrokenArmWeapons = { -- List of weapons that cannot be equipped with a broken arm!
	"tfa_g36",
	"tfa_m416",
	"tfa_scar",
	"tfa_tar21",
	"tfa_ak47",
	"tfa_ak74",
	"tfa_an94",
	"tfa_val",
	"tfa_vikhr",
	"tfa_aek971",
	"tfa_ak12",
	"tfa_ak74m",
	"tfa_akm",
	"tfa_akms",
	"tfa_aks74",
	"tfa_aks74y",
	"tfa_aks74u",
	"tfa_mosin9130",
	"tfa_ots2",
	"tfa_pkm",
	"tfa_ppsh41",
	"tfa_rpk",
	"tfa_sks",
	"tfa_saiga12",
	"tfa_vss",
	"tfa_dragunov",
	"tfa_svt40",
	"tfa_svu",
	"tfa_honeybadger",
	"tfa_smgp90",
	"tfa_mp5",
	"tfa_mp7",
	"tfa_ump45",
	"tfa_usc",
	"tfa_kac_pdw",
	"tfa_vector",
	"tfa_mp40",
	"tfa_sten",
	"tfa_uzi",
	"tfa_bizonp19",
	"tfa_vityaz19"
}

-- Design Configuration
CH_AdvMedic.Config.Design.BackgroundColor = Color( 20, 20, 20, 230 )

CH_AdvMedic.Config.Design.HeaderColor = Color( 48, 151, 209, 125 )
CH_AdvMedic.Config.Design.HeaderOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.SecondHeaderColor = Color( 200, 0, 0, 125 )
CH_AdvMedic.Config.Design.SecondHeaderOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.ChargesLeftColor = Color( 48, 151, 209, 125 )
CH_AdvMedic.Config.Design.ChargesLeftOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.RechargeKeyColor = Color( 200, 0, 0, 125 )
CH_AdvMedic.Config.Design.RechargeKeyOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.BottomTextColor = Color( 48, 151, 209, 125 )
CH_AdvMedic.Config.Design.BottomTextOutline = Color( 0, 0, 0, 255 )

-- Alternative Gender Models
-- This is here so you can set genders for models male/female models that are not default from GMod. So that they will moan with the correct gender once dead.
-- If a gender is not defined it will return as a male always.
CH_AdvMedic.Config.AlternativeMaleModels = {
	"models/humans/male_gestures.mdl",
	"models/humans/male_postures.mdl",
	"models/humans/male_shared.mdl",
	"models/humans/male_ss.mdl"
}

CH_AdvMedic.Config.AlternativeFemaleModels = {
	"models/humans/female_gestures.mdl",
	"models/humans/female_postures.mdl",
	"models/humans/female_shared.mdl",
	"models/humans/female_ss.mdl"
}