function SG.CreateMenu()
    if SG.Menu and SG.Menu:IsValid() then
        SG.Menu:Remove()
    end

    SG.Menu = vgui.Create "SG_Frame"
    SG.Menu:SetSize( ScrW() / 3, ScrH() / 3 )
    SG.Menu:SetTitle "Secondary User Groups"
    SG.Menu:Center()
    SG.Menu:MakePopup()

    local base = vgui.Create( "EditablePanel", SG.Menu )
    base:Dock( RIGHT )
    base:SetWidth( SG.Menu:GetWide() * .75 - 15 )
    base.Paint = function( s, w, h )
        draw.RoundedBox( 0, 1, 1, w - 2, h - 2, Color( 25, 25, 25 ) )
    end

    local users = vgui.Create( "SG_Users", base )
    users:Dock( FILL )

    local groups = vgui.Create( "SG_Groups", base )
    groups:Dock( FILL )
    groups:Hide()

    local sidebar = vgui.Create( "SG_Sidebar", SG.Menu )
    sidebar:Dock( LEFT )
    sidebar:SetWidth( SG.Menu:GetWide() / 4 )
    sidebar:AddTab( "Users", users )
    sidebar:AddTab( "Groups", groups )
end
net.Receive( "SG.OpenMenu", SG.CreateMenu )
