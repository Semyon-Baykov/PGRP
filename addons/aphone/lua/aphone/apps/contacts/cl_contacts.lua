-- Load/Variables
sql.Query("CREATE TABLE IF NOT EXISTS aphone_Contacts(id INTEGER, name TEXT, ip TEXT)")
aphone.Contacts = aphone.Contacts or {}
local c = {}

for k, v in ipairs(sql.Query("SELECT id, name FROM aphone_Contacts WHERE ip = " .. sql.SQLStr(game.GetIPAddress())) or {}) do
    c[tonumber(v.id)] = v.name
end

-- Functions
function aphone.Contacts.GetName(userid)
    return c[userid]
end

function aphone.GetName(e)
    local n = aphone.Contacts.GetName(e)
    if n then return n end

    local is_ply = isentity(e) and e:IsPlayer()
    if !aphone.never_realname and is_ply then
        return e:Nick()
    end

    return aphone.GetNumber(is_ply and e:aphone_GetID() or e)
end

function aphone.Contacts.Add(id, name)
    if c[id] then return true end
    sql.Query("INSERT INTO aphone_Contacts(id, name, ip) VALUES(" .. id .. ", " .. sql.SQLStr(name) .. "," .. sql.SQLStr(game.GetIPAddress()) .. ")")
    c[id] = name
end

function aphone.Contacts.ChangeName(id, name)
    if not c[id] then return end
    sql.Query("UPDATE aphone_Contacts SET name = " .. sql.SQLStr(name) .. " WHERE ip = " .. sql.SQLStr(game.GetIPAddress()) .. " AND id = " .. id)
    c[id] = name
end

function aphone.Contacts.Remove(id)
    if not c[id] then return end
    sql.Query("DELETE FROM aphone_Contacts WHERE id = " .. id .. " AND ip = " .. sql.SQLStr(game.GetIPAddress()) .. ")")
    c[id] = nil
end

function aphone.Contacts.GetContacts()
    return c
end