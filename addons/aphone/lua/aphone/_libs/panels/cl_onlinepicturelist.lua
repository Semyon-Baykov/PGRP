local PANEL = {}

local blue = Color(111, 231, 252)
local stencil_clr = Color(1, 1, 1, 1)

function PANEL:Init()
    local pnl = self
    local main_x, main_y = aphone.MainDerma:GetSize()
    local screenmode = aphone.Horizontal

    self.phone_cachewhite = aphone:Color("White")
    self:SetSize(main_x, main_y)
    self:SetMouseInputEnabled(true)

    local margin = screenmode and main_y * 0.1 or main_x * 0.1

    surface.SetFont(aphone:GetFont("Roboto40_700"))
    local _, title_y = surface.GetTextSize(aphone.L("Online_Pictures"))

    local title = vgui.Create("DLabel", pnl)
    title:Dock(TOP)
    title:DockMargin(0, screenmode and main_x*0.05 or main_y * 0.05, 0, 0)
    title:SetTall(title_y)
    title:SetFont(aphone:GetFont("Roboto40_700"))
    title:SetTextColor(aphone:Color("Black3"))
    title:SetText(aphone.L("Online_Pictures"))
    title:SetContentAlignment(5)
    title:SetMouseInputEnabled(true)

    local top_back = vgui.Create("DLabel", title)
    top_back:Dock(LEFT)
    top_back:SetWide(title_y)
    top_back:SetFont(aphone:GetFont("SVG_30"))
    top_back:SetText("l")
    top_back:SetPaintBackground(false)
    top_back:SetTextColor(aphone:Color("Black48"))
    top_back:SetMouseInputEnabled(true)
    top_back:SetContentAlignment(5)

    function top_back:DoClick()
        pnl:MoveTo(main_x, 0, 0.5, 0, 0.5, function(_, p)
            p:Remove()
        end)
    end

    local s = vgui.Create( "DScrollPanel", self )
    s:Dock( FILL )
    s:DockMargin(margin, margin, margin, margin + aphone.GUI.ScaledSizeY(24))
    s:aphone_PaintScroll()

    local l = s:Add("DIconLayout")
    l:Dock(FILL)
    l:SetSpaceX(10)
    l:SetSpaceY(10)

    // 19 = 5*3 margin between pictures + 4 for the scroll wide
    local perfect_iconsize

    if screenmode then
        perfect_iconsize = (main_y - margin * 2 - l:GetSpaceX() * 2 - 4) / 3
    else
        perfect_iconsize = (main_x - margin * 2 - l:GetSpaceX() * 2 - 4) / 3
    end

    for k,v in ipairs(aphone.GetImgurPics()) do
        local but = l:Add("DButton")
        but:SetText("")
        but:SetSize(perfect_iconsize, perfect_iconsize)
        local cache_roundedbox = aphone.GUI.RoundedBox(0, 0, perfect_iconsize, perfect_iconsize, 8)

        function but:Paint(w, h)
            aphone.Stencils.Start()
                surface.SetDrawColor(stencil_clr)
                surface.DrawPoly(cache_roundedbox)
            aphone.Stencils.AfterMask(false)
                local sub_mat = aphone.GetImgurMat(v)

                if sub_mat then
                    surface.SetMaterial(aphone.GetImgurMat(v))
                    surface.SetDrawColor(self:IsHovered() and blue or color_white)
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            aphone.Stencils.End()
        end

        function but:DoClick()
            local p = vgui.Create("aphone_ShowImage", pnl)
            p:SetMat(aphone.GetImgurMat(v))

            p:SetValid(function()
                pnl:OnSelected(v)
                pnl:Remove()
            end)
        end
    end

    l:Layout()
    self:aphone_RemoveCursor()
end

function PANEL:Paint(w,h)
    surface.SetDrawColor(self.phone_cachewhite)
    surface.DrawRect(0,0,w,h)
end

vgui.Register("aphone_OnlinePictureList", PANEL, "Panel")