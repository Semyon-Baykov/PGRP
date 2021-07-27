local clr = {
    Black48 = Color(48, 48, 48),
    Black40 = Color(40, 40, 40),
    Black40_120 = Color(40, 40, 40, 120),
    Silver = Color(200, 200, 200),
    White = Color(240, 240, 240),
    Black1 = Color(53, 59, 72),
    Black2 = Color(51, 54, 61),
    Black3 = Color(41, 45, 51),
    Text_White = Color(230, 240, 241),
    Text_White180 = Color(230, 240, 241, 180),
    Text_White120 = Color(230, 240, 241, 120),
    Text_White60 = Color(230, 240, 241, 60),
    Text_Shadow = Color(60, 60, 60, 60),
    Text_Orange = Color(230, 126, 34),
    Text_Apps = Color(230, 240, 241),
    GPS_Line = Color(230, 126, 34),
    -- Cookies
    Cookie_BoostOff = Color(218, 165, 32),
    Cookie_BoostOn = Color(255, 245, 112),
    Cookie_Blue = Color(72, 101, 129),
    -- Radio
    Radio_Background = Color(40, 40, 40),
    Radio_VolumeBar = Color(60, 60, 60),
    Radio_RadioList = Color(50, 50, 50),
    mat_red = Color(190, 55, 95),
    mat_blackred = Color(185, 32, 73),
    mat_lightred = Color(240, 194, 209),
    mat_black = Color(44, 44, 44),
    mat_orange = Color(237, 133, 84)
}


function aphone:DefaultClr(name)
    return clr[name]
end

local c = Color

function aphone:Color(name)
    local info = aphone.Clientside.GetSetting(name, clr[name])

    if istable(info) then
        aphone.Clientside.Varlist[name] = c(info.r, info.g, info.b, info.a or 255)
        info = aphone.Clientside.Varlist[name]
    end

    return info
end

hook.Add("aphone_PostLoad", "aphone_CreateParamsColors", function()
    for k, v in pairs(clr) do
        aphone:RegisterParameters("Colors", k, k, "color", aphone:DefaultClr(k))
    end
end)