local PANEL = {}

local mat_roundedboxsys = Material("akulla/aphone/rounded_boxappsys.png", "smooth 1")

function PANEL:Init()
    self:SetSize(self:GetParent():GetSize())

    local font_app = aphone:GetFont("Roboto18_500")
    local cache_shadow = Color(60, 60, 60, 60)
    local cache_whiteapp = aphone:Color("Text_Apps")
    local cache_stencil = Color(1, 1, 1, 1)

    local margin = self:GetWide() * 0.05
    local self_alt = self
    self:Phone_DrawTop(self:GetSize())

    local layout_app_panel = vgui.Create("DPanel", self)
    layout_app_panel:Dock(FILL)
    layout_app_panel:DockMargin(margin, margin + aphone.GUI.ScaledSizeY(24), margin, margin)
    layout_app_panel:SetPaintBackground(false)

    local app_syspnl = vgui.Create("DPanel", layout_app_panel)
    app_syspnl:Dock(BOTTOM)
    app_syspnl:SetTall(self:GetTall() * 0.13)

    function app_syspnl:Paint(w, h)
        surface.SetDrawColor(cache_shadow)
        surface.SetMaterial(mat_roundedboxsys)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local perfect_iconsize = (self:GetWide() - margin * 4 - aphone.GUI.ScaledSizeX(20)) / 4

    local app_syslayout = vgui.Create("DIconLayout", app_syspnl)
    app_syslayout:Dock(FILL)
    app_syslayout:DockMargin(margin, margin, margin, margin)
    app_syslayout:SetSpaceX(aphone.GUI.ScaledSizeX(5))

    local app_scroll = vgui.Create("DScrollPanel", layout_app_panel)
    app_scroll:Dock(FILL)
    app_scroll:DockMargin(margin, margin, margin, margin)

    local app_layout = vgui.Create("DIconLayout", app_scroll)
    app_layout:Dock(FILL)
    app_layout:SetSpaceY(aphone.GUI.ScaledSizeX(self:GetTall()*0.015))
    app_layout:SetSpaceX(aphone.GUI.ScaledSizeX(5))
    app_layout:aphone_PaintScroll()

    local scaled_size30 = aphone.GUI.ScaledSizeY(30)

    // Let's load big app after normal apps
    local tbl_app = {}
    local tbl_appbig = {}

    for k, v in pairs(aphone.RegisteredApps) do
        table.insert(v.bigshow and tbl_appbig or tbl_app, v)
    end

    table.Add(tbl_app, tbl_appbig)

    for k,v in ipairs(tbl_app) do
        if v.ShowCondition and !v.ShowCondition(LocalPlayer()) then continue end

        local but = vgui.Create("DButton")
        but:SetText(v.Default and "" or v.name)
        but:SetContentAlignment(2)

        if v.bigshow then
            but:SetSize(perfect_iconsize * 2, perfect_iconsize * 2 + scaled_size30)
        else
            but:SetSize(perfect_iconsize, perfect_iconsize + scaled_size30)
        end

        but:SetFont(font_app)
        but:SetTextColor(cache_whiteapp)

        if v.Default then
            app_syslayout:Add(but)
        else
            app_layout:Add(but)
        end

        // CACHE EVERYTHING !
        local frac = 0
        local last_check = CurTime()
        local mat = v.icon
        local is_hovered = false

        // Using IsHovered would be really easier, but when you got 15 buttons calling everytime this function, fprofiler cries
        function but:OnCursorEntered()
            is_hovered = true
        end

        function but:OnCursorExited()
            is_hovered = false
        end

        function but:Paint(w, h)
            if frac != 0 or is_hovered then
                local c = CurTime()

                if is_hovered then
                    frac = frac + (c - last_check) * 4
                else
                    frac = frac - (c - last_check) * 4
                end

                last_check = c

                // Math.clamp kill my fprofiler I dunno why
                if frac > 1 then
                    frac = 1
                elseif frac < 0 then
                    frac = 0
                end
            end

            surface.SetDrawColor(color_white)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(w * 0.05 * frac, h * 0.05 * frac, w * (1 - 0.1 * frac), (h - scaled_size30) * (1 - 0.1 * frac))
        end

        function but:DoClick()
            if v.Complete_Detour then
                v:Open()
                return
            end

            local pos_x, pos_y = self_alt:GetSize()

            local anim_p = vgui.Create("DPanel", self_alt:GetParent())
            anim_p:Dock(FILL)

            local p = vgui.Create("DPanel", anim_p)
            aphone.Horizontal = false
            p:Dock(FILL)

            // Circle open anim
            local anim = anim_p:NewAnimation(0.5, 0, 0.5)

            function anim:Think(_, frac_anim)
                anim_p.frac = frac_anim
            end

            function anim_p:PaintOver()
                render.SetStencilEnable(false)
            end

            function anim_p:OnRemove()
                if aphone.Running_App and aphone.Running_App.OnClose then
                    aphone.Running_App.OnClose()
                end
                aphone.Running_App = nil
                aphone.Force_AllowHorizontal = false
            end

            // End of anim

            local b_menu = vgui.Create("DButton", p)
            b_menu:Dock(BOTTOM)
            b_menu:SetText("")
            b_menu:SetTall(pos_y * 0.02)
            b_menu:DockMargin(pos_x * 0.2, 0, pos_x * 0.2, 0)

            function b_menu:Paint(w, h)
                draw.RoundedBox(h / 4, 0, 0, w, h / 2, color_black)
                draw.RoundedBox(h / 4, 2, 2, w-4, h / 2-4, color_white)
            end

            function b_menu:DoClick()
                if anim_p.phone_gettingremoved then return end
                local anim_back = anim_p:NewAnimation(0.5, 0, 0.5)

                function anim_back:Think(_, frac_anim)
                    anim_p.frac = frac_anim
                end

                if aphone.HorizontalApp then
                    aphone.RequestAnim(1)
                end

                anim_p.phone_gettingremoved = true
            end

            function anim_p:Paint(w,h)
                // I always enable stencil and not just reset it when frac > 1 because others stencil panel ( like avatar ) need the id to be 1 to do his job properly
                render.ClearStencil()
                // Reset
                render.SetStencilWriteMask( 0xFF )
                render.SetStencilTestMask( 0xFF )
                render.SetStencilFailOperation( STENCIL_ZERO )
                render.SetStencilZFailOperation( STENCIL_ZERO )

                // Enable
                render.SetStencilEnable(true)
                render.SetStencilReferenceValue( 1 )
                render.SetStencilCompareFunction( STENCIL_ALWAYS )
                render.SetStencilPassOperation( STENCIL_REPLACE )
                surface.SetDrawColor(cache_stencil)

                if self.phone_gettingremoved and self.frac == 1 then
                    self:Remove()
                    aphone.App_Panel = nil
                    render.SetStencilCompareFunction(STENCIL_NEVER)
                elseif self.frac < 1 then
                    local final_frac = self.phone_gettingremoved and 1 - self.frac or self.frac
                    local r = (w + h) / 2 * final_frac

                    surface.DrawPoly(aphone.GUI.GenerateCircle(w / 2, h / 2, r))
                    render.SetStencilCompareFunction(STENCIL_EQUAL)
                end

                if input.IsMouseDown(MOUSE_MIDDLE) and IsValid(b_menu) then
                    b_menu:DoClick()
                end
            end

            aphone.App_Panel = anim_p
            aphone.Running_App = v
            v:Open(p, pos_x, pos_y)
        end
    end

    self:GetParent():aphone_RemoveCursor()
end

vgui.Register("aphone_AppList", PANEL, "Panel")