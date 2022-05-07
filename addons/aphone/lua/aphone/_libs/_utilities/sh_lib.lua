-- The main purpose of this function is to put cd on net
-- However, I put this in shared because you can use it to make cooldown easier clientside
function aphone.NetCD(ply, name, cd)
    if IsValid(ply) then
        name = "aphone_" .. name
        ply[name] = ply[name] or 0

        if ply[name] + cd < CurTime() then
            ply[name] = CurTime()

            return true
        end
    end
end

function aphone.FormatTimeStamp(time2)
    local time = os.time() - tonumber(time2)

    if time != os.time() then
        if time < 60 then
            time = math.floor(time) .. "s"
        elseif time < 3600 then
            time = math.floor(time / 60) .. "m"
        elseif time < 86400 then
            time = math.floor(time / 3600) .. "h"
        else
            time = os.date("%d/%m/%y", time2)
        end
    else
        time = ""
    end

    return time
end

local p = FindMetaTable("Player")

-- Get digits
local digits = #string.Split(aphone.Format, "%s") - 1
-- 2, because if we loop at 2, the max we can get is 100, and if the server got 128 players, the while won't stop l.86
if digits <= 2 then
    digits = 8
    print("[APhone] Issue with the number format, trying to set to 8 digits")
end

aphone.digitscount = digits

--
function p:aphone_GetID()
    return self.aphone_ID or 0
end

function aphone.GetNumber(id)
    local str = string.Split(math.floor(util.SharedRandom("APhone", 0, 10^digits-1, id)), "")
    local n = string.Split(aphone.Format, "%s")

    while (#str < #n - 1) do
        table.insert(str, 1, 0)
    end

    return string.format(aphone.Format, unpack(str))
end

function aphone.FormatNumber(number)
    local str = string.Split(number, "")
    local n = string.Split(aphone.Format, "%s")

    while (#str < #n - 1) do
        table.insert(str, 1, 0)
    end

    return string.format(aphone.Format, unpack(str))
end

function p:aphone_GetNumber()
    if !self.aphone_number then 
        return "Loading Player..."
    end

    local str = string.Split(self.aphone_number, "")
    local n = string.Split(aphone.Format, "%s")

    while (#str < #n - 1) do
        table.insert(str, 1, 0)
    end

    return string.format(aphone.Format, unpack(str))
end