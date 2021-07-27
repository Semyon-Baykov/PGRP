local APP = {}

APP.name = aphone.L("Radio")
APP.icon = "akulla/aphone/app_radio.png"
APP.Default = false

local radio_id = 0
aphone.RadioEnts = aphone.RadioEnts or {}
local radio_owner = {}

// We instantly load radios, That's a way to avoid to wait 5min the radio to play
// I prefer getting 1 radio playing each time, I think it would be a issue if 40 people stream the same link or things like that. So I prefer found the closest player with each radio and let play it.
local function create_radios(force)
    if force or table.IsEmpty(aphone.RadioEnts) then
        for k,v in ipairs(aphone.RadioList) do
            if v.logo then
                aphone.GUI.WebPicture(v.name, v.logo)
            end

            // Why noblock ? I don't know either, but with this flag, my radio don't stop randomly
            sound.PlayURL(v.url, "noplay noblock", function(station)
                if IsValid(station) then
                    station:SetVolume(0)
                    station:Play()
                    aphone.RadioEnts[k] = station

                    if force and radio_id == k then
                        aphone.My_Radio = station
                    end
                end
            end)
        end
    end
end
create_radios()

hook.Add("PostCleanupMap", "APhone_RecreateRadios", function()
    for k, v in pairs(aphone.RadioEnts) do
        if IsValid(v) then
            v:Stop()
            aphone.RadioEnts[k] = nil
        end
    end

    create_radios(true)
end)

// SetPos, check volume change, get good player, refresh on stopsound
local last_checkradios = CurTime()

hook.Add("Think", "aphone_RadioRefresh", function()
    if last_checkradios + 1 < CurTime() then
        for k, v in pairs(aphone.RadioEnts) do
            if !IsValid(v) or ((v.bestcurtime or CurTime()) < 10 and CurTime() > 20) then
                sound.PlayURL(aphone.RadioList[k].url, "3d noplay noblock", function(station)
                    if IsValid(station) then
                        station:SetVolume(0)
                        station:Play()
                        aphone.RadioEnts[k] = station

                        if force and radio_id == k then
                            aphone.My_Radio = station
                        end
                        v.bestcurtime = CurTime()
                    end
                end)
            end
        end
        last_checkradios = CurTime()
    end

    local lp = LocalPlayer()
    local only_mine = aphone:GetParameters("Core", "OnlyMyRadio", false)

    if IsValid(lp) then
        local lp_pos = lp:GetPos()

        for k, v in pairs(aphone.RadioEnts) do
            if IsValid(v) then
                local owner = radio_owner[k]

                if owner and IsValid(owner) and owner:GetPos():DistToSqr(lp_pos) < 600*600 and (!only_mine or owner == lp) then
                    v:SetPos(owner:GetPos())
                    local vol = owner.aphone_RadioVolume

                    if vol != v:GetVolume() then
                        v:SetVolume(vol or 0.5)
                    end
                else
                    v:SetVolume(0)
                end
            end
        end
    end
end)

// Change the radio, take the closest
timer.Create("aphone_RefreshRadios", 0.5, 0, function()
    local local_ply = LocalPlayer()
    if !IsValid(local_ply) then return end

    local tbl = {}

    for k,v in ipairs(player.GetHumans()) do
        if v.aphone_RadioID then
            tbl[v.aphone_RadioID] = tbl[v.aphone_RadioID] or {}
            table.insert(tbl[v.aphone_RadioID], v)
        end
    end

    // get the closest radio
    radio_owner = {}
    local pos = local_ply:GetPos()
    for k, v in pairs(tbl) do
        local best_dist

        for i, j in ipairs(v) do
            if !best_dist then
                best_dist = j
            else
                if v.aphone_RadioVolume and v.aphone_RadioVolume != 0 and best_dist:GetPos():DistToSqr(pos) > v:GetPos():DistToSqr(pos) then
                    best_dist = v
                end
            end
        end

        tbl[k] = best_dist
        radio_owner[k] = tbl[k]
    end

    // Stop radios if nobody use them
    for id, station in ipairs(aphone.RadioEnts) do
        if IsValid(station) then
            local state = station:GetState()

            if !tbl[id] then
                // We don't pause them, because radio can timeout ( from BASS playurl wiki )
                station:SetVolume(0)
            elseif tbl[id] and state != 1 then
                station:Play()
            end
        end
    end
end)

// Nets
net.Receive("aphone_ChangeRadio", function()
    local ent = net.ReadEntity()
    ent.aphone_RadioID = net.ReadUInt(12)

    if ent.aphone_RadioID == 0 then
        ent.aphone_RadioID = nil
    end

    if ent == LocalPlayer() then
        if ent.aphone_RadioID != 0 then
            aphone.My_Radio = aphone.RadioEnts[ent.aphone_RadioID]
        else
            aphone.My_Radio = nil
        end
    end
end)

