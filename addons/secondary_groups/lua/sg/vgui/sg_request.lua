function SG.StringRequest( title, body, def, yes, no )
    local frame = vgui.Create "SG_Frame"
    frame:SetTitle( title )
    frame:SetDrawOnTop( true )
    frame:SetSize( 400, 120 )
    frame:Center()
    frame:MakePopup()
    frame.Think = function() end

    local inner = vgui.Create( "EditablePanel", frame )
    inner.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30 ) )
    end

    local text = vgui.Create( "DLabel", inner )
    text:SetText( body )
    text:SetFont "SG.Button"
    text:SizeToContents()
    text:SetContentAlignment( 5 )
    text:SetTextColor( color_white )

    local x, y = text:GetPos()

    local entry = vgui.Create( "DTextEntry", inner )
    entry:SetText( def )
    entry.OnEnter = function( s )
        yes( s:GetText() )

        frame:AlphaTo( 0, .2, 0, function() frame:Remove() end )
    end

    local buttons = vgui.Create( "EditablePanel", frame )
    buttons:SetTall( 30 )

    local accept = vgui.Create( "SG_Button", buttons )
    accept:SetText "Accept"
    accept:SetColor( Color( 30, 30, 30 ) )
    accept:SetOutlineColor( Color( 120, 255, 120, 150 ) )

    accept.DoClick = function()
        yes( entry:GetText() )

        frame:AlphaTo( 0, .2, 0, function() frame:Remove() end )
    end

    local deny = vgui.Create( "SG_Button", buttons )
    deny:SetText "Cancel"
    deny:SetColor( Color( 30, 30, 30 ) )
    deny:SetOutlineColor( Color( 255, 120, 120, 150 ) )
    deny.DoClick = function()
        no( entry:GetText() )

        frame:AlphaTo( 0, .2, 0, function() frame:Remove() end )
    end

    inner:StretchToParent( 5, 0, 5, 50 )
    inner:Dock( TOP )
    inner:DockPadding( 0, 0, 0, 20 )

    text:StretchToParent( 5, 5, 5, 30 )

    entry:StretchToParent( 5, nil, 5, nil )
    entry:AlignBottom( 5 )

    buttons:Dock( BOTTOM )
    buttons:SetWidth( frame:GetWide() )

    accept:SetSize( 100, 25 )
    accept:SetPos( buttons:GetWide() / 2 - accept:GetWide() / 2 - accept:GetWide() )

    deny:SetSize( 100, 25 )
    deny:SetPos( buttons:GetWide() / 2 + deny:GetWide() / 2 )
end
