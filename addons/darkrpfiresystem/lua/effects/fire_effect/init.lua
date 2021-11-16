--[[
THIS SCRIPT IS CREATED BY CRAP-HEAD
GMODSTORE PROFILE: https://www.gmodstore.com/users/crap-head
CRAP-HEAD STEAM ID || CRAP-HEAD ID 64
STEAM_0:0:14587461 || 76561198051291901
--]]

function EFFECT:Init( data )
	local trace = {}
	trace.start = data:GetOrigin() - Vector(0, 0, 5)
	trace.endpos = data:GetOrigin() - Vector(0, 0, 5) + Vector(0, 0, 500)
	local tr = util.TraceLine( trace )
	
	local pos = data:GetOrigin() - Vector( 0, 0, 5 )
	local fire_emitter = ParticleEmitter( pos )
	
	local TheFire = fire_emitter:Add( "effects/flame", pos )
	
	if ( TheFire ) then
		if tr.Hit then
			TheFire:SetVelocity( Vector( math.random( -30, 30 ), math.random( -30, 30 ), math.random( 0, 70 ) ) )
		else
			TheFire:SetVelocity( Vector( math.random( -30, -20 ), math.random( 20, 30 ), math.random( 0, 70 ) ) )
		end
		TheFire:SetDieTime( math.random( 2, 3 ) )
		TheFire:SetStartAlpha( 230 )
		TheFire:SetEndAlpha( 0 )
		TheFire:SetStartSize( math.random( 70, 80 ) )
		TheFire:SetEndSize( 10 )
		TheFire:SetRoll( math.random( 0, 10 ) )
		TheFire:SetRollDelta( math.random( -0.2, 0.2 ) )
	end
	
	fire_emitter:Finish()
	
	if CH_FireSystem.Config.EnableSmokeEffect then
		local pos = data:GetOrigin() + Vector( 0, 0, 5 )
		local smoke_emitter = ParticleEmitter( pos )
	
		local SmokeEffect = smoke_emitter:Add( "particle/smokestack", pos )
		if ( SmokeEffect ) then
			SmokeEffect:SetAirResistance( 0 )
			SmokeEffect:SetVelocity( Vector( math.random(-30,30), math.random(-30, 30), math.random(0, 70) ) )
			SmokeEffect:SetDieTime( 2 )
			SmokeEffect:SetStartAlpha( math.random( 100, 300 ) )
			SmokeEffect:SetGravity( Vector( 5, 5, 50 ) )
			SmokeEffect:SetCollide( true )
			SmokeEffect:SetColor( Color( 0, 0, 0, 255 ) )
			SmokeEffect:SetEndAlpha( 0 )
			SmokeEffect:SetStartSize( math.random( 35, 80 ) )
			SmokeEffect:SetEndSize( math.random( 10, 25 ) )
			SmokeEffect:SetRoll( math.random( 0, 10 ) )
			SmokeEffect:SetRollDelta( math.random( -0.2, 0.2 ) )
		end
		
		smoke_emitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end