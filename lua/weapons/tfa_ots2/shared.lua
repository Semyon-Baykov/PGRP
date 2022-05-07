-- Variables that are used on both client and server
SWEP.Gun = ("tfa_ots2") -- must be the name of your swep but NO CAPITALS!
SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-1,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "ShellEject"-- ShotShellEject shotgun or ShellEject for a SM

SWEP.Category				= "TFA Campo" --Category where you will find your weapons
SWEP.Author				= "Campo"
SWEP.Contact				= "ostankov2002@gmail.com"
SWEP.Purpose				= "Kill everyone, who stand on your way."
SWEP.Instructions				= "Kill everyone, who stand on your way."
SWEP.PrintName				= "ОЦ-02 «Кипарис»"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 40			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 1.6		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.CSMuzzleFlashes = true
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_xoma_x4_smg_ots02.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_xoma_x4_smg_ots02.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= true
SWEP.Base					= "tfa_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE! 
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.AccurateCrosshair = false

SWEP.Primary.Sound			= Sound("Weapon_Xoma_X4_OTS02.Fire")		-- Script that calls the primary fire sound
SWEP.Primary.SilencedSound 	= Sound("")		-- Sound if the weapon is silenced
SWEP.Primary.RPM			= 850		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.47		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.40		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.47		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Penetration                = true

SWEP.SelectiveFire		= true
SWEP.CanBeSilenced		= false

SWEP.BurstFireAvailable = false
SWEP.DisableBurstFire = true
SWEP.NumBurstShots = 0
SWEP.CanGoFullAuto = true
SWEP.ClipSwapAvailable = false
SWEP.PSSAvailable = true
SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 20	-- Base damage per bullet
SWEP.Primary.Spread		= .022	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .014 -- Ironsight accuracy, should be the same for shotguns

SWEP.SightsPos = Vector(-2.4664, -3.4231, 0.7983)
SWEP.SightsAng = Vector(0.158, 0.2228, 0)

SWEP.RunSightsPos = Vector(5.0658, -4.7952, -1.9566)
SWEP.RunSightsAng = Vector(-6.3461, 61.6725, -19.8289)

if GetConVar("M9KDefaultClip") == nil then
	print("M9KDefaultClip is missing! You may have hit the lua limit!")
else
	if GetConVar("M9KDefaultClip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("M9KDefaultClip"):GetInt()
	end
end

if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end