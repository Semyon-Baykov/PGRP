SG.NW.Register "secondaryusergroup"
    :Write( net.WriteString )
    :Read( net.ReadString )
    :SetPlayer()

local ply = FindMetaTable "Player"

function ply:GetSecondaryUserGroup()
    return self:GetNetVar "secondaryusergroup"
end

function ply:IsSecondaryUserGroup( group )
    return self:GetNetVar "secondaryusergroup" == group
end

function ply:SetSecondaryUserGroup( group )
    if !table.HasValue( SG.Save.CurrentGroups, group ) then return end

    self:SetNetVar( "secondaryusergroup", group )
end

function SG.CanOpen( ply )
    return SG.cfg.Groups[ ply:SteamID() ] or SG.cfg.Groups[ ply:GetUserGroup() ]
end
