AddCSLuaFile()

SWEP.PrintName = 'Boyar'
SWEP.Base = 'swep_contruction_base'

SWEP.Author = 'Campo & GPortal Team'

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Instructions = 'Use as melee weapon'

SWEP.SwayScale = 4

SWEP.Primary = {
	Ammo = -1,
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false
}

SWEP.Secondary = SWEP.Primary

SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {}
SWEP.HitDistance = 80
SWEP.Melee = true

SWEP.HitDecal = "Impact.Concrete"

SWEP.Sounds = {
	Miss = {
		Sound "Weapon_Crowbar.Single",
	},
	Impact_Flesh = {
		Sound "physics/body/body_medium_break2.wav",
		Sound "physics/body/body_medium_break3.wav",
		Sound "physics/body/body_medium_break4.wav",
	},
	Impact_World = {
		Sound "Weapon_Crowbar.Melee_Hit",
	},
}

SWEP.НелезьSound = Sound( 'boyar/dontgo.wav' )
SWEP.УдарSound = Sound( 'boyar/udar.wav' )
SWEP.РыганиеSound = Sound( 'boyar/riganie.wav' )

SWEP.VElements = {
	["cl_lel"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 2.596, -0.519), angle = Angle(0, 0, -180), size = Vector(1.274, 1.274, 1.274), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}

SWEP.WElements = {
	["lel"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, 0), angle = Angle(0, 0, 180), size = Vector(0.885, 0.885, 0.885), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}

function SWEP:Initialize()
	
	self.BaseClass.Initialize( self )
	
	if SERVER then
	
		self:SetHoldType( self.HoldType )
	
	end
end

function SWEP:Holster()
	
	if self.Рыгание then
		return false
	end
	
	return self.BaseClass.Holster( self )
	
end

function SWEP:Deploy( )
	if SERVER then
		self:SendWeaponAnim( ACT_VM_DEPLOY )
		self:EmitSound( 'boyar/open.wav' )
	end
end

function SWEP:НеЛезьБлятьДебилСукаЕбаный()
	if self.Нелезь and self.Нелезь > CurTime() then
		return
	end
	
	self.Нелезь = CurTime() + SoundDuration( self.НелезьSound ) + 1
	
	self.Owner:EmitSound( self.НелезьSound )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + SoundDuration( self.УдарSound ) + 1 )
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	if SERVER then
		if self.Owner:IsPlayer() then
			self.Owner:LagCompensation( true )
		end
		self.Owner:EmitSound( self.УдарSound )
		
		local dmginfo = DamageInfo()
	
		dmginfo:SetAttacker( self.Owner )
		dmginfo:SetInflictor( self.Weapon )
		dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
		dmginfo:SetDamage( math.random( 15, 20 ) )
		
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner
		})

		if not IsValid( tr.Entity ) then 
			tr = util.TraceHull({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
				filter = self.Owner,
				mins = Vector(-10, -10, -8),
				maxs = Vector(10, 10, 8)
			})
		end
		
		if tr.Hit then
			if tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
				if tr.MatType == MAT_FLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_BLOODYFLESH then
					self:EmitSound(table.Random(self.Sounds.Impact_Flesh), 70, 100)
					ParticleEffect("blood_impact_red_01", tr.HitPos, tr.HitNormal:Angle(), tr.Entity)
				end
			else
				local tr2 = self.Owner:GetEyeTrace()
				
				util.Decal(self.HitDecal, tr2.HitPos + tr2.HitNormal, tr2.HitPos - tr2.HitNormal)
				
				self:EmitSound(table.Random(self.Sounds.Impact_World), 70, 105)
			end
			self:SendWeaponAnim( ACT_VM_HITCENTER )
			tr.Entity:TakeDamageInfo( dmginfo )
		else
			self:EmitSound(table.Random(self.Sounds.Miss), 80, math.random(95, 105))
			self:SendWeaponAnim( ACT_VM_MISSCENTER )
		end
		if self.Owner:IsPlayer() then
			self.Owner:LagCompensation( false )
		end
	end
end

function SWEP:SecondaryAttack()
	if not self.Рыгание then
		if SERVER then
			self.Owner:TakeDamage(5)
		end
		self.Рыгание = true
		self.РыганиеEnd = CurTime() + SoundDuration( self.РыганиеSound ) + 0.1
		self:EmitSound( self.РыганиеSound )
	end
end

function SWEP:Think()
	if self.Рыгание then
		if self.РыганиеEnd < CurTime() then
			self.Рыгание = false
			return
		end
		local att = self.Owner:GetAttachment( 2 )
		if not att then return end
		
		local pos = att.Pos
		local angle = att.Ang
		local scale = 0.5
		
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() * ( 6 - scale ) / 2 )
		effectdata:SetScale( scale / 2 )
		util.Effect( "StriderBlood", effectdata, true, true )
	end
end

function SWEP:Reload()
	if SERVER then
		self:НеЛезьБлятьДебилСукаЕбаный()
	end
end


