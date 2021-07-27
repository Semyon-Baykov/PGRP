surface.CreateFont('SDNA', {
    font = 'DermaDefault',
    size = 15
})

surface.CreateFont('SDNADraw', {
    font = 'ScoreboardHeader',
    size = 25
})

function SDNA.weaponName(class)
    for k, v in pairs(list.Get('Weapon')) do
        if v.ClassName == class then return v.PrintName end
    end

    return class
end

function SDNA.RagdollView(ply, pos, angles, fov)
    local Ragdoll = ply:GetNWEntity('DeathRagdoll')
    if ply:Alive() or not IsValid(Ragdoll) then return end
    local eyes = Ragdoll:GetAttachment(Ragdoll:LookupAttachment('eyes'))

    if not eyes then
        return {
            origin = Ragdoll:GetPos(),
            angles = angles,
            fov = fov,
            znear = 0.5
        }
    end

    local view = {}
    view.origin = eyes.Pos or pos
    view.angles = eyes.Ang or angles
    view.fov = fov
    view.znear = 0.5

    return view
end

function SDNA.ShowDNA(ply)
    if ply:GetNWInt('DNAWanted') == 0 or not IsValid(ply) then return end

    timer.Create('#DNA#Position', 60, 2, function()
        if ply:GetNWInt('DNAWanted') == 0 then return end
        table.insert(techrpmarkers, {'[ДНК] Последнее местоположение подозреваемого', ply:GetPos(), Material('icon16/magnifier.png'), CurTime() + 60})
        SDNA.LastMark = #techrpmarkers
        SDNA.LastMarkTime = CurTime()
    end)

    table.insert(techrpmarkers, {'[ДНК] Последнее местоположение подозреваемого', ply:GetPos(), Material('icon16/magnifier.png'), CurTime() + 60})
    SDNA.LastMark = #techrpmarkers
end

concommand.Add('dna_remove', function()
    table.remove(techrpmarkers, SDNA.LastMark)
    timer.Destroy('#DNA#Position')
    LocalPlayer():EmitSound(Sound('NPC_CombineGunship.SearchPing'))
end)

