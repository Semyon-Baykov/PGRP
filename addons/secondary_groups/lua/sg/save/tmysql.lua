SG.Save = SG.Save or {
    CurrentUsers = {},
    CurrentGroups = {}
}

local db, err

function SG.Save.Connect()
    if !file.Exists( "bin/gmsv_tmysql4_*.dll", "LUA" ) then
        error "tmysql4 is missing! Please install the tmysql4 module for proper connection"
    end

    require "tmysql4"

    SG.Print "Connecting to the database..."

    db, err = tmysql.initialize( SG.cfg.MySQL.Host, SG.cfg.MySQL.User, SG.cfg.MySQL.Pass, SG.cfg.MySQL.Database, SG.cfg.MySQL.Port )

    if err != nil or type( db ) == "boolean" then
        SG.Print "Error connecting to the database"
        SG.Print( "Error: #", err )

        return
    end

    SG.Print "Connected to the database!"
end

SG.Save.Connect()

function SG.Save.FormatQuery( query, opts, callback, err )
    local c = 0
    local format = query:gsub( "#", function() c = c + 1 return SG.Save.Esc( opts[ c ] ) end )

    local function cb( res )
        res = res[ 1 ]

        if !res.status then
            local er = err and err( res.error, query )

            if !err then
                SG.Print( "# on query: #",res.error, query )
            end

            return
        end

        if callback then
            callback( res.data, res.lastid, res.affected )
        end
    end

    db:Query( format, cb )
end

function SG.Save.Esc( str )
    return "\"" .. db:Escape( tostring( str ) ) .. "\""
end

function SG.Save.Initialize()
    SG.Save.FormatQuery "CREATE TABLE IF NOT EXISTS secondary_groups_users ( steamid VARCHAR( 32 ) NOT NULL PRIMARY KEY, name TEXT NOT NULL, rank TEXT NOT NULL )"
    SG.Save.FormatQuery "CREATE TABLE IF NOT EXISTS secondary_groups ( rank TEXT NOT NULL )"
end

SG.Save.Initialize()

function SG.Save.SetPlayer( ply, rank )
    local sid = type( ply ) == "Player" and ply:SteamID64() or ply
    local name = type( ply ) == "Player" and ply:Nick() or util.SteamIDFrom64( sid ) -- Gross but it works

    SG.Save.CurrentUsers[ sid ] = {
        name = name,
        rank = rank
    }

    SG.Save.FormatQuery( "INSERT INTO secondary_groups_users ( steamid, name, rank ) VALUES( #, #, # ) ON DUPLICATE KEY UPDATE rank = #", { sid, name, rank, rank } )
end

function SG.Save.UpdateNick( ply )
    if SG.Save.CurrentUsers[ ply:SteamID64() ] then
        SG.Save.FormatQuery( "UPDATE secondary_groups_users SET name = # WHERE steamid = #", { ply:Nick(), ply:SteamID64() } )
    end
end

function SG.Save.NewRank( rank )
    if !table.HasValue( SG.Save.CurrentGroups, rank ) then
        table.insert( SG.Save.CurrentGroups, rank )

        SG.Save.FormatQuery( "INSERT INTO secondary_groups ( rank ) VALUES( # )", { rank } )
    end
end

function SG.Save.RemovePlayer( ply )
    local sid = type( ply ) == "Player" and ply:SteamID64() or ply

    SG.Save.FormatQuery( "DELETE FROM secondary_groups_users WHERE steamid = #", { sid } )
end

function SG.Save.RemoveRank( rank )
    SG.Save.FormatQuery( "DELETE FROM secondary_groups WHERE rank = #", { rank } )
end

function SG.Save.GetAll()
    SG.Save.FormatQuery( "SELECT * FROM secondary_groups_users", nil, function( data )
        if data != nil and #data > 0 then
            for _ , ply in ipairs( data ) do
                SG.Save.CurrentUsers[ ply.steamid ] = {
                    name = ply.name,
                    rank = ply.rank
                }
            end
        end
    end )

    SG.Save.FormatQuery( "SELECT * FROM secondary_groups", nil, function( data )
        if data != nil and #data > 0 then
            for _ , group in ipairs( data ) do
                table.insert( SG.Save.CurrentGroups, group.rank )
            end
        end
    end )
end

SG.Save.GetAll()
