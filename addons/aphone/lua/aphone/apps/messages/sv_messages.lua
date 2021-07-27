// Setup SQL/Nets
util.AddNetworkString("aphone_NewMessage")
util.AddNetworkString("aphone_CacheClientMessages")
util.AddNetworkString("aphone_SyncOneMessage")

hook.Add("APhone_SQLConnected", "Sync_Messages", function()
    if aphone.MySQL then
        aphone.SQLQuery( "CREATE TABLE IF NOT EXISTS `aphone_Messages`(`user1` INT NULL, `user2` INT NULL, `body` TEXT NOT NULL, `id` INT NOT NULL auto_increment, `timestamp` INT NULL, PRIMARY KEY (`id`))")
        aphone.SQLQuery( "CREATE TABLE IF NOT EXISTS `aphone_Friends` (`user1` INT NULL DEFAULT NULL,`body` TEXT NULL,`id` INT NOT NULL auto_increment,`timestamp` INT NULL DEFAULT NULL,`last_update` INT NULL DEFAULT NULL,`last_name` TEXT NULL,PRIMARY KEY (`id`))")
        aphone.SQLQuery( "CREATE TABLE IF NOT EXISTS `aphone_Likes` (`user` INT NULL DEFAULT NULL, `msg_id` INT NULL DEFAULT NULL, `timestamp` INT NULL DEFAULT NULL)")
    else
        aphone.SQLQuery( "CREATE TABLE IF NOT EXISTS aphone_Messages(user1 INTEGER, user2 INTEGER, body TEXT, id INTEGER PRIMARY KEY, timestamp INTEGER)")
        aphone.SQLQuery( "CREATE TABLE IF NOT EXISTS aphone_Friends(user1 INTEGER, body TEXT, id INTEGER PRIMARY KEY, timestamp INTEGER, last_update INTEGER, last_name TEXT)")
        aphone.SQLQuery( "CREATE TABLE IF NOT EXISTS aphone_Likes(user INTEGER, msg_id INTEGER, timestamp INTEGER)")
    end
end)

// Functions
aphone.Messages = aphone.Messages or {}

local function add(user1, user2, body, is_friends)
    local user1_id = user1:aphone_GetID()
    if !isnumber(user1_id) or (!is_friends and (!isnumber(user2) or user1_id == user2)) then return end

    local time = os.time()

    if !is_friends then
        aphone.SQLQuery("INSERT INTO aphone_Messages (user1, user2, body, timestamp) VALUES(" .. user1_id .. ", " .. user2 .. ", " .. aphone.SQLEscape(body) .. ", " .. time .. ")")
        aphone.SQLQuery("UPDATE aphone_User SET msg_refresh = (SELECT MAX(id) FROM aphone_Messages) WHERE unique_number = " .. user1_id)

        // Get second player and check if he is connected
        for k, v in ipairs(player.GetHumans()) do
            if v:aphone_GetID() == user2 then
                aphone.SQLQuery("UPDATE aphone_User SET msg_refresh = (SELECT MAX(id) FROM aphone_Messages) WHERE unique_number = " .. user2)

                if !is_friends then
                    net.Start("aphone_SyncOneMessage")
                        net.WriteEntity(user1)
                        net.WriteString(body)
                        net.WriteBool(false)
                    net.Send(v)
                    hook.Run("aphone_insertmessages", user1, v, body)

                    return
                end
            end
        end
    else
        aphone.SQLQuery("INSERT INTO aphone_Friends (user1, body, timestamp, last_name) VALUES(" .. user1_id .. ", " .. aphone.SQLEscape(body) .. ", " .. time .. ", '" .. user1:Nick() .. "')")

        // Sync the player to the last message so he won't get the message twice
        aphone.SQLQuery("UPDATE aphone_User SET friends_refresh = (SELECT MAX(id) FROM aphone_Friends) WHERE unique_number = " .. user1_id, function()
            aphone.SQLQuery("SELECT MAX(id) as id FROM aphone_Friends", function(q)
                // I can't make multiples query but it works in a db viewer, weird
                if !q[1]["id"] then
                    print("[APhone] Issue with Friends ID, please make a gmodstore ticket and explain if you are in MySQL or SQLite")
                else
                    net.Start("aphone_SyncOneMessage")
                        net.WriteEntity(user1)
                        net.WriteString(body)
                        net.WriteBool(true)
                        net.WriteUInt(time, 32)
                        net.WriteUInt(tonumber(q[1]["id"]), 32)
                    net.Broadcast()
                end
            end)
        end)

        if aphone.Webhook and aphone.Webhook != "" then
            http.Post("https://akulla.dev/aphone/send_discord.php", {
                author_id = user1:SteamID(),
                author = user1:Nick(),
                webhook = aphone.Webhook,
                message = body
            })
        end
        return
    end

    hook.Run("aphone_insertmessagesoffline", user1, user2, body)
end

