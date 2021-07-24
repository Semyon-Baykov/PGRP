-- Variables that are used on both client and server
SWEP.Gun = ("tfa_mosin9130") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "TFA Campo"
SWEP.Author				= "Campo"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Винтовка Мосина"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 24			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"	-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_snip_mwp.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/red orchestra 2/russians/weapons/mn9130.mdl"	-- Weapon world model
SWEP.Base 				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.ShowWorldModel         = false
SWEP.FireModeName = "Bolt-Action"

SWEP.Primary.Sound			= Sound("Weapons/romosin/fire.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 33		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 5	-- Size of a clip
SWEP.Primary.DefaultClip		= 20	-- Default number of bullets in a clip
SWEP.Primary.KickUp			= 3.2				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.1	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= .45

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 70	-- Base damage per bullet
SWEP.Primary.Spread		= .065	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-3.661, 0, 2.24)
SWEP.IronSightsAng = Vector(0, -0.051, 0)
SWEP.SightsPos = Vector(-3.661, 0, 2.24)
SWEP.SightsAng = Vector(0, -0.051, 0)
SWEP.RunSightsPos = Vector(1.84, -7.237, -3.56)
SWEP.RunSightsAng = Vector(21.106, 26.733, 0)
SWEP.InspectPos = Vector(4.239, -2.613, 0.959)
SWEP.InspectAng = Vector(-7.035, 40.101, 0)

SWEP.WElements = {
	["models/red orchestra 2/russians/weapons/mn9130.mdl"] = { type = "Model", model = "models/red orchestra 2/russians/weapons/mn9130.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.987, 0.518, 3.635), angle = Angle(-8.183, 1.169, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
