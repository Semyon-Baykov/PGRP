if SERVER then

	AddCSLuaFile()

	resource.AddWorkshop( '104607228' )

else

	local EFFECT = {}

	function EFFECT:Init( data )



		self.Player = data:GetEntity()

		self.Origin = data:GetOrigin()

		self.Attachment = data:GetAttachment()

		self.Forward = data:GetNormal()

		self.Scale = data:GetScale()



		if ( !IsValid( self.Player ) || !IsValid( self.Player:GetActiveWeapon() ) ) then return end



		self.Angle = self.Forward:Angle()

		self.Position = self:GetTracerShootPos( self.Origin, self.Player:GetActiveWeapon(), self.Attachment )



		if ( ( self.Position == self.Origin ) ) then

			local att = self.Player:GetAttachment( self.Player:LookupAttachment( "anim_attachment_RH" ) )

			if ( att ) then self.Position = att.Pos + att.Ang:Forward() * -2 end

		end



		local teh_effect = ParticleEmitter( self.Player:GetPos(), true )

		if ( !teh_effect ) then return end

		

		for i = 1, 12 * self.Scale do

			local particle = teh_effect:Add( "effects/splash4", self.Position )

			if ( particle ) then

				local Spread = 0.3

				particle:SetVelocity( ( Vector( math.sin( math.Rand( 0, 360 ) ) * math.Rand( -Spread, Spread ), math.cos( math.Rand( 0, 360 ) ) * math.Rand( -Spread, Spread ), math.sin( math.random() ) * math.Rand( -Spread, Spread ) ) + self.Forward ) * 750 )



				local ang = self.Angle

				if ( i / 2 == math.floor( i / 2 ) ) then ang = ( self.Forward * -1 ):Angle() end

				particle:SetAngles( ang )

				particle:SetDieTime( 0.25 )

				local hsv = HSVToColor( CurTime() % 6 * 60, 1, 1 )

				particle:SetColor( hsv.r, hsv.g, hsv.b )

				particle:SetStartAlpha( 255 )

				particle:SetEndAlpha( 0 )

				particle:SetStartSize( 8 )

				particle:SetEndSize( 0 )

				particle:SetCollide( 1 )

				particle:SetCollideCallback( function( particleC, HitPos, normal )

					particleC:SetAngleVelocity( Angle( 0, 0, 0 ) )

					particleC:SetVelocity( Vector( 0, 0, 0 ) )

					particleC:SetPos( HitPos + normal*0.1 )

					particleC:SetGravity( Vector( 0, 0, 0 ) )



					local angles = normal:Angle()

					angles:RotateAroundAxis( normal, particleC:GetAngles().y )

					particleC:SetAngles( angles )



					particleC:SetLifeTime( 0 )

					particleC:SetDieTime( 10 )

					particleC:SetStartSize( 8 )

					particleC:SetEndSize( 0 )

					particleC:SetStartAlpha( 128 )

					particleC:SetEndAlpha( 0 )

				end )

			end

		end



		teh_effect:Finish()

	end



	function EFFECT:Think()

		return false

	end



	function EFFECT:Render()

	end

	effects.Register( EFFECT, 'rb655_extinguisher_effect' )

end


SWEP.PrintName = 'Огнетушитель'

SWEP.Author = 'SnOOp{!}'

SWEP.Instructions = 'ЛКМ - Тушить пожар'

SWEP.WepSelectIcon = Material( "rb655_extinguisher_icon.png" )

SWEP.Slot = 2

SWEP.SlotPos = 1

SWEP.Category = 'GPortalRP'


SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false


SWEP.ViewModelFOV = 55

SWEP.ViewModelFlip = false


SWEP.Spawnable = true

SWEP.AdminSpawnable = true

SWEP.UseHands = true


game.AddAmmoType( { name = "rb655_extinguisher" } )

if ( CLIENT ) then language.Add( "rb655_extinguisher_ammo", "Extinguisher Ammo" ) end



SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = 10000

SWEP.Primary.Automatic = true

SWEP.Primary.Ammo = "rb655_extinguisher"


SWEP.Secondary.ClipSize = -1

SWEP.Secondary.DefaultClip = 0

SWEP.Secondary.Ammo = 'none'


SWEP.ViewModel = 'models/weapons/c_fire_extinguisher.mdl'

SWEP.WorldModel = 'models/weapons/w_fire_extinguisher.mdl'

function SWEP:Initialize()

	self:SetHoldType( 'slam' ) 

end



function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DRAW )

	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

	

	self:Idle()



	return true

end



function SWEP:DoEffect( effectscale )



	local effectdata = EffectData()

	effectdata:SetAttachment( 1 )

	effectdata:SetEntity( self.Owner )

	effectdata:SetOrigin( self.Owner:GetShootPos() )

	effectdata:SetNormal( self.Owner:GetAimVector() )

	effectdata:SetScale( effectscale or 1 )

	util.Effect( "rb655_extinguisher_effect", effectdata )



end



