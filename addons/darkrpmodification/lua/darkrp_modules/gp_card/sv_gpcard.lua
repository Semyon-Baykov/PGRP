module( 'gp_cardealer', package.seeall )



local meta = FindMetaTable( 'Player' )

util.AddNetworkString( 'gp_card_spawnmenu' )
util.AddNetworkString( 'gpcard_spawn' )
util.AddNetworkString( 'gpcard_remove' )
util.AddNetworkString( 'gpcard_buy' )
util.AddNetworkString( 'gpcard_database' )
util.AddNetworkString( 'gpcard_sell' )
util.AddNetworkString( 'gpcard_rmar' )
util.AddNetworkString( 'gpcard_withdraw' )
util.AddNetworkString( 'gpcard_uaaa' )

util.AddNetworkString( 'DRPLoadedFine' )

local terms_tbl = {
	{
		term_pos = Vector(-6946.330078, -1833.427124, -203.247604),
		term_ang = Angle( 0,90,0 ),
		term_spawnpos = { Vector(-7550.097168, -1712.308472, -203.186081), Vector(-7544.129395, -1579.185669, -203.157455), Vector(-7541.632324, -1449.393677, -203.145035) },
		term_spawnang = Angle( 0, -90, 0 )
	},
	{
		term_pos = Vector(1552.385132,  603.604675, -195.247604),
		term_ang = Angle( 0,90,0 ),
		term_spawnpos = { Vector(1443.848145, 906.626709, -133.968750), Vector(1446.127808, 783.075562, -133.968750), Vector(1448.085449, 669.223389, -133.968750) },
		term_spawnang = Angle( 0, 90, 0 )
	},
	{
		term_pos = Vector(-13486.666016, -848.676208, -190.613876), //rg
		term_ang = Angle( 0,0,0 ),
		term_spawnpos = { Vector( -13450.881836, -521.630432, -203.591553 ), Vector( -13725.671875, -534.247253, -203.615738 ), Vector( -14017.625977, -564.797241, -203.598358 ) },
		term_spawnang = Angle( 0, 0, 0 )
	}
}


function SpawnTerms()

	print("HOOK INITIALIZED AAAA OOOO!!!")

	for k,v in pairs( terms_tbl ) do

		local en = ents.Create( 'ent_cardterm' )
		en:SetPos( v.term_pos )
		en:SetAngles( v.term_ang )
		en.spawnpos = v.term_spawnpos
		en.spawnang = v.term_spawnang
		en:Spawn()
		en:GetPhysicsObject():EnableMotion( false )
		
		print("Car entity spawned!")	
	end

end
hook.Add( 'InitPostEntity', 'gpcard_init', function()
	print("HOOK INITIALIZED AAAA OOOO!!!")
	SpawnTerms()
end )

function meta:card_chat( text )
	self:ChatAddText( Color( 139, 0, 0 ), '[PGRP Cars] ', Color( 255, 255, 255 ), text )
end

function meta:AddCar( class, don, color, number, parts )

	if !don then
		don = false
	end
	if !color then
		color = color_white
	end
	if !number then
		number = RandomNumberDef()
	end
	if !parts then
		parts = {}
	end

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))


	_t[class] = { 
		info = {
			class = class,
			donate = don,
			number = number,
			color = color
		},
		parts = parts
	 }

	self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )

end

--[[function meta:SellCar_ar( class, desc, price )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	if !_t[class] then return end

	local tb = tbl.cars[ class ]

	if price < math.ceil(tb.price/1.5) then
		self:card_chat( 'Некорректная цена' )
		return
	end

	if _t[class].info.hp then 
		if _t[class].info.hp != _t[class].info.maxhp then
			self:card_chat( 'Машина должна быть полностью починенной и заправленной!' )
			return
		end
	end

	if _t[class].info.fuel then 
		if _t[class].info.fuel != _t[class].info.fuel then
			self:card_chat( 'Машина должна быть полностью починенной и заправленной!' )
			return
		end
	end


	if !gp_shop.shop_db:ping() then
		self:card_chat( 'Нету подключения к mysql базе данных.' )
		return
	end

	local ar_tbl = 0

	 local db = gp_shop.shop_db

	 local qr = 'SELECT * FROM `gp_carshop`'
	
	local gb = db:query( qr )
	gb.onError = function( q, err )
		print( err )
	end
	gb.onData = function()
		ar_tbl = gb:getData()
	end
	gb:start()

	timer.Simple( 3, function()
		if ar_tbl and #ar_tbl and #ar_tbl > 15 then
			self:card_chat( 'Авторынок переполнен (>15 машин в продаже), попробуйте позже.' )
			return
		end
		
		self:RemoveCar( class )
		self:card_chat( 'Вы успешно выставили '..tbl.cars[class].name..' на продажу!' )
		ar_tbl = ar_tbl + 1
		
	end)
end--]]

