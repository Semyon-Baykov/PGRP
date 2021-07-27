
AddCSLuaFile()

game.AddAmmoType(	{	name	=	"545x39mmwp",	dmgtype	=	DMG_BULLET	}	)

sound.Add({	name		= "INS1on_AKS74U.Single",
	channel		= CHAN_WEAPON,
	volume		= 1.0,
	level		= 140,
	pitch		= { 95, 105 },
	sound		= "weapons_ins/aks74u/aks74u-fire.wav",
})

if (CLIENT) then
	local	_SELFENTNAME	= "ins_aks74u"
	local	_INFONAME		= "AKS-74U"
	SWEP.Category			= "Insurgency"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "Zoey"
	SWEP.Contact        	= ""
	SWEP.Instructions 		= ""
	SWEP.Slot 				= 2
	SWEP.SlotPos 			= 0
	SWEP.ViewModelFOV		= 70
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/hud/" .. _SELFENTNAME )

	language.Add( _SELFENTNAME, _INFONAME )	
	killicon.Add( _SELFENTNAME, "vgui/entities/".. _SELFENTNAME , Color( 255, 255, 255 ) )
end

SWEP.Gun					= ("ins_aks74u_npc")

SWEP.Weight					= 8
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= true
SWEP.XHair					= false
SWEP.BoltAction				= false
SWEP.HoldType 				= "ar2"

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.WorldModel				= Model("models/weapons/ins_aks74u_w.mdl")
SWEP.MuzzleAttachment		= "1"
SWEP.Base 					= "npc_pyrous_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable				= false
SWEP.AdminOnly				= true

SWEP.Primary.Sound			= Sound( "INS1on_AKS74U.Single" )
SWEP.Primary.RPM			= 692			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize		= 30		-- Size of a clip
SWEP.Primary.DefaultClip	= 60		-- Bullets you start with
SWEP.Primary.KickUp			= 0.4		-- Maximum up recoil (rise)
SWEP.Primary.KickDown		= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal	= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic		= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "545x39mmwp"
SWEP.SelectiveFire			= false
SWEP.CanBeSilenced			= false

SWEP.Secondary.IronFOV		= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 					= {}				--The starting firemode
SWEP.data.ironsights		= 1

SWEP.Primary.Damage			= 6 --base damage per bullet
SWEP.Primary.Spread			= 0.013	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy 	= 0.01 -- ironsight accuracy, should be the same for shotguns

-- enter iron sight info and bone mod info below
SWEP.IronSightsPos			= Vector(0,0,0)
SWEP.IronSightsAng			= Vector(0,0,0)
SWEP.SightsPos				= Vector(0,0,0)
SWEP.SightsAng				= Vector(0,0,0)
SWEP.RunSightsPos			= Vector(0,0,0)
SWEP.RunSightsAng			= Vector(0,0,0)

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then self:NpcReload()	return end 
	if !self.Owner:GetEnemy() then return end 
	if self.Owner:GetEnemy():GetClass() == "npc_headcrab" or self.Owner:GetEnemy():GetClass() == "npc_headcrab_fast" or self.Owner:GetEnemy():GetClass() == "npc_headcrab_black" then
		self:PrimaryAttackRunning()
	return end
	self:EmitSound(self.Primary.Sound)
	local fx 		= EffectData()
		fx:SetEntity(self)
		fx:SetOrigin(self.Owner:GetShootPos())
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(self.MuzzleAttachment)
	if GetConVar("M9KGasEffect") != nil then
		if GetConVar("M9KGasEffect"):GetBool() then 
			util.Effect("m9k_rg_muzzle_rifle",fx)
		end
	end
	self:TakePrimaryAmmo( 1 )		
	if self.Owner:GetEnemy() == nil then return end
	if self.Owner:GetEnemy():IsPlayer() == true then
		self.Primary.Damage = 6
	else
		self.Primary.Damage = 10
	end
	local att = self:GetAttachment(self.MuzzleAttachment)
	local posTgt = self.Owner:GetEnemy():LocalToWorld(self.Owner:GetEnemy():OBBCenter()) 
	local angAcc = (posTgt -att.Pos):Angle()
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = Angle(math.ApproachAngle(att.Ang.p,angAcc.p,45),math.ApproachAngle(att.Ang.y,angAcc.y,35),0):Forward()
		bullet.Tracer = 1 
		bullet.Spread = Vector(0.05,0.1,0.1)
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo 
	self.Owner:FireBullets( bullet )
