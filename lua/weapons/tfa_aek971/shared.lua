-- Variables that are used on both client and server
SWEP.Gun = ("tfa_aek971") -- must be the name of your swep but NO CAPITALS!
SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-1,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = {
        ["bolt"] = { scale = Vector(1, 1, 1), pos = Vector(-5, 0, 0), angle = Angle(0, 0, 0) }
} --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "RifleShellEject"-- ShotgunShellEject shotgun or ShellEject for a SMG
SWEP.UseHands                   = false
SWEP.LuaShellEject              = true    

SWEP.Category                           = "TFA Campo"
SWEP.Author                             = ""
SWEP.Contact                            = ""
SWEP.Purpose                            = ""
SWEP.Instructions                               = ""
SWEP.MuzzleAttachment                   = "1"   -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment                       = "2"   -- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName                          = "АЕК-971"             -- Weapon name (Shown on HUD)   
SWEP.Slot                               = 3                             -- Slot in the weapon selection menu
SWEP.SlotPos                            = 22                    -- Position in the slot
SWEP.DrawAmmo                           = true          -- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox                  = false         -- Should draw the weapon info box
SWEP.BounceWeaponIcon                   =       false   -- Should the weapon icon bounce?
SWEP.DrawCrosshair                      = true          -- set false if you want no crosshair
SWEP.Weight                             = 30                    -- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo                       = true          -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom                     = true          -- Auto switch from if you pick up a better weapon
SWEP.HoldType                           = "ar2"         -- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-1,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_PistolMode_Disabled = {
        [ACT_VM_RELOAD] = true,
        [ACT_VM_RELOAD_EMPTY] = true,
        [ACT_VM_DRAW_EMPTY] = true,
        [ACT_VM_IDLE_EMPTY] = true,
        [ACT_VM_HOLSTER_EMPTY] = true,
        [ACT_VM_DRYFIRE] = true
}
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = ""

SWEP.SelectiveFire              = true

SWEP.ViewModelFOV                       = 70
SWEP.ViewModelFlip                      = false
SWEP.ViewModel                          = "models/weapons/v_rif_aek97.mdl"      -- Weapon view model
SWEP.WorldModel                         = "models/weapons/w_rif_aek97.mdl"      -- Weapon world model
SWEP.ShowWorldModel                     = false
SWEP.Base                               = "tfa_gun_base"
SWEP.Spawnable                          = true
SWEP.AdminSpawnable                     = true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound = Sound ("Weapons/aek/fire.wav")             -- Script that calls the primary fire sound
SWEP.Primary.RPM                        = 900                   -- This is in Rounds Per Minute
SWEP.Primary.ClipSize                   = 30            -- Size of a clip
SWEP.Primary.DefaultClip                = 60           -- Bullets you start with
SWEP.Primary.KickUp                             = 0.4          -- Maximum up recoil (rise)
SWEP.Primary.KickDown                   = 0.18          -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal             = 0.18          -- Maximum up recoil (stock)
SWEP.Primary.Automatic                  = true          -- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo                       = "ar2"                 -- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV                  = 65            -- How much you 'zoom' in. Less is more!        

SWEP.data                               = {}                            --The starting firemode
SWEP.data.ironsights                    = 1

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots   = 1             -- How many bullets to shoot per trigger pull
SWEP.Primary.Damage             = 22    -- Base damage per bullet
SWEP.Primary.Spread             = .045  -- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .011 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-2.651, -0.403, 0.201)
SWEP.IronSightsAng = Vector(0.75, 0.6, 0)
SWEP.SightsPos = Vector(-2.651, -0.403, 0.201)
SWEP.SightsAng = Vector(0.75, 0.6, 0)
SWEP.RunSightsPos = Vector(1.679, 0, -0.04)
SWEP.RunSightsAng = Vector(-8.443, 18.291, 0)
SWEP.InspectPos = Vector(4.76, -2.412, -2.01)
SWEP.InspectAng = Vector(11.96, 42.915, 0)

SWEP.WElements = {
        ["aek971"] = { type = "Model", model = "models/weapons/w_rif_aek97.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.518, 0.518, 0.518), angle = Angle(-5.844, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}