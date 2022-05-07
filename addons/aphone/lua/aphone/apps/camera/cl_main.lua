local APP = {}

APP.name = aphone.L("Camera")
APP.icon = "akulla/aphone/app_camera.png"
APP.Default = true

// Windows don't like folders with ':' in their names
local dir = "aphone/" .. string.Replace(game.GetIPAddress(), ":", "_") .. "/"

local function reset_rt()
    aphone.RenderView_End("camera2_vertical")
    aphone.RenderView_End("camera_vertical")
    aphone.RenderView_End("camera2_horizontal")
    aphone.RenderView_End("camera_horizontal")
end

function APP:Open(main, main_x, main_y, horizontal)
    reset_rt()
    local last_screen = 0
    local zoom = 1
    local smileys = false
    local font_sf40 = aphone:GetFont("Roboto40")
    local font_svg40 = aphone:GetFont("SVG_40")
    local font_svg60 = aphone:GetFont("SVG_60")
    local selfie_mode = false
    local statename = aphone:Is2D() and "2d" or "3d"

    function main:OnMouseWheeled(num)
        zoom = (num > 0 and 2 or 1)
    end

    function main:Paint(w,h)
        local ang = LocalPlayer():EyeAngles()
        local pos = selfie_mode and aphone.WM_Pos or EyePos()

        if selfie_mode then
            // Perfect inverting angle
            ang = (ang:Forward() * -1):Angle()
        end

        local tr

        if selfie_mode then
            tr = util.TraceLine({
                start = pos + ang:Forward(),
                endpos = pos + ang:Forward() * 10 + ang:Up() * 3,
                collisiongroup = COLLISION_GROUP_WORLD,
            })
        else
            tr = util.TraceLine({
                start = EyePos(),
                endpos = pos + ang:Forward() * ((zoom-1) * 400 + 10),
                collisiongroup = COLLISION_GROUP_WORLD,
            })
        end

        if tr.Hit and zoom != 1 then
            zoom = zoom - 1
            tr.HitPos = pos
        end

        local mat
        local n = "camera" .. (horizontal and "2_" or "_") .. statename

        aphone.RenderView_Start(n, {
            origin = tr.HitPos,
            angles = ang,
            fov = 90,
            x = 0, y = 0,
            w = w, h = h,
            drawviewmodel = selfie_mode,
            Smileys = smileys,
        })
        mat = aphone.RenderView_RequestTexture(n)

        if mat then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        draw.SimpleText( zoom .. "x", font_sf40, w * 0.75, h * 0.1, color_white)
    end

    function main:PaintOver(w, h)
        local t = CurTime() - last_screen

        if t < 0.5 then
            surface.SetDrawColor(255, 255, 255, 255 * (1 - t * 2))
            surface.DrawRect(0, 0, w, h)
        end
    end

    local but = vgui.Create("DButton", main)
    but:Dock(BOTTOM)
    but:SetTall(main_x * 0.15)
    but:DockMargin(main_x * 0.425, 0, main_x * 0.425, !horizontal and main_x * 0.1 or 0)
    but:SetText("")

    function but:DoClick()
        local dir_final = dir .. os.date( "%Y-%m-%d-%H-%M-%S" , os.time() )
        aphone.RenderView_RequestScreenshot(horizontal and "camera2_" .. statename or "camera_" .. statename, dir_final, true)
        last_screen = CurTime()
    end

    function but:Paint(w, h)
        self.aphone_amt = self.aphone_amt or 0
        self.aphone_lastcheck = self.aphone_lastcheck or CurTime()

        local dif = (CurTime() - self.aphone_lastcheck) * 4
        self.aphone_amt = math.Clamp(self.aphone_amt + (self.Hovered and dif or -dif), 0, 1)
        self.aphone_lastcheck = CurTime()

        local r = Lerp(self.aphone_amt, 200, 255)
        local gb = Lerp(self.aphone_amt, 200, 100)

        // Circle, with font because it's prettier
        draw.SimpleText("d", font_svg60, w / 2, h / 2, color_white, 1, 1)
        draw.SimpleText("d", font_svg40, w / 2, h / 2, Color(r, gb, gb), 1, 1)
    end

    surface.SetFont(font_svg40)

    local rotate = main:Add("DLabel")
    rotate:SetPos(main_x * 0.75, horizontal and main_y*0.2 or main_y*0.15)
    rotate:SetText("j")
    rotate:SetFont(font_svg40)
    rotate:Phone_AlphaHover()
    rotate:SetSize(surface.GetTextSize("j"))
    rotate:SetMouseInputEnabled(true)

    function rotate:DoClick()
        selfie_mode = !selfie_mode
    end

    local smileybut = main:Add("DLabel")
    smileybut:SetPos(main_x * 0.75, (horizontal and main_y*0.2 or main_y*0.15) + rotate:GetTall())
    smileybut:SetText("6")
    smileybut:SetFont(font_svg40)
    smileybut:Phone_AlphaHover()
    smileybut:SetSize(surface.GetTextSize("j"))
    smileybut:SetMouseInputEnabled(true)

    function smileybut:DoClick()
        smileys = !smileys
    end

    main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
    reset_rt()
    APP:Open(main, main_x, main_y, true)
end

function APP:OnClose()
    reset_rt()
end

aphone.RegisterApp(APP)