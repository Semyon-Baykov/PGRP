-- Based on TTT's base

AddCSLuaFile()

if CLIENT then
   SWEP.PrintName       = "Base"
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_base"

SWEP.Category           = "Vant VM Shield"
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

function SWEP:PrimaryAttackMelee()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation( self.WorldAnimation or PLAYER_ATTACK1 )
	
	local result = nil 
	for i=1,12 do 
		
		local tr,trace = {},{}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = tr.start + self.Owner:GetAimVector() * (42 + ( math.sin(i/4)*10 ) ) + self.Owner:GetUp() *( 8+( -4 * i ) ) + self.Owner:GetRight() * ( 16 + ( i * -4 ) )
		tr.mask = MASK_SOLID
		tr.filter = { self, self.Owner }
		trace = util.TraceLine( tr )
		if( trace.Hit ) then 
			
			result = trace 
			if( self.MeleeHitCallback ) then 
				
				self:MeleeHitCallback( trace )
			
			end 
			
			local effectdata = EffectData()
			effectdata:SetOrigin( trace.HitPos )
			effectdata:SetStart( trace.HitNormal )
			effectdata:SetNormal( trace.HitNormal )
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( self.ImpactScale or 0.45 )
			effectdata:SetRadius( 1 )
				effectdata:SetScale( 0.35 )
		   if trace.HitWorld and trace.MatType == MAT_METAL then
				util.Effect( "micro_he_impact_plane", effectdata )
				self:EmitSound("physics/metal/metal_solid_impact_hard"..math.random(4,5)..".wav", 511, 100 )
			elseif( trace.Entity && ( trace.Entity.IsBodyPart || trace.Entity:IsPlayer() || trace.Entity:IsNPC() ) && trace.MatType != MAT_METAL ) then 
				effectdata:SetScale( 0.5 )
				util.Effect( "micro_he_blood", effectdata )
				if( primary == false ) then 
					self:EmitSound("weapons/knife/knife_stab.wav", 511, 100 )
				else 
					self:EmitSound("weapons/knife/knife_hit"..math.random(1,5)..".wav", 511, 100 )
				end 
			else
				util.Effect( "micro_he_impact", effectdata )
				self:EmitSound("weapons/knife/knife_hitwall1.wav", 511, 100 )
			end
			
			if( SERVER ) then 
			
				local dmg = DamageInfo()
				dmg:SetAttacker( self.Owner )
				dmg:SetInflictor( self )
				if( primary == false ) then 
					dmg:SetDamage( 25 )
				else 
					dmg:SetDamage( self.Primary.Damage )
				end 
				dmg:SetDamageType( DMG_SLASH )
				dmg:SetDamagePosition( trace.HitPos )
				dmg:SetDamageForce( self.Owner:GetAimVector() * 50 )
				util.BlastDamageInfo( dmg, trace.HitPos, 1 )
			
			end 
		end 
		
		-- debugoverlay.Line( tr.start, trace.HitPos, 2, Color(255,0,0,255), true )
	end 
	
	self.LastAttack = CurTime()

end

function SWEP:ResetBonePositions(vm)
	
	if (!vm:GetBoneCount()) then return end
	for i=0, vm:GetBoneCount() do
		vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
		vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
		vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
	end
	
end

if SWEP.Pos and SWEP.Ang then 

	function SWEP:DrawWorldModel()
		if( !self.Pos || !self.Ang || !IsValid( self.Owner ) ) then return end 
		local wm = self:CreateWorldModel()
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if( !bone ) then return end 
		local pos, ang = self.Owner:GetBonePosition(bone)
		local subMat = self:GetNWString("SubMaterial")
		if( subMat ) then 

			wm:SetSubMaterial( self.SkinSubMaterialIndex, self.HasSetSubmaterial )

		end 

	   if bone then
			ang:RotateAroundAxis(ang:Right(), self.Ang.p)
			ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
			ang:RotateAroundAxis(ang:Up(), self.Ang.r)

			wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
			wm:SetRenderAngles(ang)
			wm:DrawModel()
	   end
		if( self.DrawWorldModelCallback ) then 
			self:DrawWorldModelCallback()
		end 
	end
