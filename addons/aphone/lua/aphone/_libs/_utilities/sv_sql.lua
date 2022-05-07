--[[ Mysql Connection ]]
hook.Add("aphone_PostLoad", "aphone_connectsql", function()
    if aphone.MySQL then
        require("mysqloo")
        if !mysqloo then
            print("[APhone] Missing MYSQLoo")
            print("[APhone] Fallback to SQLite")
            aphone.MySQL = false
            hook.Run("APhone_SQLConnected")
        else
            local d = mysqloo.connect(aphone.MySQL.host, aphone.MySQL.user, aphone.MySQL.password, aphone.MySQL.database, aphone.MySQL.port or 3306)
        
            function d:onConnectionFailed(err)
                print("[APhone] Failed DB Connection, error : " .. err)
                print("[APhone] Fallback to SQLite")
                print("[APhone] If you got weird SQL Behavior, switch back to SQLite/Fix your MYSQL DB")
                aphone.MySQL = false

                // Make create tables once again, for the SQLite fallback
                hook.Run("APhone_SQLConnected")
            end
        
            function d:onConnected()
                print("[APhone] Connected to MYSQL")
            end

            aphone.db = d
            d:connect()
            d:wait()
            hook.Run("APhone_SQLConnected")
        end
    else
        hook.Run("APhone_SQLConnected")
    end
end)

-- [[ Query for Mysqloo or Sqlite ]]
function aphone.SQLQuery(q, c)
    if aphone.DebugMode then
        print(q)
    end

    if aphone.MySQL and mysqloo then
        local db_query = aphone.db:query(q)

        if aphone.db:status() != mysqloo.DATABASE_CONNECTED then
            print("[APhone] Unexcepted MySQL Behavior, query without connection/internal error, query will wait the connection")
        else
            function db_query:onSuccess(data)
                if c then
                    if aphone.DebugMode then
                        print("Query result of " .. q)
                        PrintTable(data)
                    end

                    c(data)
                end
            end

            db_query:start()
        end
    else
        local d = sql.Query(q) or {}

        if c then
            if aphone.DebugMode then
                print("Query result of " .. q)
                PrintTable(d)
            end

            c(d)
        end
    end
end

function aphone.SQLEscape(str)
    return (aphone.MySQL and mysqloo) and ("'" .. aphone.db:escape(str) .. "'") or SQLStr(str)
end

function aphone.SQLBegin()
    if !(aphone.MySQL and mysqloo) then
        sql.Begin()
    end
end

function aphone.SQLCommit()
    if !(aphone.MySQL and mysqloo) then
        sql.Commit()
    end
end

concommand.Add("APhone_ResetDB", function(ply)
    if aphone.DebugMode and !IsValid(ply) then
        aphone.SQLQuery("DROP TABLE aphone_User")
        aphone.SQLQuery("DROP TABLE aphone_Likes")
        aphone.SQLQuery("DROP TABLE aphone_Friends")
        aphone.SQLQuery("DROP TABLE aphone_Messages")
        aphone.SQLQuery("DROP TABLE aphone_Painting")
    end
end)

hook.Add("APhone_SQLConnected", "Create_UserTable", function()
    if aphone.MySQL then
        aphone.SQLQuery("CREATE TABLE IF NOT EXISTS `aphone_User`(`steamid` TEXT NOT NULL, `msg_refresh` INT NOT NULL DEFAULT '0', `unique_number` INT NOT NULL auto_increment, `friends_refresh` INT NOT NULL DEFAULT '0', `likes_refresh` INT NOT NULL DEFAULT '0', PRIMARY KEY (`unique_number`))")
        aphone.SQLQuery("ALTER TABLE aphone_User ADD COLUMN friends_refresh INT NULL DEFAULT '0'; ALTER TABLE aphone_User ADD COLUMN likes_refresh INT NULL DEFAULT '0';")
    else
        aphone.SQLQuery("CREATE TABLE IF NOT EXISTS aphone_User(steamid TEXT, msg_refresh INTEGER DEFAULT 0, unique_number INTEGER PRIMARY KEY AUTOINCREMENT, friends_refresh INTEGER DEFAULT 0, likes_refresh INTEGER DEFAULT 0)")
        aphone.SQLQuery("ALTER TABLE aphone_User ADD COLUMN friends_refresh INTEGER DEFAULT 0; ALTER TABLE aphone_User ADD COLUMN likes_refresh INTEGER DEFAULT 0;")
    end
end)

util.AddNetworkString("aphone_GiveID")
util.AddNetworkString("aphone_AskSQL")
util.AddNetworkString("aphone_OldID")

local unavailable_numbers = {}
local digits = #string.Split(aphone.Format, "%s") - 1

-- 2, because if we loop at 2, the max we can get is 100, and if the server got 128 players, the while won't stop l.86
if digits <= 2 then
    digits = 8
    print("[APhone] Issue with the number format, trying to set to 8 digits")
end

hook.Add("PlayerDisconnected", "APhone_FreeNumber", function(ply)
    if ply:aphone_GetNumber() then
        unavailable_numbers[ply:aphone_GetNumber()] = nil
    end
end)

local function free_number(id)
    -- We start from a "static" random number, will be consistent IF nobody got this number already in-game ( Very, very, very small chance to happens )
    util.SharedRandom("APhone", 0, 10^digits-1, id)
    local pick = math.random(0, 10^digits-1)

    if unavailable_numbers[pick] then
        while (unavailable_numbers[pick]) do
            pick = pick + 1
        end
    end

    unavailable_numbers[pick] = true
    return pick
end

function aphone.SyncPlayer(ply)
    if !IsValid(ply) then return end

    aphone.SQLQuery("SELECT * FROM aphone_User WHERE steamid = '" .. ply:SteamID64() .. "'", function(q)
        if !IsValid(ply) then return end

        if table.IsEmpty(q) then
            -- Cut off execution, insert and then sync
            aphone.SQLQuery("INSERT INTO aphone_User(steamid) VALUES('" .. ply:SteamID64() .. "')", function()
                aphone.SyncPlayer(ply)
            end)

            return
        end

        -- Set the first info we get, easier to loop
        q = q[1]

        -- SQL output numbers as strings, convert what we can
        for k, v in pairs(q) do
            if isnumber(tonumber(v)) then
                q[k] = tonumber(v)
            end
        end
        ply.aphone_ID = tonumber(q.unique_number)

        -- Generate a unique number, we don't want to get any number collision
        ply.aphone_number = free_number(ply:aphone_GetID())

        -- Send the others players ID to ply
        net.Start("aphone_OldID")
            for k, v in ipairs(player.GetHumans()) do
                if v != ply then
                    net.WriteUInt(v:aphone_GetID(), 32)
                    -- 10 digits max
                    // We can intentionally ignore a bad number, because the loading player will broadcast the good one later
                    net.WriteUInt(v.aphone_number or 0, 30)
                end
            end
        net.Send(ply)

        -- Broadcast ply id
        net.Start("aphone_GiveID")
            net.WriteEntity(ply)
            net.WriteUInt(ply:aphone_GetID(), 32)
            net.WriteUInt(ply.aphone_number, 32)
        net.Broadcast()
        hook.Run("aphone_PostUserSQL", ply, q)
    end)
end

net.Receive("aphone_AskSQL", function(_, ply)
    if ply.aphone_ID then return end
    aphone.SyncPlayer(ply)
end)

/*
--Don't uncomment this, it's made to debug IDs
hook.Add("PlayerInitialSpawn", "APhone_BotDebug", function(ply)
    timer.Simple(1, function()
        aphone.SyncPlayer(ply)
    end)
end)
*/