local APP = {}

APP.name = aphone.L("SMS")
APP.icon = "akulla/aphone/app_sms.png"
APP.Default = true

local clr_green = Color(46,139,87)
local clr_blue = Color(93,207,202)

function APP:Open(main, main_x, main_y, screenmode)
    local clr_white = aphone:Color("Text_White")
    local clr_black3 = aphone:Color("Black3")
    local clr_black1 = aphone:Color("Black1")
    local clr_white120 = aphone:Color("Text_White120")
    local font_bold = aphone:GetFont("Roboto45_700")
    local font_mediumheader = aphone:GetFont("MediumHeader")

    local tbl = {}

    function main:Paint(w, h)
        surface.SetDrawColor(clr_black3)
        surface.DrawRect(0,0,w,h)
    end

    surface.SetFont(font_bold)
    local _, title_y = surface.GetTextSize(aphone.L("Messages"))

    local local_player = LocalPlayer()
    local already_ids = {}
    local already_num = {}

    local title = vgui.Create("DLabel", main)
    title:Dock(TOP)
    title:DockMargin(main_x * 0.12, main_y * 0.05, 0, 0)
    title:SetTall(title_y)
    title:SetFont(font_bold)
    title:SetTextColor(clr_white)
    title:SetText(aphone.L("Messages"))

    local search_bg = vgui.Create("DPanel", main)
    search_bg:Dock(TOP)
    search_bg:DockMargin(main_x * 0.04, main_y * 0.025, main_x * 0.04, 0)
    search_bg:SetTall(main_y * 0.07)

    function search_bg:Paint(w, h)
        draw.RoundedBox(h / 2, 0, 0, w, h, clr_black1)
    end

    local search_icon = vgui.Create("DLabel", search_bg)
    search_icon:Dock(LEFT)
    search_icon:DockMargin(search_bg:GetTall() / 2, 0, 0, 0)
    search_icon:SetWide(search_bg:GetTall())
    search_icon:SetFont(aphone:GetFont("SVG_30"))
    search_icon:SetText("g")
    search_icon:SetTextColor(clr_white120)

    local search_entry = vgui.Create("DLabel", search_bg)
    search_entry:Dock(FILL)
    search_entry:DockMargin(0, 0, search_bg:GetTall() / 2, 0)
    search_entry:SetFont(font_mediumheader)
    search_entry:SetText(aphone.L("Search"))
    search_entry:SetMouseInputEnabled(true)
    search_entry:Phone_AlphaHover()

    function search_entry:DoClick()
        self:Phone_AskTextEntry(self:GetText(), 32)
    end

    function search_entry:textChange(txt)
        txt = string.lower(txt or "")

        for k, v in pairs(tbl) do
            if !string.StartWith(k, txt) and !v.on_closeanim then
                // Reset it
                v:SetAnimationEnabled(false)
                v:SetAnimationEnabled(true)

                v:AlphaTo(0, 0.25, 0)
                v:SizeTo(-1, 0, 0.25, 0, 0.5)
                v.on_closeanim = true
            elseif string.StartWith(k, txt) then
                // Reset it
                if v.on_closeanim then
                    v:SetAnimationEnabled(false)
                    v:SetAnimationEnabled(true)
                end

                v:SizeTo(-1, main_y * 0.12, 0.25, 0, 0.5)
                v:AlphaTo(255, 0.25, 0)
                v.on_closeanim = false
            end
        end
    end

    local dial = vgui.Create("DLabel", main)
    dial:Dock(BOTTOM)
    dial:DockMargin(0, 0, 0, main_y*0.05)
    dial:SetFont(aphone:GetFont("SVG_40"))
    dial:SetText("5")
    dial:SetContentAlignment(5)
    dial:SetAutoStretchVertical(true)
    dial:SetMouseInputEnabled(true)
    dial:Phone_AlphaHover()

    function dial:DoClick()
        local number = 0

        local dial_bigpanel = vgui.Create("DButton", main)
        dial_bigpanel:SetSize(main_x, main_y)
        dial_bigpanel:SetPaintBackground(false)
        dial_bigpanel:SetText("")
        dial_bigpanel.open = CurTime()

        local dial_keys = vgui.Create("DPanel", dial_bigpanel)
        dial_keys:SetPos(0, main_y)
        dial_keys:SetSize(main_x, main_y*0.55)
        dial_keys:MoveTo(0, main_y - dial_keys:GetTall(), 0.5, 0, 0.2)

        function dial_bigpanel:DoClick()
            dial_bigpanel.closing = CurTime()
            dial_keys:MoveTo(0, main_y, 0.5, 0, 0.2, function()
                dial_bigpanel:Remove()
            end)
        end

        function dial_bigpanel:Paint(w, h)
            local ratio = !dial_bigpanel.closing and (CurTime() - dial_bigpanel.open)*3 or 1 - (CurTime() - dial_bigpanel.closing)*3

            if ratio > 1 then
                ratio = 1
            elseif ratio < 0 then
                ratio = 0
            end

            surface.SetDrawColor(0, 0, 0, 230 * ratio)
            surface.DrawRect(0, 0, w, h)
        end

        function dial_keys:Paint(w, h)
            draw.RoundedBoxEx(32, 0, 0, w, h, clr_blue, true, true, false, false)
            draw.RoundedBoxEx(32, 0, 10, w, h, clr_black1, true, true, false, false)
        end

        surface.SetFont(font_bold)

        local dial_number = vgui.Create("DLabel", dial_keys)
        dial_number:Dock(TOP)
        dial_number:SetText(aphone.FormatNumber("0"))
        dial_number:SetFont(font_bold)
        dial_number:SetContentAlignment(5)
        dial_number:DockMargin(0, main_y*0.03, 0, 0)
        dial_number:SetTextColor(clr_blue)
        dial_number:SetTall(select(2, surface.GetTextSize(aphone.FormatNumber("0"))))

        local lang_unknown = aphone.L("PlayerNotFound")

        local dial_name = vgui.Create("DLabel", dial_keys)
        dial_name:Dock(TOP)
        dial_name:SetText(lang_unknown)
        dial_name:SetFont(aphone:GetFont("Little_NoWeight"))
        dial_name:SetContentAlignment(5)
        dial_name:SetTextColor(clr_white120)
        dial_name:DockMargin(0, 0, 0, main_y*0.02)

        surface.SetFont(dial_name:GetFont())
        dial_name:SetTall(select(2, surface.GetTextSize(dial_name:GetText())))

        local dial_DIconLayout = vgui.Create("DIconLayout", dial_keys)
        dial_DIconLayout:Dock(TOP)
        dial_DIconLayout:DockMargin(main_x*0.2, 0, main_x*0.2, 0)
        dial_DIconLayout:SetTall(main_y*0.25)

        local button_call = vgui.Create("DLabel", dial_keys)
        button_call:Dock(FILL)
        button_call:SetText("o")
        button_call:SetFont(dial:GetFont())
        button_call:SetContentAlignment(5)
        button_call:Phone_AlphaHover()
        button_call:SetVisible(false)
        button_call:SetMouseInputEnabled(true)

        function button_call:DoClick()
            if !IsValid(already_num[dial_number:GetText()]) then return end

            net.Start("aphone_Phone")
                net.WriteUInt(1, 4)
                net.WriteEntity(already_num[dial_number:GetText()])
            net.SendToServer()

            dial_bigpanel:DoClick()
        end

        local roboto40 = aphone:GetFont("Roboto40")
        local pnl_0

        for i=9, 0, -1 do
            local ratio = (i != 0 and 3 or 1)

            local num = vgui.Create("DButton", dial_DIconLayout)
            num:SetSize(main_x*0.6 / ratio, main_y*0.25 / 3)
            num:SetText(i)
            num:SetPaintBackground(false)
            num:SetFont(roboto40)
            num:Phone_AlphaHover()

            function num:DoClick()
                local tempnumber = tonumber(tostring(number) .. i)

                if string.len(tempnumber) > aphone.digitscount then return end
                number = tempnumber
                dial_number:SetText(aphone.FormatNumber(tempnumber))

                if already_num[dial_number:GetText()] then
                    dial_name:SetText(aphone.GetName(already_num[dial_number:GetText()]))
                    button_call:SetVisible(true)
                else
                    dial_name:SetText(lang_unknown)
                    button_call:SetVisible(false)
                end
            end

            if i == 0 then pnl_0 = num end
        end

        local remove = vgui.Create("DButton", pnl_0)
        remove:SetSize(main_x*0.2, main_y*0.25 / 3)
        remove:SetText("<")
        remove:SetPaintBackground(false)
        remove:SetFont(roboto40)
        remove:Phone_AlphaHover()
        remove:Dock(RIGHT)

        function remove:DoClick()
            if tonumber(number) == 0 then return end
            local formatted = string.sub(tostring(number), 1, -2)
            formatted = (formatted != "" and formatted or "0")

            number = tonumber(formatted)
            dial_number:SetText(aphone.FormatNumber(formatted))

            if already_num[dial_number:GetText()] then
                dial_name:SetText(aphone.GetName(already_num[dial_number:GetText()]))
                button_call:SetVisible(true)
            else
                dial_name:SetText(lang_unknown)
                button_call:SetVisible(false)
            end
        end

        dial_bigpanel:aphone_RemoveCursor()
    end

    local player_list = vgui.Create("DScrollPanel", main)
    player_list:Dock(FILL)
    player_list:DockMargin(0, main_y * 0.02, 0, 0)
    player_list:aphone_PaintScroll()

    local title_available = player_list:Add("DLabel")
    title_available:Dock(TOP)
    title_available:DockMargin(main_x * 0.09, 0, 0, 0)
    title_available:SetTall(title_y)
    title_available:SetFont(aphone:GetFont("Little"))
    title_available:SetTextColor(clr_white120)
    title_available:SetText(aphone.L("Available"))

    main:aphone_RemoveCursor()

    function player_list:Phone_GeneratePanel(ply, disconnected)
        if !ply then return end

        local connected = ply and isentity(ply) and ply:IsPlayer()
        local id = connected and ply:aphone_GetID() or ply

        // Get last message, for date + text display
        local infos = sql.Query("SELECT * FROM aphone_Messages WHERE user = " .. id .. " AND ip = '" .. game.GetIPAddress() .. "' ORDER BY timestamp DESC LIMIT 1")
        local name = aphone.GetName(ply)

        infos = infos and infos[1]

        local player_main = vgui.Create("DButton", self)
        player_main:Dock(TOP)
        player_main:SetTall(main_y * 0.12)
        player_main:SetPaintBackground(false)
        player_main:TDLib()
        player_main:SetText("")
        player_main:FadeHover(clr_green)

        local player_subpanel = vgui.Create("DPanel", player_main)
        player_subpanel:Dock(TOP)
        player_subpanel:DockMargin(main_x * 0.04, main_y * 0.02, main_x * 0.04, main_y * 0.02)
        player_subpanel:SetTall(main_y * 0.08)
        player_subpanel:SetPaintBackground(false)
        player_subpanel:SetMouseInputEnabled(false)

        tbl[string.lower(aphone.GetName(ply))] = player_main

        function player_main:DoClick()
            local msg_pnl = vgui.Create("aphone_Msg", main)
            msg_pnl:InitPly(ply)
        end

        if !disconnected then
            local player_outlineavatar = vgui.Create("DPanel", player_subpanel)
            player_outlineavatar:Dock(LEFT)
            player_outlineavatar:SetWide(player_subpanel:GetTall())
            player_outlineavatar:SetMouseInputEnabled(false)
            player_outlineavatar:SetPaintBackground(false)
            player_outlineavatar:DockMargin(main_x * 0.05, 0, 0, 0)

            local s_c = aphone.GUI.ScaledSize(8)

            local player_avatar = vgui.Create("aphone_CircleAvatar", player_outlineavatar)
            player_avatar:Dock(FILL)
            player_avatar:DockMargin(s_c, s_c, s_c, s_c)
            player_avatar:SetPlayer(ply, 184)
        end

        local player_text = vgui.Create("DPanel", player_subpanel)
        player_text:Dock(FILL)
        player_text:DockMargin(main_x * 0.05, 0, 0, 0)
        player_text:SetPaintBackground(false)
        player_text:SetMouseInputEnabled(false)

        local time = aphone.FormatTimeStamp(infos and infos.timestamp or 0)

        surface.SetFont(font_mediumheader)
        local text_x, text_y = surface.GetTextSize(time)

        local player_toptext = vgui.Create("DPanel", player_text)
        player_toptext:Dock(TOP)
        player_toptext:SetTall(text_y)
        player_toptext:SetPaintBackground(false)
        player_toptext:SetMouseInputEnabled(false)

        local player_textdate = vgui.Create("DLabel", player_toptext)
        player_textdate:Dock(RIGHT)
        player_textdate:SetWide(text_x)
        player_textdate:SetFont(font_mediumheader)
        player_textdate:SetText(time)
        player_textdate:SetTextColor(aphone:Color("Text_White180"))
        player_textdate:SetMouseInputEnabled(false)

        local player_textname = vgui.Create("DLabel", player_toptext)
        player_textname:Dock(FILL)
        player_textname:DockMargin(0, 0, 5, 0)
        player_textname:SetFont(font_mediumheader)
        player_textname:SetTextColor(aphone:Color("Text_White"))
        player_textname:SetText(aphone.GetName(ply))
        player_textname:SetMouseInputEnabled(false)

        if infos and infos.body then
            local player_lastmsg = vgui.Create("DLabel", player_text)
            player_lastmsg:Dock(FILL)
            player_lastmsg:DockMargin(0, 5, 0, 0)
            player_lastmsg:SetFont(font_mediumheader)
            player_lastmsg:SetText(infos.body)
            player_lastmsg:SetTextColor(aphone:Color("Text_White180"))
            player_lastmsg:SetMouseInputEnabled(false)
        end
    end

    // Create Special Numbers ( aka compatibilities with sh_compatibilities.lua )
    for k, v in pairs(aphone.SpecialNumbers) do
        if v.showcondition and !v.showcondition() then continue end

        local spenum = vgui.Create("DButton", player_list)
        spenum:Dock(TOP)
        spenum:SetTall(main_y * 0.12)
        spenum:SetPaintBackground(false)
        spenum:SetText("")
        spenum:TDLib()
        spenum:FadeHover(v.clr or clr_green)

        function spenum:DoClick()
            v.func()
        end

        local spenum_sub = vgui.Create("DPanel", spenum)
        spenum_sub:Dock(TOP)
        spenum_sub:DockMargin(main_x * 0.09, main_y * 0.02, main_x * 0.04, main_y * 0.02)
        spenum_sub:SetTall(main_y * 0.08)
        spenum_sub:SetPaintBackground(false)
        spenum_sub:SetMouseInputEnabled(false)

        local player_outlineavatar = vgui.Create("DPanel", spenum_sub)
        player_outlineavatar:Dock(LEFT)
        player_outlineavatar:SetWide(spenum_sub:GetTall() - aphone.GUI.ScaledSizeX(16))
        player_outlineavatar:SetMouseInputEnabled(false)
        player_outlineavatar:DockMargin(aphone.GUI.ScaledSize(8, 8, 8, 8))

        function player_outlineavatar:Paint(w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(v.icon)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local player_text = vgui.Create("DButton", spenum_sub)
        player_text:Dock(FILL)
        player_text:SetText("")
        player_text:DockMargin(main_x * 0.05, 0, 0, 0)
        player_text:SetPaintBackground(false)
        player_text:SetMouseInputEnabled(false)
        player_text:TDLib()

        player_text:DualText(
            v.name,
            font_mediumheader,
            color_white,

            v.desc or "",
            font_mediumheader,
            clr_white120,
            TEXT_ALIGN_LEFT
        )
    end

    for k, v in ipairs(player.GetHumans()) do
        local id = v:aphone_GetID()

        if local_player == v or (aphone.disable_showingUnknownPlayers and !aphone.Contacts.GetName(id)) then continue end
        already_ids[id] = v
        player_list:Phone_GeneratePanel(v)
    end

    for k, v in ipairs(player.GetHumans()) do
        if local_player == v or !v:aphone_GetNumber() then continue end
        already_num[v:aphone_GetNumber()] = v
    end

    local title_onlymessages = vgui.Create("DLabel", player_list)
    title_onlymessages:Dock(TOP)
    title_onlymessages:DockMargin(main_x * 0.09, 0, 0, 0)
    title_onlymessages:SetTall(title_y)
    title_onlymessages:SetFont(aphone:GetFont("Little"))
    title_onlymessages:SetTextColor(clr_white120)
    title_onlymessages:SetText(aphone.L("Not_Available"))

    for k, v in pairs(aphone.Contacts.GetContacts()) do
        if !already_ids[k] then
            player_list:Phone_GeneratePanel(k, true)
        end
    end

    main:aphone_RemoveCursor()
end

function APP:OnClose()
    aphone.InsertNewMessage = nil
end

aphone.RegisterApp(APP)