local PANEL = {};

function PANEL:Init()
    local w, h = self:GetParent():GetSize()

    local clr_black40 = aphone:Color("Black40_120")
    local font_svg30 = aphone:GetFont("SVG_30")
    local clr_white120 = aphone:Color("Text_White120")

    self:SetMouseInputEnabled(true)
    local pnl = self

    if !self.skipanim then
        self:SetSize(0, 0)
        self:SetPos(w / 2, h / 2)

        self:SizeTo(w, h, 0.33, 0, 0.5)
        self:MoveTo(0, 0, 0.33, 0, 0.5)
    else
        self:SetSize(w, h)
    end

    surface.SetFont(font_svg30)
    local _, text_y = surface.GetTextSize("l")

    local header = vgui.Create("DPanel", self)
    header:Dock(TOP)
    header:SetTall(text_y * 1.5)

    function header:Paint(w, h)
        surface.SetDrawColor(clr_black40)
        surface.DrawRect(0, 0, w, h)
    end

    local header_quit = vgui.Create("DButton", header)
    header_quit:Dock(LEFT)
    header_quit:SetWide(text_y)
    header_quit:SetFont(font_svg30)
    header_quit:SetText("l")
    header_quit:SetPaintBackground(false)
    header_quit:SetTextColor(clr_white120)
    header_quit:DockMargin(text_y / 2, 0, 0, 0)
    header_quit:Phone_AlphaHover()

    function header_quit:DoClick()
        pnl:CloseAnimation()

        if pnl.onclose then
            pnl.onclose()
        end
    end

    self.header_upload = vgui.Create("DButton", header)
    self.header_upload:Dock(LEFT)
    self.header_upload:SetWide(text_y)
    self.header_upload:SetFont(font_svg30)
    self.header_upload:SetText("k")
    self.header_upload:SetPaintBackground(false)
    self.header_upload:SetTextColor(clr_white120)
    self.header_upload:SetEnabled(false)
    self.header_upload:SetAlpha(0)
    self.header_upload:Phone_AlphaHover()

    function self.header_upload:DoClick()
        if !aphone.ImgurUploading then
            aphone.ImgurUploading = true

            if !pnl.dir then
                print("[APhone] Issue in imageshow, please report this in a gmodstore ticket, there must be a error on top of this, please report this too")
            end

            aphone.SendImgur(pnl.dir)

            self.waitend = true
        end
    end

    function self.header_upload:Think()
        if self.waitend and !aphone.ImgurUploading then
            pnl:CloseAnimation()
            self.Think = nil
        end
    end
    
    self:aphone_RemoveCursor()
end

function PANEL:SetDir(dir)
    self.dir = dir
    self.header_upload:SetEnabled(true)
    self.header_upload:SetAlpha(255)
end

function PANEL:CloseAnimation()
    self:SizeTo(0, 0, 0.33, 0, 0.5)
    self:MoveTo(self:GetWide() / 2, self:GetTall() / 2, 0.33, 0, 0.5, function(_, p)
        p:Remove()
    end)
end

function PANEL:SetMat(mat)
    self.mat = mat

    local w = mat:Width()
    local h = mat:Height()

    self.horizontal_pic = h < w
end

function PANEL:Paint(w, h)
    if self.mat then
        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(self.mat)
        surface.SetDrawColor(color_white)

        local horizontal = w > h

        if self.horizontal_pic and !horizontal then
            surface.DrawTexturedRect(0, h/2 - (w*(w/h))/2, w, w*(w/h))
        elseif !self.horizontal_pic and horizontal then
            surface.DrawTexturedRect(w/2 - (h*(h/w))/2, 0, h*(h/w), h)
        else
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end
end

local black_180 = Color(40, 40, 40, 180)
local stencil_clr = Color(1, 1, 1, 1)
function PANEL:PaintOver(w, h)
    if aphone.ImgurUploading then
        surface.SetDrawColor(black_180)
        surface.DrawRect(0, 0, w, h)

        if !self.circle1 then
            self.circle1 = aphone.GUI.GenerateCircle(w / 2, h / 2, (aphone.Horizontal and h or w) / 4)
            self.circle2 = aphone.GUI.GenerateCircle(w / 2, h / 2, (aphone.Horizontal and h or w) / 4-6)
        end

        local rad = CurTime() * 6

        aphone.Stencils.Start()
            surface.SetDrawColor(stencil_clr)
            surface.DrawPoly(self.circle1)
        aphone.Stencils.AfterMask(false)
            surface.DrawPoly(self.circle2)

            surface.SetDrawColor(aphone:Color("GPS_Line"))

            local p_size = (aphone.Horizontal and h or w) 
            draw.SimpleText("d", aphone:GetFont("SVG_60"), math.cos( rad ) * (p_size / 4) + w / 2, math.sin(rad) * (p_size / 4) + h / 2, aphone:Color("GPS_Line"), 1, 1)
        aphone.Stencils.End()
    end
end

function PANEL:SetValid(func)
    local valid_label = vgui.Create("DLabel", self)
    valid_label:Dock(BOTTOM)
    valid_label:SetTall(aphone.MainDerma:GetTall()*0.2)
    valid_label:SetText("r")
    valid_label:Phone_AlphaHover()
    valid_label:SetFont(aphone:GetFont("SVG_60"))
    valid_label:SetContentAlignment(8)
    valid_label:SetMouseInputEnabled(true)

    function valid_label:DoClick()
        func()
    end

    valid_label:aphone_RemoveCursor()
end

vgui.Register("aphone_ShowImage", PANEL)