function meta:SellCarGov( class )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	if !_t[class] then return end

	local tb = tbl.cars[ class ]

	self:RemoveCar( class )
	self:addMoney( math.ceil(tb.price/2) )

	self:card_chat( 'Вы успешно продали свое т/c за '..DarkRP.formatMoney( math.ceil(tb.price/2) )..'!' )


end

function meta:RemoveCar( class )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	if !_t[class] then return end

	_t[class] = nil 

	self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )
end

function meta:BuyDefCar( class, color )

	if string.find( class, 'low' ) then return end

	local tb = tbl.cars[ class ]

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	if !tb then return end

	if !self:canAfford( tb.price ) then
		self:card_chat( 'Для покупки данного транспортного средства недостаточно средств.' )
		return
	end

	if _t[class] then
		self:card_chat( 'У вас уже есть данный автомобиль.' )
		return
	end

	if tb.vip and !self:gp_VipAccess() then
		self:card_chat( 'Вы не Premium! Приобрести его можно в F9' )
		return
	end
	
	self:addMoney( -tb.price )

	self:AddCar( class, false, color )

	self:card_chat( 'Вы приобрели "'..tb.name..'" за '..DarkRP.formatMoney(tb.price)..'. Поздравляем с покупкой!' )

end

function meta:BuyArCar( id )

	local db = gp_shop.shop_db
	
	local qr = 'SELECT * FROM gp_carshop where id ="'..id..'"'

	local gb = db:query( qr )
	gb.onData = function( q, data )
			
		local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

		local tb = data
		local _tb = tbl.cars[tb.carname]
		if !self:canAfford( tb.price ) then
			self:card_chat( 'Для покупки данного транспортного средства недостаточно средств.' )
			return
		end

		if _t[tb.carname] then
			self:card_chat( 'У вас уже есть данный автомобиль.' )
			return
		end

		PrintTable( tb )
		local qr = 'DELETE FROM gp_carshop where id ="'..id..'"'
		local gdb = db:query( qr )
		gdb.onSuccess = function( q )

			self:addMoney( -tb.price )
			self:card_chat( 'Вы приобрели "'.._tb.name..'" за '..DarkRP.formatMoney(tb.price)..'. Поздравляем с покупкой!' )
			self:AddCar( tb.carname, false, string.ToColor( tb.color ), tb.number, util.JSONToTable( tb.tune ) )
			util.SetPData( tb.osid, 'gpcard_armon', util.GetPData( tb.osid, 'gpcard_armon', 0 ) + tb.price )
			if player.GetBySteamID( tb.osid ) then
				local pl = player.GetBySteamID( tb.osid )
				pl:card_chat( self:Nick()..' купил ваше т/с на авторынке. Забрать выручку можно в меню F4.' )
				pl:SetNWInt( 'gpcard_armon' , tonumber(pl:GetPData( 'gpcard_armon' )) )
			end

		end
		gdb.onError = function( q, err )

			print( 'Ошибка: "'..err..'"' )
			self:card_chat( "Ошибка базы данных '"..err.."'. Обратитесь к Kail'у" )

		end

		gdb:start()

	end
	gb.onError = function( q, err )
		print( 'Ошибка: "'..err..'"' )
		self:card_chat( "Ошибка базы данных '"..err.."'. Обратитесь к Kail'у" )
	end
	gb:start()

end

