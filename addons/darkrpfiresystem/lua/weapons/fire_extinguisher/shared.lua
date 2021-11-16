if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Fire Extinguisher"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Crap-Head"
SWEP.Instructions = "Aim at a fire to extinguish it.\nLeft Click: Extinguish Fires"
SWEP.Category = "DarkRP Fire System"

SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/craphead_scripts/ocrp2/props_meow/weapons/c_extinguisher.mdl"
SWEP.WorldModel = "models/craphead_scripts/ocrp2/props_meow/weapons/w_extinguisher.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType( "normal" ) -- else use "normal"
	local Len = self:SequenceDuration( self:SelectWeightedSequence( ACT_VM_DRAW ) )

    self:SendWeaponAnim( ACT_VM_DRAW )
    self:SetNextPrimaryFire( CurTime() + Len )

    --if CLIENT then
	--	local Vm = self.Owner:GetViewModel()
	--	Vm:SetModel( self.ViewModel )
    --end
end

function SWEP:PrimaryAttack()
	if self:WaterLevel() > 0 then
		return
	end
	
	if SERVER then
		if not table.HasValue( CH_FireSystem.Config.AllowedTeams, team.GetName( self.Owner:Team() ) ) then
			if not self.HasBeenActivated then
				timer.Simple( CH_FireSystem.Config.FireExtRemoveTimer, function()
					if IsValid( self ) then
						if IsValid( self.Owner ) then
							if self.Owner:HasWeapon( "fire_extinguisher" ) then
								self.Owner:StripWeapon( "fire_extinguisher" )
								DarkRP.notify( self.Owner, 1, 5,  "Ваш огнетушитель пропал." )
							end
						end
					end
				end)
				DarkRP.notify( self.Owner, 1, 5,  "Вы взяли огнетушитель! Он пропадёт через ".. CH_FireSystem.Config.FireExtRemoveTimer .." секунд." )
			end
			self.HasBeenActivated = true
		end
	end
	
	self.Weapon:EmitSound( Sound("ambient/wind/wind_hit2.wav") )
	self.Attacking = true

	local Len = self:SequenceDuration( self:SelectWeightedSequence( ACT_VM_PRIMARYATTACK ) )

	timer.Simple( Len, function()
		if IsValid( self ) and IsValid( self.Owner ) then
			if IsValid( self.Owner:GetActiveWeapon() ) then
				if self.Owner:GetActiveWeapon():GetClass() == "fire_extinguisher" then
					if self.Owner:KeyDown( IN_ATTACK ) then
						self:SendWeaponAnim( ACT_VM_RECOIL1 )
					end
				end
			end
		end
	end )
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:SetNextPrimaryFire( CurTime() + Len )
	
	self.Weapon:SendWeaponAnim( ACT_VM_RECOIL1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + .1 )
	
	local ExtinguishEffect = EffectData()
	ExtinguishEffect:SetAttachment( 1 )
	ExtinguishEffect:SetEntity( self.Owner )
	ExtinguishEffect:SetOrigin( self.Owner:GetShootPos() )
	ExtinguishEffect:SetNormal( self.Owner:GetAimVector() )
	util.Effect( "extinguish", ExtinguishEffect )
	
	if SERVER then
		local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150
		trace.filter = self.Owner

		local tr = util.TraceLine( trace )
		
		for k, v in pairs( ents.FindInSphere( tr.HitPos, 50 ) ) do
			if v:GetClass() == "fire" then
				v:ExtinguishAttack( self.Owner, false )
			end
			
			if v:IsOnFire() then 
				v:Extinguish()
				v:SetColor( Color( 255, 255, 255, 255 ) )
			end
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	if self.Owner:KeyDown( IN_ATTACK ) then
		-- do nothing
	else
		if self.Attacking then
			self.Attacking = false

			local Len = self:SequenceDuration( self:SelectWeightedSequence( ACT_VM_SECONDARYATTACK ) )
			self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			self:SetNextPrimaryFire( CurTime() + Len )
		end
	end
end