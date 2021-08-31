util.AddNetworkString( 'gp_c4' )

local meta = FindMetaTable( 'Entity' )
local props_to_delete = {}

local function delete_exploded_props()
	timer.Simple(30, function()
		for k, v in ipairs( props_to_delete ) do
			v:Remove()
		end
	end)
end

function meta:OpenC4Menu( activator )

	net.Start( 'gp_c4' )
		net.WriteEntity( self )
	net.Send( activator )

end

function meta:C4_Defuse( ply, code )

	if not IsValid( self ) or not IsValid( ply ) then
		return
	end

	if self.code == code then
		self:c4_RemoveTimers()
		self:EmitSound( 'weapons/c4/c4_disarm.wav' )
		self:Remove()
	else
		ply:ChatAddText( Color( 255, 0, 0 ), '[C4] ', Color( 255, 255, 255 ), 'Неверный код!' )
	end

end

function meta:C4_StartTimer( ply, code )

	if not IsValid( ply ) then
		return
	end

	if string.len(code) > 4 then
		return
	end

	local a = 1
	self.code = code
	self:SetNWBool( 'c4_timer_started', true )
	self:SetNWInt( 'c4_ExplodeTime', CurTime() + 60 )

	timer.Create( 'c4_timer_'..self:EntIndex(), 1, 60,  function()

		a = a + 1

		if a == 60 then
			self:c4_RemoveTimers()
			self:C4_Explode( ply )
		end

		self:SetNWInt( 'c4_StartTime', 60 - a )

	end )

end

function meta:c4_RemoveTimers()

	local id = self:EntIndex()

	timer.Remove( 'c4_timer_'..id )

end
local c4boom = Sound("c4.explode")
function meta:C4_Explode( activator )

	if not IsValid( self ) then return end

	local radius = 350

	-- util.BlastDamage( self, owner, self:GetPos(), radius, 500 )
	local ents_tbl = ents.FindInSphere( self:GetPos(), radius )
	for k,v in ipairs( ents_tbl ) do

		if v:GetClass() == 'prop_door_rotating' then
			v:Fire( 'unlock' )
			v:Fire( 'open' )
		end
		if v.isFadingDoor then
			fadingdoors.Fade(v)
		end
		if v:GetClass() == 'func_breakable' then
			v:Fire( 'Break' )
		end
		if v:GetClass() == 'prop_physics' and not v.isFadingDoor then
			constraint.RemoveAll( v )
			local PhysObj = v:GetPhysicsObject()
			PhysObj:EnableMotion(true)
			table.append(props_to_delete, v)
		end

	end
	
	delete_exploded_props()
	
	-- Boom!
	self:EmitSound( 'siege/big_explosion.wav', 100, 100 )
	local effect = EffectData()
	effect:SetStart(self:GetPos())
	effect:SetOrigin(self:GetPos())
	effect:SetScale(300)
	effect:SetRadius(300)
	effect:SetMagnitude(500)
	effect:SetOrigin(self:GetPos())
	util.Effect("Explosion", effect, true, true)
	util.Effect("HelicopterMegaBomb", effect, true, true)
	-- Explode
	local vPoint = self:GetPos()
	local effect_explode = ents.Create( "env_explosion" )
	if not IsValid( effect_explode ) then return end
	effect_explode:SetPos( vPoint )
	effect_explode:Spawn()
	effect_explode:SetKeyValue( "iMagnitude","220" )
	effect_explode:Fire( "Explode", 0, 0 )
	
 	--[[local effect = EffectData()
	  effect:SetStart(self:GetPos())
	  effect:SetOrigin(self:GetPos())
	  -- these don't have much effect with the default Explosion
	  effect:SetScale(300)
	  effect:SetRadius(300)
	  effect:SetMagnitude(500)
	  effect:SetOrigin(self:GetPos())
	  util.Effect("Explosion", effect, true, true)
	  util.Effect("HelicopterMegaBomb", effect, true, true)

	   local phexp = ents.Create("env_physexplosion")
      phexp:SetPos(self:GetPos())
      phexp:SetKeyValue("magnitude", 500)
      phexp:SetKeyValue("radius", 300)
      phexp:SetKeyValue("spawnflags", "19")
      phexp:Spawn()
      phexp:Fire("Explode", "", 0)
        timer.Simple(0.1, function() sound.Play(c4boom, self:GetPos(), 100, 100) end) --]]
	
	self.IsDestroyed = true
	self:Remove()
end

net.Receive( 'gp_c4', function( _, ply )

		local ent = net.ReadEntity()
		local code = net.ReadString()

		if not ent:GetNWBool( 'c4_timer_started', false ) then
			ent:C4_StartTimer( ply, code )
		else
			ent:C4_Defuse( ply, code )
		end

end )
