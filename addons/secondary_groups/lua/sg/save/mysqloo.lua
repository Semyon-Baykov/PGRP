SG.Save = SG.Save or {
    CurrentUsers = {},
    CurrentGroups = {}
}

local db

function SG.Save.Connect()
    if !file.Exists( "bin/gmsv_mysqloo_*.dll", "LUA" ) then
        error "mysqloo is missing! Please install the mysqloo9 module for proper connection"
    end

    require "mysqloo"

    SG.Print "Connecting to the database..."

    db = mysqloo.connect( SG.cfg.MySQL.Host, SG.cfg.MySQL.User, SG.cfg.MySQL.Pass, SG.cfg.MySQL.Database, SG.cfg.MySQL.Port )

    function db:onConnectionFailed( err )
        SG.Print "Error connecting to the database"
        SG.Print( "Error: #", err )
    end

    function db:onConnected()
        SG.Print "Connected to the database!"
    end

    db:connect()
end

SG.Save.Connect()

function SG.Save.FormatQuery( query, opts, callback, err )
    local c = 0
    local format = query:gsub( "#", function() c = c + 1 return SG.Save.Esc( opts[ c ] ) end )
    local newQuery = db:query( format )
    local data

    function newQuery:onError( _query, _err )
        if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
            SG.Print "Database connection has been lost! Reconnecting..."

            mysqloo.connect( SG.cfg.MySQL.Host, SG.cfg.MySQL.User, SG.cfg.MySQL.Pass, SG.cfg.MySQL.Database, SG.cfg.MySQL.Port )

            return
        end

        if err then
            err( _err, query )
        else
            SG.Print( "# on query #", _err, query )
        end
    end

    function newQuery:onSuccess( data )
        local row = data

        if callback then
            callback( row, newQuery:lastInsert() )
        end
    end

    newQuery:start()
end

function SG.Save.Esc( str )
    return "\"" .. db:escape( tostring( str ) ) .. "\""
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
