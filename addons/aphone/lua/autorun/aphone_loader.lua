aphone = aphone or {}
aphone.Config = aphone.Config or {}
aphone.RegisteredApps = {}

local start_time = SysTime()

local function include_dir(dir)
    local files, folders = file.Find(dir .. "*", "LUA")

    for k,v in ipairs(files) do
        local prefix = string.sub(v, 1, 3)
        local file_dir = dir .. v

        if aphone.disable_hitman and string.find(file_dir, "darkweb") then continue end

        if prefix == "sh_" then
            if SERVER then
                AddCSLuaFile(file_dir)
            end
            include(file_dir)
        elseif prefix == "sv_" and SERVER then
            include(file_dir)
        elseif prefix == "cl_" then
            if SERVER then
                AddCSLuaFile(file_dir)
            else
                include(file_dir)
            end
        else
            print("[APhone] Can't include " .. v .. ", wrong prefix")
            continue
        end
    end

    for k, v in ipairs(folders) do
        include_dir(dir .. v .. "/")
    end
end

include("aphone/sh_config.lua")

if !aphone.RadioList then
    print("------ APhone ------")
    print("You got a issue with installation, the config file can't be loaded")
    print("Follow these instructions to debug the config file")
    print("Check before this message in your console if there any errors OR paste your config in this file : https://fptje.github.io/glualint-web/")
    print("Most of the time, it's a missing comma or quotation marks")
    print("To prevent any issues, APhone will stop loading")
    print("--------------------")
    return
end

if SERVER then
    AddCSLuaFile("aphone/sh_config.lua")
    AddCSLuaFile("aphone/languages/" .. aphone.Language .. ".lua")
    include("aphone/sv_config.lua")
    --resource.AddWorkshop( "2485178558" )
end

include("aphone/languages/" .. aphone.Language .. ".lua")

include_dir("aphone/_libs/")
include_dir("aphone/apps/")
hook.Run("aphone_PostLoad")

if aphone.DebugMode then
    print("[APhone] Loading in " .. SysTime() - start_time .. "s")
end