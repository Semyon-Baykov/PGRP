util.AddNetworkString "SG.SendGroups"
util.AddNetworkString "SG.SendUsers"
util.AddNetworkString "SG.DataUpdated"
util.AddNetworkString "SG.UpdateData"
util.AddNetworkString "SG.RemoveData"
util.AddNetworkString "SG.DataRemoved"
util.AddNetworkString "SG.OpenMenu"

function SG.OpenMenu( ply )
    if table.HasValue( SG.Users, ply ) then
        net.Start "SG.OpenMenu"
        net.Send( ply )
    else
        SG.SendData( ply )
    end
end

function SG.SendData( ply )
    if SG.CanOpen( ply ) then
        table.insert( SG.Users, ply )

        net.Start "SG.SendGroups"
        net.WriteTable( SG.Save.CurrentGroups )
        net.Send( ply )

        local compressedGroups = SG.Compress( SG.Save.CurrentUsers ) -- Convert groups to raw data
        local packetSize = 16384 -- 16kb binary
        local packetSpeed = .25 -- 64kb/s
        local packetCount = math.ceil( #compressedGroups / packetSize )

        for i = 1, packetCount do
            local sendDelay = packetSpeed * ( i - 1 )

            timer.Simple( sendDelay, function()
                local currentPacket = compressedGroups:sub( ( i - 1 ) * packetSize, i * packetSize )

                SG.Print( "Sending Packet #/# to #", i, packetCount, ply:Nick() )
                SG.Print( "Packet size: # bytes", #currentPacket )

                net.Start "SG.SendUsers"
                net.WriteData( currentPacket, #currentPacket )
                net.WriteBool( i == packetCount )
                net.Send( ply )

                if i == packetCount then
                    SG.OpenMenu( ply )
                end
            end )
        end
    end
end

function SG.Update( dataType, data )
    if dataType == 0 then
		net.Start "SG.UpdateData"
		net.WriteBit( 0 )
        net.WriteString( data )
		net.Send( SG.Users )

        SG.Save.NewRank( data )
    else
        local playerOn = player.GetBySteamID64( data.steamid )

        data.name = playerOn and playerOn:Nick() or util.SteamIDFrom64( data.steamid )

        if playerOn then
            playerOn:SetSecondaryUserGroup( data.rank )
        end

        if data.name:match "^STEAM_[0-5]:[01]:%d+$" and SG.Save.CurrentUsers[ data.steamid ] then
            data.name = SG.Save.CurrentUsers[ data.steamid ].name
        end

		net.Start "SG.UpdateData"
		net.WriteBit( 1 )
        net.WriteTable( data )
		net.Send( SG.Users )

        SG.Save.SetPlayer( data.steamid, data.rank )
    end 
end

function SG.Delete( type, data )
    net.Start "SG.RemoveData"
    net.WriteBit( type )
    net.WriteString( data )
    net.Send( SG.Users )

    if type == 0 then
        table.RemoveByValue( SG.Save.CurrentGroups, data )

        SG.Save.RemoveRank( data )
    else
        SG.Save.CurrentUsers[ data ] = nil

        SG.Save.RemovePlayer( data )

        if player.GetBySteamID64( data ) then
            player.GetBySteamID64( data ):SetSecondaryUserGroup ""
        end
    end
end

function SG.DataUpdated( len, ply )
    if SG.CanOpen( ply ) then
        local type = net.ReadBit()
        local data = type == 0 and net.ReadString() or net.ReadTable()

        SG.Update( type, data )
    end
end
net.Receive( "SG.DataUpdated", SG.DataUpdated )

function SG.RemoveData( len, ply )
    if SG.CanOpen( ply ) then
        local type = net.ReadBit()
        local data = net.ReadString()

		print( type, data )
		
        SG.Delete( type, data )
    end
end
net.Receive( "SG.DataRemoved", SG.RemoveData )


function SG.PlayerAuthed( ply )
    if SG.Save.CurrentUsers[ ply:SteamID64() ] then
        local rank = SG.Save.CurrentUsers[ ply:SteamID64() ].rank

        if table.HasValue( SG.Save.CurrentGroups, rank ) then
            ply:SetSecondaryUserGroup( rank )
        end
    end
end
hook.Add( "PlayerAuthed", "SG.PlayerAuthed", SG.PlayerAuthed )

function SG.PlayerDisconnected( ply )
    if table.HasValue( SG.Users, ply ) then
        table.RemoveByValue( SG.Users, ply )
    end

    if SG.Save.CurrentUsers[ ply:SteamID64() ] then
        SG.Save.UpdateNick( ply )
    end
end
hook.Add( "PlayerDisconnected", "SG.PlayerDisconnected", SG.PlayerDisconnected )

function SG.ShutDown()
    for _, ply in ipairs( player.GetAll() ) do
        if SG.Save.CurrentUsers[ ply:SteamID64() ] then
            SG.Save.UpdateNick( ply )
        end
    end
end
hook.Add( "ShutDown", "SG.ShutDown", SG.ShutDown )