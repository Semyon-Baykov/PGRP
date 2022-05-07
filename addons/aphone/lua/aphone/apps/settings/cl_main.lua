local APP = {}

APP.name = aphone.L("Options")
APP.icon = "akulla/aphone/app_settings.png"
APP.Default = false // You shouldn't use this flag, it's only for "system app" that got a special display at the bottom of the menu

local stencil_clr = Color(1, 1, 1, 1)
local clr_blue = Color(93,207,202)


function APP:Open(main, main_x, main_y)
    local color_black1 = aphone:Color("Black1")
    local color_black2 = aphone:Color("Black2")
    local color_black3 = aphone:Color("Black3")
    local color_white120 = aphone:Color("Text_White120")
    local color_white180 = aphone:Color("Text_White180")
    local color_white = aphone:Color("Text_White")
    local color_orange = aphone:Color("Text_Orange")
    local font_mediumheader = aphone:GetFont("MediumHeader")
    local font_big = aphone:GetFont("Roboto80")
    local color_gps = aphone:Color("GPS_Line")
    local font_bold = aphone:GetFont("Roboto45_700")

    local local_player = LocalPlayer()
    local local_playernick = local_player:Nick()

    function main:Paint(w, h)
        surface.SetDrawColor(color_black2)
        surface.DrawRect(0,0,w,h)
    end

    local top_app = vgui.Create("DPanel", main)
    top_app:Dock(TOP)
    top_app:DockMargin(main_y * 0.03, main_y * 0.05, main_y * 0.03, 0)
    top_app:SetTall(main_y * 0.075)
    top_app:SetPaintBackground(false)

    local avatar = vgui.Create("aphone_CircleAvatar", top_app)
    avatar:Dock(LEFT)
    avatar:SetWide(top_app:GetTall())
    avatar:SetPlayer(local_player, 128)

    local local_num = local_player:aphone_GetNumber()

    function top_app:Paint(w, h)
        draw.SimpleText(local_playernick, font_mediumheader, top_app:GetTall() * 1.25, h / 2, color_white, 0, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(local_num, font_mediumheader, top_app:GetTall() * 1.25, h / 2, color_white120, 0, TEXT_ALIGN_TOP)
    end

    local select_scroll = vgui.Create("DPanel", main)
    select_scroll:Dock(TOP)
    select_scroll:SetTall(main_y * 0.10)
    select_scroll:SetPaintBackground(false)
    select_scroll:DockMargin(0, main_y * 0.01, 0, 0)

    local main_scroll = vgui.Create("DScrollPanel", main)
    main_scroll:SetPos(main_x * 0.07, main_y * 0.24)
    main_scroll:SetSize(main_x * 0.86, main_y * 0.785 - main_y * 0.05)
    main_scroll:aphone_PaintScroll()

    // Used later for sliders params
    local wide = (main_x - aphone.GUI.ScaledSizeX(160) - main_y * 0.06) / 3

    surface.SetFont(font_mediumheader)

    for k, v in pairs(aphone.Params) do
        local cat_title = main_scroll:Add("DLabel")
        cat_title:Dock(TOP)
        cat_title:SetFont(font_mediumheader)
        cat_title:SetText(k)
        cat_title:SetTextColor(color_orange)
        cat_title:DockMargin(aphone.GUI.ScaledSize(5, 10, 0, 5))
        cat_title:Toggle()
        cat_title:SetAutoStretchVertical(true)

        local listpanel = vgui.Create("DPanel", main_scroll)
        listpanel:Dock(TOP)
        listpanel:DockMargin(aphone.GUI.ScaledSize(0, 5, 0, 0))
        listpanel:SetTall(0)

        function listpanel:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, color_black3)
        end

        for i, j in pairs(v) do
            local sub_panel = vgui.Create("DPanel", listpanel)
            sub_panel:Dock(TOP)
            sub_panel:SetPaintBackground(false)

            local sub_txt = vgui.Create("DLabel", sub_panel)
            sub_txt:SetMouseInputEnabled(true)
            sub_txt:SetTextColor(color_white180)
            sub_txt:SetFont(font_mediumheader)
            sub_txt:SetTall(select(2, sub_txt:GetContentSize()) * 1.5)
            sub_txt:SetText(j.full_name)
            sub_txt:DockMargin(main_y * 0.02, 0, 0, 0)
            sub_txt:SetIsToggle(true)
            sub_txt:Dock(TOP)

            if j.var_type == "string" or j.var_type == "num" then
                local panel_but = vgui.Create("DLabel", sub_panel)
                panel_but:Dock(TOP)
                panel_but:SetTall(sub_txt:GetTall())
                panel_but:SetFont(font_mediumheader)
                panel_but:SetTextColor(color_white)
                panel_but:SetIsToggle(true)
                panel_but:DockMargin(main_y * 0.02, 0, 0, 0)
                panel_but:SetText(aphone:GetParameters(k, i, j.def))
                panel_but:SetMouseInputEnabled(true)

                function panel_but:DoClick()
                    local text_entry = self:Phone_AskTextEntry(self:GetText())
                    text_entry:SetNumeric(j.var_type == "num")
                end

                function sub_txt:DoClick()
                    if !self:GetToggle() then
                        sub_panel:SetTall(sub_txt:GetTall() + panel_but:GetTall())
                        listpanel:SetTall(listpanel:GetTall() + panel_but:GetTall())
                    else
                        sub_panel:SetTall(sub_txt:GetTall())
                        listpanel:SetTall(listpanel:GetTall() - panel_but:GetTall())
                    end

                    self:Toggle()
                end

            elseif j.var_type == "color" then
                local panel_but = vgui.Create("DPanel", sub_panel)
                panel_but:Dock(TOP)
                panel_but:SetTall(sub_txt:GetTall() * 0.5)
                panel_but:SetPaintBackground(false)

                sub_txt:SetText(aphone.L(i))

                local clr = aphone:Color(i)

                for a, b in ipairs({"r", "g", "b"}) do
                    local p = vgui.Create("DSlider", panel_but)
                    p:Dock(LEFT)
                    p:SetWide( wide )
                    p:DockMargin(aphone.GUI.ScaledSize(20, 0, 20, 0))
                    p:SetSlideX(clr[b] / 255)

                    function p:Paint(w, h)
                        draw.RoundedBox(4, 0, h / 2-4, w, 8, color_white)
                        draw.RoundedBox(4, 0, h / 2-4, w * self:GetSlideX(), 8, color_orange)
                    end
                    function p.Knob:Paint(w, h) end

                    function p:Think()
                        if self:IsEditing() then
                            local new_clr = table.Copy(aphone:Color(i))
                            new_clr[b] = self:GetSlideX() * 255
                            aphone.Clientside.SaveSetting(i, Color(new_clr.r, new_clr.g, new_clr.b, new_clr.a or 255))
                        end
                    end
                end

                function sub_txt:DoClick()
                    if !self:GetToggle() then
                        sub_panel:SetTall(sub_txt:GetTall() + panel_but:GetTall())
                        listpanel:SetTall(listpanel:GetTall() + panel_but:GetTall())
                    else
                        sub_panel:SetTall(sub_txt:GetTall())
                        listpanel:SetTall(listpanel:GetTall() - panel_but:GetTall())
                    end

                    self:Toggle()
                end

                local reset_but = vgui.Create("DButton", sub_txt)
                reset_but:Dock(RIGHT)
                reset_but:SetWide(sub_txt:GetTall())
                reset_but:SetText("")

                function reset_but:Paint(w, h)
                    if self:IsHovered() or sub_txt:IsHovered() then
                        draw.SimpleText("j", aphone:GetFont("SVG_25"), w / 2, h / 2, color_white, 1, 1)
                    end
                end

                function reset_but:DoClick()
                    local default_clr = aphone:DefaultClr(i)
                    aphone.Clientside.SaveSetting(i, default_clr)

                    for a, b in ipairs({"r", "g", "b"}) do
                        panel_but:GetChildren()[a]:SetSlideX(default_clr[b] / 255)
                    end
                end
            elseif j.var_type == "bool" then
                sub_txt:SetTextColor(aphone:GetParameters(k, i, false) and color_white or color_white120)

                function sub_txt:DoClick()
                    local new_value = aphone:ChangeParameters(k, i, !aphone:GetParameters(k, i, false))
                    self:SetTextColor(new_value and color_white or color_white120)
                end
            elseif j.var_type == "sound" then
                -- same as bool, just disable himself after a change
                function sub_txt:DoClick()
                    self:SetTextColor(aphone:ChangeParameters(k, i, !aphone:GetParameters(k, i, false)) and color_white or color_white120)
                end

                hook.Add("APhone_SettingChange", i, function(cat, short_name)
                    if IsValid(sub_txt) then
                        if short_name != i then
                            aphone:ChangeParameters(k, i, false, true)
                        end
                        sub_txt:SetTextColor(short_name == i and color_white or color_white120)
                    end
                end)

                sub_txt:SetTextColor(aphone:GetParameters(k, i, false) and color_white or color_white120)
            end

            sub_panel:SetTall(sub_txt:GetTall())
        end

        // SizeToContent and children not working
        local height = 0

        for i, j in ipairs(listpanel:GetChildren()) do
            height = height + j:GetTall()
        end

        listpanel:SetTall(height)
    end

    local main_scrollbg = vgui.Create("DPanel", main)
    main_scrollbg:SetPos(main_x * 1.07, main_y * 0.25)
    main_scrollbg:SetSize(main_x * 0.86, main_y * 0.76 - main_y * 0.05)

    function main_scrollbg:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, color_black3)
    end

    local main_scrollbg_scroll = vgui.Create( "DScrollPanel", main_scrollbg ) // Create the Scroll panel
    main_scrollbg_scroll:Dock( FILL )
    main_scrollbg_scroll:DockMargin(8, 8, 8, 8)
    main_scrollbg_scroll:aphone_PaintScroll()

    local main_scrollbg_layout = main_scrollbg_scroll:Add("DIconLayout")
    main_scrollbg_layout:Dock(FILL)
    main_scrollbg_layout:SetSpaceX(aphone.GUI.ScaledSize(10))
    main_scrollbg_layout:SetSpaceY(main_scrollbg_layout:GetSpaceX())

    local size_bgw = main_scrollbg:GetWide() / 3 - 12 - main_scrollbg_layout:GetSpaceX() / 2
    local size_bgh = size_bgw * 2.1375
    local rb = aphone.GUI.RoundedBox(0, 0, size_bgw, size_bgh, 8)

    local actual_bg = aphone.Clientside.GetSetting("Background")

    local function addbg(v)
        local bg = main_scrollbg_layout:Add("DButton")
        bg:SetSize(size_bgw, size_bgh)
        bg:SetText("")

        function bg:Paint(w, h)
            local mat = aphone.GetImgurMat(v)

            if mat and !mat:IsError() then
                aphone.Stencils.Start()
                    surface.SetDrawColor(stencil_clr)
                    surface.DrawPoly(rb)
                aphone.Stencils.AfterMask(false)
                    render.SetStencilPassOperation(STENCILOPERATION_KEEP)

                    surface.SetMaterial(mat)
                    surface.SetDrawColor(color_white)
                    surface.DrawTexturedRect(0, 0, w, h)

                    if actual_bg == v then
                        draw.SimpleText("r", aphone:GetFont("SVG_60"), w / 2, h / 2, color_white, 1, 1)
                    end
                aphone.Stencils.End()
            else
                // Loading animation
                draw.RoundedBox(8, 0, 0, w, h, color_black2)

                if !self.circle1 then
                    self.circle1 = aphone.GUI.GenerateCircle(w / 2, h / 2, w / 4)
                    self.circle2 = aphone.GUI.GenerateCircle(w / 2, h / 2, w / 4 - 4)
                end

                local rad = CurTime() * 6

                aphone.Stencils.Start()
                    draw.NoTexture()
                    surface.SetDrawColor(stencil_clr)
                    surface.DrawPoly(self.circle1)
                aphone.Stencils.AfterMask(false)
                    draw.NoTexture()
                    surface.DrawPoly(self.circle2)

                    render.SetStencilPassOperation(STENCILOPERATION_KEEP)

                    surface.SetDrawColor(color_white120)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(color_gps)
                    draw.SimpleText("d", aphone:GetFont("SVG_40"), math.cos( rad ) * (w / 4) + w / 2, math.sin(rad) * (w / 4) + h / 2, color_gps, 1, 1)
                aphone.Stencils.End()
            end
        end

        function bg:DoClick()
            local is_bg = aphone.Clientside.GetSetting("Background") == v
            aphone.Clientside.SaveSetting("Background", !is_bg and v or nil)
            actual_bg = aphone.Clientside.GetSetting("Background")
            hook.Run("APhone_ChangedBackground")
        end
    end

    for k, v in ipairs(aphone.backgrounds_imgur) do
        addbg(v)
    end

    for k, v in ipairs(aphone.Clientside.GetSetting("userbg", {})) do
        addbg(v)
    end

    local bg = main_scrollbg_layout:Add("DButton")
    bg:SetSize(size_bgw, size_bgh)
    bg:SetText("+")
    bg:SetFont(font_big)
    bg:Phone_AlphaHover()

    function bg:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, color_black2)
    end

    function bg:DoClick()
        local bigpnl = vgui.Create("DButton", main)
        bigpnl:SetSize(main_x, main_y)
        bigpnl:SetPaintBackground(false)
        bigpnl:SetText("")
        bigpnl.open = CurTime()
    
        local subpnl = vgui.Create("DPanel", bigpnl)
        subpnl:SetPos(0, main_y)
        subpnl:SetSize(main_x, main_y*0.30)
        subpnl:MoveTo(0, main_y - subpnl:GetTall(), 0.5, 0, 0.2)
    
        function bigpnl:DoClick()
            bigpnl.closing = CurTime()
            subpnl:MoveTo(0, main_y, 0.5, 0, 0.2, function()
                bigpnl:Remove()
            end)
        end

        function bigpnl:Paint(w, h)
            render.SetStencilEnable(false)
            local ratio = !bigpnl.closing and (CurTime() - bigpnl.open)*3 or 1 - (CurTime() - bigpnl.closing)*3
    
            if ratio > 1 then
                ratio = 1
            elseif ratio < 0 then
                ratio = 0
            end
    
            surface.SetDrawColor(0, 0, 0, 230 * ratio)
            surface.DrawRect(0, 0, w, h)
        end
    
        function subpnl:Paint(w, h)
            draw.RoundedBoxEx(32, 0, 0, w, h, clr_blue, true, true, false, false)
            draw.RoundedBoxEx(32, 0, 10, w, h, color_black1, true, true, false, false)
        end

        local title = vgui.Create("DLabel", subpnl)
        title:Dock(TOP)
        title:SetText("Imgur ID")
        title:SetFont(font_bold)
        title:SetContentAlignment(5)
        title:DockMargin(0, main_y*0.03, 0, 0)
        title:SetTextColor(clr_blue)
        title:SetAutoStretchVertical(true)

        local imgur_entry = vgui.Create("DLabel", subpnl)
        imgur_entry:Dock(TOP)
        imgur_entry:DockMargin(main_x*0.1, main_y*0.02, main_x*0.1, 0)
        imgur_entry:SetFont(font_mediumheader)
        imgur_entry:SetText("ID")
        imgur_entry:SetMouseInputEnabled(true)
        imgur_entry:SetAutoStretchVertical(true)
        imgur_entry:Phone_AlphaHover()
    
        function imgur_entry:DoClick()
            top_pnl:SetText(top_pnl:GetText() == "n" and "" or "n")
        end
    
        function imgur_entry:Paint(w, h)
            surface.SetDrawColor(imgur_entry:GetTextColor())
            surface.DrawLine(0, h-1, w, h-1)
        end
    
        function imgur_entry:DoClick()
            self:Phone_AskTextEntry(self:GetText(), 12)
        end

        local imgur_valid = vgui.Create("DLabel", subpnl)
        imgur_valid:Dock(FILL)
        imgur_valid:SetText("r")
        imgur_valid:SetFont(aphone:GetFont("SVG_40"))
        imgur_valid:SetContentAlignment(5)
        imgur_valid:Phone_AlphaHover()
        imgur_valid:SetMouseInputEnabled(true)
    
        function imgur_valid:DoClick()
            local self_bg = aphone.Clientside.GetSetting("userbg", {})
            local imgur_id = imgur_entry:GetText()
            local match = string.match(imgur_id or "", "[%a%d]+")

            if !self_bg[imgur_id] and imgur_id and imgur_id != "ID" and match and match == imgur_id then
                table.insert(self_bg, imgur_id)
                aphone.Clientside.SaveSetting("userbg", self_bg)
                addbg(imgur_id)
            end
            bigpnl:DoClick()
        end

        bigpnl:aphone_RemoveCursor()
    end

    local select_scroll_switchmain = vgui.Create("DButton", select_scroll)
    select_scroll_switchmain:Dock(LEFT)
    select_scroll_switchmain:SetWide(main_x / 2)
    select_scroll_switchmain:SetFont(aphone:GetFont("SVG_40"))
    select_scroll_switchmain:SetText("C")
    select_scroll_switchmain:Phone_AlphaHover()
    select_scroll_switchmain:SetPaintBackground(false)
    select_scroll_switchmain:TDLib()
    select_scroll_switchmain:BarHover(aphone:Color("mat_orange"))

    function select_scroll_switchmain:DoClick()
        main_scroll:MoveTo(main_x * 0.07, main_y * 0.24, 0.5, 0, 0.5)
        main_scrollbg:MoveTo(main_x * 1.07, main_y * 0.25, 0.5, 0, 0.5)
    end

    local select_scroll_switchbg = vgui.Create("DButton", select_scroll)
    select_scroll_switchbg:Dock(FILL)
    select_scroll_switchbg:SetFont(aphone:GetFont("SVG_40"))
    select_scroll_switchbg:SetText("Y")
    select_scroll_switchbg:Phone_AlphaHover()
    select_scroll_switchbg:SetPaintBackground(false)
    select_scroll_switchbg:TDLib()
    select_scroll_switchbg:BarHover(aphone:Color("mat_orange"))

    function select_scroll_switchbg:DoClick()
        main_scroll:MoveTo(-main_x * 1.07, main_y * 0.24, 0.5, 0, 0.5)
        main_scrollbg:MoveTo(main_x * 0.07, main_y * 0.25, 0.5, 0, 0.5)
    end

    main:aphone_RemoveCursor()
end

aphone.RegisterApp(APP)






/*

function dial:DoClick()
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
*/