function SWEP:DoExtinguish( pushforce, effectscale )

	if ( self:Ammo1() < 1 ) then return end



	if ( CLIENT ) then 

		if ( self.Owner == LocalPlayer() ) then self:DoEffect( effectscale ) end -- FIXME

		return

	end



	self:TakePrimaryAmmo( 1 )

	

	effectscale = effectscale or 1

	pushforce = pushforce or 0



	local tr

	if ( self.Owner:IsNPC() ) then

		tr = util.TraceLine( {

			start = self.Owner:GetShootPos(),

			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 16384,

			filter = self.Owner

		} )

	else

		tr = self.Owner:GetEyeTrace()

	end

	

	local pos = tr.HitPos



	for id, prop in pairs( ents.FindInSphere( pos, 80 ) ) do

		if ( prop:GetPos():Distance( self:GetPos() ) < 256 ) then

			if ( prop:IsValid() and math.random( 0, 1000 ) > 500 ) then

				local wasOnFire

				if ( prop:IsOnFire() ) then prop:Extinguish() wasOnFire=true end

				local class = prop:GetClass()

				if string.find( class, 'sfire' ) or ( string.find( class, 'env_fire' ) and prop.sfire ) then

					if prop.sfire then

						prop = prop.sfire 

					end

					if not prop.health then

						prop.health = ( team.NumPlayers( TEAM_MEDIC ) * 20 )

					end

					prop.health = prop.health - 1

					if prop.health <= 0 then

						if prop:GetClass() == 'sfire' then prop:Remove() else prop:Extinguish() end

						if self.Owner:Team() == TEAM_MEDIC and prop:GetClass() =='sfire' then

							local money = math.random( 25, 75 )

							self.Owner:addMoney( money )

							DarkRP.notify( self.Owner, 4, 5, 'Вы получили $' .. string.Comma( money ) .. ' за тушение пожара!' )

						end

					end

					wasOnFire = not prop.aah

					prop.aah = true

				end



				if wasOnFire then

					hook.Run("PlayerExtinguishedFire", self.Owner, prop, self)

				end

			end

			

			if ( pushforce > 0 ) then

				local physobj = prop:GetPhysicsObject()

				if ( IsValid( physobj ) ) then

					physobj:ApplyForceOffset( self.Owner:GetAimVector() * pushforce, pos )

				end

			end

		end

	end



	self:DoEffect( effectscale )



end



function SWEP:PrimaryAttack()

	if ( self:GetNextPrimaryFire() > CurTime() ) then return end



	if ( IsFirstTimePredicted() ) then



		self:DoExtinguish( 196, 1 )



		if ( SERVER ) then



			if ( self.Owner:KeyPressed( IN_ATTACK ) || !self.Sound ) then 

				self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )



				self.Sound = CreateSound( self.Owner, Sound( "weapons/extinguisher/fire1.wav" ) )

				

				self:Idle()

			end



			if ( self:Ammo1() > 0 ) then if ( self.Sound ) then self.Sound:Play() end end



		end

	end

	

	self:SetNextPrimaryFire( CurTime() + 0.05 )

end



function SWEP:SecondaryAttack()

end



function SWEP:Reload()

end



function SWEP:PlaySound()

	self:EmitSound( "weapons/extinguisher/release1.wav", 100, math.random( 95, 110 ) )

end



function SWEP:Think()

	if ( self:GetNextSecondaryFire() > CurTime() || CLIENT ) then return end

	

	if ( ( self.NextAmmoReplenish or 0 ) < CurTime() ) then

		local ammoAdd = 0

		if ( self.Owner:WaterLevel() > 1 ) then ammoAdd = 25 end

	

		self.Owner:SetAmmo( math.min( self:Ammo1() + ammoAdd, self.Primary.DefaultClip * 2 ), self:GetPrimaryAmmoType() )

		self.NextAmmoReplenish = CurTime() + 0.1

	end



	if ( self.Sound && self.Sound:IsPlaying() && self:Ammo1() < 1 ) then

		self.Sound:Stop()

		self:PlaySound()

		self:DoIdle()

	end



	if ( self.Owner:KeyReleased( IN_ATTACK ) || ( !self.Owner:KeyDown( IN_ATTACK ) && self.Sound ) ) then

	

		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )



		if ( self.Sound ) then

			self.Sound:Stop()

			self.Sound = nil

			if ( self:Ammo1() > 0 ) then

				self:PlaySound()

				if ( !game.SinglePlayer() ) then self:CallOnClient( "PlaySound", "" ) end

			end

		end



		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

		self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() )

		

		self:Idle()



	end

end



function SWEP:Holster( weapon )

	if ( CLIENT ) then return end



	if ( self.Sound ) then

		self.Sound:Stop()

		self.Sound = nil

	end

	

	self:StopIdle()

	

	return true

end



function SWEP:DoIdleAnimation()

	if not IsValid( self.Owner ) then return end

	if ( self.Owner:KeyDown( IN_ATTACK ) and self:Ammo1() > 0 ) then self:SendWeaponAnim( ACT_VM_IDLE_1 ) return end

	if ( self.Owner:KeyDown( IN_ATTACK ) and self:Ammo1() < 1 ) then self:SendWeaponAnim( ACT_VM_IDLE_EMPTY ) return end

	self:SendWeaponAnim( ACT_VM_IDLE )

end



function SWEP:DoIdle()

	self:DoIdleAnimation()



	timer.Adjust( "rb655_idle" .. self:EntIndex(), self:SequenceDuration(), 0, function()

		if ( !IsValid( self ) ) then timer.Destroy( "rb655_idle" .. self:EntIndex() ) return end



		self:DoIdleAnimation()

	end )

end



function SWEP:StopIdle()

	timer.Destroy( "rb655_idle" .. self:EntIndex() )

end



function SWEP:Idle()

	if ( CLIENT || !IsValid( self.Owner ) ) then return end

	timer.Create( "rb655_idle" .. self:EntIndex(), self:SequenceDuration() - 0.2, 1, function()

		if ( !IsValid( self ) ) then return end

		self:DoIdle()

	end )

end



if ( SERVER ) then return end



SWEP.WepSelectIcon = Material( "rb655_extinguisher_icon.png" )



function SWEP:DrawWeaponSelection( x, y, w, h, a )

	surface.SetDrawColor( 255, 255, 255, a )

	surface.SetMaterial( self.WepSelectIcon )

	

	local size = math.min( w, h ) - 32

	surface.DrawTexturedRect( x + w / 2 - size / 2, y + h * 0.05, size, size )

end



