-- I can't simulate keys, because it won't trigger the reload/secondary attack SWEP hooks, so I need this
function aphone.RequestAnim(id)
    if aphone.Horizontal and id == 2 then return end
    if !aphone.Horizontal and id == 1 then return end

    if !aphone:Is2D() and (aphone.Force_AllowHorizontal or (aphone.Running_App and aphone.Running_App.Open2D)) then
        net.Start("aphone_AskAnim")
        net.WriteUInt(id, 4)
        net.SendToServer()
        aphone.Horizontal = (id == 2)
        aphone.asking_changestate = true
    end
end