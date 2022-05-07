local APP = {}

APP.name = "Friends"
APP.icon = "akulla/aphone/app_friends.png"
APP.Default = true

local m = Material("akulla/aphone/avatar_unknown.png", "smooth 1")
local red = Color(255, 82, 82)
local last_closedpic

function APP:Open(main, main_x, main_y, screenmode)
    local clr_black2 = aphone:Color("Black2")
    local clr_black1 = aphone:Color("Black1")
    local color_white180 = aphone:Color("Text_White180")
    local Roboto60 = aphone:GetFont("Roboto60")
    local font_mediumheader = aphone:GetFont("MediumHeader_500")
    local font_header = aphone:GetFont("Roboto40")
    local font_little = aphone:GetFont("Little_NoWeight")
    local font_small = aphone:GetFont("Small")
    local font_littlew = aphone:GetFont("Little")
    local svg_30 = aphone:GetFont("SVG_30")
    local svg_25 = aphone:GetFont("SVG_25")

    if !screenmode then
        main:Phone_DrawTop(main_x, main_y, true)
    end
    
    // Get player ids
    local already_ids = {}

    for k, v in ipairs(player.GetHumans()) do
        already_ids[v:aphone_GetID()] = v
    end

    function main:Paint(w, h)
        surface.SetDrawColor(220, 220, 220)
        surface.DrawRect(0,0,w,h)
    end

    local message_writing = vgui.Create("DPanel", main)
    message_writing:Dock(BOTTOM)
    message_writing:DockMargin(main_x * 0.04, main_y * 0.025, main_x * 0.04, main_y * 0.025)
    message_writing:SetTall(screenmode and main_x*0.07 or main_y * 0.07)

    local perfect_h = main_y * 0.035
    local clr_text = aphone:Color("Black40")

    function message_writing:Paint(w, h)
        draw.RoundedBox(perfect_h, 0, 0, w, h, clr_text)
    end

    surface.SetFont(svg_30)
    local msg_writingtall = message_writing:GetTall()

    local message_send = vgui.Create("DLabel", message_writing)
    message_send:Dock(RIGHT)
    message_send:DockMargin(0, 0, msg_writingtall / 4, 0)
    message_send:SetWide(select(1, surface.GetTextSize("i")))
    message_send:SetFont(svg_30)
    message_send:SetText("i")
    message_send:SetTextColor(clr_white120)
    message_send:SetMouseInputEnabled(true)

    // aphone_OnlinePictureList
    local messages_pic = vgui.Create("DLabel", message_writing)
    messages_pic:Dock(RIGHT)
    messages_pic:DockMargin(0, 0, msg_writingtall / 4, 0)
    messages_pic:SetWide(select(1, surface.GetTextSize("m")))
    messages_pic:SetFont(svg_30)
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
        local messages_picmain = vgui.Create("aphone_OnlinePictureList", main)
        function messages_picmain:OnSelected(imgur_url)
            aphone.Contacts.Send(id, "imgur://" .. imgur_url, true)
        end
    end

    local placeholder = aphone.L("Type_Message")
    function message_writingEntry:DoClick()
        self:Phone_AskTextEntry(message_writingEntry:GetText() == placeholder and "" or self:GetText(), 140, message_writing, (main_x * 0.92 - msg_writingtall * 1.25 - messages_pic:GetWide() - message_send:GetWide()))
    end

    function message_writingEntry:textEnd(clean_txt, wrapped_txt)
        self:SetText(wrapped_txt)
        self.goodtext = clean_txt
    end

    // Header_Friends
    local player_text = vgui.Create("DLabel", main)
    player_text:Dock(TOP)
    player_text:DockMargin(main_x * 0.05, main_y * 0.05, 0, 0)
    player_text:SetText("Friends")
    player_text:SetTextColor(clr_black2)
    player_text:SetFont(aphone:GetFont("Header_Friends"))
    player_text:SetContentAlignment(5)
    player_text:SetTall(select(2, player_text:GetTextSize()))

    local message_scroll = vgui.Create("DScrollPanel", main)
    message_scroll:Dock(FILL)
    message_scroll:aphone_PaintScroll()
    message_scroll:DockMargin(screenmode and main_x * 0.03 or 0, 0, 0, 0)

    aphone.Friends_PanelList = {}
    local lastpanel

    function aphone.InsertNewMessage_Friend(userid, body, msg_id, last_name, likes, local_vote)
        if IsValid(message_scroll) then
            local sub

            if !lastpanel or lastpanel.userid ~= userid then
                sub = message_scroll:Add("DPanel")
                sub:SetTall(aphone.GUI.ScaledSizeY(54))
                sub:Dock(TOP)
                sub:SetPaintBackground(false)
                sub:DockMargin(0, 0, 0, main_y*0.02)
                sub.userid = userid

                local sub_mainpnl = vgui.Create("DPanel", sub)
                sub_mainpnl:SetTall(sub:GetTall())
                sub_mainpnl:Dock(TOP)
                sub_mainpnl:SetPaintBackground(false)

                local avatar

                // try to get the player
                if isnumber(userid) and already_ids[userid] then
                    userid = already_ids[userid]
                end

                local connected = !isnumber(userid) and IsValid(userid)
                local plyname = connected and userid:Nick() or last_name

                if !isnumber(userid) and IsValid(userid) then
                    avatar = vgui.Create("aphone_CircleAvatar", sub_mainpnl)
                    avatar:SetPlayer(userid, 64)
                else
                    avatar = vgui.Create("DPanel", sub_mainpnl)

                    function avatar:Paint(w, h)
                        surface.SetDrawColor(color_white)
                        surface.SetMaterial(m)
                        surface.DrawTexturedRect(0, 0, h, h)
                    end
                end

                avatar:Dock(LEFT)
                avatar:SetWide(sub_mainpnl:GetTall())
                avatar:DockMargin(sub_mainpnl:GetTall()/6*2, 0, sub_mainpnl:GetTall()/6, 0)

                local bottom_name = vgui.Create("DLabel", sub_mainpnl)
                bottom_name:Dock(BOTTOM)
                bottom_name:SetText("@" .. string.Replace(plyname, " ", ""))
                bottom_name:SetFont(font_little)
                bottom_name:SetTextColor(clr_black1)
                bottom_name:SetAutoStretchVertical(true)
                bottom_name:SetAlpha(180)
                bottom_name:DockMargin(5, 0, 0, 0)
                bottom_name:SetMouseInputEnabled(false)

                local subtitle = vgui.Create("DPanel", sub_mainpnl)
                subtitle:Dock(FILL)
                subtitle:SetPaintBackground(false)

                sub.like_logo = vgui.Create("DLabel", subtitle)
                sub.like_logo:Dock(RIGHT)
                sub.like_logo:SetWide(aphone.GUI.ScaledSizeX(25))
                sub.like_logo:SetTextColor(local_vote == 1 and red or clr_black1)
                sub.like_logo:SetText("3")
                sub.like_logo:SetFont(svg_25)
                sub.like_logo:SetContentAlignment(5)
                sub.like_logo:SetMouseInputEnabled(true)
                sub.like_logo:DockMargin(0, 0, main_x*0.1, 0)

                function sub.like_logo:DoClick()
                    net.Start("aphone_AddLike") 
                        net.WriteUInt(msg_id, 29)
                    net.SendToServer()
                end

                surface.SetFont(font_littlew)

                sub.like_count = vgui.Create("DLabel", subtitle)
                sub.like_count:Dock(RIGHT)
                sub.like_count:SetWide(select(1, surface.GetTextSize("9999")))
                sub.like_count:SetTextColor(color_black)
                sub.like_count:SetText(likes)
                sub.like_count:SetFont(font_littlew)
                sub.like_count:SetContentAlignment(6)
                sub.like_count:DockMargin(3, 0, 3, 0)
                sub.like_count:SetMouseInputEnabled(true)

                function sub.like_count:DoClick()
                    sub.like_logo:DoClick()
                end

                local name = vgui.Create("DLabel", subtitle)
                name:Dock(FILL)
                name:SetText(plyname)
                name:SetFont(font_mediumheader)
                name:SetTextColor(clr_black1)
                name:SetAutoStretchVertical(true)
                name:DockMargin(5, 0, 0, 0)

                aphone.Friends_PanelList[tonumber(msg_id)] = sub
                lastpanel = sub
            else
                sub = lastpanel
            end

            local sub_size = aphone.GUI.ScaledSizeY(54)

            local left_margin = sub_size*1.5 + 5

            if string.StartWith(body, "imgur://") then
                local sub_messagepnl = vgui.Create("aphone_MessageImage", sub)
                sub_messagepnl:Dock(TOP)
                sub_messagepnl:Left_Avatar(false)
                sub_messagepnl:SetImgur(body)
                sub_messagepnl:SetTall(main_x * 0.35)
                sub_messagepnl:DockMargin(sub_size * 1.25, 5, sub_size/2, 0)
                sub:SetTall(sub:GetTall() + sub_messagepnl:GetTall())

                function sub_messagepnl:DoClick()
                    local show_pic = vgui.Create("aphone_ShowImage", main)
                    show_pic:SetMat(aphone.GetImgurMat(body))
                    last_closedpic = msg_id

                    function show_pic.onclose()
                        last_closedpic = nil
                    end
                end

                if last_closedpic and last_closedpic == msg_id then
                    sub_messagepnl:DoClick()
                end
            else
                local text_panel = vgui.Create("DLabel", sub)
                text_panel:DockMargin(sub_size*1.5 + 5, 5, sub_size/2, 0)
                text_panel:Dock(TOP)

                local wrapped = aphone.GUI.WrapText(body, font_small, main_x - left_margin - sub_size)

                text_panel:SetWrap(true)
                text_panel:SetText(wrapped)
                text_panel:SetFont(font_small)
                text_panel:SetAutoStretchVertical(true)
                text_panel:SetTextColor(clr_black2)

                sub:SetTall(sub:GetTall() + select(2, surface.GetTextSize(wrapped)))
            end

            sub:SetTall(sub:GetTall() + aphone.GUI.ScaledSizeY(10))
            sub:aphone_RemoveCursor()

            return lastpanel
        end
    end

    function message_send:DoClick()
        if !message_writingEntry.goodtext then return end

        aphone.Contacts.Send(id, message_writingEntry.goodtext, true)

        self:GetParent():SetTall(main_y * 0.07)
        message_writingEntry:SetText(aphone.L("Type_Message"))
        message_writingEntry.goodtext = nil
    end

    // Let's not load ALL messages. Imagine if he got a lot of messages
    local msg_tbl = sql.Query("SELECT * FROM aphone_Friends WHERE ip = '" .. game.GetIPAddress() .. "' AND timestamp > " .. os.time() - 604800) or {}

    local scrollto
    for k, v in ipairs(msg_tbl) do
        scrollto = aphone.InsertNewMessage_Friend(tonumber(v.user), v.body, tonumber(v.id), v.last_name, v.likes, tonumber(v.local_vote), false)
    end

    if scrollto then
        // We need to wait that dock size everything, I think ?
        timer.Simple(0.33, function()
            message_scroll:ScrollToChild(scrollto)
        end)
    end

    main:aphone_RemoveCursor()
end

function APP:OnClose()
    last_closedpic = nil
    aphone.InsertNewMessage_Friend = nil
end

function APP:Open2D(main, main_x, main_y)
    APP:Open(main, main_x, main_y, true)
end

aphone.RegisterApp(APP)