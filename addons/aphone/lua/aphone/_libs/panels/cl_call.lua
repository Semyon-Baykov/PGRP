local PANEL = {}

local green = Color(46, 204, 113)
local stencil_writemask = render.SetStencilWriteMask
local stencil_testmask = render.SetStencilTestMask
local stencil_id = render.SetStencilReferenceValue
local stencil_fail = render.SetStencilFailOperation
local stencil_zfail = render.SetStencilZFailOperation
local stencil_compare = render.SetStencilCompareFunction
local stencil_pass = render.SetStencilPassOperation

function PANEL:Init()
    local font_svg45 = aphone:GetFont("SVG_45")

    local clr_white = aphone:Color("Text_White")
    local clr_white120 = aphone:Color("Text_White120")
    local clr_white60 = aphone:Color("Text_White60")
    local clr_transparent = Color(1, 1, 1, 1)

    local main_x, main_y = self:GetParent():GetSize()

    if main_x > main_y then
        aphone.RequestAnim(1)
        self:Remove()
        return
    end

    self:SetSize(main_x, main_y)
    self.last_dring = 0

    self:GetParent():SetMouseInputEnabled(false)
    self:SetMouseInputEnabled(true)

    if aphone.Call.Infos.target then
        self.backgroundavatar = vgui.Create("AvatarImage", self)
        self.backgroundavatar:SetSize(main_y, main_y)
        self.backgroundavatar:SetPos(main_x/2 - main_y/2, 0)
        self.backgroundavatar:SetPlayer(aphone.Call.Infos.target, 184)
        self.backgroundavatar:SetPaintedManually(true)
    end

    local circle
    local avatar_outline = vgui.Create("DPanel", self)
    avatar_outline:SetSize(main_x*0.8, main_x*0.8)
    avatar_outline:SetPos(main_x*0.4, -main_x*0.1)
    avatar_outline:SetMouseInputEnabled(false)
    avatar_outline.colorbg = green

    function avatar_outline:Paint(w, h)
        if !circle then
            circle = aphone.GUI.GenerateCircle(w / 2, h / 2, w / 2)
        end

        if !aphone.Call.Infos then return end
        draw.NoTexture()

        if aphone.Call.Infos.target then
            surface.SetDrawColor(self.colorbg or green)
            surface.DrawPoly(circle)
        else
            render.ClearStencil()
            render.SetStencilEnable(true)
            stencil_writemask( 0xFF )
            stencil_testmask( 0xFF )
            stencil_fail( STENCIL_KEEP )
            stencil_zfail( STENCIL_KEEP )
            stencil_id( 1 )

            // Stencil
            stencil_compare(STENCIL_ALWAYS)
            stencil_pass(STENCIL_REPLACE)
                draw.NoTexture()
                surface.SetDrawColor(clr_transparent)
                surface.DrawPoly(circle)
            stencil_id(1)
            stencil_pass(STENCIL_KEEP)
            stencil_compare(STENCIL_EQUAL)
                surface.SetMaterial(aphone.SpecialNumbers[aphone.SpecialCalls[aphone.Call.Infos.special_id].name].icon)
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(0, 0, w, h)
            render.SetStencilEnable(false)
        end
    end

    if aphone.Call.Infos.target then
        local player_avatar = vgui.Create("aphone_CircleAvatar", avatar_outline)
        player_avatar:Dock(FILL)
        player_avatar:DockMargin(aphone.GUI.ScaledSize(7, 7, 7, 7))
        player_avatar.ignorestencil = true
        player_avatar:SetPlayer(aphone.Call.Infos.target, 184)
    end
    self.avatar_outline = avatar_outline

    local player_calling = vgui.Create("DLabel", self)
    player_calling:Dock(TOP)
    player_calling:SetFont(aphone:GetFont("MediumHeader"))
    player_calling:SetText("")
    player_calling:SetContentAlignment(4)
    player_calling:DockMargin(main_x*0.08, main_y*0.45, 0, 0)
    player_calling:SetTextColor(aphone:Color("Text_White180"))
    player_calling:SetMouseInputEnabled(true)

    function player_calling:Think()
        if aphone.Call.Infos and aphone.Call.Infos.pending and aphone.Call.Infos.is_caller then
            player_calling:SetText(aphone.L("Calling") .. string.rep( ".", CurTime() % 3 ))
        else
            player_calling:SetText("")
            player_calling.Think = nil
        end
    end
    self.player_calling = player_calling

    surface.SetFont(player_calling:GetFont())
    player_calling:SetTall(select(2, surface.GetTextSize(player_calling:GetText())))

    surface.SetFont(aphone:GetFont("Roboto40"))

    local player_num = vgui.Create("DLabel", self)
    player_num:Dock(TOP)

    player_num:SetText(aphone.Call.Infos.target and aphone.Call.Infos.target:aphone_GetNumber() or "")
    player_num:SetFont(aphone:GetFont("Roboto40"))
    player_num:SetContentAlignment(4)
    player_num:DockMargin(main_x*0.08, 0, 0, 0)
    player_num:SetTextColor(clr_white60)
    self.player_num = player_num

    surface.SetFont(player_num:GetFont())
    player_num:SetTall(select(2, surface.GetTextSize(player_num:GetText())))

    local player_name = vgui.Create("DLabel", self)
    player_name:Dock(TOP)
    player_name:SetText(aphone.Call.Infos.target and aphone.GetName(aphone.Call.Infos.target) or aphone.Call.Infos.is_caller and aphone.SpecialCalls[aphone.Call.Infos.special_id].name or "Unknown")
    player_name:SetFont(aphone:GetFont("Roboto60"))
    player_name:SetContentAlignment(4)
    player_name:DockMargin(main_x*0.08, 0, 0, 0)
    player_name:SetTextColor(clr_white)
    self.player_name = player_name

    surface.SetFont(player_name:GetFont())
    player_name:SetTall(select(2, surface.GetTextSize(player_name:GetText())))

    local buttons = vgui.Create("DPanel", self)
    buttons:Dock(BOTTOM)
    buttons:DockMargin(0, 0, 0, main_y * 0.1)
    buttons:SetTall(main_y * 0.1)
    buttons:SetPaintBackground(false)

    local ref = vgui.Create("DButton", buttons)
    ref:SetPos(((aphone.Call.Infos.pending and !aphone.Call.Infos.is_caller) and main_x * 0.25 or main_x * 0.50) - buttons:GetTall() / 2, 0)
    ref:SetSize(buttons:GetTall(), buttons:GetTall())
    ref:SetText("")
    ref:TDLib()
    ref:ClearPaint()
    ref:Circle(aphone:Color("Black3"))
    ref:CircleFadeHover(aphone:Color("mat_red"))

    ref:On("PaintOver", function(self, w, h)
        draw.SimpleText("4", font_svg45, w / 2, h / 2, clr_white, 1, 1)
    end)

    ref:On("DoClick", function()
        net.Start("aphone_Phone")
            net.WriteUInt(3, 4)
        net.SendToServer()
    end)
    self.button_refuse = ref

    if aphone.Call.Infos.pending and !aphone.Call.Infos.is_caller then
        self.button_accept = vgui.Create("DButton", buttons)
        self.button_accept:SetPos(main_x * 0.75 - buttons:GetTall() / 2, 0)
        self.button_accept:SetSize(buttons:GetTall(), buttons:GetTall())
        self.button_accept:SetText("")
        self.button_accept:TDLib()
        self.button_accept:ClearPaint()
        self.button_accept:Circle(aphone:Color("Black3"))
        self.button_accept:CircleFadeHover(green)

        function self.button_accept:PaintOver(w, h)
            draw.SimpleText("o", aphone:GetFont("SVG_40"), w / 2, h / 2, clr_white, 1, 1)
        end

        function self.button_accept:DoClick()
            net.Start("aphone_Phone")
                net.WriteUInt(2, 4)
            net.SendToServer()
        end

        self.button_accept:aphone_RemoveCursor()
    end

    surface.SetFont(aphone:GetFont("SVG_76"))
    local fc_x, fc_y = surface.GetTextSize("E")

    local fc = vgui.Create("DButton", self)
    fc:SetPos(main_x * 0.1, main_x * 0.1)
    fc:SetSize(main_x * 0.1, main_x * 0.1)
    fc:SetFont(aphone:GetFont("SVG_40"))
    fc:SetText("E")
    fc:SetPaintBackground(false)
    fc:SetEnabled(!aphone.Call.Infos.pending)
    fc:SetAlpha(!aphone.Call.Infos.pending and 255 or 0)
    fc:SetTextColor(aphone.Call.Infos.facetime and clr_white or clr_white120)

    function fc:DoClick()
        aphone.Call.Infos.facetime = !aphone.Call.Infos.facetime
        self:SetTextColor(aphone.Call.Infos.facetime and clr_white or clr_white120)

        net.Start("aphone_Phone")
            net.WriteUInt(4, 4)
        net.SendToServer()
    end

    local msg = vgui.Create("DButton", self)
    msg:SetPos(main_x * 0.1, main_x * 0.2)
    msg:SetSize(main_x * 0.1, main_x * 0.1)
    msg:SetFont(aphone:GetFont("SVG_40"))
    msg:SetText("n")
    msg:SetPaintBackground(false)
    msg:SetEnabled(!aphone.Call.Infos.pending)
    msg:SetAlpha(!aphone.Call.Infos.pending and 255 or 0)
    msg:Phone_AlphaHover()

    function msg:DoClick()
        local msg_pnl = vgui.Create("aphone_Msg", self:GetParent())
        msg_pnl:InitPly(aphone.Call.Infos.target:aphone_GetID())
    end

    self.msg = msg
    self.fc = fc

    aphone.Call.Panel = self
    self:aphone_RemoveCursor()
