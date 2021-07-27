local PANEL = {}
local clr_green = Color(46,139,87)

function PANEL:InitPly(ply)
    local main_x, main_y = aphone.MainDerma:GetSize()
    local clr_black3 = aphone:Color("Black3")
    local clr_black2 = aphone:Color("Black2")
    local clr_black1 = aphone:Color("Black1")
    local clr_white120 = aphone:Color("Text_White120")
    local font_mediumheader = aphone:GetFont("MediumHeader")
    local connected = ply and isentity(ply) and ply:IsPlayer()
    local id = connected and ply:aphone_GetID() or ply
    local name = aphone.GetName(ply)
    local pnl = self

    self:SetPaintBackground(false)

    self:SetSize(aphone.MainDerma:GetSize())

    local message_panel = vgui.Create("DPanel", self)
    message_panel:SetSize(main_x, main_y)
    message_panel:SetPos(main_x, 0)
    message_panel:MoveTo(0, 0, 0.25, 0, 0.5)

    local message_writing = vgui.Create("DPanel", message_panel)
    message_writing:Dock(BOTTOM)
    message_writing:DockMargin(main_x * 0.04, main_y * 0.025, main_x * 0.04, main_y * 0.025)
    message_writing:SetTall(main_y * 0.07)

    local perfect_h = main_y * 0.035

    function message_writing:Paint(w, h)
        draw.RoundedBox(perfect_h, 0, 0, w, h, clr_black1)
    end

    surface.SetFont(aphone:GetFont("SVG_30"))
    local msg_writingtall = message_writing:GetTall()

    local message_send = vgui.Create("DLabel", message_writing)
    message_send:Dock(RIGHT)
    message_send:DockMargin(0, 0, msg_writingtall / 4, 0)
    message_send:SetWide(select(1, surface.GetTextSize("i")))
    message_send:SetFont(aphone:GetFont("SVG_30"))
    message_send:SetText("i")
    message_send:SetTextColor(clr_white120)
    message_send:SetMouseInputEnabled(true)

    // aphone_OnlinePictureList
    local messages_pic = vgui.Create("DLabel", message_writing)
    messages_pic:Dock(RIGHT)
    messages_pic:DockMargin(0, 0, msg_writingtall / 4, 0)
    messages_pic:SetWide(select(1, surface.GetTextSize("m")))
    messages_pic:SetFont(aphone:GetFont("SVG_30"))
    messages_pic:SetText("m")
    messages_pic:SetTextColor(clr_white120)
    messages_pic:SetMouseInputEnabled(true)
    messages_pic:Phone_AlphaHover()

    local message_writingEntry = vgui.Create("DLabel", message_writing)
    message_writingEntry:Dock(FILL)
    message_writingEntry:DockMargin(msg_writingtall / 2, 0, msg_writingtall / 2, 0)
    message_writingEntry:SetFont(font_mediumheader)
    message_writingEntry:SetText(aphone.L("Type_Message"))
    message_writingEntry:SetTextColor(clr_white120)
    message_writingEntry:SetMouseInputEnabled(true)
    message_writingEntry:Phone_AlphaHover()

    -- Create a panel to select online pictures, then set the dlabel text to the link
    function messages_pic:DoClick()
        local messages_picmain = vgui.Create("aphone_OnlinePictureList", pnl)
        function messages_picmain:OnSelected(imgur_url)
            aphone.InsertNewMessage(LocalPlayer(), "imgur://" .. imgur_url)
            aphone.Contacts.Send(id, "imgur://" .. imgur_url)
        end
    end

    local placeholder = aphone.L("Type_Message")
    function message_writingEntry:DoClick()
        self:Phone_AskTextEntry(message_writingEntry:GetText() == placeholder and "" or self:GetText(), 140, message_writing, (main_x*0.92 - msg_writingtall*1.25 - messages_pic:GetWide() - message_send:GetWide()))
    end

    function message_writingEntry:textEnd(clean_txt, wrapped_txt)
        self:SetText(wrapped_txt)
        self.goodtext = clean_txt
    end

    surface.SetFont(aphone:GetFont("Roboto45_700"))
    local title_x, title_y = surface.GetTextSize(name)

    local top_name = vgui.Create("DPanel", message_panel)
    top_name:Dock(TOP)
    top_name:DockMargin(main_x * 0.12, main_y * 0.05, 0, main_y * 0.05)
    top_name:SetTall(title_y)
    top_name:SetPaintBackground(false)

    local top_back = vgui.Create("DButton", top_name)
    top_back:Dock(RIGHT)
    top_back:SetWide(title_y)
    top_back:SetFont(aphone:GetFont("SVG_30"))
    top_back:SetText("l")
    top_back:SetPaintBackground(false)
    top_back:Phone_AlphaHover()
    top_back:SetTextColor(clr_white120)
    top_back:DockMargin(0, 0, top_back:GetWide(), 0)

    function top_back:DoClick()
        message_panel:MoveTo(main_x, 0, 0.5, 0, 0.5, function()
            pnl:Remove()
        end)
    end

    // Disconnected, hide call button
    if connected then
        surface.SetFont(aphone:GetFont("SVG_30"))
        local top_call = vgui.Create("DButton", top_name)
        top_call:Dock(RIGHT)
        top_call:SetWide(select(1, surface.GetTextSize("o")))
        top_call:SetFont(aphone:GetFont("SVG_30"))
        top_call:SetText("o")
        top_call:Phone_AlphaHover()
        top_call:SetTextColor(clr_white120)
        top_call:SetPaintBackground(false)

        function top_call:DoClick()
            net.Start("aphone_Phone")
                net.WriteUInt(1, 4)
                net.WriteEntity(ply)
            net.SendToServer()
        end
    end

    local title_sub = vgui.Create("DLabel", top_name)
    title_sub:SetFont(aphone:GetFont("Roboto40_700"))
    title_sub:SetTextColor(aphone:Color("Text_White"))
    title_sub:SetText(name)
    title_sub:Dock(FILL)
    title_sub:SetWide(title_x + 10)

    local message_scroll = vgui.Create("DScrollPanel", message_panel)
    message_scroll:Dock(FILL)
    message_scroll:aphone_PaintScroll()

    local is_empty = true

    // Ghetto but work and won't make optimisation issues searching the dscrollpanel from the main panel etc
    local last_msgpanel
    function aphone.InsertNewMessage(userid, body)
        if IsValid(message_scroll) then
            local ext = false

            if isbool(userid) then
                ext = userid
            elseif isentity(userid) and userid == LocalPlayer() then
                ext = true
            elseif isnumber(userid) and userid == LocalPlayer():aphone_GetID() then
                ext = true
            end

            is_empty = false

            if string.StartWith(body, "imgur://") then
                local sub_messagepnl = message_scroll:Add("aphone_MessageImage")
                sub_messagepnl:Dock(TOP)
                sub_messagepnl:DockMargin(0, main_x * 0.025, 0, main_x * 0.025)
                sub_messagepnl:Left_Avatar(ext)
                sub_messagepnl:SetImgur(body)
                sub_messagepnl:SetTall(main_x * 0.35)

                function sub_messagepnl:DoClick()
                    local show_pic = vgui.Create("aphone_ShowImage", pnl)
                    show_pic:SetMat(aphone.GetImgurMat(body))
                end

                last_msgpanel = sub_messagepnl
                return sub_messagepnl
            else
                if !IsValid(last_msgpanel) or last_msgpanel:GetName() != "aphone_Message" or last_msgpanel.revert != ext then
                    local sub_messagepnl = message_scroll:Add("aphone_Message")
                    sub_messagepnl:Dock(TOP)
                    sub_messagepnl:DockMargin(main_x * 0.05, main_x * 0.025, main_x * 0.05, main_x * 0.025)
                    sub_messagepnl:Left_Avatar(ext)
                    sub_messagepnl:SetText(body)
                    sub_messagepnl:SetBackgroundColor(ext and clr_green or clr_black2)

                    if !connected then
                        sub_messagepnl:KillAvatar()
                    else
                        sub_messagepnl:SetAvatar(userid, 184)
                    end

                    last_msgpanel = sub_messagepnl
                    return sub_messagepnl
                else
                    last_msgpanel:SetText(last_msgpanel:GetText() .. "\n" .. body)
                end
            end
        end
    end

    function message_send:DoClick()
        if !message_writingEntry.goodtext then return end

        aphone.Contacts.Send(id, message_writingEntry.goodtext)

        self:GetParent():SetTall(main_y * 0.07)
        aphone.InsertNewMessage(LocalPlayer(), message_writingEntry.goodtext)

        message_writingEntry.goodtext = nil
        message_writingEntry:SetText(aphone.L("Type_Message"))
    end

    // Let's not load ALL messages. Imagine if he got a lot of messages
    local msg_tbl = sql.Query("SELECT * FROM aphone_Messages WHERE user = " .. id .. " AND ip = '" .. game.GetIPAddress() .. "' AND timestamp > " .. os.time() - 604800) or {}

    local pnl
    for k, v in ipairs(msg_tbl) do
        if connected then
            pnl = aphone.InsertNewMessage(tonumber(v.local_sender) == 1 and LocalPlayer() or ply, v.body)
        else
            pnl = aphone.InsertNewMessage(tonumber(v.local_sender) == 1, v.body)
        end
    end

    if IsValid(pnl) then
        timer.Simple(0.33, function()
            message_scroll:ScrollToChild(pnl)
        end)
    end

    function message_panel:Paint(w, h)
        surface.SetDrawColor(clr_black3)
        surface.DrawRect(0,0,w,h)

        if is_empty then
            local _, txt_y = draw.SimpleText("U", aphone:GetFont("SVG_76"), w / 2, h / 4, clr_white120, 1)
            draw.DrawText(aphone.L("First_Message"), font_mediumheader, w / 2, h / 4 + txt_y + 10, clr_white120, 1)
        end
    end

    self:aphone_RemoveCursor()
end

vgui.Register("aphone_Msg", PANEL, "DPanel")