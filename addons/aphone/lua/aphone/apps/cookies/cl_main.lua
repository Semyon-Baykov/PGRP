local APP = {}

APP.name = aphone.L("Cookies")
APP.icon = "akulla/aphone/app_cookie.png"

local config = {
    [1] = {
        price = 15,
        name = aphone.L("Cursor"),
        mat = Material("akulla/aphone/cookie_cursor.png", "smooth 1"),
        amt_sec = 0.1,
    },
    [2] = {
        price = 100,
        name = aphone.L("Grandma"),
        mat = Material("akulla/aphone/cookie_grandma.png", "smooth 1"),
        amt_sec = 1,
    },
    [3] = {
        price = 1100,
        name = aphone.L("Farm"),
        mat = Material("akulla/aphone/cookie_farm.png", "smooth 1"),
        amt_sec = 8,
    },
    [4] = {
        price = 12000,
        name = aphone.L("Mine"),
        mat = Material("akulla/aphone/cookie_mine.png", "smooth 1"),
        amt_sec = 47,
    },
    [5] = {
        price = 130000,
        name = aphone.L("Factory"),
        mat = Material("akulla/aphone/cookie_factory.png", "smooth 1"),
        amt_sec = 260,
    },
    [6] = {
        price = 1400000,
        name = aphone.L("Bank"),
        mat = Material("akulla/aphone/cookie_bank.png", "smooth 1"),
        amt_sec = 1400,
    },
    [7] = {
        price = 20000000,
        name = aphone.L("Temple"),
        mat = Material("akulla/aphone/cookie_temple.png", "smooth 1"),
        amt_sec = 7800,
    },
    [8] = {
        price = 330000000,
        name = aphone.L("WizardTower"),
        mat = Material("akulla/aphone/cookie_wizardtower.png", "smooth 1"),
        amt_sec = 44000,
    },
    [9] = {
        price = 5100000000,
        name = aphone.L("Shipment"),
        mat = Material("akulla/aphone/cookie_shipment.png", "smooth 1"),
        amt_sec = 260000,
    },
    [10] = {
        price = 75000000000,
        name = aphone.L("Alchemy"),
        mat = Material("akulla/aphone/cookie_alchemy.png", "smooth 1"),
        amt_sec = 1600000,
    },
    [11] = {
        price = 1000000000000,
        name = aphone.L("Portal"),
        mat = Material("akulla/aphone/cookie_portal.png", "smooth 1"),
        amt_sec = 10000000,
    },
    [12] = {
        price = 14000000000000,
        name = aphone.L("TimeMachine"),
        mat = Material("akulla/aphone/cookie_time.png", "smooth 1"),
        amt_sec = 65000000,
    },
    [13] = {
        price = 170000000000000,
        name = aphone.L("Antimatter_Condenser"),
        mat = Material("akulla/aphone/cookie_antimatter.png", "smooth 1"),
        amt_sec = 430000000,
    },
    [14] = {
        price = 2100000000000000,
        name = aphone.L("Prism"),
        mat = Material("akulla/aphone/cookie_prism.png", "smooth 1"),
        amt_sec = 2900000000,
    },
    [15] = {
        price = 26000000000000000,
        name = aphone.L("Chancemaker"),
        mat = Material("akulla/aphone/cookie_chance.png", "smooth 1"),
        amt_sec = 21000000000,
    },
    [16] = {
        price = 310000000000000000,
        name = aphone.L("FractalEngine"),
        mat = Material("akulla/aphone/cookie_fractal.png", "smooth 1"),
        amt_sec = 150000000000,
    },
    [17] = {
        price = 71000000000000000000,
        name = aphone.L("JSConsole"),
        mat = Material("akulla/aphone/cookie_js.png", "smooth 1"),
        amt_sec = 1100000000000,
    },
    [18] = {
        price = 12000000000000000000000,
        name = aphone.L("Idleverse"),
        mat = Material("akulla/aphone/cookie_universe.png", "smooth 1"),
        amt_sec = 8300000000000,
    },
}

local tbl = {
    [0] = "",
    [1] = aphone.L("Thousand"),
    [2] = aphone.L("Million"),
    [3] = aphone.L("Billion"),
    [4] = aphone.L("Trillion"),
    [5] = aphone.L("Quadrillion"),
    [6] = aphone.L("Quintillion"),
    [7] = aphone.L("Sextillion"),
    [8] = aphone.L("Septillion"),
}


