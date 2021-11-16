--[[
models/craphead_scripts/ocrp2/props_meow/weapons/c_axe.mdl
models/craphead_scripts/ocrp2/props_meow/weapons/w_axe.mdl

Recommended FOV 75

Sequences (30fps):
idle	ACT_VM_IDLE
use	ACT_VM_PRIMARYATTACK
draw	ACT_VM_DRAW

Hold type: melee2
--]]

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName = "Fire Axe"
	SWEP.Slot = 2
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Crap-Head" 
SWEP.Instructions = "Use the axe to open doors in case of fire."
SWEP.Category = "DarkRP Fire System"

SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/craphead_scripts/ocrp2/props_meow/weapons/c_axe.mdl"
SWEP.WorldModel = "models/craphead_scripts/ocrp2/props_meow/weapons/w_axe.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType("melee2")
end

function SWEP:Deploy()
    self:SetHoldType( "melee2" )
	self:SendWeaponAnim( ACT_VM_DRAW )
	-- 76561198051291901
end

function SWEP:PrimaryAttack()	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:EmitSound( "npc/vort/claw_swing" .. math.random( 1, 2 ) .. ".wav" )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	
	if self.Owner:EyePos():Distance( tr.HitPos ) > 75 then 
		return 
	end
	
	if tr.MatType == MAT_GLASS then
		self.Weapon:EmitSound("physics/glass/glass_cup_break" .. math.random( 1, 2 ) .. ".wav")
		return
	elseif tr.HitWorld then
		self.Weapon:EmitSound("physics/metal/metal_canister_impact_hard" .. math.random( 1, 3 ) .. ".wav")
		return
	end
	
	if ent:IsPlayer() or ent:IsNPC() then
		self.Weapon:EmitSound("physics/flesh/flesh_impact_hard" .. math.random( 1, 6 ) .. ".wav")
		
		if SERVER then
			ent:TakeDamage( CH_FireSystem.Config.AxePlayerDamage )
		end
	elseif ent:isDoor() then
		self.Weapon:EmitSound("physics/wood/wood_box_impact_hard" .. math.random( 1, 3 ) .. ".wav")
		
		local NearFire = false
		for k, v in pairs(ents.FindInSphere(ent:GetPos(), CH_FireSystem.Config.AxeFireRange)) do
			if v:GetClass() == "fire" then
				NearFire = true
			end
		end
		
		if NearFire then
			ent.DoorHealth = ent.DoorHealth or math.random( 4, 6 )
			ent.DoorHealth = ent.DoorHealth - 1
			
			if ent.DoorHealth <= 0 then
				ent.DoorHealth = nil
				
				if SERVER then
					ent:Fire("unlock", "", 0)
					ent:Fire("open", "", 0.5)
				end
			end
		else
			if SERVER then
				DarkRP.notify(self.Owner, 1, 5,  "Рядом нету огня.")
			end
		end
	elseif IsValid( ent ) and ent:GetClass() == "func_breakable_surf" then
		if SERVER then
			ent:Fire( "Shatter" )
		end
	elseif ent.fadeActivate then
		local NearFire = false
		for k, v in pairs(ents.FindInSphere(ent:GetPos(), CH_FireSystem.Config.AxeFireRange)) do
			if v:GetClass() == "fire" then
				NearFire = true
			end
		end
		
		if NearFire then
			if not ent.fadeActive then
				local FadeRandomize = math.random( 1,3 )

				if tonumber( FadeRandomize ) == 2 then
					ent:fadeActivate()
					timer.Simple( 5, function() 
						if IsValid( ent ) and ent.fadeActive then 
							ent:fadeDeactivate() 
						end 
					end )
					self.Owner:EmitSound( "physics/wood/wood_box_impact_hard" .. math.random( 1, 3 ) .. ".wav" )
				else
					if SERVER then
						DarkRP.notify(self.Owner, 1, 5, "Вы не можете выбить эту ФД!")
						return
					end
				end
			end
		else
			if SERVER then
				DarkRP.notify(self.Owner, 1, 5,  "Рядом нету огня. Вы не можете выбить эту дверь.")
			end
		end
	end
end

function SWEP:SecondaryAttack()
end