util.AddNetworkString("aphone_AddLike")
local function add_like(user, msg_id)
    aphone.SQLQuery( "SELECT * FROM aphone_Likes WHERE msg_id = " .. msg_id .. " AND user = " .. user, function(q)
        local b = (!q or table.IsEmpty(q))

        if b then
            aphone.SQLQuery("INSERT INTO aphone_Likes(user, msg_id, timestamp) VALUES(" .. user .. ", " .. msg_id .. ", " .. os.time() .. ")")
        else
            // remove like
            q = q[1]
            aphone.SQLQuery("DELETE FROM aphone_Likes WHERE msg_id = " .. msg_id .. " AND user = " .. user)
        end

        aphone.SQLQuery("UPDATE aphone_Friends SET last_update = " .. os.time() .. " WHERE id = " .. msg_id)

        net.Start("aphone_AddLike")
            net.WriteBool(b)
            net.WriteUInt(msg_id, 29)
            net.WriteUInt(user, 24)
        net.Broadcast()
    end)
end

net.Receive("aphone_AddLike", function(_, ply)
    if !aphone.NetCD(ply, "Like", 1) then return end
    add_like(ply:aphone_GetID(), net.ReadUInt(29))
end)

util.AddNetworkString("aphone_CacheLikes")
hook.Add("aphone_PostUserSQL", "aphone_MessageSync", function(ply, q)
    local num = tonumber(q.msg_refresh)

    if num then
        // Get uncached messages. We get the last msg player ID. Get the greater ones and give him, then set his msg_refresh to the last msg
        aphone.SQLQuery("SELECT * FROM aphone_Messages WHERE id > " .. num .. " AND (user1 = " .. q.unique_number .. " OR user2 = " .. q.unique_number .. ")", function(query)
            if query and !table.IsEmpty(query) then
                net.Start("aphone_CacheClientMessages")
                    // Write size of the table
                    net.WriteUInt(table.Count(query), 16)
                    net.WriteBool(false)

                    // Loop
                    for k, v in pairs(query) do
                        net.WriteUInt(v.user1, 24)
                        net.WriteUInt(v.user2, 24)
                        net.WriteString(v.body)
                        net.WriteUInt(tonumber(v.timestamp), 32)
                    end
                net.Send(ply)

                // Get last message ( aka best id )
                aphone.SQLQuery("UPDATE aphone_User SET msg_refresh = " .. query[#query].id .. " WHERE unique_number = " .. q.unique_number)
            end
        end)
    end

    local friend_msg = tonumber(q.friends_refresh or 0)
    aphone.SQLQuery("SELECT * FROM aphone_Friends WHERE id > " .. friend_msg, function(query)
        if query and !table.IsEmpty(query) then
            net.Start("aphone_CacheClientMessages")
                // Write size of the table
                net.WriteUInt(table.Count(query), 16)
                net.WriteBool(true)

                // Loop
                for k, v in pairs(query) do
                    net.WriteUInt(v.user1, 24)
                    net.WriteString(v.body)
                    net.WriteUInt(v.timestamp, 32)
                    net.WriteString(v.last_name)
                    net.WriteUInt(v.id, 32)
                end
            net.Send(ply)

            // Get last message ( aka best id )
            aphone.SQLQuery("UPDATE aphone_User SET friends_refresh = " .. query[#query].id .. " WHERE unique_number = " .. q.unique_number)
        end
    end)

    local like_refresh = tonumber(q.likes_refresh or 0)

    // I know it's a ugly query, but it's a hotfix, as I'm not the best in SQL and since it's a bug I don't got a lot of time to clean this, will remake it later
    aphone.SQLQuery("SELECT COUNT(msg_id), msg_id FROM aphone_likes WHERE msg_id IN (SELECT id FROM aphone_friends WHERE last_update > " .. like_refresh .. ") GROUP BY msg_id UNION SELECT '0' AS 'COUNT(msg_id)', id FROM aphone_friends WHERE id NOT IN (SELECT msg_id FROM aphone_likes) AND last_update > " .. like_refresh, function(query)
        if query and !table.IsEmpty(query) then
            net.Start("aphone_CacheLikes")
                // Write size of the table
                net.WriteUInt(table.Count(query), 16)

                // Loop
                for k, v in pairs(query) do
                    net.WriteUInt(v["COUNT(msg_id)"], 32)
                    net.WriteUInt(v["msg_id"], 32)
                end
            net.Send(ply)

            // Get last message ( aka best id )
            aphone.SQLQuery("UPDATE aphone_User SET likes_refresh = " .. os.time() .. " WHERE unique_number = " .. q.unique_number)
        end
    end)
end)

net.Receive("aphone_NewMessage", function(_, ply)
    if !aphone.NetCD(ply, "NewMsg", 1) then return end
    local is_friends = net.ReadBool()
    local user_id = is_friends and 0 or net.ReadUInt(32)
    local body = net.ReadString()

    if user_id >= 0 and string.len(body) > 0 and string.len(body) < 120 then
        add(ply, user_id, body, is_friends)
    end
end)