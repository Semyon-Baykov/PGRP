SG.Save = SG.Save or {
    CurrentUsers = {},
    CurrentGroups = {}
}

function SG.Save.Initalize()
    if !sql.TableExists "secondary_groups_users" then
        sql.Query "CREATE TABLE IF NOT EXISTS secondary_groups_users ( steamid VARCHAR( 32 ) NOT NULL PRIMARY KEY, name TEXT NOT NULL, rank TEXT NOT NULL )"
        sql.Query "CREATE TABLE IF NOT EXISTS secondary_groups ( rank TEXT NOT NULL )"
    end
end

SG.Save.Initalize()

function SG.Save.FormatQuery( query, ... )
    local c = 0
    local opts = { ... }
    local format = query:gsub( "#", function() c = c + 1 return SQLStr( opts[ c ] ) end )

    return sql.Query( format )
end

function SG.Save.SetPlayer( ply, rank )
    local sid = type( ply ) == "Player" and ply:SteamID64() or ply
    local name = type( ply ) == "Player" and ply:Nick() or util.SteamIDFrom64( sid ) -- Gross but it works

    if SG.Save.CurrentUsers[ sid ] then
        SG.Save.FormatQuery( "UPDATE secondary_groups_users SET rank = # WHERE steamid = #", rank, sid )
    else
        SG.Save.FormatQuery( "INSERT INTO secondary_groups_users ( steamid, name, rank ) VALUES( #, #, # )", sid, name, rank )

        SG.Save.CurrentUsers[ sid ] = {
            name = name,
            rank = rank
        }
    end
end

function SG.Save.UpdateNick( ply )
    if SG.Save.CurrentUsers[ ply:SteamID64() ] then
        SG.Save.FormatQuery( "UPDATE secondary_groups_users SET name = # WHERE steamid = #", ply:Nick(), ply:SteamID64() )
    end
end

function SG.Save.NewRank( rank )
    if !table.HasValue( SG.Save.CurrentGroups, rank ) then
        table.insert( SG.Save.CurrentGroups, rank )

        SG.Save.FormatQuery( "INSERT INTO secondary_groups ( rank ) VALUES( # )", rank )
    end
end

function SG.Save.RemovePlayer( ply )
    local sid = type( ply ) == "Player" and ply:SteamID64() or ply

    SG.Save.FormatQuery( "DELETE FROM secondary_groups_users WHERE steamid = #", sid )
end

function SG.Save.RemoveRank( rank )
    SG.Save.FormatQuery( "DELETE FROM secondary_groups WHERE rank = #", rank )
end

function SG.Save.GetAll()
    local allUsers = sql.Query "SELECT * FROM secondary_groups_users"
    local allGroups = sql.Query "SELECT * FROM secondary_groups"

    if allUsers != nil and #allUsers > 0 then
        for _, ply in ipairs( allUsers ) do
            SG.Save.CurrentUsers[ ply.steamid ] = {
                name = ply.name,
                rank = ply.rank
            }
        end
    end

    if allGroups != nil and #allGroups > 0 then
        for _, group in ipairs( allGroups ) do
            table.insert( SG.Save.CurrentGroups, group.rank )
        end
    end
end

SG.Save.GetAll()
