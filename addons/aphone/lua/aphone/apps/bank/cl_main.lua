local APP = {}

APP.name = aphone.L("Bank")
APP.icon = "akulla/aphone/app_bank.png"

local lua_grad = Material("akulla/aphone/lua_grad1.png")

function APP:ShowCondition()
	return tobool(aphone.Bank)
end

local functions_table = {
    [1] = {
        name = "Deposit",
        logo = "1",
        max_valuetype = true, // False = Bank amt, true = player amt
    },
    [2] = {
        name = "Withdraw",
        logo = "2",
    },
    [3] = {
        name = "Transfer",
        logo = "0",
        player_param = true,
        transfer = true,
    }
}

function APP:Open(main, main_x, main_y, screenmode)
	// consts
    if BATM and !BATM.GetPersonalAccount() then
        aphone.AddNotif("alert", aphone.L("BATM_Issue"), 5)
        aphone.App_Panel:Remove()
        return
    end

	local font_header = aphone:GetFont("Roboto40")
	local font_mediumheader = aphone:GetFont("MediumHeader")
	local font_svg = aphone:GetFont("SVG_40")
    local font_small = aphone:GetFont("Small")

	local clr_white180 = aphone:Color("Text_White180")
	local clr_white = aphone:Color("Text_White")
    local clr_bg = aphone:Color("Black2")
    local local_ply = LocalPlayer()
    local local_plyname = local_ply:Nick()
    local send_txt = aphone.L("Confirm")

    local boosted_clr = Color(math.Clamp(aphone.Bank.clr.r + 20, 0, 255), math.Clamp(aphone.Bank.clr.g + 20, 0, 255), math.Clamp(aphone.Bank.clr.b + 20, 0, 255))

    function main:Paint(w, h)
        surface.SetDrawColor(clr_bg)
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(lua_grad)
        surface.SetDrawColor(aphone.Bank.clr)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 180)

        draw.SimpleText(aphone.Bank.FormatMoney( local_ply:aphone_getmoney() ), font_mediumheader, w / 2, h * 0.93, clr_white180, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local logo = vgui.Create("DPanel", main)
    logo:Dock(TOP)
    logo:SetTall(main_x / 4)
    logo:DockMargin(0, main_y * 0.08, 0, main_y * 0.04)

    function logo:Paint(w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(aphone.Bank.logo)
        surface.DrawTexturedRect(w / 2 - h / 2, 0, h, h)
    end

    local welcome_txt = aphone.L("Hello")
    surface.SetFont(font_header)

    local txt_h = select(2, surface.GetTextSize(welcome_txt))

    local welcome_text = vgui.Create("DLabel", main)
    welcome_text:Dock(TOP)
    welcome_text:SetText(welcome_txt)
    welcome_text:SetFont(font_header)
    welcome_text:SetTall(txt_h)
    welcome_text:SetTextColor(clr_white)
    welcome_text:SetContentAlignment(5)

    local name_text = vgui.Create("DLabel", main)
    name_text:Dock(TOP)
    name_text:SetText(local_plyname)
    name_text:SetFont(font_header)
    name_text:SetTall(select(2, surface.GetTextSize(local_plyname)))
    name_text:SetContentAlignment(5)
    name_text:SetTextColor(clr_white180)

	main:Phone_DrawTop(main_x, main_y)

    local main_scroll = vgui.Create("DScrollPanel", main)
    main_scroll:Dock(FILL)
    main_scroll:aphone_PaintScroll()
    main_scroll:DockMargin(0, main_y * 0.025, 0, main_y * 0.025)

    for k, v in pairs(functions_table) do
        if aphone.bank_onlytransfer and !v.transfer then continue end

        local sub_pnl = main_scroll:Add("DPanel")
        sub_pnl:SetPaintBackground(false)
        sub_pnl:Dock(TOP)
        sub_pnl:SetTall(txt_h * 1.5)
        sub_pnl:DockMargin(0, main_y * 0.005, 0, main_y * 0.005)

        local sub_pnltop = vgui.Create("DButton", sub_pnl)
        sub_pnltop:Dock(TOP)
        sub_pnltop:SetTall(txt_h * 1.5)
        sub_pnltop:SetPaintBackground(false)
        sub_pnltop:TDLib()
        sub_pnltop:FadeHover(aphone.Bank.clr, 3)
        sub_pnltop:SetText("")
        sub_pnltop:SetIsToggle(true)

        function sub_pnltop:OnToggled(opening)
            if opening then
                sub_pnl:SetTall(txt_h * (v.player_param and 5 or 3))
            else
                sub_pnl:SetTall(txt_h * 1.5)
            end
        end

        local icon = vgui.Create("DLabel", sub_pnltop)
        icon:Dock(LEFT)
        icon:DockMargin(txt_h, 0, txt_h, 0)
        icon:SetWide(txt_h)
        icon:SetText(v.logo)
        icon:SetTextColor(color_white)
        icon:SetFont(font_svg)
        icon:SetContentAlignment(5)

        local title = vgui.Create("DLabel", sub_pnltop)
        title:Dock(FILL)
        title:SetText(v.name)
        title:SetTextColor(clr_white)
        title:SetFont(font_mediumheader)

        local sub_option = vgui.Create("DPanel", sub_pnl)
        sub_option:Dock(TOP)
        sub_option:SetTall(txt_h * (v.player_param and 3.5 or 1.5))
        sub_option:SetPaintBackground(false)

        local p = vgui.Create("DSlider", sub_option)
        p:Dock(TOP)
        p:SetSlideX(0)
        p:DockMargin(aphone.GUI.ScaledSize(main_x * 0.1, 0, main_x * 0.1, 0))

        function p:Paint(w, h)
            draw.RoundedBox(4, 0, h / 2-4, w, 8, clr_white180)
            draw.RoundedBox(4, 0, h / 2-4, w * self:GetSlideX(), 8, boosted_clr)
        end
        function p.Knob:Paint(w, h) end

        local textentry

        if v.player_param then
            textentry = vgui.Create("DLabel", sub_option)
            textentry:Dock(TOP)
            textentry:SetTall(txt_h)
            textentry:SetText(aphone.L("PutName"))
            textentry:SetFont(font_small)
            textentry:SetTextColor(clr_white)
            textentry:DockMargin(main_x * 0.1, 0, main_x * 0.1, 0)
            textentry:SetMouseInputEnabled(true)
            textentry:SetContentAlignment(5)

            function textentry:textEnd(text_pnl)
                for k, v in ipairs(player.GetHumans()) do
                    if v:Nick() == text_pnl then
                        self:SetText(text_pnl)
                        self.targetentity = v
                        return
                    end
                end

                self:SetText(aphone.L("PlayerNotFound"))
            end

            function textentry:DoClick()
                self:Phone_AskTextEntry(self:GetText(), 32)
            end
        end

        local p_amt = vgui.Create("DLabel", sub_option)
        p_amt:SetText(send_txt .. " - " .. aphone.Bank.FormatMoney(0))
        p_amt:SetFont(font_small)
        p_amt:SetTextColor(clr_white)
        p_amt:SetTall(txt_h)
        p_amt:Dock(TOP)
        p_amt:SetContentAlignment(5)
        p_amt:SetMouseInputEnabled(true)

        function p_amt:DoClick()
            if !textentry or IsValid(textentry.targetentity) then
                net.Start("aphone_bank")
                    net.WriteUInt(k, 4)
                    net.WriteUInt(math.Round(p:GetSlideX() * (v.max_valuetype and aphone.Gamemode.GetMoney(local_ply) or local_ply:aphone_getmoney()) ), 32)

                    if IsValid(textentry) then
                        net.WriteEntity(textentry.targetentity)
                    end
                net.SendToServer()
            end
        end

        function p:Think()
            self.lastrefresh = self.lastrefresh or CurTime()
            if self:IsEditing() or self.lastrefresh < CurTime() then
                local max_amt = v.max_valuetype and aphone.Gamemode.GetMoney(local_ply) or local_ply:aphone_getmoney()
                p_amt:SetText(send_txt .. " - " .. aphone.Bank.FormatMoney( math.Round(self:GetSlideX() * max_amt )))
                self.lastrefresh = CurTime() + 0.33
            end
        end
    end

	main:aphone_RemoveCursor()
end

aphone.RegisterApp(APP)