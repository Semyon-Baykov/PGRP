-- Variables that are used on both client and server
SWEP.Gun = ("tfa_ak12") -- must be the name of your swep but NO CAPITALS!

SWEP.Category				= "TFA Campo"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "АК-12"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType                           = "ar2"         -- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.SelectiveFire              = true

SWEP.ViewModelFOV                       = 65
SWEP.ViewModelFlip                      = false
SWEP.ViewModel                          = "models/weapons/v_rif_ak12.mdl"       -- Weapon view model
SWEP.WorldModel                         = "models/weapons/w_rif_ak12.mdl"       -- Weapon world model
SWEP.ShowWorldModel                     = false
SWEP.Base                               = "tfa_gun_base"
SWEP.Spawnable                          = true
SWEP.AdminSpawnable                     = true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound = Sound ("Weapons/ak12/fire.wav")-- Script that calls the primary fire sound
SWEP.Primary.RPM                        = 650                   -- This is in Rounds Per Minute
SWEP.Primary.ClipSize                   = 30            -- Size of a clip
SWEP.Primary.DefaultClip                = 60           -- Bullets you start with
SWEP.Primary.KickUp                             = 0.28          -- Maximum up recoil (rise)
SWEP.Primary.KickDown                   = 0.18          -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal             = 0.18          -- Maximum up recoil (stock)
SWEP.Primary.Automatic                  = true          -- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo                       = "ar2"                 -- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV                  = 60            -- How much you 'zoom' in. Less is more!        

SWEP.data                               = {}                            --The starting firemode
SWEP.data.ironsights                    = 1

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots   = 1             -- How many bullets to shoot per trigger pull
SWEP.Primary.Damage             = 28    -- Base damage per bullet
SWEP.Primary.Spread             = .035  -- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-3.381, -4.422, 0.72)
SWEP.IronSightsAng = Vector(0, 0.05, 0)
SWEP.SightsPos = Vector (-3.381, -4.422, 0.72)
SWEP.SightsAng = Vector (0, 0.05, 0)
SWEP.RunSightsPos = Vector (1.48, -8.04, -5.72)
SWEP.RunSightsAng = Vector (-4.222, 56.28, -32.362)
SWEP.InspectPos = Vector(6.159, -2.613, -1.201)
SWEP.InspectAng = Vector(0, 39.396, 0)

SWEP.WElements = {
        ["ak12"] = { type = "Model", model = "models/weapons/w_rif_ak12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1, 0), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}