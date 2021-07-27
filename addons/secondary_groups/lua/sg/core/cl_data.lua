SG.Data = SG.Data or {
    CurrentUsers = {},
    CurrentGroups = {},
    TempUsers = {}
}

function SG.ReceiveGroups()
    SG.Data.CurrentGroups = table.Copy( net.ReadTable() )
end
net.Receive( "SG.SendGroups", SG.ReceiveGroups )

function SG.ReceiveUsers( len )
    local rawData = net.ReadData( ( len - 1 ) / 8 )
    local isDone = net.ReadBool()

    table.insert( SG.Data.TempUsers, rawData )

    if isDone then
        SG.Data.TempUsers = table.concat( SG.Data.TempUsers )
        SG.Data.CurrentUsers = SG.Decompress( SG.Data.TempUsers )

        SG.Data.TempUsers = {}
    end
end
net.Receive( "SG.SendUsers", SG.ReceiveUsers )

function SG.UpdateData()
    local type = net.ReadBit()
    local data = type == 0 and net.ReadString() or net.ReadTable()

    if type == 0 then
        if !table.HasValue( SG.Data.CurrentGroups, data ) then
            table.insert( SG.Data.CurrentGroups, data )
        end
    else
        SG.Data.CurrentUsers[ data.steamid ] = {
            name = data.name,
            rank = data.rank
        }
    end

    hook.Run( "SG.MenuUpdate", type )
end
net.Receive( "SG.UpdateData", SG.UpdateData )

function SG.RemovedData()
    local type = net.ReadBit()
    local data = net.ReadString()

    if type == 0 then
        table.RemoveByValue( SG.Data.CurrentGroups, data )
    else
        SG.Data.CurrentUsers[ data ] = nil
    end

    hook.Run( "SG.MenuUpdate", type )
end
net.Receive( "SG.RemoveData", SG.RemovedData )
