local APP = {}

APP.name = aphone.L("Gallery")
APP.icon = "akulla/aphone/app_gallery.png"

local last_closedpic
local stencil_clr = Color(1, 1, 1, 1)

function APP:Open(main, main_x, main_y, screenmode)
    local clr_white = aphone:Color("White")
    local clr_orange = aphone:Color("Text_Orange")
    local clr_black = aphone:Color("Black3")
    local font_svg = aphone:GetFont("SVG_16")

    local margin = screenmode and main_y * 0.1 or main_x * 0.1
    function main:Paint(w,h)
        surface.SetDrawColor(clr_white)
        surface.DrawRect(0,0,w,h)
    end

    surface.SetFont(aphone:GetFont("Roboto40_700"))
    local _, title_y = surface.GetTextSize(aphone.L("Offline_Pictures"))

    local title = vgui.Create("DLabel", main)
    title:Dock(TOP)
    title:SetContentAlignment(5)
    title:DockMargin(0, screenmode and main_x * 0.03 or main_y * 0.05, 0, 0)
    title:SetTall(title_y)
    title:SetFont(aphone:GetFont("Roboto40_700"))
    title:SetTextColor(clr_black)
    title:SetText(aphone.L("Offline_Pictures"))

    local s = vgui.Create( "DScrollPanel", main )
    s:Dock( FILL )
    s:DockMargin(margin, margin, margin, margin)
    s:aphone_PaintScroll()

    local l = vgui.Create("DIconLayout")
    s:AddItem(l)
    l:SetSpaceX(10)
    l:SetSpaceY(10)
    l:Dock(FILL)

    // 19 = 5*3 margin between pictures
    local perfect_iconsize = ((screenmode and main_y or main_x) - margin * 2 - l:GetSpaceX() * 2 - s:GetVBar():GetWide()) / 3
    local cache_poly = aphone.GUI.RoundedBox(0, 0, perfect_iconsize, perfect_iconsize, 8)

    for k,v in SortedPairs(aphone.Pictures) do
        local but = l:Add("DButton")
        but:SetText("")
        but:SetSize(perfect_iconsize, perfect_iconsize)
        but:TDLib()
        but:ClearPaint()

        local frac = 0
        local last_check = CurTime()
        local is_hovered

        function but:OnCursorEntered()
            is_hovered = true
        end

        function but:OnCursorExited()
            is_hovered = false
        end

        function but:Paint(w, h)
            if frac != 0 or is_hovered then
                if is_hovered then
                    frac = frac + (CurTime() - last_check) * 4
                else
                    frac = frac - (CurTime() - last_check) * 4
                end
                last_check = CurTime()

                // Math.clamp kill my fprofiler I dunno why
                if frac > 1 then
                    frac = 1
                elseif frac < 0 then
                    frac = 0
                end
            end

            aphone.Stencils.Start()
                surface.SetDrawColor(stencil_clr)
                surface.DrawPoly(cache_poly)
            aphone.Stencils.AfterMask(false)
                if frac != 0 then
                    render.SetStencilPassOperation(STENCIL_KEEP)

                    surface.SetMaterial(v)
                    surface.SetDrawColor(color_white)
                    surface.DrawTexturedRect(0, 0, w, h)

                    draw.NoTexture()
                    surface.SetDrawColor(clr_orange.r, clr_orange.g, clr_orange.b, frac * 120)
                    surface.DrawPoly(aphone.GUI.GenerateCircle(w / 2, h / 2, (h / 2 + w / 2) * frac))

                    render.SetStencilReferenceValue(1)
                    render.SetStencilPassOperation(STENCIL_REPLACE)
                    render.SetStencilCompareFunction(STENCIL_ALWAYS)
                        surface.SetDrawColor(stencil_clr)
                        surface.DrawRect(0, 0, w, h)
                else
                    surface.SetMaterial(v)
                    surface.SetDrawColor(color_white)
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            aphone.Stencils.End()
        end

        function but:DoClick()
            local p = vgui.Create("aphone_ShowImage", main)
            p:SetMat(v)
            p:SetDir(string.Replace(v:GetName(), "../data/", "") .. ".jpg")
            p.skipanim = (last_closedpic == v)

            last_closedpic = v

            function p.onclose()
                last_closedpic = nil
            end
        end

        if last_closedpic == v then
            but:DoClick()
        end

        local delete = vgui.Create("DButton", but)
        delete:SetPos(perfect_iconsize * 0.75, perfect_iconsize*0.05)
        delete:SetText("S")
        delete:SetFont(font_svg)
        delete:SetSize(perfect_iconsize*0.2, perfect_iconsize*0.2)
        delete:Phone_AlphaHover()
        delete:SetPaintBackground(false)

        function delete:DoClick()
            but:Remove()
            file.Delete(string.sub(v:GetName() .. ".jpg", 9))
            aphone.Pictures[k] = nil
        end
    end
    main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
    self:Open(main, main_x, main_y, true)
end

function APP:OnClose()
    last_closedpic = nil
end

aphone.RegisterApp(APP)