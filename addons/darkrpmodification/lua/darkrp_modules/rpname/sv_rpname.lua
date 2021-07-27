module( 'gp_rpname', package.seeall )

util.AddNetworkString( 'gp_rpname.Open' )
util.AddNetworkString( 'gp_rpname.Create' )

local meta = FindMetaTable( 'Player' )

function meta:SetRPname( lname, fname )
	if utf8.len( fname ) > 15 then
		derma_notify.Send( self, 1, 'Ошибка', 'Имя персонажа не может быть длинее 15 букв')
		return 
	end
	if utf8.len( lname ) > 15 then
		derma_notify.Send( self, 1, 'Ошибка', 'Фамилия персонажа не может быть длинее 15 букв')
		return 
	end
	if utf8.len( fname ) < 2 then
		derma_notify.Send( self, 1, 'Ошибка', 'Имя персонажа не может быть короче 2 букв')
		return 
	end
	if utf8.len( lname ) < 2 then
		derma_notify.Send( self, 1, 'Ошибка', 'Фамилия персонажа не может быть короче 2 букв')
		return 
	end
	if string.find( fname, '%p' ) or string.find( fname, '%d' ) then
		derma_notify.Send( self, 1, 'Ошибка', 'Недопустимый символ в имени персонажа')
		return 
	end
	if string.find( lname, '%p' ) or string.find( lname, '%d' ) then
		derma_notify.Send( self, 1, 'Ошибка', 'Недопустимый символ в фамилии персонажа')
		return 
	end

	local name = fname..' '..lname

	DarkRP.retrieveRPNames(name, function(taken)
        if taken then
            derma_notify.Send( self, 1, 'Ошибка', 'Ник "'..name..'" занят.')
            return 
        end
        DarkRP.storeRPName( self, name )
        self:setDarkRPVar( 'rpname', name )
     	self:SendLua( 'gp_rpname.frame:Remove()' )
     	self:SendLua( 'gpws.start()' )
     end)
end

net.Receive( 'gp_rpname.Create', function( _, ply )

	local fname = net.ReadString()
	local lname = net.ReadString()

	ply:SetRPname( lname, fname )

end )

hook.Add( 'PlayerInitialSpawn', 'firstspawncheck', function( ply )

	if ply:GetPData( 'FirstSpawn', true ) == true then
		net.Start( 'gp_rpname.Open' )
		net.Send( ply )
		ply:SetPData( 'FirstSpawn', false )
	else
		ply:SendLua( 'gpws.start()' )
	end

end )