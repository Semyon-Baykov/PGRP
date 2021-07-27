local APP = {}

APP.name = "DodgeIt!"
APP.icon = "akulla/aphone/app_dodgeit.png"

local clr = {
    Color(29, 209, 161),
    Color(72, 219, 251),
    Color(255, 107, 107),
    Color(255, 159, 67),
    Color(254, 202, 87),
    Color(255, 159, 243),
    Color(95, 39, 205),
    Color(200, 214, 229),
}

function APP:Open(main, main_x, main_y, horizontal)
    local color_black2 = aphone:Color("Black2")
    local color_white180 = aphone:Color("Text_White180")
    local round_time = CurTime()
    local Roboto60 = aphone:GetFont("Roboto60")
    local svg_30 = aphone:GetFont("SVG_30")

    local balls = {}

    function main:Paint(w, h)
        surface.SetDrawColor(color_black2)
        surface.DrawRect(0,0,w,h)

        draw.SimpleText(math.Round(CurTime() - round_time) .. "s", Roboto60, w / 2, h / 5, color_white180, 1, 1)
    end

    local s = main_x < main_y and main_x * 0.1 or main_y * 0.1

    local end_game = vgui.Create("DPanel", main)
    end_game:Dock(FILL)
    end_game:SetVisible(false)
    end_game:SetAlpha(0)

    function end_game:Paint(w, h)
        surface.SetDrawColor(color_black2)
        surface.DrawRect(0,0,w,h)

        draw.SimpleText(end_game.win_time .. "s", Roboto60, w / 2, h / 5, color_white180, 1, 1)
    end

    local restart = vgui.Create("DLabel", end_game)
    restart:SetFont(Roboto60)
    restart:SetContentAlignment(5)
    restart:Dock(FILL)
    restart:SetText(aphone.L("Restart"))
    restart:SetTextColor(color_white180)
    restart:Phone_AlphaHover()
    restart:SetMouseInputEnabled(true)

    function restart:DoClick()
        round_time = CurTime()
        timer.UnPause("APhone_DodgeIt")
        timer.Adjust("APhone_DodgeIt", 1)

        end_game:AlphaTo(0, 0.25, 0, function()
            end_game:SetVisible(false)
        end)
    end

    timer.Create("APhone_DodgeIt", 1, 0, function()
        local dir = math.random(1, 4)
        local move_x, move_y
        local c = vgui.Create("DPanel", main)

        c:SetSize(s, s)

        if dir == 1 then
            local val = math.random(0, main_y)
            c:SetPos(0, val)
            move_x, move_y = main_x + s, val
        elseif dir == 2 then
            local val = math.random(0, main_y)
            c:SetPos(main_x, val)
            move_x, move_y = -s, val
        elseif dir == 3 then
            local val = math.random(0, main_x)
            c:SetPos(val, 0)
            move_x = val
            move_y = main_y + s
        elseif dir == 4 then
            local val = math.random(0, main_x)
            c:SetPos(val, main_y)
            move_x, move_y = val, -s
        end

        c:MoveTo(move_x, move_y, 1, 0, 1, function()
            c:Remove()
            table.RemoveByValue(balls, c)
        end)

        local random_clr = clr[ math.random( #clr ) ]

        function c:Paint(w, h)
            draw.SimpleText("d", svg_30, w / 2, h / 2, random_clr, 1, 1)

            // He hover a ball ? then he lost
            // Cursor not visible ? Then he is cheating, make him lose
            if self:IsHovered() and !end_game:IsVisible() then
                end_game.win_time = math.Round(CurTime() - round_time)

                end_game:SetVisible(true)
                end_game:AlphaTo(255, 0.5, 0)
                timer.Pause( "APhone_DodgeIt" )
            end
        end

        local time = timer.TimeLeft("APhone_DodgeIt") - 0.03
        time = (time >= 0.20) and time or 0.20

        timer.Adjust("APhone_DodgeIt", time)

        table.insert(balls, c)
    end)

    function main:Think()
        if !aphone.cursor_visible and !end_game:IsVisible() then
            end_game.win_time = math.Round(CurTime() - round_time)

            end_game:SetVisible(true)
            end_game:AlphaTo(255, 0.5, 0)
            timer.Pause( "APhone_DodgeIt" )
        end
    end

    main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
    APP:Open(main, main_x, main_y, true)
end

aphone.RegisterApp(APP)