end

function SWEP:PrimaryAttackRunning()
	if self:Clip1() <= 0 then self:NpcReload()	return end 
	self:EmitSound(self.Primary.Sound)
	local fx 		= EffectData()
		fx:SetEntity(self)
		fx:SetOrigin(self.Owner:GetShootPos())
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(self.MuzzleAttachment)
	if GetConVar("M9KGasEffect") != nil then
		if GetConVar("M9KGasEffect"):GetBool() then 
			util.Effect("m9k_rg_muzzle_rifle",fx)
		end
	end
	self:TakePrimaryAmmo( 1 )
	if self.Owner:GetEnemy() == nil then return end
	if self.Owner:GetEnemy():IsPlayer() == true then
		self.Primary.Damage = 6
	else
		self.Primary.Damage = 10
	end
	
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Tracer = 1 
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo 
	self.Owner:FireBullets( bullet )
end

function SWEP:Reload()	end

function SWEP:NpcReload()
	if !self:IsValid() or !self.Owner:IsValid() then return; end
	self.Owner:SetSchedule(SCHED_RELOAD)
end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
	if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end 
	if self.Owner:GetActivity() == 11 then
		self:PrimaryAttackRunning()
	else
		self:PrimaryAttack()
	end
	if self.Owner:GetClass() == "npc_combine_s" then
		timer.Simple(0.15, function()
			if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end
			if (!self.Owner:GetEnemy()) then return; end 
			if self.Owner:GetActivity() == 11 then
				self:PrimaryAttackRunning()
			else
				self:PrimaryAttack()
			end
		end)
	else
		timer.Simple(0.25, function()
			if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end
			if (!self.Owner:GetEnemy()) then return; end 
			if self.Owner:GetActivity() == 11 then
				self:PrimaryAttackRunning()
			else
				self:PrimaryAttack()
			end
		end)
	end
end

if SERVER then

	function SWEP:Initialize()
		self:SetWeaponHoldType("ar2")
		if self.Owner:GetClass() == "npc_citizen" then
			self.Owner:Fire( "DisableWeaponPickup" )
		end

		self.Owner:SetKeyValue( "spawnflags", "256" )
		
		if self.Owner:GetClass() == "npc_combine_s" then
			self:Proficiency()
			hook.Add( "Think", self, self.onThink )
			if self.Owner:LookupSequence("grenThrow") == nil then return end
			local seq = self.Owner:LookupSequence("grenThrow") 
			if self.Owner:GetSequenceName(seq) == "grenThrow" then
				self.Owner:SetKeyValue("NumGrenades", "2") 
			end
		end

	end

	function SWEP:onThink()
		self:NextFire()
	end
		
	function SWEP:NextFire()
		if !self:IsValid() or !self.Owner:IsValid() then return; end

		if self.Owner:GetActivity() == 16 then
			self:NPCShoot_Primary( ShootPos, ShootDir )
			hook.Remove("Think", self)
				
			timer.Simple(0.3, function()
				hook.Add("Think", self, self.NextFire)
			end)
		end
	end

	function SWEP:Proficiency()
		timer.Simple(0.5, function()
			if !self:IsValid() or !self.Owner:IsValid() then return; end
			self.Owner:SetCurrentWeaponProficiency(2)
		end)
	end

	AccessorFunc( SWEP, "fNPCMinBurst",                 "NPCMinBurst" )
	AccessorFunc( SWEP, "fNPCMaxBurst",                 "NPCMaxBurst" )
	AccessorFunc( SWEP, "fNPCFireRate",                 "NPCFireRate" )
	AccessorFunc( SWEP, "fNPCMinRestTime",         "NPCMinRest" )
	AccessorFunc( SWEP, "fNPCMaxRestTime",         "NPCMaxRest" )

	function SWEP:OnDrop()
		self:Remove()
	end

end