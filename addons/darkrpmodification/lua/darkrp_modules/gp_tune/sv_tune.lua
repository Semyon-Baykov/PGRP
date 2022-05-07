module( 'gp_tune', package.seeall )

util.AddNetworkString( 'gp_tune_opmenu' )
util.AddNetworkString( 'gp_tunecar_en' )
util.AddNetworkString( 'gp_tunecar_clr' )
util.AddNetworkString( 'gp_tunecar' )



local meta = FindMetaTable( 'Player' )
local veh_meta = FindMetaTable( 'Entity' )

function meta:card_t_chat( text )
	self:ChatAddText( Color( 102, 204, 255 ), '[GPRP Tune] ', Color( 255, 255, 255 ), text )
end

function meta:OpenTuneMenu( class )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	if !_t[ class ] then return end

	local tbl = _t[ class ]

	if !_t then return end

	net.Start( 'gp_tune_opmenu' )
		net.WriteTable( tbl )
	net.Send( self )

end

function meta:TuneCar_body( class, tune, num )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))
	local tune_item = tbl[tune]

	if !_t[class] then return end
	if !tune_item then return end

	if !self:canAfford( tune_item.subs[num].price ) then
		self:card_t_chat( 'У вас нет таких денег!' )
		return
	end

	self:addMoney( -tune_item.subs[num].price )

	if num == 0 then
		self:card_t_chat( 'Вы успешно установили "'..tune_item.name..'" за '..DarkRP.formatMoney( tune_item.subs[num].price )..'!' )
	else
		self:card_t_chat( 'Вы успешно сняли "'..tune_item.name..'" за '..DarkRP.formatMoney( tune_item.subs[num].price )..'!' )
	end
	
	_t[class].parts[tune] = {
		num = num
	}

	self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )

	self:OpenTuneMenu( class )

	self:GetNWEntity( 'gpcard_veh' ):InitializeTune()

end

function meta:TuneCar_engine( class, stage )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	local s = tbl_en[stage]

	if !_t[class] then return end
	if !s then return end

	if !self:canAfford( s.price ) then
		self:card_t_chat( 'У вас нет таких денег!' )
		return
	end

	self:addMoney( -s.price )

	self:card_t_chat( 'Вы успешно установили "'..s.name..'" за '..DarkRP.formatMoney( s.price )..'!' )
	
	_t[class].parts['en_tune'] = { stage = stage }

	self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )

	self:OpenTuneMenu( class )

	self:GetNWEntity( 'gpcard_veh' ):InitializeTune()

end

function meta:TuneCar_color( class, color, Skin )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	if !_t[class] then return end

	if !self:canAfford( 25000 ) then
		self:card_t_chat( 'У вас нет таких денег!' )
		return
	end

	self:addMoney( -25000 )

	self:card_t_chat( 'Вы успешно перекрасили т/c за '..DarkRP.formatMoney( 25000 )..'!' )
		
	PrintTable( color )
	print( Skin )

	_t[class].info.color = color
	_t[class].parts['skin'] = { skin = Skin }

	self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )

	self:OpenTuneMenu( class )

	self:GetNWEntity( 'gpcard_veh' ):InitializeTune()

end

function veh_meta:InitializeTune()

	if not IsValid( self.Owner ) then
		return
	end

	local ply = self.Owner
	local class = util.JSONToTable(ply:GetNWString( 'gpcard_cartable' )).info.class

	local _t = util.JSONToTable(ply:GetPData( 'gpcard_simf', '[]' ))
	local parts = _t[class].parts

	if parts['skin'] then
		self:SetSkin( parts['skin'].skin )
	end

	self:SetColor( _t[class].info.color )

	for k,v in pairs( self:GetBodyGroups() ) do
		if parts[v.name] then
			self:SetBodygroup( v.id, parts[v.name].num )
		end
	end

	if parts['en_tune'] then
		local stage = parts['en_tune'].stage

		-- back to default

		local vname = self:GetSpawn_List()
		local VehicleList = list.Get( "simfphys_vehicles" )[vname]
	
		self:SetLimitRPM( VehicleList.Members.LimitRPM )
		self:SetPowerBandEnd( VehicleList.Members.PowerbandEnd )
		self:SetMaxTorque( VehicleList.Members.PeakTorque )
		self:SetTurboCharged( VehicleList.Members.Turbocharged or false )
		self:SetSuperCharged( VehicleList.Members.Supercharged or false )
		

		local rpm, torque, band, turbo, super_turbo, fire = self:GetLimitRPM(), self:GetMaxTorque(), self:GetPowerBandEnd(), self:GetTurboCharged(), self:GetSuperCharged(), self:GetBackFire()


		if stage == 1 then
			self:SetLimitRPM( rpm*1.055  )
			self:SetMaxTorque( torque*1.45 )
			self:SetPowerBandEnd( band*1.05 )
		elseif stage == 2 then
			self:SetLimitRPM( rpm*1.1  )
			self:SetMaxTorque( torque*1.55 )
			self:SetPowerBandEnd( band*1.15  )
			if not turbo then
				self:SetTurboCharged( true )
			end
		elseif stage == 3 then
			self:SetLimitRPM( rpm*1.2  )
			self:SetMaxTorque( torque*1.65 )
			self:SetPowerBandEnd( band*1.25 )
			if not turbo then
				self:SetTurboCharged( true )
			end
			if not super_turbo then
				self:SetSuperCharged( true )
			end
			if not fire then
				self:SetBackFire( true )
			end
		end
	end
end

net.Receive( 'gp_tunecar', function( _, ply ) 

	local class = net.ReadString()
	local tune = net.ReadString()
	local num = net.ReadInt( 4 )

	ply:TuneCar_body( class, tune, num )

end)

net.Receive( 'gp_tunecar_en', function( _, ply ) 

	local class = net.ReadString()
	local stage = net.ReadInt( 4 )


	ply:TuneCar_engine( class, stage )

end)
net.Receive( 'gp_tunecar_clr', function( _, ply ) 

	local class = net.ReadString()
	local col = string.ToColor( net.ReadString() )
	local Skin = net.ReadInt( 6 )


	ply:TuneCar_color( class, col, Skin )

end)