-- Save Vars
aphone.Clientside = aphone.Clientside or {}
aphone.Clientside.Varlist = util.JSONToTable(file.Read("aphone/save.json") or "") or {}

-- You can't create a folder with : in the name
local dir = "aphone/" .. string.Replace(game.GetIPAddress(), ":", "_") .. "/"
file.CreateDir(dir)

function aphone.Clientside.GetSetting(name, fallback)
    return aphone.Clientside.Varlist[name] or fallback
end

-- Save, with timer so we don't kill their HDD and gmod with spamming saves
local rewrite = false

function aphone.Clientside.SaveSetting(name, var)
    aphone.Clientside.Varlist[name] = var
    rewrite = true
end

timer.Create("aphone_InsertNewInfosClientside", 10, 0, function()
    if rewrite then
        file.Write("aphone/save.json", util.TableToJSON(aphone.Clientside.Varlist))
        rewrite = false
    end
end)

-- Register Param
local acceptables_types = {
    ["string"] = true,
    ["bool"] = true,
    ["num"] = true,
    ["color"] = true,
    ["sound"] = true,
}

-- Create Params
aphone.Params = aphone.Params or {}

function aphone:RegisterParameters(catName, paramName, short_name, var_type, defaultValue, onChange)
    if catName and paramName and var_type and acceptables_types[var_type] then
        table.Merge(aphone.Params, {
            [catName] = {
                [short_name] = {
                    var_type = var_type,
                    full_name = paramName,
                    def = defaultValue,
                    onChange = onChange
                }
            }
        })
    end
end

function aphone:ChangeParameters(catName, short_name, value, ignore)
    local p = aphone.Params[catName][short_name]
    aphone.Clientside.SaveSetting(catName .. "_" .. short_name, value)

    if p.onChange then
        aphone.Params[catName][short_name].onChange()
    end

    if !ignore then
        hook.Run("APhone_SettingChange", catName, short_name, value)
    end

    return value
end

function aphone:GetParameters(catName, shortName, fallback)
    return aphone.Clientside.GetSetting(catName .. "_" .. shortName, fallback)
end

-- Default/hard-coded params
aphone:RegisterParameters("Core", "2D", "2D", "bool", false, function()
    if IsValid(aphone.MainDerma) then
        gui.EnableScreenClicker(false)
        aphone.MainDerma:Remove()
    end
end)

aphone:RegisterParameters("Core", aphone.L("SilentMode"), "SilentMode", "bool", false)
aphone:RegisterParameters("Core", aphone.L("AutoLight"), "AutoLight", "bool", false)

if aphone.OthersHearRadio then
    aphone:RegisterParameters("Core", aphone.L("OnlyMyRadio"), "OnlyMyRadio", "bool", false)
end

aphone:RegisterParameters("Core", "Flashlight", "Flashlight", "bool", false)

for k, v in ipairs(aphone.Ringtones) do
    aphone:RegisterParameters(aphone.L("Ringtones"), v.name, "Ringstone_" .. k, "sound", false)
end