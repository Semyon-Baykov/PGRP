ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Fire Entity"
ENT.Author = "Orange Cosmos RP Team (Jake, Noob, Crap-Head)"
ENT.Contact = "N/A"

local PMETA = FindMetaTable( "Player" )

function PMETA:CanSee( ent, close )
	if close then
		if not self:HasLOS( ent ) then 
			return false 
		end
	end

	local fov = self:GetFOV()
	local disp = ent:GetPos() - self:GetPos()
	local dist = disp:Length()
	local size = ent:BoundingRadius() * 0.5
	
	local MaxCos = math.abs( math.cos( math.acos( dist / math.sqrt( dist * dist + size * size ) ) + fov * ( math.pi / 180 ) ) )
	disp:Normalize()

	if disp:Dot( self:EyeAngles():Forward() ) > MaxCos and ent:GetPos():Distance( self:GetPos() ) < 5000 then
		return true
	end
	
	return false
end