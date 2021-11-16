--[[
THIS SCRIPT IS CREATED BY CRAP-HEAD
GMODSTORE PROFILE: https://www.gmodstore.com/users/crap-head
CRAP-HEAD STEAM ID || CRAP-HEAD ID 64
STEAM_0:0:14587461 || 76561198051291901
--]]

function EFFECT:Init( data )
	local target = data:GetEntity()
    local pos = Vector( 0, 0, 0 )
	
	if IsValid( self ) and IsValid( data:GetEntity() ) then
        pos = self:GetTracerShootPos( data:GetOrigin(), data:GetEntity():GetActiveWeapon(), data:GetAttachment())
    end
	local emitter = ParticleEmitter( pos )
	
	for i = 1, 10 do
		if target and IsValid( target ) and target:IsPlayer() and target:Alive() then
			local effect = emitter:Add( "effects/extinguisher", pos )
			effect:SetVelocity( target:GetAimVector() * 500 )
			effect:SetDieTime( 1 )
			effect:SetStartAlpha( 0 )
			effect:SetEndAlpha( 100 )
			effect:SetStartSize( 5 )
			effect:SetEndSize( 40 )
			effect:SetRoll( math.Rand( 0, 10  ) )
			effect:SetRollDelta( math.Rand( -0.2, 0.2 ) )
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end