local APP = {}

APP.name = aphone.L("Darkweb")
APP.icon = "akulla/aphone/app_darkweb.png"

// Clean himself without serverside help/signal. No need to ask everytime, keep old infos
aphone.Deepweb_Contracts = aphone.Deepweb_Contracts or {}

local list_pnl
local clr_g = Color(34, 180, 85)
local clr_g_alpha =  Color(34, 180, 85, 125)
local clr_g_99 = Color(32, 178, 83, 99)
local black_0_90 = Color(0, 0, 0, 90)
local black_0_200 = Color(0, 0, 0, 200)
local clr_r_125 = Color(200, 0, 0, 125)

function APP:Open(main, main_x, main_y, screenmode)
    local title = aphone.L("Darkweb_Title")
    local font_bigdarkweb = aphone:GetFont("BigDarkweb")
    local font_mediumheader = aphone:GetFont("MediumHeader")
    local font_logo = aphone:GetFont("SVG_180")
    local color_logo = Color(255, 255, 255, 120)
    local str = ""

    // Generate text for backgrounds
    surface.SetFont( font_mediumheader )
    local simplechar_x, simplechar_y = surface.GetTextSize("1")
    local lines_y = (main_y / simplechar_y) + 2

    for i = 1, (main_x / simplechar_x) * lines_y do
        str = str .. math.random(0, 1)
    end

    function main:Paint(w,h)
        surface.SetDrawColor(color_black)
        surface.DrawRect(0,0,w,h)

        surface.SetFont( font_bigdarkweb )
        surface.SetTextPos(w * 0.1, h * 0.05)
        surface.SetTextColor(color_white)
        surface.DrawText(title)

        -- Remove last char, add one at first index
        str = string.sub(str, 0, -2)
        str = math.random(0, 1) .. str

        surface.SetFont( font_logo )
        surface.SetTextColor( color_logo )
        surface.SetTextPos( (w / 2) * 0.60, (h / 2) - (w / 2) * 0.55 )
        surface.DrawText( "x" )

        surface.SetFont( font_mediumheader )
        surface.SetTextColor( clr_g_alpha )

        // Draw text background
        surface.SetTextPos(0, 0)
        surface.DrawText( string.sub(str, 0, 30) )

        for i = 1, lines_y do
            surface.SetTextPos(0, simplechar_y * i)
            surface.DrawText( string.sub(str, 30 * i, 60 * i) )
        end
    end

    local list = vgui.Create("DPanel", main)
    list:Dock(FILL)
    list:DockMargin(main_x * 0.10, main_x * 0.10 + main_y * 0.1,  main_x * 0.10, main_x * 0.10)

    function list:Paint(w, h)
        surface.SetDrawColor(black_0_90)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(clr_g_99)

        for i = 0, 3 do
            surface.DrawOutlinedRect(i, i, w-i * 2, h-i * 2)
        end

        surface.DrawRect(0, 0, w, h * 0.06)
        draw.SimpleText(aphone.L("Darkweb_Contracts"), aphone:GetFont("HeaderDarkWeb"), h * 0.03, h * 0.03, color_black, 0, 1)
    end

    local create = vgui.Create("DPanel", list)
    create:Dock(BOTTOM)
    create:SetTall(main_y * 0.15)

    function create:Paint(w, h)
        surface.SetDrawColor(clr_g_alpha)
        surface.DrawRect(0, 0, w, 3)

        surface.SetDrawColor(black_0_200)
        surface.DrawRect(3, 3, w-6, h-6)
    end

    local confirm_contract = vgui.Create("DButton", list)
    confirm_contract:SetText(aphone.L("Darkweb_Confirm"))
    confirm_contract:Dock(BOTTOM)
    confirm_contract:SetFont(aphone:GetFont("HeaderDarkWeb"))
    confirm_contract:SetEnabled(false)
    confirm_contract:SetAlpha(0)
    confirm_contract:Phone_AlphaHover()

    function confirm_contract:Paint(w, h)
        surface.SetDrawColor(clr_g)
        surface.DrawRect(3, 0, w-6, h)
    end

    local create_name_fields = vgui.Create("DPanel", create)
    create_name_fields:Dock(LEFT)
    create_name_fields:SetWide(main_x * 0.2)
    create_name_fields:SetPaintBackground(false)

    local create_name_ply = vgui.Create("DLabel", create_name_fields)
    create_name_ply:Dock(TOP)
    create_name_ply:SetTall(create:GetTall() / 2)
    create_name_ply:SetText(aphone.L("Darkweb_name"))
    create_name_ply:SetTextColor(clr_g)
    create_name_ply:SetFont(aphone:GetFont("HeaderDarkWeb"))
    create_name_ply:DockMargin(create_name_fields:GetWide() * 0.1, 0, 0, 0)

    local create_name_price = vgui.Create("DLabel", create_name_fields)
    create_name_price:Dock(BOTTOM)
    create_name_price:SetTall(create:GetTall() / 2)
    create_name_price:SetText(aphone.L("Darkweb_price"))
    create_name_price:SetTextColor(clr_g)
    create_name_price:SetFont(aphone:GetFont("HeaderDarkWeb"))
    create_name_price:DockMargin(create_name_fields:GetWide() * 0.1, 0, 0, 0)

    local create_fields = vgui.Create("DPanel", create)
    create_fields:Dock(LEFT)
    create_fields:SetWide(main_x * 0.6)
    create_fields:SetPaintBackground(false)

    local create_fieldsprice_box = vgui.Create("DPanel", create_fields)
    create_fieldsprice_box:Dock(BOTTOM)
    create_fieldsprice_box:SetTall(create:GetTall() * 0.3)
    create_fieldsprice_box:DockMargin(create_fields:GetWide() * 0.1, create:GetTall() * 0.1, create_fields:GetWide() * 0.1, create:GetTall() * 0.1)

    local create_fieldsname_box = vgui.Create("DPanel", create_fields)
    create_fieldsname_box:Dock(FILL)
    create_fieldsname_box:SetTall(create:GetTall() * 0.3)
    create_fieldsname_box:DockMargin(create_fields:GetWide() * 0.1, create:GetTall() * 0.1, create_fields:GetWide() * 0.1, create:GetTall() * 0.1)

    function create_fieldsprice_box:Paint(w, h)
        surface.SetDrawColor(clr_g)
        surface.DrawOutlinedRect(0, 0, w, h)
        surface.DrawOutlinedRect(1, 1, w-2, h-2)

        surface.SetDrawColor(color_black)
        surface.DrawRect(2, 2, w-4, h-4)
    end

    function create_fieldsname_box:Paint(w, h)
        surface.SetDrawColor(clr_g)
        surface.DrawOutlinedRect(0, 0, w, h)
        surface.DrawOutlinedRect(1, 1, w-2, h-2)

        surface.SetDrawColor(color_black)
        surface.DrawRect(2, 2, w-4, h-4)
    end

    local create_name_plyfield = vgui.Create("DLabel", create_fieldsname_box)
    create_name_plyfield:Dock(FILL)
    create_name_plyfield:SetText(aphone.L("Darkweb_putname"))
    create_name_plyfield:SetTextColor(color_white)
    create_name_plyfield:SetFont(aphone:GetFont("HeaderDarkWeb"))
    create_name_plyfield:SetMouseInputEnabled(true)
    create_name_plyfield:DockMargin(create_name_fields:GetWide() * 0.1, 0, 0, 0)

    local create_name_priceenter = vgui.Create("DLabel", create_fieldsprice_box)
    create_name_priceenter:Dock(FILL)
    create_name_priceenter:DockMargin(2, 2, 2, 2)
    create_name_priceenter:SetText(aphone.L("Darkweb_price"))
    create_name_priceenter:SetTextColor(color_white)
    create_name_priceenter:SetFont(aphone:GetFont("HeaderDarkWeb"))
    create_name_priceenter:SetMouseInputEnabled(true)
    create_name_priceenter:DockMargin(create_name_fields:GetWide() * 0.1, 0, 0, 0)

    surface.SetFont(aphone:GetFont("HeaderDarkWeb"))

    function create_name_plyfield:DoClick()
        local ply_select = vgui.Create("DPanel", main)
        ply_select:SetSize(main_x * 0.75, main_y * 0.75)
        ply_select:SetPos(main_x * 0.125, main_y * 0.125)

        function ply_select:Paint(w, h)
            aphone.blur_rt(8 * (h/w), 8, 2)
            surface.SetDrawColor(color_black)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(clr_g_99)
            surface.DrawOutlinedRect(0, 0, w, h)
            surface.DrawOutlinedRect(1, 1, w-2, h-2)
        end

        local scr = vgui.Create("DScrollPanel", ply_select)
        scr:Dock(FILL)
        scr:DockMargin(2, 2, 2, 2)

        local hdw = aphone:GetFont("HeaderDarkWeb")

        for k, v in ipairs(player.GetAll()) do
            if v == LocalPlayer() then continue end

            local plypnl = scr:Add("DButton")
            plypnl:Dock(TOP)
            plypnl:SetTall(main_y*0.1)
            plypnl:SetPaintBackground(false)
            plypnl:SetText("")

            local name = vgui.Create("DLabel", plypnl)
            name:Dock(TOP)
            name:SetTall(plypnl:GetTall()/2)
            name:DockMargin(main_x*0.1, 0, 0, 0)
            name:SetText(v:Nick())
            name:SetFont(hdw)
            name:SetContentAlignment(1)
            name:SetTextColor(clr_g_99)
            name:SetMouseInputEnabled(false)

            local jobname = vgui.Create("DLabel", plypnl)
            jobname:Dock(TOP)
            jobname:SetTall(plypnl:GetTall()/2)
            jobname:DockMargin(main_x*0.1, 0, 0, 0)
            jobname:SetText(v:Nick())
            jobname:SetFont(aphone:GetFont("LittleDarkWeb"))
            jobname:SetContentAlignment(7)
            jobname:SetMouseInputEnabled(false)

            function plypnl:DoClick()
                local n = string.lower(v:Nick())
                create_name_plyfield.goodtext = n
                create_name_plyfield:SetText(n)
                ply_select:Remove()
            end
        end

        local close = vgui.Create("DButton", ply_select)
        close:SetFont(hdw)
        close:SetText("x")
        close:SetPos(ply_select:GetWide()*0.9, ply_select:GetTall() * 0.02)
        close:SetPaintBackground(false)

        surface.SetFont(hdw)
        close:SetSize(surface.GetTextSize(close:GetText()))
        close:Phone_AlphaHover()

        function close:DoClick()
            ply_select:Remove()
        end

        ply_select:aphone_RemoveCursor()
    end

    local function check_validentry()
        if !create_name_plyfield.goodtext or !tonumber(create_name_priceenter:GetText()) then
            confirm_contract:SetEnabled(false)
            confirm_contract:SetAlpha(0)
            return
        end

        for k, v in ipairs(player.GetHumans()) do
            if string.lower(v:Nick()) == create_name_plyfield.goodtext then
                confirm_contract:SetEnabled(true)
                confirm_contract:SetAlpha(255)
                return
            end
        end

        create_name_plyfield:SetText(aphone.L("Darkweb_notfound"))
        confirm_contract:SetEnabled(false)
        confirm_contract:SetAlpha(0)
    end

    function create_name_plyfield:textEnd(text, wrapped_text)
        self:SetText(string.lower(wrapped_text))
        self.goodtext = string.lower(text)
        check_validentry()
    end

    function create_name_priceenter:DoClick()
        self:Phone_AskTextEntry("", 10)
    end

    function create_name_priceenter:textEnd()
        self:SetText(self:GetText())
        check_validentry()
    end

    function confirm_contract:DoClick()
        if !create_name_plyfield.goodtext then return end

        for k, v in ipairs(player.GetHumans()) do
            if string.lower(v:Nick()) == create_name_plyfield.goodtext then
                net.Start("aphone_darkweb")
                    net.WriteBool(false)
                    net.WriteEntity(v)
                    net.WriteUInt(tonumber(create_name_priceenter:GetText()), 32)
                net.SendToServer()
            end
        end
    end

    list_pnl = vgui.Create("DScrollPanel", list)
    list_pnl:Dock(FILL)
    list_pnl:GetVBar():SetWide(0)
    list_pnl:DockMargin(0, main_y * 0.8 * 0.06, 0, 0)

    function list_pnl:AddContract(tbl)
        local bar = list_pnl:Add("DButton")
        bar:SetWide(main_y * 0.08)
        bar:Dock(TOP)
        bar:SetPaintBackground(false)
        bar:SetAlpha(0)

        surface.SetFont(aphone:GetFont("HeaderDarkWeb"))
        bar:SetTall(select(2, surface.GetTextSize(tbl.target:Nick())))

        local price = vgui.Create("DLabel", bar)
        price:SetText(aphone.Gamemode.Format(tbl.price))
        price:Dock(RIGHT)
        price:SetWide(surface.GetTextSize(price:GetText()))
        price:SetFont(aphone:GetFont("HeaderDarkWeb"))
        price:DockMargin(0, 0, main_x * 0.02, 0)

        local name = vgui.Create("DLabel", bar)
        name:SetText(tbl.target:Nick())
        name:Dock(FILL)
        name:SetFont(aphone:GetFont("HeaderDarkWeb"))
        name:DockMargin(main_x * 0.02, 0, 0, 0)

        bar:AlphaTo(255, 0.5, 0)
        bar:SetText("")

        if tbl.owner == LocalPlayer() then
            function bar:Paint(w, h)
                if self:IsHovered() then
                    surface.SetDrawColor(clr_r_125)
                    surface.DrawRect(4, 0, w-8, h)
                end
            end

            function bar:DoClick()
                net.Start("aphone_darkweb")
                    net.WriteBool(true)
                net.SendToServer()
                self:Remove()
            end
        end
    end

    for k, v in pairs(aphone.Deepweb_Contracts) do
        if !IsValid(v.target) or !IsValid(v.owner) then
            aphone.Deepweb_Contracts[k] = nil
            continue
        end

        list_pnl:AddContract(v)
    end

    main:aphone_RemoveCursor()
end

net.Receive("aphone_darkweb", function()
    local delete = net.ReadBool()

    if delete then
        aphone.Deepweb_Contracts[net.ReadUInt(32)] = nil
    else
        local owner = net.ReadEntity()

        aphone.Deepweb_Contracts[owner:UserID()] = {
            owner = owner,
            target = net.ReadEntity(),
            price = net.ReadUInt(32),
        }

        if IsValid(list_pnl) then
            list_pnl:AddContract(aphone.Deepweb_Contracts[owner:UserID()])
        end
    end
end)

aphone.RegisterApp(APP)