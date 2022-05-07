local Brightness = CreateClientConVar( 'fireworks_brightness', '1', true, false)
local ShowGlow = CreateClientConVar( 'fireworks_glow', '1', true, false)
local SmokeExplosion = CreateClientConVar( 'fireworks_smokeexplosion', '1', true, false)

// Screenspace Effects
local EffectTable = {}

local function AddEffect( Vec, Scale )
	if !Vec or !Scale then return end
	table.insert( EffectTable, {Vec, CurTime(), Scale} )
end

local function RenderScreenspaceEffects()
	if #EffectTable < 1 then return end
	
	for k, v in pairs (EffectTable) do
		local Position = v[1]
		local Time = v[2]
		local Scale = v[3]
		
		local FadeOutTimeMult = 1
		
		// First let's make sure the effect isn't over with, if it is then remove it.
		if ( CurTime() > Time + 3*FadeOutTimeMult ) then
			table.remove( EffectTable, k )
			continue
		end
		
		local ScreenPos = Position:ToScreen()
		
		local Eye_Angles = EyeAngles()
		local Eye_Origin = EyePos()
		
		local FadeOut = ( (CurTime() - Time)/3 ) * FadeOutTimeMult
		local Fade = -math.max( Eye_Angles:Forward():DotProduct( ( Position - Eye_Origin ):GetNormal() ) - FadeOut, 0 ) + 1

		local Mult = ( (-Fade+1)*0.25 )
		local Bright = math.Clamp( Brightness:GetFloat(), 0.1, 3 )
		
		DrawSunbeams( Fade, Mult*Bright, 0.035*Scale, ScreenPos.x / ScrW(), ScreenPos.y / ScrH() )
	end
end
hook.Add( 'RenderScreenspaceEffects', 'Fireworks.RenderScreenspaceEffects', RenderScreenspaceEffects )

function EFFECT:Init( data )
	
	self.Origin = data:GetOrigin()
	self.FWScale = data:GetScale()
	self.StartTime = CurTime()
	local Col = data:GetStart()	
	
	// Make Col brighter (Because it looks disgusting to have pure red fireworks)
	local Hue, Saturation, Value = ColorToHSV( Color( Col.r, Col.g, Col.b ) )
	Col = HSVToColor( Hue, Saturation/3, Value )
	
	// Do flash/glow effect
	if render.SupportsPixelShaders_2_0() && ShowGlow:GetBool() then
		AddEffect( self.Origin, self.FWScale )
	end
	
	sound.Play( 'fireworks/firework_explosion_'..math.random( 1, 3 )..'.wav', self.Origin, 165, math.Rand( 75, 125 ) )

	local NumParticles = math.Clamp( math.ceil( Lerp( self.FWScale/3, 128, 1024 ) ), 128, 1024 )
	local NumSmoke = 8
	
	local emitter = ParticleEmitter( self.Origin, false )
		for i=0, NumParticles do
			local Vel = ( VectorRand():GetNormal() * math.Rand( 2400, 2750 ) /* + Vector( 0, 0, 1500 ) */ )*self.FWScale
		
			local ColorParticleStreak = emitter:Add( 'sprites/gmdm_pickups/light', self.Origin )
			
			if ColorParticleStreak then
				ColorParticleStreak:SetVelocity( Vel )
				
				ColorParticleStreak:SetLifeTime( 0 )
				ColorParticleStreak:SetDieTime( 5 )
				
				ColorParticleStreak:SetStartAlpha( 255 )
				ColorParticleStreak:SetEndAlpha( 0 )
				
				local Size = math.Rand( 50, 75 )
				ColorParticleStreak:SetStartSize( Size*self.FWScale )
				ColorParticleStreak:SetEndSize( 0 )
				
				local AirResistance = math.Rand(  130, 150 )
				ColorParticleStreak:SetAirResistance( AirResistance )
				
				local Gravity = math.Rand( -300, -500 )
				
				ColorParticleStreak:SetGravity( Vector( 0, 0, Gravity ) )
				
				local RandBrightness = math.Rand(0.2,1)
				ColorParticleStreak:SetColor( Col.r*RandBrightness, Col.g*RandBrightness, Col.b*RandBrightness )
				
				ColorParticleStreak:SetStartLength( Size*5*self.FWScale )
				ColorParticleStreak:SetEndLength( 0 )
				
				ColorParticleStreak:SetCollide( false )
				ColorParticleStreak:SetBounce( 1 )
			end
		end
		
		if self.FWScale >= 0.75 && SmokeExplosion:GetBool() then
			for i=0, NumSmoke do
				local SmokeEffect = emitter:Add( 'particle/particle_noisesphere', self.Origin )
				local Vel = VectorRand():GetNormal()*math.Rand( 1000, 2000 )*self.FWScale
				
				if SmokeEffect then
					SmokeEffect:SetVelocity( Vel )
					
					SmokeEffect:SetLifeTime( 0 )
					SmokeEffect:SetDieTime( 10 )
					
					SmokeEffect:SetStartAlpha( 15 )
					SmokeEffect:SetEndAlpha( 0 )
					
					SmokeEffect:SetRoll( 0, 360 )
					SmokeEffect:SetRollDelta( math.Rand( -0.4, 0.4 ) )
					
					local Size = math.Rand( 450, 650 )*self.FWScale
					SmokeEffect:SetStartSize( Size )
					SmokeEffect:SetEndSize( Size*math.Rand( 2, 5 ) )
					
					SmokeEffect:SetAirResistance( 100 )
					SmokeEffect:SetGravity( Vector( 0, 0, 0 ) )
					
					local RandDarkness = math.Rand( 0.25, 1 )
					
					SmokeEffect:SetColor( 255*RandDarkness, 255*RandDarkness, 255*RandDarkness )
				end
			end
		end
		
	emitter:Finish()
	
	SafeRemoveEntityDelayed( self, 15 ) // Some people say it doesn't remove itself properly. So hopefully this will fix it. (If it was ever really broken) (I don't think it was)
end

function EFFECT:Think( )
	return CurTime() < self.StartTime + 0.5
end


local Mat = Material( 'sprites/gmdm_pickups/light' )

function EFFECT:Render()
	if !ShowGlow:GetBool() then return end
	if CurTime() > self.StartTime + 0.5 then return end
	
	local Increase = ( ( CurTime() - self.StartTime ) / 0.5 )

	local Alpha = (-Increase+1)*0.75

	local Size = 8192*Increase
	
	render.SetMaterial( Mat )
	render.DrawSprite( self.Origin, Size*self.FWScale, Size*self.FWScale, Color(255, 255, 255, Alpha*255) )
end