local function prepare_tbl( t, ply )

	for k,v in pairs( tbl.govcars ) do
		if v.check(ply) then
			t[k] = { 
				id = k,
				info = {
					class = k,
					donate = false,
					number = RandomNumberPolice(),
					gov = true
				},
				parts = {}
			}
		end
	end

	return t

end


function meta:OpenSpawnMenu( ent )

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))


	net.Start( 'gp_card_spawnmenu' )
		net.WriteTable( prepare_tbl( _t, self ) )
		net.WriteEntity( ent )
	net.Send( self )


end

local function CheckSpace( pos )

	local _e  = ents.FindInSphere( pos , 70 )
	
	for k,v in pairs( _e ) do
		if v:IsVehicle() then
			return true
		end
	end

end



function meta:SpawnCar( ent, car )

	if !ent then return end
	if math.Dist(ent:GetPos()[1],ent:GetPos()[2], self:GetPos()[1],self:GetPos()[2]) > 100 then return end
	if self:GetNWEntity( 'gpcard_veh' ) != NULL then
		self:card_chat( 'У вас уже есть вызванный транспорт (С >> Отозвать транспорт)' )
		return
	end
	local sp = ent.spawnpos
	local sa = ent.spawnang
	if !istable(sp) then
		sp = {Vector(ent:GetPos()[1]-150,ent:GetPos()[2], ent:GetPos()[3])}
	end
	if !isangle(sa) then
		sa = Angle( 0, 0, 0 )
	end
	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))
	local __t = prepare_tbl( _t, self )
	if !__t[car] then 
		self:card_chat( 'У вас нету данного транспорта.' )
		return 
	end

	for k,v in pairs( sp ) do

		if CheckSpace( v ) then
			continue
		end

		if __t[car].info.gov and tbl.govcars[car].check(self) then
			local tbl = tbl.govcars[car]

			local _ = simfphys.SpawnVehicleSimple( car, v, sa )
			_:setDoorGroup( tbl.doorgroup )
			_.car = car
			_.gov = true
			_:keysLock()
			self:card_chat( 'Служебный '..tbl.name..' успешно создан!' )
			self:SetNWEntity( 'gpcard_veh', _ )
			_:CallOnRemove('gpcard_remgov', function()
				self:SetNWEntity( 'gpcard_veh', NULL )
			end)
			self:SetNWString( 'gpcard_cartable', util.TableToJSON( { info = { number = __t[car].info.number, class = __t[car].info.class, gov = true } } ) )
			hook.Run( 'PlayerSpawnedVehicle', self, _  )
			_:CPPISetOwner(world)
		else
			local tbl1
			if __t[car].info.donate then
				tbl1 = tbl.doncars[car]
			else
				tbl1 = tbl.cars[car]
			end

			local _ = simfphys.SpawnVehicleSimple( car, v, sa )
			_.OnDestroyed = function(ent) self:DestroyCar( _ ) self.destroyed = true end
			_.OnDelete = function( ent )
				if IsValid( self ) then
					local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))
					if self.destroyed == true then 
						_t[ent.car].info.fuel = ent:GetFuel()
						self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )
				     	return
				     end
					_t[ent.car].info.hp = ent:GetCurHealth()
					_t[ent.car].info.fuel = ent:GetFuel()
					self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )
				end
			end
			
			_.car = car
			_:keysOwn( self )
			_.Owner = self
			_:keysLock()
			_:SetColor( __t[car].info.color )
			hook.Run( 'PlayerSpawnedVehicle', self, _  )
			self:card_chat( 'Ваш '..tbl1.name..' успешно создан!' )
			timer.Simple( .5, function() 
				if __t[car].info.hp and __t[car].info.fuel then
					_:SetCurHealth( __t[car].info.hp )
					if __t[car].info.hp == 0 then
						_.Destroyed = true
					end
					_:SetFuel( __t[car].info.fuel )				
				else
					_:SetCurHealth( _:GetMaxHealth() )
					_:SetFuel( _:GetMaxFuel() )
				end
			end)
			self:SetNWEntity( 'gpcard_veh', _ )
			_:CallOnRemove('gpcard_remdef', function()
				self:SetNWEntity( 'gpcard_veh', NULL )
			end)
			self:SetNWString( 'gpcard_cartable', util.TableToJSON( { info = { number = __t[car].info.number, hp = __t[car].info.hp, maxhp = __t[car].info.maxhp, fuel = __t[car].info.fuel, maxfuel = __t[car].info.maxfuel, class = __t[car].info.class } } ) )
			_:SetNWString( 'LicensePlate', __t[car].info.number )
			_:CPPISetOwner(world)
			_:InitializeTune()
		end

		return
	end

