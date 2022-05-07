

///////////////////////////////////
//			Grenade weapon 		//
/////////////////////////////////


AddCSLuaFile()

SWEP.Author = 'SnOOp'
SWEP.Information = 'Уничтожать дома.'
SWEP.Editable = false
SWEP.Spawnable = true
SWEP.AdminOnly = true

if CLIENT then
	SWEP.PrintName = 'Осколочная граната'
	SWEP.Instructions = 'ЛКМ - Истребить людей;'
	SWEP.Slot = 3
	SWEP.Category = "GPortalRP"
	SWEP.ViewModelFlip = true 
	SWEP.DrawCrosshair = false
end

SWEP.ViewModel = 'models/weapons/v_eq_fraggrenade.mdl'
SWEP.WorldModel = 'models/weapons/w_eq_fraggrenade.mdl'

SWEP.Weight = 5
SWEP.AutoSwitchFrom = true 
SWEP.NoSights = true 

SWEP.Primary = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true 
SWEP.Primary.Delay = 1.0 
SWEP.Primary.Ammo = 'none'

SWEP.Secondary = {}

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Ammo = 'none'

SWEP.CanThrow = true
SWEP.Mode = false 
SWEP.LastChange = 0

function SWEP:Initialize()
	self:SetHoldType( 'grenade' )
end

local AdminBlacklist = { 'STEAM_0:0:69346632', 'STEAM_0:1:46592572' }

function SWEP:Reload()
	if self.Owner:IsSuperAdmin() and self.Owner:GetUserGroup() == 'superadmin' then
		if CurTime() - self.LastChange > 1 then
			self.Mode = !self.Mode
			self.LastChange = CurTime()
			if SERVER then self.Owner:ChatPrint( 'Changed mode to:'..( self.Mode and 'admin' or 'user' ) ) end
		end
	else
		return false
	end
end

function SWEP:PrimaryAttack()
	if self.Mode and self.Owner:IsSuperAdmin() then
		if SERVER then
			if not table.HasValue( AdminBlacklist, self.Owner:SteamID() ) then
				local ply = self.Owner

				local ang = ply:EyeAngles()
				local src = ply:GetPos() + ( ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset() ) + ( ang:Forward() * 8 ) + ( ang:Right() * 10 )

				local target = ply:GetEyeTraceNoCursor().HitPos 
				local tang = ( target - src ):Angle()

				if tang.p < 90 then
					tang.p = -10 + tang.p * ( 90 + 10 ) / 90
				else
					tang.p = 360 - tang.p
					tang.p = -10 + tang.p * -( 90 + 10 ) / 90
				end

			    tang.p = math.Clamp( tang.p, -90, 90 )

			    local vel = math.min( 800, ( 90 - tang.p ) * 6 )

				self:CreateGrenade( ( tang:Forward() * vel + ply:GetVelocity() ), src )
			else
				self.Owner:ChatPrint( 'Вы занесены в черный список админ режима. Узнайте почему по адресу: пойти нахуй.ком' )
			end
		end
	else
		if self.CanThrow then
			self.CanThrow = false 

			self:SendWeaponAnim( ACT_VM_PULLPIN )

			if SERVER then
				timer.Simple( 1, function()
	      			local ply = self.Owner

	      			local ang = ply:EyeAngles()
	      			local src = ply:GetPos() + ( ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset() ) + ( ang:Forward() * 8 ) + ( ang:Right() * 10 )

	      			local target = ply:GetEyeTraceNoCursor().HitPos 
	      			local tang = ( target - src ):Angle()

	      			if tang.p < 90 then
	      				tang.p = -10 + tang.p * ( 90 + 10 ) / 90
	      			else
	      				tang.p = 360 - tang.p
	      				tang.p = -10 + tang.p * -( 90 + 10 ) / 90
	      			end

	      			tang.p = math.Clamp( tang.p, -90, 90 )

	      			local vel = math.min( 800, ( 90 - tang.p ) * 6 )

					self:CreateGrenade( ( tang:Forward() * vel + ply:GetVelocity() ), src )
					
					ply:SetAnimation( PLAYER_ATTACK1 )
					ply:StripWeapon( 'weapon_fraggrenade' )
				end )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	
end


function SWEP:CreateGrenade( vel, pos )
	if not SERVER then return end

	local grenade = ents.Create( 'sent_fraggrenade' )

	grenade:SetPos( pos )

	grenade.Mode = self.Mode

	grenade:SetThrower( self.Owner )

	grenade:Spawn()

	grenade:SetGravity( 0.4 )
   	grenade:SetFriction( 0.2 )
   	grenade:SetElasticity( 0.45 )

	local phys = grenade:GetPhysicsObject()

	if IsValid( phys ) then
		phys:Wake()
		phys:SetVelocity( vel )
	end

	timer.Simple( 4, function()
		grenade:Explode()
	end )
end


///////////////////////////////////
//			Boom entity 		//
/////////////////////////////////

local ENT = {}

ENT.Base = 'base_gmodentity'

AccessorFunc( ENT, "thrower", "Thrower" )
AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )
AccessorFunc( ENT, "dmg", "Damage", FORCE_NUMBER )

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
else
	function ENT:Initialize()
		if not self:GetRadius() then self:SetRadius( 200 ) end
		if not self:GetDamage() then self:SetDamage( 150 ) end

		self:SetModel( 'models/weapons/w_eq_fraggrenade.mdl' )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:Wake()
		end
	end

	function ENT:PhysicsCollide( data, phys )
		if data.Speed > 50 then self:EmitSound( Sound( 'HEGrenade.Bounce' ) ) end
	end

	function ENT:Think()
		if not IsValid( self:GetThrower() ) then
			self:Remove()
		end
	end
end

function ENT:Explode()
	if SERVER then
		self:SetNoDraw( true )
		self:SetNotSolid( true )

		local effect = EffectData()
		effect:SetStart( self:GetPos() )
		effect:SetOrigin( self:GetPos() )
		effect:SetScale( self:GetRadius() * 0.6 )
		effect:SetRadius( self:GetRadius() )
		effect:SetMagnitude( self:GetDamage() )

		util.Effect( 'Explosion', effect, true, true )
		util.BlastDamage( self, self:GetThrower(), self:GetPos(), self:GetRadius(), self:GetDamage() )

		for k, v in pairs( ents.FindInSphere( self:GetPos(), self:GetRadius() * 0.7 ) ) do
			if v:GetClass() == 'prop_physics' then
				if not v.isFadingDoor and self.Mode then
					--v:GetPhysicsObject():EnableMotion( true ) 
					--v:GetPhysicsObject():SetVelocity( ( v:GetPos() - self:GetPos() ) * self:GetDamage() / 10 ) 
				else
					if not v.fadeActivate then continue end
					v:fadeActivate()
				end
			elseif v:GetClass() == 'prop_door_rotating' then
				v:Fire'unlock'
				
				if v:GetSaveTable().m_eDoorState == 0 then v:Fire'use' end
			end
		end

		self:Remove()
	end
end

scripted_ents.Register( ENT, 'sent_fraggrenade' )