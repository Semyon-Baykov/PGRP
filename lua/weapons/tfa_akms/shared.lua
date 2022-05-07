SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(.1,-1,-.1) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "RifleShellEject"-- ShotgunShellEject shotgun or ShellEject for a SMG    
SWEP.UseHands			= false
SWEP.LuaShellEject		= true

SWEP.Category				= "TFA Campo"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= "Medium firing rate and high damage. Medium Range."
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "АКМС"		-- Weapon name (Shown on HUD)	
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

SWEP.SelectiveFire		= true
SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_rif_akms.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_akms.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/cw_akms/akmsfire.wav")
SWEP.Primary.RPM			= 560			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 1		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.5		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.2		-- Maximum up recoil (stock)
SWEP.Primary.StaticRecoilFactor = 0.7
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.FireModes = {
	"Auto",
	"Single"
}
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 28	-- Base damage per bullet
SWEP.Primary.Spread		= .03	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .006 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-2.28, -3.82, 0.25)
SWEP.IronSightsAng = Vector(0.79, 0, 0)
SWEP.RunSightsPos = Vector(6.519, 0, -2.56)
SWEP.RunSightsAng = Vector(-9.146, 49.95, -14.775)
SWEP.InspectPos = Vector(6.519, 0, -2.56)
SWEP.InspectAng = Vector(-9.146, 49.95, -14.775)

SWEP.Offset = {
        Pos = {
        Up = 1,
        Right = 1,
        Forward = 3,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 0.85
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
