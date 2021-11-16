-- Based on TTT's base

AddCSLuaFile()

if CLIENT then
   SWEP.PrintName       = "Base2"
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_nod_base"

SWEP.Category           = "DU Bulletproof Shield"
SWEP.Spawnable          = false

SWEP.Weight             = 5
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false 

SWEP.Primary.Sound          = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.Recoil         = 1.5
SWEP.Primary.Damage         = 1
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.02
SWEP.Primary.Delay          = 0.15

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ClipMax        = -1

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.ClipMax      = -1

SWEP.HeadshotMultiplier = 2.7

SWEP.DeploySpeed = 1.4

SWEP.StoredAmmo = 0

SWEP.Scoped = false

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

SWEP.PhysBulletPropType      = "sent_mini_shell"
SWEP.PhysBulletMinDamage     = 450
SWEP.PhysBulletMaxDamage     = 450
SWEP.PhysBulletBlastRadius   = 16

function SWEP:PrimaryAttack( worldsnd )
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if ( !self.ComplexSound ) then 
   
      if not worldsnd then
        self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )

      elseif SERVER then
        sound.Play( self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel )

      end
   end 
   
   if ( self.LastAttack or 0 + self.Primary.Delay <= CurTime() ) then

      self.LastAttack = CurTime()
         
      if ( self:Clip1() <= 0 ) then self:Reload() return false end

      self:SendWeaponAnim(self.PrimaryAnim)
	  -- self.Weapon:SendWeaponAnim(  )
		if( CLIENT ) then 
			if( self.ClientAttackCallback ) then	 
				
				self:ClientAttackCallback()
				
			end 
			
		end 
      if ( self.Primary.CustomMuzzle ) then
         ParticleEffect( self.Primary.CustomMuzzle, self.Owner:GetShootPos() + self:GetForward() * 32 + self.Owner:GetUp() * -8, self.Owner:EyeAngles(), 1  )
      else 
         self.Owner:MuzzleFlash()
      end 

       self.Owner:SetAnimation( PLAYER_ATTACK1 )

      if not IsFirstTimePredicted() then return end

      if not IsFirstTimePredicted() then return end

      if (not IsValid(self.Owner)) or (not self.Owner:Alive()) or self.Owner:IsNPC() then return end

      if SERVER then
         if ( self.Primary.PhysRecoil ) then 
            self.Owner:SetVelocity( self.Owner:GetAimVector() * -self.Primary.PhysRecoil )
         end 
	
		local shots = self.Primary.NumShots 
		if( shots == 0 || !shots ) then 
			shots = 1 
		end 
		
		for i=1,shots do 
			
			local bullet = ents.Create( self.PhysBulletPropType or self.Primary.PhysAmmoType )
			bullet.Damage = self.Primary.Damage
			bullet:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 16 + self.Owner:GetUp() * -1  )
			bullet:SetAngles( self.Owner:EyeAngles() )
			bullet.Owner = self.Owner
			bullet.TinyTrail = true 
			bullet:Spawn()
			bullet:SetOwner( self.Owner )
			if( bullet.Knife ) then 
				bullet.Knife:GetPhysicsObject():SetMass( 50000 )
				bullet.Knife:GetPhysicsObject():SetVelocity( self.Owner:GetVelocity() + bullet:GetForward() * ( self.BulletForce or 555250 ) )
			else 
				bullet:GetPhysicsObject():SetVelocity( self.Owner:GetVelocity() + bullet:GetForward() * ( self.BulletForce or 555250 ) )
			end 
			
			bullet.MinDamage = self.PhysBulletMinDamage or 450
			bullet.MaxDamage = self.PhysBulletMaxDamage or 650
			bullet.Radius = self.PhysBulletBlastRadius or 16
			bullet:GetPhysicsObject():EnableDrag( true )
			if( !self.GravityEnabledOnShells ) then 
			
				bullet:GetPhysicsObject():EnableGravity( false )
				bullet:GetPhysicsObject():EnableDrag( false )
				
				
			end 
			
			bullet:GetPhysicsObject():SetMass( 10 )
			bullet:Fire("kill","",30)
			-- bullet:GetPhysicsObject():SetInertia( bullet:GetForward() * ( self.BulletForce or  9955999 ) )
			bullet.Owner = self.Owner 
		
			local tr,trace={},{}
			tr.start = self.Owner:GetShootPos()
			tr.endpos = tr.start + self.Owner:GetAimVector() * 36000
			tr.filter = { self, self.Owner }
			tr.mask = MASK_SOLID 
			trace = util.TraceLine( tr ) 
			
			local ent = NULL 
				
			if( trace.Hit ) then
				local Radius = 1000
				local closest = Radius 
			
				for k,v in ipairs( ents.FindInSphere( trace.HitPos, Radius ) ) do 
					local dist = ( v:GetPos() - trace.HitPos ):Length() 
					if( ( v:IsPlayer() || v:IsNPC() || v:GetNWInt("health") ) && dist < closest ) then 
						closest = dist 
						ent = v 
					end 
				end 
			end 
		
			if( IsValid( ent ) ) then 
				
				bullet.Target = ent:GetPos() 
				bullet.TargetEntity = ent 
				
			else 
					
				local tr,trace = {},{}
				tr.start = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100 
				tr.endpos = tr.start + self.Owner:GetAimVector() * 36000
				tr.mask = MASK_SOLID 
				tr.filter = { self, self.Owner, bullet }
				trace = util.TraceLine( tr )

				bullet.Target = trace.HitPos 
				
			end 
			
			if( self.SwepPhysbulletCallback ) then 
			
				self:SwepPhysbulletCallback( bullet )
				
			end 
			
		  end
		
		end 
		
   end

	
   self:TakePrimaryAmmo( 1 )
   if( self:Clip1() == 0 ) then 
    
		self:SetNextPrimaryFire( 0 )
		self:SetNextSecondaryFire( 0 )
		if( self.Primary.AutoReload ) then 
			
			-- timer.Simple( .1, function() 
			
				self:Reload()
			
			-- end )
			
		end 
		
	end 
	
   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

  local sights = self:GetIronsights()
  local recoil = self.Primary.Recoil

  if ((game.SinglePlayer() and SERVER) or
	  ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

	 -- reduce recoil if ironsighting
	 recoil = sights and (recoil * 0.6) or recoil

	 local eyeang = self.Owner:EyeAngles()
	 eyeang.pitch = eyeang.pitch - recoil
	 self.Owner:SetEyeAngles( eyeang )
  end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end
