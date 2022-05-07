AddCSLuaFile()
-- Credit to arleitiss for the model 
-- SWEP.HoldType = "magic"

if CLIENT then
   SWEP.PrintName = "РГ Щит"
   SWEP.Slot = 1
   SWEP.ViewModelFlip = false
end

SWEP.DrawCrosshair = false
SWEP.Base = "weapon_nod_base_ent"
SWEP.Category = "MoPachE"
SWEP.ComplexSound = false
SWEP.Primary.CustomMuzzle = "MG_muzzleflash"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false 

SWEP.DrawCrosshair		= false

SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0.5
SWEP.Primary.Cone = 0.0

SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1
SWEP.HoldType = "slam"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 0
SWEP.Primary.PhysRecoil = 1

SWEP.Primary.Sound = Sound("micro/Gau8_humm2.wav")
SWEP.Primary.EndSound = Sound("micro/GAU8_end_test.wav")

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 64
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = ""

SWEP.HeadshotMultiplier = 2.2

SWEP.IronSightsPos = Vector(-1.96, -5.119, 4.349)
SWEP.IronSightsAng = Vector(0, 0, 0)
	
function SWEP:PrimaryAttack()

	--[[ NOTHING!!!
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	if not self:CanPrimaryAttack() then return end
	if ( self.LastAttack or 0 + self.Primary.Delay <= CurTime() ) then

		self.LastAttack = CurTime()
		self:SendWeaponAnim(self.PrimaryAnim)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		if not IsFirstTimePredicted() then return end

		if (not IsValid(self.Owner)) or (not self.Owner:Alive()) or self.Owner:IsNPC() then return end


		local owner = self.Owner
		if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

		owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
		if( self.Owner:GetVelocity():Length() < self.Owner:GetMaxSpeed( )) then 
			
			local velo =  self.Owner:GetForward() * 500
			velo.z = 0
			self.Owner:SetVelocity( velo )
		
		end 
		
		local damage = DamageInfo()
		damage:SetAttacker( self.Owner )
		damage:SetDamage( math.random( 25, 45 ) )
		-- damage:Set
		damage:SetDamageForce( self.Owner:GetAimVector() * 500 )
		damage:SetInflictor( self.Owner )
		damage:SetDamageType( DMG_CRUSH )
		damage:SetDamagePosition( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 33 ) 
		
		local count = 0 
		for i=1,15 do 
			local tr,trace={},{}
			tr.start = self.Owner:GetShootPos() 
			tr.endpos = tr.start + ( ( self.Owner:GetAimVector() + VectorRand() * .125 ) * 65 )
			tr.filter = { self.Owner, self, self.Owner.Shield }
			tr.mask = MASK_SOLID
			trace = util.TraceLine( tr )
			if( trace.Hit && trace.Entity:IsPlayer() || trace.Entity:IsNPC()  ) then 
				
				count = count + 1 
				
			end
					
		end 
		
		if( count > 0 ) then 
				
			self.Owner:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav", 511, 100 )
			
		end 
		
		
		util.BlastDamageInfo( damage, self.Owner:GetShootPos() + self.Owner:GetForward() * 33, 32 )

	end 
	
	--]]
	
end 

function SWEP:Deploy()


	if( SERVER ) then 
	
		if( IsValid( self.Owner.Shield ) ) then 
		
			self.Owner.Shield:Remove()
			
		end 
		local a = self.Owner:EyeAngles() 
		self.Owner:SetEyeAngles( Angle( 0, a.y, a.r ) )
		self.Owner.Shield = ents.Create("prop_physics")
		self.Owner.Shield:SetModel("models/vant-vm/vant-vm.mdl")	--vant-vm.mdl
		self.Owner.Shield:SetPos(self.Owner:LocalToWorld( Vector( 0 ,15, 17 ) ) )  -- self.Owner:GetPos() + Vector(10,0,15) + (self.Owner:GetForward()*25))
		self.Owner.Shield:SetAngles( self.Owner:GetAngles() + Angle( -5,0,0 ) )
		self.Owner.Shield:SetParent( self.Owner )
		self.Owner.Shield:Fire("SetParentAttachmentMaintainOffset", "anim_attachment_RH", 0.01)
		self.Owner.Shield:SetOwner( self.Owner ) 
		self.Owner.Shield.Owner = self.Owner 
		self.Owner.Shield:Spawn()
		self.Owner.Shield:Activate()
		self.Owner.Shield.PhysgunDisabled  = true
		
	end 
	
	self.Owner:DrawViewModel(false)
	
end 

if( SERVER ) then 

	
	function SWEP:Think()
		if( IsValid( self.Owner.Shield ) ) then
			if(self.Owner:Crouching()) then
				self.Owner.Shield:SetPos(self.Owner:LocalToWorld( Vector( 3 , 15, 0 ) ) ) 
				self.Owner.Shield:SetAngles( self.Owner:GetAngles() + Angle( -5,0,0 ) )
				self.Owner.Shield:SetParent( self.Owner )
				self.Owner.Shield:Fire("SetParentAttachmentMaintainOffset", "anim_attachment_RH", 0.01)
				self.Owner.Shield:SetOwner( self.Owner ) 
				self.Owner.Shield.Owner = self.Owner 
				self.Owner.Shield.PhysgunDisabled  = true
			else
				self.Owner.Shield:SetPos(self.Owner:LocalToWorld( Vector( 0 ,15, 17 ) ) )  -- self.Owner:GetPos() + Vector(10,0,15) + (self.Owner:GetForward()*25))
				self.Owner.Shield:SetAngles( self.Owner:GetAngles() + Angle( -5,0,0 ) )
				self.Owner.Shield:SetParent( self.Owner )
				self.Owner.Shield:Fire("SetParentAttachmentMaintainOffset", "anim_attachment_RH", 0.01)
				self.Owner.Shield:SetOwner( self.Owner ) 
				self.Owner.Shield.Owner = self.Owner 
				self.Owner.Shield.PhysgunDisabled  = true
			end
		end
	end
	
	
	
	function SWEP:Holster()
	
		if( IsValid( self.Owner.Shield ) ) then 
			self.Owner.Shield:Remove()
			self.Owner.Shield.PhysgunDisabled  = false
		end 
		
		return true 
		
	end 
	

else 
	
	function SWEP:Draw()
	
		return false
	
	end 


end 
