-- Groups and steamids that are allowed to open the menu
-- Follow the formatting of the examples
SG.cfg.Groups = {
    [ "superadmin" ] = true
}

-- The command to open the menu
-- Don't add ! or /
SG.cfg.Command = "sg"

-- The command to open the menu from console
SG.cfg.ConCommand = "secondary_groups"

-- If true, edit the MySQL config
SG.cfg.UseMySQL = false


--[[
    USAGE EXAMPLES:

    POINTSHOP:
        ITEM.SecondaryGroups = { "donator", "donator+" }


        function ITEM:OnBuy( ply )
            if !table.HasValue( ITEM.SecondaryGroups, ply:GetSecondaryUserGroup() ) then return end
        end

    DARKRP:
        customCheck = function( ply ) return ply:IsSecondaryUserGroup "donator" end

        OR

        customCheck = function( ply ) return table.HasValue( { "donator", "donator+" }, ply:GetSecondaryUserGroup() ) end

]]