end 

function SWEP:CreateWorldModel(  )
   if self.Pos && self.Ang && !self.WModel then
		
		self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
		self.WModel:SetNoDraw(true)
		if( self.WorldModelScale ) then 

			self.ScaleMatrix = Matrix()
			self.ScaleMatrix:Scale( self.WorldModelScale )
			self.WModel:EnableMatrix( "RenderMultiply", self.ScaleMatrix )
		
		end 
		
   end
   
   return self.WModel
end

function SWEP:PrimaryAttack(worldsnd)
	
	if( self.IsMeleeWeapon ) then 
		self:PrimaryAttackMelee( )
		return 
	end 
	
   self:SetNextSecondaryFire( CurTime() + ( self.Secondary.Delay or 0 ) )
   self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay or 0 ) )
   
   if not self:CanPrimaryAttack() then return end

   if ( !self.ComplexSound ) then 
   
      if not worldsnd then
		
		if( self.Silenced ) then 
				
			self:EmitSound( self.Primary.SoundSilenced, self.Primary.SoundLevel )
			
		else 
			
			self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		
		end
	  
	  elseif SERVER then
		  if( self.Silenced ) then 
			
			sound.Play(self.Primary.SoundSilenced, self:GetPos(), self.Primary.SoundLevel)
			
		  else
		  
			sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		  
		  end 
		 
	  end
      
   end 
   
   if( !self.Thrown ) then 
   
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
	
	else
	
		self:ThrowBullet( false  )
	
	end 
	
   self:TakePrimaryAmmo( 1 )
	if( self.Thrown && self.PrimaryAnim == ACT_VM_THROW ) then 
		self:Reload()
		
		self:SetNextSecondaryFire( CurTime() + ( self.Secondary.Delay or 0 ) )
		self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay or 0 ) )
   
	end 
	
	self.LastAttack = CurTime()
	
   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
 
	
   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end

function SWEP:ThrowBullet( slow )

	if not IsFirstTimePredicted() then return end

	self:SendWeaponAnim(self.PrimaryAnim)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( self.WorldAnimation or PLAYER_ATTACK1 )

	if( SERVER ) then 
		
		local obj = ents.Create( self.ThrownObject )
		obj:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * -4 + self.Owner:GetRight() * 10 )
		obj:SetAngles( self.Owner:EyeAngles() )
		obj:SetOwner( self.Owner )
		obj.Owner = self.Owner 
		obj:Spawn()
		obj:Activate()
		if( self.ForceModel ) then 
			obj:SetModel( self.ForceModel )
		end 
		obj:GetPhysicsObject():SetMass( 5 )
		obj:GetPhysicsObject():SetVelocityInstantaneous( self.Owner:GetVelocity() )
		obj:GetPhysicsObject():AddAngleVelocity( VectorRand() * 150 )
		obj:Fire("kill","",20)
		
		if( slow ) then 
			
			obj:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * self.ThrowForce * .5 )
		
		else 
		
			obj:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * self.ThrowForce )
		
		end 
		obj.Damage = self.Primary.Damage 
		
	end 
	
end 

function SWEP:DryFire(setnext)
   if CLIENT and LocalPlayer() == self.Owner then
      self:EmitSound( "Weapon_Pistol.Empty" )
   end
   setnext(self, CurTime() + 0.2)
end

function SWEP:CanPrimaryAttack()
   if not IsValid(self.Owner) then return end
	if ( self:GetNetworkedBool( "reloading" ) ) then return false end
	
   if self:Clip1() <= 0 then

      self:DryFire(self.SetNextPrimaryFire)
	  return false
   end
   return true
end

function SWEP:CanSecondaryAttack()
   if not IsValid(self.Owner) then return end

   if self:Clip2() <= 0 then
      self:DryFire(self.SetNextSecondaryFire)
      return false
   end
   return true
end