end

function meta:RemoveSpawnedCar()

	local car = self:GetNWEntity( 'gpcard_veh' )

	if car == NULL then return end
	if !car.gov then
		
		local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))
		print( car:GetCurHealth() )
		_t[car.car].info.hp = car:GetCurHealth()
		_t[car.car].info.fuel = car:GetFuel()

		if not _t[car.car].info.maxhp and not _t[car.car].info.maxfuel then
			_t[car.car].info.maxhp = car:GetMaxHealth()
			_t[car.car].info.maxfuel = car:GetMaxFuel()
		end

		if _t[car.car].info.maxhp == 0 or  _t[car.car].info.maxfuel == 0 then
			_t[car.car].info.maxhp = car:GetMaxHealth()
			_t[car.car].info.maxfuel = car:GetMaxFuel()
		end
		self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )

	end


	car:Remove()

end

function meta:DestroyCar( car )
	
	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))
	_t[car.car].info.hp = 0
	print(car.car)
	self:SetPData( 'gpcard_simf', util.TableToJSON( _t ) )

end

hook.Add( 'PlayerDisconnected', 'gpcard_dis', function( ply ) 

	ply:GetNWEntity( 'gpcard_veh' ).trunk = {}
	ply:RemoveSpawnedCar()	

end)

hook.Add( 'OnPlayerChangedTeam', 'gpcard_change', function( ply )

	if ply:GetNWEntity( 'gpcard_veh' ) and ply:GetNWEntity( 'gpcard_veh' ).gov then

		ply:RemoveSpawnedCar()

	end

end )

function meta:Rmar( id )

	local db = gp_shop.shop_db
	
	local qr = 'SELECT * FROM gp_carshop where id ="'..id..'"'

	local gb = db:query( qr )
	gb.onData = function( q, data )

		local t = data

		if t.osid == self:SteamID() then
			
			local qr = 'DELETE FROM gp_carshop where id ="'..id..'"'
			local gdb = db:query( qr )
			gdb.onSuccess = function( q )

				self:card_chat( 'Вы успешно сняли свое т/с c продажи!' )
				self:AddCar( t.carname, false, string.ToColor( t.color ), t.number, util.JSONToTable( t.tune ) )

			end
			gdb.onError = function( q, err )

				print( 'Ошибка: "'..err..'"' )
				self:card_chat( "Ошибка базы данных '"..err.."'. Обратитесь к Kail'у" )

			end

			gdb:start()

		end

	end
	gb.onError = function( q, err )

		print( 'Ошибка: "'..err..'"' )
		self:card_chat( "Ошибка базы данных '"..err.."'. Обратитесь к Kail'у" )

	end
	gb:start()

end

function meta:card_migrate()

	if self:GetPData( 'card_migrate' ) == true then return end

	local _t = util.JSONToTable(self:GetPData( 'gpcard_simf', '[]' ))

	MySQLite.query( [[ SELECT * FROM fcd_playerData1 WHERE uniqueID =  ]]..self:UniqueID(), 
		function( data ) 
			if data and data[1].vehicles and util.JSONToTable(data[1].vehicles) then
				for k,v in pairs( util.JSONToTable(data[1].vehicles) ) do
					if _t[v] then
						continue
					end
					if tbl.cars[v] then 
						self:AddCar( v, false, color_white )
						self:SetPData( 'card_migrate', true )
					end
				end	
			end
		end 
	)

end

