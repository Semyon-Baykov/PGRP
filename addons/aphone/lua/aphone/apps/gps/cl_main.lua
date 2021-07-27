local APP = {}

APP.name = aphone.L("GPS")
APP.icon = "akulla/aphone/app_gps.png"
APP.Default = true

// finalvec = vec + 64 height
local function hammer_to_meters(vec1, vec2)
    return math.floor(vec1:Distance(vec2) / 52.49)
end

local mat_cursor = Material( "akulla/aphone/gps_mark.png", "smooth 1")
local mat_size = mat_cursor:Width()/2
local path = {}
local splitted = {}

local function split()
    -- split it now
    splitted = {}

    for k,v in ipairs(path) do
        if path[k + 1] then
            local split_num = (path[k + 1] - v):Length() / mat_size
            local div = (path[k + 1] - v) / split_num
            local ang = (path[k + 1] - v):GetNormalized()

            -- looks ugly without it
            ang.z = 90

            for i=1, split_num do
                table.insert(splitted, {
                    pos = v + div*i,
                    angle = ang,
                })
            end
        end
    end
end

net.Receive("aphone_AskPath", function()
    local step = net.ReadUInt(16)
    path = {}
    local localpos = LocalPlayer():GetPos()

    for i = 1, step do
        local vec = net.ReadVector()
        if localpos:DistToSqr(vec) < 1200*1200 then
            table.insert(path, vec + Vector(0, 0, 5))
        end
    end
    split()
end)

local selected

/*
There is a more optimised way ?
I don't think so, using material + surface.DrawTexturedRect would take more performances. Maybe using UV textures but can't rotate them, 
except with cam.Start3D2D or matrix
*/

hook.Add("PostDrawTranslucentRenderables", "aphone_GPSLines", function()
    if selected then
        render.SetMaterial(mat_cursor)

        for k,v in ipairs(splitted) do
            if splitted[k + 1] then
                render.DrawQuadEasy(v.pos, v.angle, 32, 32, color_white, 0)
            end
        end
    end
end)


-- Draw logo
local white_trans = Color(230, 240, 241, 120)
hook.Add("HUDPaint", "aphone_GPSShow", function()
    if selected then
        local inf = aphone.GPS[selected]
        local s = inf.vec:ToScreen()

        if s.visible then
            local dist = hammer_to_meters(LocalPlayer():GetPos(), aphone.GPS[selected].vec) .. "m"

            draw.SimpleText(inf.name, "Roboto60_3D", s.x, s.y, color_white, 1, 1)
            draw.SimpleText(dist, "Roboto40_3D", s.x, s.y+40, white_trans, 1, 1)
            draw.SimpleText(inf.icon or "O", "SVG_60_3D", s.x, s.y + 60, inf.clr or color_white, 1, 0)
        end
    end
end)

local mat = Material("akulla/aphone/gps.jpg")
local gps_under = Color(100, 100, 100)

function APP:Open(main, main_x, main_y, screenmode)
    local clr_white = aphone:Color("Text_White")
    local clr_black40 = aphone:Color("Black40")
    local clr_white180 = aphone:Color("Text_White180")
    local font_sf40 = aphone:GetFont("Roboto40")
    local font_mediumheader = aphone:GetFont("MediumHeader")

    function main:Paint(w, h)
        surface.SetDrawColor(clr_black40)
        surface.DrawRect(0, 0, w, h)
    end

    if !screenmode then
        local bg_pnl = vgui.Create("DPanel", main)
        bg_pnl:Dock(TOP)
        bg_pnl:SetTall(main_y * 0.40)

        function bg_pnl:Paint(w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end

    local stats = vgui.Create("DPanel", main)
    stats:Dock(TOP)
    stats:SetTall(selected and (screenmode and main_y or main_x) * 0.24 or 0)
    stats:SetPaintBackground(false)

    function stats:Paint(w, h)
        if selected then
            local dist = hammer_to_meters(LocalPlayer():GetPos(), aphone.GPS[selected].vec) .. "m"

            draw.SimpleText(aphone.GPS[selected].name, font_sf40, w / 2, h / 2 - 5, clr_white, 1, 4)
            draw.SimpleText(dist, font_mediumheader, w / 2, h / 2 + 5, aphone.GPS[selected].clr, 1, 3)

            surface.SetDrawColor(gps_under)
            surface.DrawRect(0, h-2, w, 2)
        end
    end

    local s = vgui.Create("DScrollPanel", main)
    s:Dock(FILL)
    s:aphone_PaintScroll()

    local local_playerpos = LocalPlayer():GetPos()

    for k,v in ipairs(aphone.GPS) do
        local but = s:Add("DButton")
        but:Dock(TOP)
        but:SetTall((screenmode and main_x or main_y) * 0.10)
        but:SetText("")
        but:TDLib()
        but:FadeHover(v.clr)
        but:SetPaintBackground(false)
        but:SetAlpha(selected == k and 255 or 120)

        local sub_txt = vgui.Create("Panel", but)
        sub_txt:Dock(FILL)
        sub_txt:DockMargin(main_x * 0.05, 0, 0, 0)
        sub_txt:TDLib()
        sub_txt:SetMouseInputEnabled(false)
        sub_txt:DualText(
            v.name,
            aphone:GetFont("Roboto40"),
            color_white,

            hammer_to_meters(local_playerpos, v.vec) .. "m",
            aphone:GetFont("MediumHeader"),
            clr_white180, TEXT_ALIGN_LEFT)
        sub_txt:Text(v.icon, aphone:GetFont("SVG_30"), color_white, TEXT_ALIGN_RIGHT, -main_x * 0.05, 0, true)

        function but:DoClick()
            net.Start("aphone_AskPath")
            net.WriteUInt(k, 8)
            net.SendToServer()

            for i, j in ipairs(s:GetCanvas():GetChildren()) do
                if j:GetName() == "DButton" then
                    j:SetAlpha(120)
                end
            end

            if selected and selected == k then
                selected = nil
                stats:SetTall(0)
                path = {}
            else
                stats:SetTall((screenmode and main_y or main_x) * 0.24)
                selected = k
                self:SetAlpha(255)
            end
        end
    end
    main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
    self:Open(main, main_x, main_y, true)
end

function APP:ShowCondition()
    return aphone.GPS and !table.IsEmpty(aphone.GPS)
end

aphone.RegisterApp(APP)