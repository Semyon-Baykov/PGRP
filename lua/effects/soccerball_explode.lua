AddCSLuaFile()

function EFFECT:Init( data )

	local pressure = data:GetScale()
	local vOffset = data:GetOrigin()

	util.ScreenShake( vOffset , 10 , 0.1, 0.1, 150 )
	sound.Play( "Weapon_AR2.NPC_Double", vOffset, 90, math.random( 90, 120 ) )

	local NumParticles = 32
	local emitter = ParticleEmitter( vOffset, true )
	local b = false

		for i = 1 , NumParticles do

			local Pos = Vector( math.Rand( -1 , 1 ), math.Rand( -1 , 1 ), math.Rand( -1 , 1 ) )
			local Color = ( b ) and color_white or color_black
			local particle = emitter:Add( "particles/balloon_bit", vOffset + Pos * 16 )
			b = not b
			if particle then

				particle:SetVelocity( Pos * ( 250 + 250 * pressure )  )

				particle:SetLifeTime( 0 )
				particle:SetDieTime( 10 )

				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 255 )

				particle:SetStartSize( 3 )
				particle:SetEndSize( 0.5 )

				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )

				particle:SetAirResistance( 100 + ( 250 * ( 1 - pressure ) ) )
				particle:SetGravity( Vector(0,0,-300) )

				local randdarkness = math.Rand( 0.8, 1.0 )
				particle:SetColor( Color.r*randdarkness, Color.g*randdarkness, Color.b*randdarkness )

				particle:SetCollide( true )

				particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) )

				particle:SetBounce( 1 )
				particle:SetLighting( true )

			end

		end

	emitter:Finish()

end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