function SWEP:Sparklies(attacker, b, dmginfo, Hack, count )
		
		-- if( !IsFirstTimePredicted() ) then return end 
		
	-- if( SERVER || ( CLIENT && game.MultiPlayer() ) then 
	-- if( b.Entity != self.Owner ) then 
		
			local effectdata = EffectData()
			effectdata:SetOrigin( b.HitPos )
			effectdata:SetStart( b.HitNormal )
			effectdata:SetNormal( b.HitNormal )
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( self.ImpactScale or 0.45 )
			effectdata:SetRadius( 1 )
		   if b.HitWorld and b.MatType == MAT_METAL then
				util.Effect( "micro_he_impact_plane", effectdata )
			elseif( b.Entity && ( b.Entity.IsBodyPart || b.Entity:IsPlayer() || b.Entity:IsNPC() ) && b.MatType != MAT_METAL ) then 
				effectdata:SetScale( 0.8 )
				util.Effect( "micro_he_blood", effectdata )
			else
				util.Effect( "micro_he_impact", effectdata )
			end
		
	-- end 
	
	if( Hack ) then 
		
		self:PenetrateThinSurfaceCallback( attacker, b, dmginfo, count )
		-- debugoverlay.Line( b.HitPos, self.Owner:GetShootPos(), 15, Color(5,255,5,255), true )

	end 

end
function SWEP:PenetrateThinSurfaceCallback( a,b,c, count )

	local dir = self.Owner:GetAimVector()
	local pos = b.HitPos + dir * 17
	local tr,trace={},{}
	tr.start = pos 
	tr.endpos = b.HitPos 
	tr.mask = MASK_SOLID
	trace = util.TraceLine( tr ) 
		
	local impactDirection = self.Owner:GetAimVector()
	-- print("Pierce Depth: ", ( trace.HitPos - b.HitPos ):Length(), trace.Fraction  )
	-- debugoverlay.Line( pos, self.Owner:GetShootPos() + dir * 3500, 1, Color(255,5,5,255), true )
 	local DotProduct = b.HitNormal:Dot( b.Normal * -1 ) 
 	local newNormal = ( 2 * b.HitNormal * DotProduct ) + b.Normal
	local bAttacker = self.Owner
	local tracer = self.TracerCount or ( ( !game.SinglePlayer() && CLIENT )and 0 or 1 ) --math.random(1,3)
	if( !self.NoRicochet && ( DotProduct < .4 && count == 0 && ( b.MatType == MAT_CONCRETE || b.MatType == MAT_METAL ) ) || (  b.Entity:GetModel() == "models/arleitiss/riotshield/shield.mdl" || b.Entity:GetModel() == "models/vant-vm/vant-vm.mdl" || b.Entity.BulletProof ) ) then 
		
		impactDirection = newNormal
		pos = b.HitPos + b.HitNormal 
		EmitSound(self.RicochetSound, b.HitPos, b.Entity:EntIndex(), CHAN_AUTO, 1, 511, 0, math.random(75,125) )
		if( IsValid( b.Entity ) && (  b.Entity:GetModel() == "models/arleitiss/riotshield/shield.mdl"  || b.Entity.BulletProof ) ) then 
			
			bAttacker = IsValid( b.Entity.Owner ) and b.Entity.Owner or b.Entity
			
		end 
	
	else
		
		if( self.PenetrationSound ) then 
			
			local snd = self.PenetrationSound 
			if( type( self.PenetrationSound ) == "table" ) then 
				snd = self.PenetrationSound[math.random(1,#self.PenetrationSound)]
			end
				
			EmitSound( snd, b.HitPos, b.Entity:EntIndex(), CHAN_ITEM, 1, 511, 0, math.random(75,125) )
		
		end 
		
	end 
	if( game.SinglePlayer() ) then tracer = 0 end 
	
	-- debugoverlay.Line( pos, pos + impactDirection* 3500, 2, Color(5,5,255,255), true )
	
	local ang = ( self:GetPos() - b.HitPos ):Normalize()
 	local bullet = {} 
 	bullet.Num 		= self.Primary.NumShots
 	bullet.Src 		= pos 
 	bullet.Dir 		= impactDirection
	bullet.Attacker = bAttacker 
 	bullet.Spread 	= VectorRand() * ( self.Primary.Recoil / 15 ) 
 	bullet.Tracer	= tracer
 	bullet.Force	= self.ImpactForce or 10
 	bullet.Damage	= self.Primary.Damage * .75 
	bullet.HullSize = self.HullSize or 0 
 	bullet.TracerName 	= self.Tracer or "tracer"
	bullet.Callback = function(a,b,c) self:Sparklies( a, b, c, ( self.ForcePenetration || trace.Fraction > .45 ) && count < 7, count+1 ) end -- this should be fun 
	
 	self.Owner:FireBullets( bullet  ) 
	
	return { damage = true, effects = DoDefaultEffect } 
	
end
function SWEP:ShootBullet( dmg, recoil, numbul, cone )

	if not IsFirstTimePredicted() then return end

	self:SendWeaponAnim(self.PrimaryAnim)

	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(  self.WorldAnimation or PLAYER_ATTACK1 )

	local sights = self:GetIronsights()

	numbul = numbul or 1
	cone   = cone   or math.Rand( 0.01, 0.09 )
	
	local SpreadDelta = 0 
	if( self.Owner:IsPlayer() ) then 
	
		SpreadDelta = self.Owner:GetVelocity():Length() / self.Owner:GetMaxSpeed() 
	 
	end 
	if( self.LastAttack && self.LastAttack + ( self.Primary.Delay ) <= CurTime() ) then 
		SpreadDelta = 0 
		-- print("true", SpreadDelta )
	end 

	local scale = math.max(0.0,  10 * self:GetPrimaryCone())
	local LastShootTime = self.LastGunshot or 0 
	-- print( CurTime() - LastShootTime )
	scale = 0.15 * scale * ( 2 - math.Clamp( ( CurTime() - LastShootTime), 0.0, 1.0 ))
	local src = self.Owner:GetShootPos()
	local len = 1
	local hasRide = false 
		-- print( SpreadDelta + scale  )
	if( !self.Owner:IsNPC() && IsValid( self.Owner:GetVehicle() ) ) then  -- allow us to shoot out
		-- local tr,trace={},{}
		-- tr.start = self.Owner:GetShootPos() + self.Owner:GetAimVector() *125
		-- tr.endpos = self.Owner:GetShootPos()
		-- tr.mask = MASK_SOLID 
		-- trace = util.TraceLine( tr )
		-- len = ( self.Owner:GetShootPos() - ( trace.HitPos ) ):Length() * 1.5
		-- src = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 172 
		-- hasRide = true 
	end 
   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = src
   -- if( offsetAim ) then 
   -- bullet.Dir    = ( bullet.Src - self.Owner:GetAimVector() * 36000 ):GetNormalized()
   -- else
   bullet.Dir    =  self.Owner:GetAimVector()
   -- end 
   if( self.Owner.ShootingDirection ) then 
	bullet.Dir = self.Owner.ShootingDirection 
	end 
   if( hasRide ) then 
		SpreadDelta = 0 
		scale = 0 
	end
   bullet.Spread = Vector( math.Rand(-SpreadDelta+scale, SpreadDelta+scale),math.Rand(-SpreadDelta+scale, SpreadDelta+scale), 0 ) -- Vector( math.Rand(-.01,.01),math.Rand(-.01,.01),0  ) 
   
   bullet.Tracer = len == 1 && ( self.TracerCount or  math.random(1,3) ) or 0 
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = self.ImpactForce or 10
   bullet.Damage = dmg
   bullet.filter = !self.Owner:IsNPC() and self.Owner:GetVehicle() or NULL 
   if( hasRide ) then
	local t = self.Owner:GetVehicle():GetOwner().TotalParts
	if( t ) then table.insert( t, self.Owner:GetVehicle():GetOwner() ) end 
	bullet.filter = t 
   end 
   bullet.Callback = function( a,b,c ) self:Sparklies( a, b, c, true, 0 ) end 

   self.Owner:FireBullets( bullet )
	self.LastGunshot = CurTime()
	
   -- Owner can die after firebullets
   if (not IsValid(self.Owner)) or ( !self.Owner:IsNPC() && not self.Owner:Alive()) or self.Owner:IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )
	  
   end

end

function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.2
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.85) or cone
end

function SWEP:GetHeadshotMultiplier(victim, a )
   return self.HeadshotMultiplier
end

function SWEP:SecondaryAttack()
	if( self.Thrown ) then 
	
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	   
	   if not self:CanPrimaryAttack() then return end

	   if ( !self.ComplexSound ) then 
	   
		  if not worldsnd then
			self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		  elseif SERVER then
			sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		  end
		  
	   end 
	
		self:ThrowBullet( true  )
	
	   self:TakePrimaryAmmo( 1 )

	   local owner = self.Owner
	   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
		self.LastAttack = CurTime() 
		
	   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	   
	   return 
	   
	end 
   if self.NoSights or (not self.IronSightsPos) then return end
   --if self:GetNextSecondaryFire() > CurTime() then return end

   self:SetIronsights(not self:GetIronsights())
	if( self.IronSightHoldType ) then 
		if( self:GetIronsights() ) then 
			self:SetHoldType( self.IronSightHoldType )
		   if self.SetWeaponHoldType then
			  self:SetWeaponHoldType(self.IronSightHoldType)
		   end
		else
			self:SetHoldType( self.HoldType )
			if self.SetWeaponHoldType then
			  self:SetWeaponHoldType(self.HoldType)
		   end
		end 
	end
   if self.Scoped || self.IronSightZoom then
      if self:GetIronsights() then
         if( IsValid( self.Owner ) ) then
            self.Owner:SetFOV( 75/self.Secondary.ScopeZoom, 0.15 )   
			if( !self.IronSightZoom ) then 
				self.Owner:DrawViewModel( false )
			end 
			
            self.Weapon:SetNetworkedBool("LastSwap", CurTime()) 
         end
	
      else
         self.Owner:DrawViewModel( true )
         self.Owner:SetFOV( 0, 0.2 )
      end
   end

   self:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:Deploy()

	
	if( self.Silenced ) then 
		
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW_SILENCED  ) 
			
	end 
	
   self:SetIronsights(false)
   return true