end

function PANEL:Accepted()
    if IsValid(self.button_accept) then
        self.button_accept:Remove()
        self.button_refuse:MoveTo(self:GetWide() * 0.5 - self.button_refuse:GetParent():GetTall() / 2, 0, 0.5, 0, 0.5)
    end

    self.fc:SetEnabled(true)
    self.fc:SetAlpha(0)
    self.fc:AlphaTo(255, 0.5, 0)

    self.msg:SetEnabled(true)
    self.msg:SetAlpha(0)
    self.msg:AlphaTo(255, 0.5, 0)
end

function PANEL:OnRemove()
    self:GetParent():SetMouseInputEnabled(true)
    self:SetMouseInputEnabled(false)
    aphone.RenderView_End("phoneCamSelf")
    aphone.RenderView_End("phoneCam")
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(aphone.GUI.GetBackground())
    surface.DrawTexturedRect(0, 0, w, h)

    if self.backgroundavatar then
        self.backgroundavatar:PaintManual()
    end

    aphone.blur_rt(8 * (h/w), 8, 2)

    if aphone.Call.Infos.target_facetime and IsValid(aphone.Call.Infos.target) then
        // Better use power of 2 numbers for RenderTarget
        local localply = aphone.Call.Infos.target
        local ang = localply:EyeAngles()
        local pos = localply:EyePos()
        local wep = localply:GetActiveWeapon()
        local is_out = IsValid(wep) and wep:GetClass() == "aphone"

        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, w, h)

        if is_out then
            local atta = wep:GetAttachment(1)
            local tr = util.TraceLine({
                start = pos,
                endpos = atta.Pos + atta.Ang:Forward() * 5,
                collisiongroup = COLLISION_GROUP_WORLD,
            })

            if !tr.Hit then
                aphone.RenderView_Start("phoneCam", {
                    origin = tr.HitPos,
                    angles = ang,
                    fov = 90,
                    x = 0, y = 0,
                    w = 1024, h = 1024,
                })

                surface.SetMaterial(aphone.RenderView_RequestTexture("phoneCam"))
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(w / 2 - h / 2, 0, h, h)
            end
        end
    else
        aphone.RenderView_End("phoneCam")
    end

    if aphone.Call.Infos.facetime then
        // Better use power of 2 numbers for RenderTarget
        local localply = LocalPlayer()
        local ang = localply:EyeAngles()
        local pos = EyePos()

        local tr = util.TraceLine({
            start = EyePos(),
            endpos = pos + ang:Forward() * 10,
            collisiongroup = COLLISION_GROUP_WORLD,
        })

        aphone.RenderView_Start("phoneCamSelf", {
            origin = tr.HitPos,
            angles = ang,
            fov = 90,
            x = 0, y = 0,
            w = 1024, h = 1024,
        })

        surface.SetDrawColor(color_white)
        surface.DrawRect(w * 0.1-2, h - w/4 - w*0.1-2, w/4+4, w/4+4)

        surface.SetMaterial(aphone.RenderView_RequestTexture("phoneCamSelf"))
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(w * 0.1, h - w/4 - w*0.1, w/4, w/4)
    else
        aphone.RenderView_End("phoneCamSelf")
    end
end

local old_ratio = 0
function PANEL:Think()
    if !aphone.Call.Infos then
        timer.Remove("aphone_DringSound")
        self:Remove()
    elseif self.player_calling:IsVisible() then
        if self.avatar_outline then
            self.avatar_outline:SetVisible(!aphone.Call.Infos.target_facetime)
            local ratio = 0

            if IsValid(aphone.Call.Infos.target) then
                ratio = aphone.Call.Infos.target:VoiceVolume()*2
            end

            if old_ratio > ratio and old_ratio > 0 then
                old_ratio = old_ratio - 0.03
            else
                old_ratio = ratio
            end

            self.avatar_outline.colorbg.r = Lerp(old_ratio, 46, 52)
            self.avatar_outline.colorbg.g = Lerp(old_ratio, 204, 152)
            self.avatar_outline.colorbg.b = Lerp(old_ratio, 113, 219)
        end

        self.player_calling:SetVisible(!aphone.Call.Infos.target_facetime)
        self.player_name:SetVisible(!aphone.Call.Infos.target_facetime)
        self.player_num:SetVisible(!aphone.Call.Infos.target_facetime)
    end
end

vgui.Register("aphone_Call", PANEL)