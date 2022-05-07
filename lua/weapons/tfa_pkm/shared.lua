SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-2,-.2) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "RifleShellEject"-- ShotgunShellEject shotgun or ShellEject for a SMG    
SWEP.UseHands			= false
SWEP.LuaShellEject		= true
SWEP.MoveSpeed = 0.75 --Multiply the player's movespeed by thi
SWEP.IronSightsMoveSpeed = 0.4 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.DryFireDelay = 9999
SWEP.Primary.Force = 0 --Force value, leave nil to autocalc
SWEP.Primary.Knockback = 0 --Autodetected if nil; this is the velocity kickback
SWEP.Primary.DamageType = DMG_BULLET

SWEP.Primary.SpreadMultiplierMax = 10 --How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement = 1/0.5 --What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery = 20--How much the spread recovers, per second. Example val: 3

SWEP.TracerName 		= "er_opfortracer" 
SWEP.TracerCount 		= 1 	--0 disables, otherwise, 1 in X chance

SWEP.Category				= "TFA Campo"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= "High rate of fire and average damage. Close range. Has higher penetration potential."
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "ПКМ"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.VMPos = Vector(0,3,-1) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.SelectiveFire		= true
SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_erectanglepkm.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_erectanglepkm.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.RangeFalloff = 0.000001
SWEP.Primary.Range = 8000
SWEP.Primary.Sound			= Sound("erect_pkm.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 650			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 100		-- Size of a clip
SWEP.Primary.DefaultClip		= 200		-- Bullets you start with
SWEP.Primary.KickUp				= 0.6		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.6		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 1		-- Maximum up recoil (stock)
SWEP.Primary.StaticRecoilFactor = 0.7
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 50		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.FireModes = {
	"Auto",
	"Single"
}
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 15	-- Base damage per bullet
SWEP.Primary.Spread		= .07	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .005 -- Ironsight accuracy, should be the same for shotguns
SWEP.Primary.PenetrationMultiplier = 6 --Change the amount of something this gun can penetrate through
SWEP.IronRecoilMultiplier = 0.2 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 1 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-2.215, 7, 0.4)
SWEP.IronSightsAng = Vector(-0.257, 0.039, 0.003)
SWEP.RunSightsPos = Vector(-1.519, 0, -1)
SWEP.RunSightsAng = Vector(-9.146, 10, -14.775)
SWEP.InspectPos = Vector(6.519, 0, -2.56)
SWEP.InspectAng = Vector(-9.146, 49.95, -14.775)

SWEP.Offset = {
        Pos = {
        Up = 1,
        Right = 1,
        Forward = 5,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 1
}

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "body", rel = "", pos = Vector(0.007, -2.671, 0.899), angle = Angle(0, 0, 0), size = Vector(0.006, 0.006, 0.006), color = Color(255, 0, 0, 255), surpresslightning = false, material = "dev/blurentity_alphasilhoutte", skin = 0, bodygroup = {} }
}

if GetConVar("sv_tfa_default_clip") == nil then
	print("sv_tfa_default_clip is missing!  You might've hit the lua limit.  Contact the SWEP author(s).")
else
	if GetConVar("sv_tfa_default_clip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("sv_tfa_default_clip"):GetInt()
	end
end

if GetConVar("sv_tfa_unique_slots") != nil then
	if not (GetConVar("sv_tfa_unique_slots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end