local per_sec = 0
local cookies = 0

local boost_active = false
local boost_time = 0

// Config loaded, now we need to load save
local player_save = {}

for k, v in pairs(config) do
    local level = aphone.Clientside.GetSetting("CookiesClicker_" .. k, 0)
    player_save[k] = level
    cookies = aphone.Clientside.GetSetting("CookiesClicker_CookiesNum", 0)

    per_sec = per_sec + v.amt_sec * level
end

// Functions to manage cookies
local function format_cookies(amt)
    amt = amt or cookies
    local exp_id = 0

    while (amt > 1000) do
        if exp_id == table.Count(tbl) - 1 then
            break
        end
        amt = amt / 1000
        exp_id = exp_id + 1
    end

    return math.Round(amt, 2) .. tbl[exp_id] .. " cookies"
end

local function add_cookie(amt)
    cookies = cookies + (boost_active and amt * 10 or amt)

    return amt
end

local function price_nextlevel(item_id)
    return math.Round(config[item_id].price * (1.15 ^ player_save[item_id]), 2)
end

local function buy_param(item_id)
    local price = price_nextlevel(item_id)

    if price <= cookies then
        cookies = cookies - price

        local i = config[item_id]
        per_sec = per_sec + i.amt_sec

        player_save[item_id] = player_save[item_id] + 1
        aphone.Clientside.SaveSetting("CookiesClicker_" .. item_id, player_save[item_id])
    end
end

// We are nearly done, now we got the app tables and UI
function APP:OnClose()
    for k, v in pairs(config) do
        aphone.Clientside.SaveSetting("CookiesClicker_" .. k, player_save[k])
    end
    aphone.Clientside.SaveSetting("CookiesClicker_CookiesNum", cookies)
end

local last_frame = CurTime()
local mat_bg = Material("akulla/aphone/cookies_bg.jpg")
local mat_cookie = Material("akulla/aphone/cookies_png.png", "smooth 1")

