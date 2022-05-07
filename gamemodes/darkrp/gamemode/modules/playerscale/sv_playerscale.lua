util.AddNetworkString( 'DarkRP_darkrp_playerscale' )

local function setScale(ply, scale)
    ply:SetModelScale(scale, 0)

    ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72 * scale))
    /*
    umsg.Start("darkrp_playerscale")
        umsg.Entity(ply)
        umsg.Float(scale)
    umsg.End()
    */
    net.Start( 'DarkRP_darkrp_playerscale' )
        net.WriteEntity( ply )
        net.WriteFloat( scale )
    net.Broadcast()

end

local function onLoadout(ply)
    local Team = ply:Team()
    if not RPExtraTeams[Team] or not tonumber(RPExtraTeams[Team].modelScale) then
        setScale(ply, 1)
        return
    end

    local modelScale = tonumber(RPExtraTeams[Team].modelScale)

    setScale(ply, modelScale)
end
hook.Add("PlayerLoadout", "playerScale", onLoadout)