end

function SWEP:Reload()

	if ( IsValid( self.Owner ) && !self.Owner:IsNPC() && ( self:Clip1() == self.Primary.ClipSize or ( self.Owner.GetAmmoCount && self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) ) ) then return end
	
	if( self.SequentialReload ) then 
		// Already reloading
		if ( self:GetNetworkedBool( "reloading" ) ) then return end

		// Start reloading if we can
		if ( self:Clip1() < self.Primary.ClipSize &&  self.Owner.GetAmmoCount && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
			self:SetNetworkedBool( "reloading", true )
			self:SetVar( "reloadtimer", CurTime() + 0.3 )
		
			if( self.Silenced ) then 
				
				self:SendWeaponAnim( ACT_VM_RELOAD_SILENCED )
				
			else 
				
				self:SendWeaponAnim( ACT_VM_RELOAD )
			
			end 
			
			-- end 
			
		end
	
	else 
			
		if( self.PrimaryAnim && self.PrimaryAnim == ACT_VM_THROW ) then 
	
			self:DefaultReload( ACT_VM_DRAW)
		
		else 
			self:DefaultReload(self.ReloadAnim)
				
		end 
		
	end 
	
	self:SetIronsights( false )
	if( !self.Owner.DrawViewModel ) then return end 
	self.Owner:DrawViewModel( true )
	self.Owner:SetFOV( 0, 0.2 )
	
	if( self.IronSightHoldType ) then 
		
		local htype =  self.HoldType
		if( self:GetIronsights() ) then 
			htype =  self.IronSightHoldType
		end 
		
		self:SetHoldType(  htype )
		if self.SetWeaponHoldType then
		  self:SetWeaponHoldType( htype )
		end
		   
	end
	
end


function SWEP:OnRestore()
   self.NextSecondaryAttack = 0
   self:SetIronsights( false )
end

function SWEP:Ammo1()
   return IsValid(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) or false
end

-- The OnDrop() hook is useless for this as it happens AFTER the drop. OwnerChange
-- does not occur when a drop happens for some reason. Hence this thing.
function SWEP:PreDrop()
   if SERVER and IsValid(self.Owner) and self.Primary.Ammo != "none" then
      local ammo = self:Ammo1()

      -- Do not drop ammo if we have another gun that uses this type
      for _, w in pairs(self.Owner:GetWeapons()) do
         if IsValid(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
            ammo = 0
         end
      end

      self.StoredAmmo = ammo

      if ammo > 0 then
         self.Owner:RemoveAmmo(ammo, self.Primary.Ammo)
      end
   end
end

function SWEP:DampenDrop()
   -- For some reason gmod drops guns on death at a speed of 400 units, which
   -- catapults them away from the body. Here we want people to actually be able
   -- to find a given corpse's weapon, so we override the velocity here and call
   -- this when dropping guns on death.
   local phys = self:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocityInstantaneous(Vector(0,0,-75) + phys:GetVelocity() * 0.001)
      phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
   end
end

local SF_WEAPON_START_CONSTRAINED = 1

-- Picked up by player. Transfer of stored ammo and such.
function SWEP:Equip(newowner)
   if SERVER then
      if self:IsOnFire() then
         self:Extinguish()
      end

      self.fingerprints = self.fingerprints or {}

      if not table.HasValue(self.fingerprints, newowner) then
         table.insert(self.fingerprints, newowner)
      end

      if self:HasSpawnFlags(SF_WEAPON_START_CONSTRAINED) then
         -- If this weapon started constrained, unset that spawnflag, or the
         -- weapon will be re-constrained and float
         local flags = self:GetSpawnFlags()
         local newflags = bit.band(flags, bit.bnot(SF_WEAPON_START_CONSTRAINED))
         self:SetKeyValue("spawnflags", newflags)
      end
   end

   if SERVER and IsValid(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo != "none" then
      local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
      local given = math.min(self.StoredAmmo, self.Primary.ClipMax - ammo)

      newowner:GiveAmmo( given, self.Primary.Ammo)
      self.StoredAmmo = 0
   end
end

-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
function SWEP:GetIronsights() return false end
function SWEP:SetIronsights() end

-- Set up ironsights dt bool. Weapons using their own DT vars will have to make
-- sure they call this.
function SWEP:SetupDataTables()
   -- Put it in the last slot, least likely to interfere with derived weapon's
   -- own stuff.
   self:NetworkVar("Bool", 3, "Ironsights")
end

function SWEP:Holster()
	if( !IsValid( self.Owner ) ) then return end 
	if( self.Owner:IsPlayer() && !IsValid( self.Owner:GetViewModel(0) ) ) then return end 
	self.Owner:GetViewModel(0):SetSubMaterial(0, nil )
	return true 
end
 
function SWEP:Deploy()
	if( SERVER && self.RandomSkins  && self.SkinSubMaterialIndex && !self.SubMaterial ) then 
		self:SetNWString("SubMaterial", self.RandomSkins[math.random(1,#self.RandomSkins)]   )
		self.SubMaterial = true  
		-- print("Setting skin")
	end 
	
	if( CLIENT && self.RandomSkins && self.SkinSubMaterialIndex ) then 
		 if( !self.HasSetSubmaterial ) then 
			self.HasSetSubmaterial = self:GetNWString("SubMaterial")
		end 
		self:SetSubMaterial( self.SkinSubMaterialIndex, self.HasSetSubmaterial )
		self.Owner:GetViewModel(0):SetSubMaterial( self.SkinSubMaterialIndex, self.HasSetSubmaterial )

	end 
	
end 

function SWEP:Initialize()
	if( self.Silenced ) then  
		self.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
		self.ReloadAnim = ACT_VM_RELOAD_SILENCED
	end 
   if CLIENT and self:Clip1() == -1 then
      self:SetClip1(self.Primary.DefaultClip)
   elseif SERVER then
      self.fingerprints = {}
      if( self.ComplexSound ) then 
			self.ShootSound = CreateSound( self, self.Primary.Sound )
      end 
      self:SetIronsights(false)
   end
   self:SetDeploySpeed(self.DeploySpeed)
	if (SERVER) then
		self:SetNPCFireRate(self.Primary.Delay)
		self:SetNPCMaxBurst( 10 )
	end
	self:SetHoldType( self.HoldType )
   if self.PhysBulletEnable then
      self.LastAttack = CurTime() - 5
   end
   self.RicochetSound = Sound( "weapons/fx/rics/ric4.wav" )
end

function SWEP:Think()

	if( self.SequentialReload ) then 
	
		if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
		
			if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
				
				// Finsished reload -
				if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
					self.Weapon:SetNetworkedBool( "reloading", false )
					return
				end
				
				// Next cycle
				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
				if( self.Silenced ) then 
					
					self.Weapon:SendWeaponAnim( ACT_VM_RELOAD_SILENCED )
				
				else 
				
					self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
				
				end 
				
				// Add ammo
				self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
				self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
				
				// Finish filling, final pump
				if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
					self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				else
				
				end
				
			end
		
		end
   
   end 
   
   self:NextThink(CurTime())
end


local LOWER_POS = Vector(0, 0, -2)

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition( pos, ang )
   if not self.IronSightsPos then return pos, ang end

   local bIron = self:GetIronsights()

   if bIron != self.bLastIron then
      self.bLastIron = bIron
      self.fIronTime = CurTime()

      if bIron then
         self.SwayScale = 0.3
         self.BobScale = 0.1
      else
         self.SwayScale = 1.0
         self.BobScale = 1.0
      end

   end

   local fIronTime = self.fIronTime or 0
   if (not bIron) and fIronTime < CurTime() - IRONSIGHT_TIME then
      return pos, ang
   end

   local mul = 1.0

   if fIronTime > CurTime() - IRONSIGHT_TIME then

      mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )

      if not bIron then mul = 1 - mul end
   end

   local offset = self.IronSightsPos + (0 and LOWER_POS or vector_origin)

   if self.IronSightsAng then
      ang = ang * 1
      ang:RotateAroundAxis( ang:Right(),    self.IronSightsAng.x * mul )
      ang:RotateAroundAxis( ang:Up(),       self.IronSightsAng.y * mul )
      ang:RotateAroundAxis( ang:Forward(),  self.IronSightsAng.z * mul )
   end

   pos = pos + offset.x * ang:Right() * mul
   pos = pos + offset.y * ang:Forward() * mul
   pos = pos + offset.z * ang:Up() * mul

   return pos, ang
end

local scopemat, num = Material( "scope/gdcw_svdsight")
local ScopeMatSize = 1084
local Offset = ScopeMatSize / 2

function SWEP:DrawHUD()

	if( CLIENT && self.RandomSkins && self.SkinSubMaterialIndex ) then 
		-- if( !self.HasSetSubmaterial ) then 
			self.HasSetSubmaterial = self:GetNWString("SubMaterial", nil )
		-- end 
		if( self.HasSetSubmaterial ) then 
			
			self:SetSubMaterial( self.SkinSubMaterialIndex, self.HasSetSubmaterial )
			self.Owner:GetViewModel(0):SetSubMaterial( self.SkinSubMaterialIndex, self.HasSetSubmaterial )
		end 
		
	end 
	-- // uncomment this for ricochet prediction	
	-- local b = self.Owner:GetEyeTrace()
	-- local DotProduct = b.HitNormal:Dot( b.Normal * -1 ) 
 	-- local newNormal = ( 2 * b.HitNormal * DotProduct ) + b.Normal
	-- local tr,trace={},{}
	-- tr.start = b.HitPos 
	-- tr.endpos = tr.start + newNormal * 5000 
	-- tr.mask = MASK_SOLID 
	-- trace = util.TraceLine( tr ) 
	-- local p1 = self.Owner:GetShootPos():ToScreen()
	-- local p2 = self.Owner:GetEyeTrace().HitPos:ToScreen()
	-- local p3 = trace.HitPos:ToScreen()
	-- if( DotProduct < .4 ) then 
		-- surface.SetDrawColor( Color( 0,255,0, 255 ) )
	-- else
		-- surface.SetDrawColor( Color( 255,0,0, 255 ) )
	-- end 
	-- surface.DrawLine( p1.x, p1.y, p2.x, p2.y )
	-- surface.DrawLine( p2.x, p2.y, p3.x, p3.y )
	-- debugoverlay.Line( self.Owner:GetShootPos(), , FrameTime(), Color(5,255,5,255), true )
	-- debugoverlay.Line( self.Owner:GetEyeTrace().HitPos, , FrameTime(), Color(255,5,5,255), true )
	if( self.PreDraw != nil ) then 
		
		self:PreDraw()
		
	end 
	
	if ( self.Scoped ) and self:GetIronsights() then
		
		if( self.ScopeTexture ) then 	
		-- ScopeTexture
			if( !self.NoLines ) then 
			
				surface.SetDrawColor( Color( 0,0,0, 255 ) )
				surface.DrawLine( ScrW()/2, 0, ScrW()/2, ScrH() )
				surface.DrawLine( 0, ScrH()/2, ScrW(), ScrH()/2 )
				-- surface.DrawLine( p2.x, p2.y, p3.x, p3.y )
		
			end 
			
			local Scale = 1 
			local w,h = 0,0 
			local width, height = ScrW(), ScrH()
			
			if( self.ScopeUseTextureSize ) then 
				
				width = self.ScopeTexture:Width()
				height = self.ScopeTexture:Height()
			
			end 
			
			if( self.ScopeTextureScale ) then 
				Scale = self.ScopeTextureScale 
				w = ( width - ( Scale * width  ) ) / 2
				h = ( height - ( Scale * height  ) ) / 2
			end 
			if( self.ScopeUseTextureSize ) then 
				w = ScrW()/2 - width * Scale / 2
				h = ScrH()/2 - height * Scale / 2 
				
			end 
			
			-- print( w,h, width, height )
			
			surface.SetMaterial( self.ScopeTexture )
			surface.SetDrawColor( Color( 255,255,255, 255 ) )
			surface.DrawTexturedRect( w,h, width*Scale,height*Scale )
			
			surface.SetMaterial( self.ScopeTexture2 )
			surface.SetDrawColor( Color( 255,255,255, 255 ) )
			surface.DrawTexturedRect( 0,0, ScrW(),ScrH()) 
					
			
		else 
			
			surface.SetMaterial( scopemat )
			surface.SetDrawColor( Color( 0,0,0, 255 ) )
			surface.DrawTexturedRect( ( ScrW() / 2 ) - Offset, ( ScrH() / 2 ) - Offset, ScopeMatSize, ScopeMatSize ) 
			
		end 
	
	elseif( !self:GetIronsights() ) then 
	
		local SpreadDelta = self.Owner:GetVelocity():Length() / self.Owner:GetMaxSpeed() 
		local crosshair_size = .5 
		local x = math.floor(ScrW() / 2.0)
		local y = math.floor(ScrH() / 2.0)
		local scale = math.max(0.2,  10 * self:GetPrimaryCone())
		local LastShootTime = self:LastShootTime()
		scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 )) + SpreadDelta
		local gap = math.floor(20 * scale * 1 )
		local length = math.floor(gap + (25 * crosshair_size ) * scale )
		surface.SetDrawColor( Color( 0,255,0, 255 ) )
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
   
   end
	
	if( self.PostDraw != nil ) then 
		self:PostDraw()
	end 
	
end