net.Receive("aphone_RadioVolume", function()
    local ent = net.ReadEntity()
    local volume = net.ReadUInt(7) / 100

    ent.aphone_RadioVolume = volume or 0.5
end)

// Meta extraction
function APP:ExtractMusicTitle(str)
    if str then
        local tbl = string.Explode( "'", str, true)
        for k,v in ipairs(tbl) do
            if v == "StreamTitle=" and tbl[k + 1] != "" then
                return tbl[k + 1]
            end
        end
    end
    return aphone.L("Music_NotFound")
end

local lua_grad = Material("akulla/aphone/lua_grad1.png")
local clr_125_20 = Color(125, 125, 125, 20)

function APP:Open(main, main_x, main_y, screenmode)
    local clr_volbar = aphone:Color("Radio_VolumeBar")
    local clr_bg = aphone:Color("Radio_Background")
    local clr_white180 = aphone:Color("Text_White180")
    local clr_white = aphone:Color("Text_White")
    local clr_white120 = aphone:Color("Text_White120")
    local clr_shadow = aphone:Color("Text_Shadow")

    local font_mediumheader = aphone:GetFont("MediumHeader")
    local font_little = aphone:GetFont("Little")
    local font_header = aphone:GetFont("Roboto40")
    local font_Small = aphone:GetFont("Small")

    function main:Paint(w,h)
        surface.SetDrawColor(clr_volbar)
        surface.DrawRect(0, 0, w, h)
    end

    // Lua refresh break local infos, try to get them back
    if radio_id == 0 and IsValid(aphone.My_Radio) then
        for k, v in pairs(aphone.RadioEnts) do
            if v == aphone.My_Radio then
                radio_id = k
                break
            end
        end
    end

    local app = self
    local radio = aphone.RadioList[radio_id]
    local radio_title = radio and radio.name or aphone.L("Radio_Off")
    local radio_clr = radio and radio.clr or color_transparent
    local radio_music = (IsValid(aphone.My_Radio) and app:ExtractMusicTitle(aphone.My_Radio:GetTagsMeta()) or "")
    local lerptable

    local radio_top = vgui.Create("DPanel", main)

    if screenmode then
        radio_top:Dock(LEFT)
        radio_top:SetWide(main_y)
    else
        radio_top:Dock(TOP)
        radio_top:SetTall(main_x)
    end

    function radio_top:Paint(w, h)
        surface.SetDrawColor(clr_bg)
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(lua_grad)
        surface.SetDrawColor(radio_clr)
        surface.DrawTexturedRect(0, 0, w, h)

        local infos = aphone.RadioList[radio_id]

        if infos then
            local logo = infos.logo
            if logo then
                local mat = aphone.GUI.WebPicture(radio_title, logo, "smooth 1")

                if mat and !mat:IsError() then
                    surface.SetMaterial(aphone.GUI.WebPicture(radio_title, logo, "smooth 1"))
                    surface.SetDrawColor(color_white)
                    surface.DrawTexturedRect(w * 0.1, w * 0.1, w * 0.8, w * 0.8)
                end
            end

            // Visualizer
            if IsValid(aphone.My_Radio) then
                local data = {}
                aphone.My_Radio:FFT(data, FFT_1024)

                if !lerptable then
                    lerptable = data
                elseif data and !table.IsEmpty(data) then
                    local div = math.ceil(w / 60)
                    for i = 1, 60 do
                        if lerptable[i] and lerptable[i] > data[i] then
                            lerptable[i] = math.Clamp(lerptable[i]-0.0025, 0, 1)
                        else
                            lerptable[i] = data[i]
                        end

                        surface.SetDrawColor(clr_white180)
                        surface.DrawRect(div * i, h - (lerptable[i] * 0.5 * h), div * 0.8, lerptable[i] * 0.5 * h)
                    end
                end
            end
        end

        // Music/Radio Name
        surface.SetFont(font_mediumheader)
        local txt_x, txt_y = surface.GetTextSize(radio_music)
        local font = txt_x < w and font_mediumheader or font_little

        draw.SimpleTextOutlined(radio_music, font, w / 2, h * 0.95, clr_white120, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, clr_shadow)
        draw.SimpleTextOutlined(radio_title, font_header, w / 2, h * 0.95 - txt_y, clr_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, clr_shadow)
    end

    local soundbar_panel = vgui.Create("DPanel", main)
    soundbar_panel:SetPaintBackground(false)
    soundbar_panel:Dock(TOP)
    soundbar_panel:SetTall((screenmode and main_x or main_y) * 0.08)

    local space_soundbar_but = (screenmode and soundbar_panel:GetWide() or soundbar_panel:GetTall())
    local space_soundbar_margin = (screenmode and main_y or main_x) * 0.05

    local soundbar_button_low = vgui.Create("DButton", soundbar_panel)
    soundbar_button_low:SetText("q")
    soundbar_button_low:SetFont(aphone:GetFont("SVG_30"))
    soundbar_button_low:SetTextColor(color_white)
    soundbar_button_low:SetPaintBackground(false)
    soundbar_button_low:Dock(LEFT)
    soundbar_button_low:SetTall(space_soundbar_but)
    soundbar_button_low:DockMargin(space_soundbar_margin, space_soundbar_margin, space_soundbar_margin, space_soundbar_margin)

    local soundbar_button_high = vgui.Create("DButton", soundbar_panel)
    soundbar_button_high:SetText("p")
    soundbar_button_high:SetFont(aphone:GetFont("SVG_30"))
    soundbar_button_high:SetTextColor(color_white)
    soundbar_button_high:SetPaintBackground(false)
    soundbar_button_high:Dock(RIGHT)
    soundbar_button_high:SetTall(space_soundbar_but)
    soundbar_button_high:DockMargin(space_soundbar_margin, space_soundbar_margin, space_soundbar_margin, space_soundbar_margin)

    local soundbar_slider = vgui.Create( "DSlider", soundbar_panel )
    soundbar_slider:Dock(FILL)
    soundbar_slider:DockMargin(0, soundbar_panel:GetTall() / 2-4, 0, soundbar_panel:GetTall() / 2-4)
    soundbar_slider:SetSlideX(0.5)

    function soundbar_slider:Paint(w, h)
        draw.RoundedBox(4, 1, 0, w-2, h, color_white)
        draw.RoundedBox(4, 0, 0, w * self:GetSlideX(), h, radio_clr)
    end
    function soundbar_slider.Knob:Paint(w, h) end

    // not gonna spam net. Wait he finished
    local was_edited = false
    function soundbar_slider:Think()
        if self:IsEditing() and !was_edited then
            was_edited = self:GetSlideX()
        end

        if !self:IsEditing() and was_edited then
            net.Start("aphone_RadioVolume")
                net.WriteUInt(self:GetSlideX() * 100, 7)
            net.SendToServer()
            was_edited = false
        end
    end

    local list_scroll = vgui.Create("DScrollPanel", main)
    list_scroll:Dock(FILL)
    list_scroll:aphone_PaintScroll()

    local scaled_size80 = aphone.GUI.ScaledSizeY(80)
    local scaled_size10 = aphone.GUI.ScaledSizeX(10)
    local disabled_text = aphone.L("Music_Disabled")

    for k, v in SortedPairs(aphone.RadioList) do
        local disabled = (!aphone.RadioEnts[k] or !IsValid(aphone.RadioEnts[k])) and k != 0
        surface.SetFont(font_mediumheader)
        local name = ""

        if k != 0 then
            name = !disabled and v.name or v.name .. disabled_text
        else
            name = aphone.L("Radio_Off")
        end

        local font = surface.GetTextSize(name) > main_x - 20 and font_Small or font_header

        local r_bg = vgui.Create("DPanel")
        list_scroll:AddItem(r_bg)
        r_bg:Dock(TOP)
        r_bg:SetTall(scaled_size80)

        function r_bg:Paint(w, h)
            if radio_id == k then
                surface.SetDrawColor(radio_clr)
                surface.DrawRect(0, 0, w, h)
            elseif k % 2 == 0 then
                surface.SetDrawColor(clr_125_20)
                surface.DrawRect(0, 0, w, h)
            end
        end

        local r = vgui.Create("Button", r_bg)
        r:Dock(FILL)
        r:SetText(name)
        r:DockMargin(scaled_size10, 0, 0, 0)
        r:SetContentAlignment(4)
        r:SetFont(font)
        r:SetPaintBackground(false)

        if disabled then
            r:SetTextColor(clr_white120)
        else
            r:Phone_AlphaHover()
        end

        function r:DoClick()
            if disabled then return end

            if radio_id == k then
                radio_id = 0
                radio_clr = color_transparent
                radio_title = aphone.L("Radio_Off")
                radio_music = ""
                aphone.My_Radio = nil

                net.Start("aphone_ChangeRadio")
                    net.WriteUInt(0, 12)
                net.SendToServer()
            else
                radio_id = k
                radio_clr = aphone.RadioList[k].clr
                radio_title = name
                radio_music = (k != 0 and app:ExtractMusicTitle(aphone.RadioEnts[k]:GetTagsMeta()) or "")
                aphone.My_Radio = aphone.RadioEnts[k]

                net.Start("aphone_ChangeRadio")
                    net.WriteUInt(k, 12)
                net.SendToServer()
            end
        end
    end

    if !screenmode then
        main:Phone_DrawTop(main_x, main_y)
    end

    main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
    self:Open(main, main_x, main_y, true)
end

aphone.RegisterApp(APP)