function meta:card_Refund()

	if self:GetPData( 'gpcard_vehs1', false ) then

		local refund_tbl = util.JSONToTable( self:GetPData( 'gpcard_vehs1' ) )

		local actual_price = 0

		print( 'Start card refund for '..self:Nick()..' | '..self:SteamID() )

		for k,v in pairs( refund_tbl ) do
			
			if not tbl.refund[k] then continue end

			print( 'class = '..k..' | '..actual_price..' + '..tbl.refund[k].price.. ' = '..(actual_price + tbl.refund[k].price) )
			actual_price = actual_price + tbl.refund[k].price

		end

		print( 'Final price: '..DarkRP.formatMoney( actual_price ) )

		self:card_chat( 'Весь ваш транспорт удален из-за несовместимости с обновлением.\n Средства, а именно - '..DarkRP.formatMoney( actual_price )..' потраченные на покупку транспорта возвращены на ваш счет Б/У авторынка.\nИзвиняемся за доставленные неудобства.' )

		self:SetPData( 'gpcard_armon', self:GetPData( 'gpcard_armon', 0 ) + actual_price )

		self:RemovePData( 'gpcard_vehs1' )

	end

end


---------------------------networking----------------------

net.Receive( 'gpcard_spawn', function( _, ply )

	local ent = net.ReadEntity()
	local car = net.ReadString()

	ply:SpawnCar( ent, car )

end)

net.Receive( 'gpcard_remove', function( _, ply )

	ply:RemoveSpawnedCar()

end)

net.Receive( 'gpcard_buy', function( _, ply )

	local class = net.ReadString()
	local act = net.ReadString()
	local color = string.ToColor(net.ReadString())
	local id = net.ReadInt( 16 )

	if act == 'buy' then
		ply:BuyDefCar( class, color )
	elseif act == 'buy_ar' then
		ply:BuyArCar( id )
	end

end)
--[[
net.Receive( 'gpcard_database', function( _, ply )

	if !gp_shop.shop_db:ping() then
		return false
	end

	local db = gp_shop.shop_db

	local qr = 'SELECT * FROM `gp_carshop`'

	local gb = db:query( qr )
	gb.onError = function( q, err )
		print( err )
	end
	gb.onData = function()
		net.Start( 'gpcard_database' )
			net.WriteTable( gb:getData() )
		net.Send( ply )
	end
	gb:start()


end )]]--

net.Receive( 'gpcard_sell', function( _, ply )

	local class = net.ReadString()
	local act = net.ReadString()
	local desc = net.ReadString()
	local price = net.ReadInt( 25 )


	if act == 'sell_ar' then
		ply:SellCar_ar( class, desc, price )
	elseif act == 'sell_gov' then
		ply:SellCarGov( class )
	end

end )

net.Receive( 'gpcard_rmar', function( _, ply )

	local id = net.ReadInt( 20 )

	ply:Rmar( id )

end )

net.Receive( 'gpcard_withdraw', function( _, ply )

	print( 'blyad' )

	local pam = tonumber(ply:GetPData( 'gpcard_armon' ))

	if pam <= 0 then return end

	ply:SetPData( 'gpcard_armon', 0 )
	ply:SetNWInt( 'gpcard_armon', 0 )

	ply:addMoney( pam )

	ply:card_chat( 'Вы успешно вывели '..DarkRP.formatMoney( pam )..' с баланса авторынка!' )

end )

net.Receive( 'gpcard_uaaa', function( _, ply )

	local _t = util.JSONToTable(ply:GetPData( 'gpcard_simf', '[]' ))

	net.Start( 'gpcard_uaaa' )
	net.WriteTable( _t )
	net.Send( ply )

end )

hook.Add( 'PlayerInitialSpawn', 'gpcard_initsp', function( ply )

	ply:card_Refund()

	ply:SetNWInt( 'gpcard_armon', tonumber(ply:GetPData( 'gpcard_armon', 0 )) )
	
	if ply:GetPData( 'card_migrate', false ) == false then 
		ply:card_migrate()
	end

end )

hook.Add( 'EntityTakeDamage', 'gpcard_Destroyed', function( ent, dmg )

	if ent:IsVehicle() and ent.Destroyed == true then
		return true
	end

end )

