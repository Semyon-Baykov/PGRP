--[[
models/craphead_scripts/ocrp2/props_meow/weapons/c_molotov.mdl
models/craphead_scripts/ocrp2/props_meow/weapons/w_molotov.mdl

FOV  75

Hold type grenade

sequences(30fps):
idle	ACT_VM_IDLE
throw	ACT_VM_PRIMARYATTACK
draw	ACT_VM_DRAW

attachment point name:   attachment
--]]

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Molotov Cocktail"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Crap-Head"
SWEP.Instructions = "Left Click: Throw Molotov"
SWEP.Category = "DarkRP Fire System"

SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false
SWEP.UseHands	= true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/craphead_scripts/ocrp2/props_meow/weapons/c_molotov.mdl"
SWEP.WorldModel = "models/craphead_scripts/ocrp2/props_meow/weapons/w_molotov.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")
end

function SWEP:Deploy()
    self:SetHoldType( "grenade" )
	self:SendWeaponAnim( ACT_VM_DRAW )
	-- 76561198051291901
end

function SWEP:PrimaryAttack()	
	local ent = self.Owner:GetEyeTrace().Entity

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:EmitSound( "npc/vort/claw_swing" .. math.random( 1, 2 ) .. ".wav" )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	self:SetNextPrimaryFire( CurTime() + 2 )
	self:SetNextSecondaryFire( CurTime() + 2 )
	
	if SERVER then
		local MolotovObject = ents.Create( "fire_molotov_object" )
		MolotovObject:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 20 )
		MolotovObject:Spawn()
		MolotovObject:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * 1400 )
		
		timer.Simple( 1, function()
			if IsValid( self ) then
				self.Owner:StripWeapon( "fire_molotov" )
			end
		end )
	end
end