local function create_derma(main, main_x, main_y, is_horizontal)
    local cookies_anim = {}

    local clr_black40 = aphone:Color("Black40_120")
    local clr_white = aphone:Color("Text_White")
    local clr_white120 = aphone:Color("Text_White120")
    local clr_white180 = aphone:Color("Text_White180")
    local clr_textshadow = aphone:Color("Text_Shadow")
    local clr_boostoff = aphone:Color("Cookie_BoostOff")
    local clr_booston = aphone:Color("Cookie_BoostOn")
    local font_mediumheader = aphone:GetFont("MediumHeader")
    local font_little = aphone:GetFont("Little")
    local font_sf40 = aphone:GetFont("Roboto40")
    local font_small = aphone:GetFont("Small")
    local s_s40 = aphone.GUI.ScaledSizeX(40)
    local s_s80 = aphone.GUI.ScaledSizeY(80)
    local cur = CurTime()

    function main:Paint(w, h)
        cur = CurTime()
        surface.SetDrawColor(color_white)
        surface.SetMaterial(mat_bg)

        local size = 1024 + main_y * 0.15 + main_x / 2
        surface.DrawTexturedRectRotated(w / 2, !is_horizontal and main_y * 0.15 + main_x / 2 or h / 2, size, size, cur % 36 * 10)

        surface.SetDrawColor(clr_black40)
        surface.DrawRect(0, 0, main_x, main_y * 0.17)

        // Add cookies, I put this in paint so we calculate every frame, it's not a big operation so don't mind about frame-drop
        local next_frametime = cur - last_frame
        add_cookie(next_frametime * per_sec)
        last_frame = cur

        if boost_active then
            boost_time = boost_time - next_frametime * 10

            if boost_time < 0 then
                boost_active = false
            end
        else
            if boost_time > 300 then
                boost_active = true
            end
        end

        for k, v in pairs(cookies_anim) do
            local ratio = (cur - v.time) * 2

            surface.SetDrawColor(255, 255, 255, v.alpha)
            surface.SetMaterial(mat_cookie)
            surface.DrawTexturedRectRotated((w * v.x_cookie) - s_s40, (h + 160) * ratio - s_s80, s_s80, s_s80, v.x * ratio)
        end

        draw.SimpleText(format_cookies(), is_horizontal and font_mediumheader or font_sf40, main_x / 2, main_y * 0.07, clr_white, 1, 1)
        draw.SimpleText(format_cookies(per_sec) .. "/sec", is_horizontal and font_little or font_mediumheader, main_x / 2, main_y * 0.12, clr_white120, 1, 1)

        draw.RoundedBox(8, w * 0.05, main_y * 0.15, w * 0.90, main_y * 0.01, clr_textshadow)
        draw.RoundedBox(8, w * 0.05, main_y * 0.15, (w * 0.90) * (boost_time / 300), main_y * 0.01, !boost_active and clr_boostoff or clr_booston)
    end

    local cookie_panel = vgui.Create("DButton", main)
    cookie_panel:SetText("")
    cookie_panel:Dock(is_horizontal and LEFT or TOP)
    cookie_panel:NoClipping(true)

    if !is_horizontal then
        cookie_panel:SetTall(main_x + aphone.GUI.ScaledSizeY(10))
        cookie_panel:DockMargin(0, main_y * 0.15, 0, 0)
    else
        cookie_panel:SetWide(main_y - main_x * 0.2)
        cookie_panel:DockMargin(main_x * 0.1, main_x * 0.1, 0, main_x * 0.1)
    end

    function cookie_panel:Paint(w, h)
        surface.SetMaterial(mat_cookie)
        surface.SetDrawColor(color_white)

        if !self:IsDown() then
            surface.DrawTexturedRect(0, 0, w, h)
        else
            surface.DrawTexturedRect(w * 0.05, h * 0.05, w * 0.9, h * 0.9)
        end

        for k,v in pairs(cookies_anim) do
            local ratio = (cur - v.time)

            if ratio > 1 then
                table.remove(cookies_anim, k)
            else
                draw.SimpleTextOutlined(v.num, font_sf40, w * v.x, h / 2 * (1 - ratio), Color(230, 240, 241, 255 * ((1 - ratio) * 2 - 0.5)), 1, 0, 1, Color(60, 60, 60, 120 * (1 - ratio)))
            end
        end
    end

    local cookie_shop = vgui.Create("DPanel", main)
    cookie_shop:Dock(FILL)

    if !is_horizontal then
        cookie_shop:DockMargin(aphone.GUI.ScaledSize(24, 0, 24, 24))
    else
        cookie_shop:DockMargin(main_x * 0.1, main_x * 0.1, main_x * 0.1, main_x * 0.1)
    end

    local clr1 = Color(36, 59, 83)
    local clr2 = Color(51, 78, 104)
    function cookie_shop:Paint(w, h)
        draw.RoundedBox(16, 0, 0, w, h, clr1)
        draw.RoundedBox(16, 4, 4, w-8, h-8, clr2)
    end

    local cookie_shop_scroll = vgui.Create("DScrollPanel", cookie_shop)
    cookie_shop_scroll:Dock(FILL)
    cookie_shop_scroll:DockMargin(aphone.GUI.ScaledSize(16, 16, 16, 16))
    cookie_shop_scroll:aphone_PaintScroll()

    for k, v in SortedPairs(config) do
        local button = vgui.Create("DButton", cookie_shop_scroll)
        cookie_shop_scroll:AddItem(button)
        button:Dock(TOP)
        button:SetTall(aphone.GUI.ScaledSizeY(50))
        button:DockMargin(aphone.GUI.ScaledSize(5, 5, 5, 5))
        button:SetText("")

        function button:Paint(w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(v.mat)
            surface.DrawTexturedRect(0, 0, h, h)

            draw.SimpleText(v.name, font_mediumheader, h + 5, h / 2, self:IsHovered() and clr_white or clr_white180, 0, 4)
            draw.SimpleText(format_cookies(price_nextlevel(k), 1), font_small, h + 5, h / 2, clr_white120, 0, 3)
        end

        function button:DoClick()
            buy_param(k)
        end
    end

    function cookie_panel:DoClick()
        local amt_togive = per_sec / 5
        amt_togive = amt_togive > 1 and amt_togive or 1
        add_cookie(amt_togive)

        table.insert(cookies_anim, {
            num = "+" .. format_cookies(amt_togive),
            x = math.Rand(0.2, 0.8),
            x_cookie = math.Rand(0.2, 0.8),
            alpha = math.Rand(40, 255),
            time = cur,
        })
    end

    main:aphone_RemoveCursor()
end

function APP:Open(main, main_x, main_y)
    create_derma(main, main_x, main_y, false)
end

function APP:Open2D(main, main_x, main_y)
    create_derma(main, main_x, main_y, true)
end

aphone.RegisterApp(APP)