function SDNA.Draw()
    if LocalPlayer():GetNWEntity('DNAA') ~= nil and timer.Exists('#DNA#Position') and LocalPlayer():GetNWInt('DNAT') ~= nil then
        draw.SimpleText('ДНК Сканер', 'SDNADraw', ScrW() / 2, 2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText('До обновления позиции: ' .. math.Round((timer.TimeLeft('#DNA#Position') or 0)), 'SDNADraw', ScrW() / 2, 22, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText('ДНК распадется через: ' .. (LocalPlayer():GetNWInt('DNAT') ~= nil and math.Round(math.abs(CurTime() - (LocalPlayer():GetNWInt('DNAT') + 240))) or 0), 'SDNADraw', ScrW() / 2, 42, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function SDNA.Show(ragdoll)
    if IsValid(SDNA.menu) then
        SDNA.menu:Remove()
    end

    if not IsValid(ragdoll) then return end
    local ply = ragdoll:GetNWEntity('victim')
    local model = ragdoll:GetNWString('model')
    local dna_score = ragdoll:GetNWInt('score')
    local time = ragdoll:GetNWInt('time')
    local job = ragdoll:GetNWString('job')
    local kill_distance = ragdoll:GetNWInt('distance')
    local kill_reason = ragdoll:GetNWString('reason')
    local kill_weapon = ragdoll:GetNWString('weapon')
    local killer = ragdoll:GetNWEntity('attacker')
    local removetime = ragdoll:GetNWInt('removetime')
    if not IsValid(ply) then return Derma_Message('Информация о гражданине отсутствует в базе данных.', 'ДНК', 'ОК') end
    local frame = vgui.Create'gpFrame'
    frame:MakePopup()
    frame:SetSize(ScrW() - (ScrW() / 1.3), ScrH() - (ScrH() / 1.35))
    frame:Center()
    frame:SetTitle('Свидетельство о смерти')

    if kill_reason == 'убийство' and LocalPlayer():Team() == TEAM_FBI then
        frame:SetSize(ScrW() - (ScrW() / 1.3), ScrH() - (ScrH() / 1.35))
    else
        frame:SetSize(ScrW() - (ScrW() / 1.3), ScrH() - (ScrH() / 1.25))
    end

    function frame:Think()
        if not IsValid(ragdoll) then
            frame:Remove()
        end
    end

    SDNA.menu = frame
    local face = vgui.Create('DModelPanel', frame)
    face:SetModel(model)
    face:SetSize(frame:GetWide() / 3, frame:GetTall() - 30)
    face:SetPos(frame:GetWide() - face:GetWide() - 5, 25)

    function face:LayoutEntity(ent)
        ent:SetSequence(ent:LookupSequence('menu_gman'))
        face:RunAnimation()

        return
    end

    local eyepos = face.Entity:GetBonePosition(face.Entity:LookupBone('ValveBiped.Bip01_Head1') or 1)
    face:SetCamPos(eyepos + Vector(75, 25, -30))
    face:SetLookAt(eyepos)
    face:SetFOV(12)
    local info = vgui.Create('DLabel', frame)
    info:SetFont('SDNA')
    info:SetText('Информация об убитом: ')
    info:SetTooltip(info:GetText())
    info:SetMouseInputEnabled(true)
    info:SizeToContents()
    info:Dock(TOP)
    local ply_name = vgui.Create('DLabel', frame)
    ply_name:SetFont('SDNA')
    ply_name:SetText('• Имя: ' .. (ply:Nick() or 'nil'))
    ply_name:SetTooltip(ply_name:GetText())
    ply_name:SetMouseInputEnabled(true)
    ply_name:SizeToContents()
    ply_name:Dock(TOP)
    local jobf = vgui.Create('DLabel', frame)
    jobf:SetFont('SDNA')
    jobf:SetText('• Работа: ' .. job)
    jobf:SetTooltip(jobf:GetText())
    jobf:SetMouseInputEnabled(true)
    jobf:SizeToContents()
    jobf:Dock(TOP)
    local close = vgui.Create('gpButton', frame)
    close:SetFont('SDNA')
    close:setText('Закрыть')
    close:Dock(BOTTOM)

    close.DoClick = function()
        frame:Remove()
    end

    if LocalPlayer():Team() == TEAM_FBI then
        local reason = vgui.Create('DLabel', frame)
        reason:SetFont('SDNA')
        reason:SetText('• Причина смерти: ' .. kill_reason)
        reason:SetTooltip(reason:GetText())
        reason:SetMouseInputEnabled(true)
        reason:SizeToContents()
        reason:Dock(TOP)
    else
        local call = vgui.Create('gpButton', frame)
        call:SetFont('SDNA')
        call:setText('Вызвать ФСБ')
        call:DockMargin( 0, 0, 0, 5 )
        call:Dock(BOTTOM)

        call.DoClick = function()
            net.Start('SDNA#')
            net.WriteEntity(ragdoll)
            net.WriteUInt(2, 2)
            net.SendToServer()
        end
    end

    if kill_reason == 'убийство' and LocalPlayer():Team() == TEAM_FBI then
        local distance = vgui.Create('DLabel', frame)
        distance:SetFont('SDNA')
        distance:SetText('• Расстояние от убийцы: ' .. math.Round(kill_distance) .. ' м')
        distance:SetTooltip(distance:GetText())
        distance:SetMouseInputEnabled(true)
        distance:SizeToContents()
        distance:Dock(TOP)
        local weapon = vgui.Create('DLabel', frame)
        weapon:SetFont('SDNA')
        weapon:SetText('• Орудие убийства: ' .. SDNA.weaponName(kill_weapon))
        weapon:SetTooltip(distance:GetText())
        weapon:SetMouseInputEnabled(true)
        weapon:SizeToContents()
        weapon:Dock(TOP)
        local dna = vgui.Create('gpButton', frame)
        dna:SetFont('SDNA')
        dna:SetText('Взять образец ДНК')
        dna:Dock(BOTTOM)

        dna.DoClick = function()
            if not IsValid(killer) then return Derma_Message('Убийца скрылся с места преступления.', 'ДНК', 'ОК') end
            if killer == LocalPlayer() then return Derma_Message('Вы убили его.', 'ДНК', 'ОК') end
            if ragdoll:GetNWInt('DNAFinded') == 1 then return Derma_Message('Убийство расследовано.', 'ДНК', 'ОК') end

            if dna_score == 0 then
                Derma_Message('Очков ДНК не осталось.', 'ДНК', 'ОК')
            else
                Derma_Message('Последнее местоположение подозреваемого отправлено и показано на карте. Каждую минуту метка обновится! \nОсталось очков ДНК: ' .. (dna_score - 1), 'ДНК', 'ОК')
                net.Start('SDNA#')
                net.WriteEntity(ragdoll)
                net.WriteUInt(1, 2)
                net.SendToServer()

                timer.Simple(1, function()
                    SDNA.ShowDNA(killer)
                end)
            end

            frame:Remove()
        end
    end

    local delete = vgui.Create('DLabel', frame)
    delete:SetFont('SDNA')
    delete:SetText('Труп исчезнет через: ' .. math.Round(math.abs(CurTime() - (time + removetime))) .. ' сек')
    delete:SetTooltip(delete:GetText())
    delete:SetMouseInputEnabled(true)
    delete:SizeToContents()
    delete:Dock(BOTTOM)

    function delete:Think()
        self:SetText('Труп исчезнет через: ' .. math.Round(math.abs(CurTime() - (time + removetime))) .. ' сек')
    end
end

hook.Add('CalcView', 'SDNA', SDNA.RagdollView)
hook.Add('HUDPaint', 'SDNA', SDNA.Draw)