local Spread = 0.1
			
function EFFECT:Init( data )

	self.Player = data:GetEntity()
	
	if ( !IsValid( self.Player ) || !IsValid( self.Player:GetActiveWeapon() ) ) then return end
	
	self.Origin = self.Player:GetShootPos()
	self.Attachment = data:GetAttachment()
	self.Forward = self.Player:EyeAngles():Forward()
	self.Magnitude = data:GetMagnitude()
	self.Scale = data:GetScale()

	self.Angle = self.Forward:Angle()
	self.Position = self:GetTracerShootPos( self.Origin, self.Player:GetActiveWeapon(), self.Attachment )

	if ( ( self.Position == self.Origin ) ) then
		local att = self.Player:GetAttachment( self.Player:LookupAttachment( "anim_attachment_RH" ) )
		if ( att ) then self.Position = att.Pos + att.Ang:Forward() * -2 end
	end

	local emitter = ParticleEmitter( self.Player:GetPos(), true )
	if ( !emitter ) then return end
	
	for i = 1, 12 * self.Magnitude do
		local particle = emitter:Add( "effects/splash4", self.Position )
		if ( particle ) then
			particle:SetVelocity( ( Vector( math.sin( math.Rand( 0, 360 ) ) * math.Rand( -Spread, Spread ), math.cos( math.Rand( 0, 360 ) ) * math.Rand( -Spread, Spread ), math.sin( math.random() ) * math.Rand( -Spread, Spread ) ) + self.Forward ) * 750 )

			local ang = self.Angle
			if ( i / 2 == math.floor( i / 2 ) ) then ang = ( self.Forward * -1 ):Angle() end
			particle:SetAngles( ang )
			particle:SetDieTime( 0.25 )
			particle:SetColor( 255, 255, 255 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( self.Scale )
			particle:SetEndSize( 0 )
			particle:SetCollide( 1 )
			particle:SetCollideCallback( function( myself, HitPos, normal )
				myself:SetAngleVelocity( Angle( 0, 0, 0 ) )
				myself:SetVelocity( Vector( 0, 0, 0 ) )
				myself:SetPos( HitPos + normal*0.1 )
				myself:SetGravity( Vector( 0, 0, 0 ) )

				local angles = normal:Angle()
				angles:RotateAroundAxis( normal, myself:GetAngles().y )
				myself:SetAngles( angles )

				myself:SetLifeTime( 0 )
				myself:SetDieTime( 10 )
				myself:SetStartSize( 8 )
				myself:SetEndSize( 0 )
				myself:SetStartAlpha( 128 )
				myself:SetEndAlpha( 0 )
			end )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
