aphone.GUI = aphone.GUI or {}

// Data Pictures
aphone.Pictures = aphone.Pictures or {}
local dir = "aphone/" .. string.Replace(game.GetIPAddress(), ":", "_") .. "/"

// Functions caching
local material_ = Material
local table_insert = table.insert
local get_extension = string.GetExtensionFromFilename
local string_replace = string.Replace

if table.IsEmpty(aphone.Pictures) then
    for k,v in SortedPairs(select(1, file.Find(dir .. "*", "DATA")) or {}, true) do
        // No need to use smooth there
        local mat = material_("../data/" .. dir .. v)

        if !mat:IsError() then
            table_insert(aphone.Pictures, mat)
        end
    end
end

// Web picture
local webtable = {}
local downloading = {}
function aphone.GUI.WebPicture(name, link, flags)
    local format = link and get_extension(link) or ".jpg"
    local sub_dir = "aphone/link_" .. name .. "." .. format

    if webtable[name] and !webtable[name]:IsError() then
        return webtable[name]
    else
        if !file.Exists(sub_dir, "DATA") then
            // Cooldown - Don't start a lot of downloads
            if downloading[name] then return end
            downloading[name] = true

            http.Fetch(link, function(body)
                file.Write(sub_dir, body)

                timer.Simple(3, function()
                    webtable[name] = Material("../data/" .. sub_dir, flags)
                end)
                downloading[name] = false
            end, function(err)
                timer.Simple(5, function()
                    print("[APhone] - Download failed, link may be dead ? Error : " .. err)
                    downloading[name] = false
                end)
            end)
        else
            webtable[name] = Material("../data/" .. sub_dir, flags)
            return webtable[name]
        end
    end
end

function aphone.GUI.GetWebPicture(name, link, flags)
    if webtable[name] and !webtable[name]:IsError() then
        return webtable[name]
    end

    return aphone.GUI.WebPicture(name, link, flags)
end

// Imgur

local function add_imgur(url)
    if !url then return end

    id = string_replace( url, "https://i.imgur.com/", "" )
    id = string_replace( id, ".jpg", "" )
    id = string_replace( id, ".jpeg", "" )

    local tbl_settings = aphone.Clientside.GetSetting("Imgur_Links", {})
    table_insert(tbl_settings, 1, id)
    aphone.Clientside.SaveSetting("Imgur_Links", tbl_settings)

    aphone.GUI.WebPicture("Imgur_" .. id, url)
end

function aphone.GetImgurPics()
    return aphone.Clientside.GetSetting("Imgur_Links", {})
end

function aphone.GetImgurMat(imgur_id)
    if !imgur_id then return end
    imgur_id = string_replace(imgur_id, "imgur://", "")

    return aphone.GUI.GetWebPicture("imgur_" .. imgur_id, "https://i.imgur.com/" .. imgur_id .. ".jpg", "smooth 1")
end

function aphone.SendImgur(read_dir)
    http.Post( "https://akulla.dev/aphone/send_imgur.php", {["img"] = util.Base64Encode(file.Read( read_dir, "DATA" ))},
        function( body, length, headers, code )
            if (!string.StartWith(body, "[APhone-PHP]")) then
                // We can do that because my API return directly the imgur id, and not the whole thing we can get with the default imgur request
                add_imgur(body)
            else
                print(body)
            end
            aphone.ImgurUploading = nil
        end,
        function(err)
            print("[APhone] Upload error : " .. err)
            aphone.ImgurUploading = nil
        end
    )
end

// Load imgur pics
hook.Add("aphone_PostLoad", "aphone_LoadClientPictures", function()
    for k, v in ipairs(aphone.GetImgurPics()) do
        aphone.GetImgurMat(v)
    end
end)

hook.Add("aphone_PostLoad", "aphone_LoadBackground", function()
    for k, v in ipairs(aphone.backgrounds_imgur) do
        aphone.GetImgurMat(v)
    end
end)

// Background
local mat_bg = Material("akulla/aphone/phone_bg.jpg")
local bg_value = aphone.GetImgurMat(aphone.Clientside.GetSetting("Background"))

hook.Add("APhone_ChangedBackground", "APhone_GetNewBackground", function()
    bg_value = aphone.GetImgurMat(aphone.Clientside.GetSetting("Background"))
end)

function aphone.GUI.GetBackground()
    return (bg_value and !bg_value:IsError()) and bg_value or mat_bg
end