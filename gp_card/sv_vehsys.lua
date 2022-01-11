module( 'gp_vehsys', package.seeall )

local meta = FindMetaTable( 'Entity' )
local plymeta = FindMetaTable( 'Player' )


function plymeta:gpv_checkaccess( veh )

	if veh:GetDriver() ~= NULL and veh:getKeysDoorGroup() and table.HasValue(RPExtraTeamDoors[veh:getKeysDoorGroup()] or {}, self:Team()) then
		return false
	end

	return veh:GetDriver() == NULL and veh:getDoorOwner() == self or veh:getKeysCoOwners() and veh:getKeysCoOwners()[self.SID] or veh:getKeysDoorGroup() and table.HasValue(RPExtraTeamDoors[veh:getKeysDoorGroup()] or {}, self:Team()) or false

end

function meta:StartSignal()

	if self.signal == true then
		return
	end

	self:SetTSInternal( 1 )
	
	net.Start( "simfphys_turnsignal" )
		net.WriteEntity( self )
		net.WriteInt( 1, 32 )
	net.Broadcast()

	self.signal = true

	local a = 1

	local ent_index = self:EntIndex()

	timer.Create( 'signal_'..ent_index, 0.5, 45*2, function()

		if IsValid( self ) then

			if a == 1 then
				self:EmitSound( 'simulated_vehicles/horn_1.wav' )
				a = 0
				return
			end

			if a == 0 then
				self:StopSound( 'simulated_vehicles/horn_1.wav' )
				a = 1
				return
			end 		

		else

			timer.Remove( 'signal_'..ent_index )

		end

	end )

	self:CallOnRemove( 'signal_remvoe' , function()

		self:StopSound( 'simulated_vehicles/horn_1.wav' )

	end)

	timer.Simple( 45, function()

		if IsValid( self ) then
			self:SetTSInternal( 0 )
			self.signal = false
			if a == 0 then
				self:StopSound( 'simulated_vehicles/horn_1.wav' )
			end
			net.Start( "simfphys_turnsignal" )
				net.WriteEntity( self )
				net.WriteInt( 0, 32 )
			net.Broadcast()
		end

	end )

end