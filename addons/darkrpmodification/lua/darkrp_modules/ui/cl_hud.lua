surface.CreateFont( 'GHUD-MINI', { font = 'Roboto', weight = 350, addictive = true, size = ScrW() - ( ScrW() / 1.013 ) } )

surface.CreateFont( 'GHUD-MINI1', { font = 'Roboto', weight = 350, addictive = true, size = ScrW() - ( ScrW() / 1.011 ) } )

surface.CreateFont( 'GHUD-NORMAL', { font = 'Roboto', weight = 350, addictive = true, size = ScrW() - ( ScrW() / 1.018 ) } )

local hud = {}

hud.barSizeW, hud.barSizeH = ScrW() - ( ScrW() / 1.27 ), ScrH() - ( ScrH() / 1.037 )

hud.iconSize = ScrH() - ( ScrH() / 1.027 )

hud.lerp = { 

    [ 'health' ] = { 0, function( self ) return ( self.Health and self:Health() or 0 ) end }, 

    [ 'armor' ] = { 0, function( self ) return ( self.Armor and self:Armor() or 0 ) end }

}

hud.icons = {
    

    [ 'fuel' ] = Material( 'gportalhud/fuel.png' ),

    [ 'car' ] = Material( 'gportalhud/car.png' ),

    [ 'health' ] = Material( 'gportalhud/health.png' ),

    [ 'armor' ] = Material( 'gportalhud/armor.png' ),

    [ 'hunger' ] = Material( 'gportalhud/hunger.png' ),

    [ 'wallet' ] = Material( 'gportalhud/money.png' ),

    [ 'license' ] = Material( 'gportalhud/identification.png' ),

    [ 'salary' ] = Material( 'icon16/money_add.png' )

}



hud.bars = {

    { icon = 'car', color = Color( 43, 168, 14 ), bar = function( self, ply ) return ply:GetSimfphys():GetCurHealth() / ply:GetSimfphys():GetMaxHealth() end, text = function( self, ply ) return math.ceil( ( ply:GetSimfphys():GetCurHealth() / ply:GetSimfphys():GetMaxHealth() ) * 100 ) end, view = function( self, ply ) return ply:GetSimfphys() != NULL  end },
    { icon = 'fuel', color = Color( 248, 244, 0 ), bar = function( self, ply ) return ply:GetSimfphys():GetFuel() / ply:GetSimfphys():GetMaxFuel() end, text = function( self, ply ) return math.ceil( ( ply:GetSimfphys():GetFuel() / ply:GetSimfphys():GetMaxFuel() ) * 100 ) end, view = function( self, ply ) return ply:GetSimfphys() != NULL end },
    { icon = 'health', color = Color( 233, 0, 36 ), bar = function( self, ply ) return hud.lerp[ 'health' ][ 1 ] / ply:GetMaxHealth() end, text = function( self, ply ) return ply:Health() end, view = function( self, ply ) return true end },
    { icon = 'armor', color = Color( 0, 131, 223 ), bar = function( self, ply ) return hud.lerp[ 'armor' ][ 1 ] / 100 end, text = function( self, ply ) return ply:Armor() end, view = function( self, ply ) return math.floor( hud.lerp[ 'armor' ][ 1 ] ) > 0 end },
    { icon = 'hunger', color = function( self, ply ) return HSVToColor( self.bar( self, ply ) * 30, 1, 1 ) end, bar = function( self, ply ) return math.ceil( ply:getDarkRPVar( 'Energy' ) or 0 ) / 100 end, text = function( self, ply ) return math.ceil( ply:getDarkRPVar( 'Energy' ) or 0 ) end, view = function( self, ply ) return true end }

}

hud.hideHUDElements = {
    
    [ 'DarkRP_HUD' ] = false,

    [ 'DarkRP_EntityDisplay' ] = false,

    [ 'DarkRP_ZombieInfo' ] = false,

    [ 'DarkRP_LocalPlayerHUD' ] = true,

    [ 'DarkRP_Hungermod' ] = true,

    [ 'DarkRP_Agenda' ] = true,

    [ 'CHudAmmo' ] = false,

    [ 'DarkRP_LockdownHUD' ] = true,

    [ 'CakeHUD' ] = true,

    [ 'GHUD' ] = false,

}

hud.textWide = function( text, font )
        
    surface.SetFont( font or 'GHUD-NORMAL' )

    local w, h = surface.GetTextSize( text or '' )

    return { w, h }

end

hud.drawIcon = function( x, y, name )

    if not hud.icons[ name ] then

        error( '[GHUD] Данная иконка не существует! -- ' .. name )

        return

    end
        
    surface.SetDrawColor( 255, 255, 255, 255 )

    surface.SetMaterial( hud.icons[ name ] )

    surface.DrawTexturedRect( x, y, hud.iconSize, hud.iconSize )

end

hook.Add( 'HUDShouldDraw', 'HideDefaultHUD', function( name )

    if hud.hideHUDElements[ name ] then

        return false 

    end

end )

hook.Add( 'HUDPaint', 'GHUD', function()

    if not hook.Run( 'HUDShouldDraw', 'GHUD' ) then return end

    if not string.Comma then return end

    --------------------------------

    ------------- BARS -------------

    --------------------------------

    for k, v in pairs( hud.lerp ) do

        v[ 1 ] = Lerp( 0.05, v[ 1 ], v[ 2 ]( LocalPlayer() ) )

    end

    local bars = {}

    for k, v in pairs( hud.bars ) do

        if v.view and v.view( v, LocalPlayer() ) then

            table.insert( bars, { icon = v.icon, bar = v.bar, color = v.color, text = v.text, view = v.view } )

        end

    end



    local x, y = 27, ScrH() - ( hud.barSizeH * #bars + 25 )

    for k, v in pairs( bars ) do

        local indentW, indentH = hud.barSizeW - ( hud.barSizeW / 1.1 ), hud.barSizeH - ( hud.barSizeH / 1.1 )
    
        draw.RoundedBox( 0, x, y, hud.barSizeW, hud.barSizeH, Color( 0, 0, 0, 100 ) )

        draw.RoundedBox( 0, x + indentW, y + indentH, ( hud.barSizeW - indentW ) * math.Clamp( v.bar( v, LocalPlayer() ) , 0, 1 ) - indentH, hud.barSizeH - indentH * 2, ( isfunction( v.color ) and v.color( v, LocalPlayer() ) or v.color ) )

        draw.SimpleTextOutlined( math.max( v.text( v, LocalPlayer() ), 0 ) .. '%', 'GHUD-MINI', x + hud.barSizeW / 2, y + hud.barSizeH / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0,0,0 ) )

        hud.drawIcon( x + ( indentW / 2 ) - ( hud.iconSize / 2 ), y + ( hud.barSizeH / 2 ) - ( hud.iconSize / 2 ), v.icon )

        y = y + hud.barSizeH + 2

    end

    -------------------------------------

    ------------- SHIT PANEL -------------

    -------------------------------------

    local indentW, indentH = 10, 2

    local wide, height = indentW, indentH

    local vars = { 

        job = LocalPlayer():getDarkRPVar( 'job' ) or team.GetName( TEAM_CITIZEN ), 

        jobcolor = team.GetColor( LocalPlayer():getJobTable() and LocalPlayer():getJobTable().team or TEAM_CITIZEN ),

        wallet = string.Replace( string.Comma( LocalPlayer():getDarkRPVar( 'money' ) or 0 ), ',', '.' ) .. '₽+' .. ( LocalPlayer():getDarkRPVar( 'salary' ) or 0 )..'₽',

        salary = ( LocalPlayer():getDarkRPVar( 'salary' ) or 0 ),

        license = LocalPlayer():getDarkRPVar( 'HasGunlicense' ) and 'Имеется лицензия' or nil,

        name = LocalPlayer():GetName()

    }


    local vars_size = {

        job = hud.textWide( vars.job, utf8.len(vars.job) < 15 and 'GHUD-NORMAL' or 'GHUD-MINI1' ),

        name = hud.textWide( vars.name ),

        --wallet_icon = { 20 + ( indentW * 2 ), 0 },

        wallet = hud.textWide( vars.wallet ),

        license = hud.textWide( vars.license )

    }

    wide = math.max( wide, vars_size.job[ 1 ] )

    wide = math.max( wide, vars_size.name[ 1 ] )

    wide = math.max( wide, vars_size.wallet[ 1 ] + hud.iconSize )

    if vars.license then

        wide = math.max( wide, vars_size.license[ 1 ] + hud.iconSize )

    end

    wide = wide + indentW

    height = indentH + vars_size.job[ 2 ] + vars_size.name[ 2 ] + indentH * 2

    draw.RoundedBox( 0, 12, 12, wide, height + indentH * 2, Color( 0, 0, 0, 80 ) )

    draw.SimpleTextOutlined( vars.job, utf8.len(vars.job) < 15 and 'GHUD-NORMAL' or 'GHUD-MINI1', 12 + wide / 2, 12 + indentH, vars.jobcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0,0,0 )  )

    draw.SimpleTextOutlined( vars.name, 'GHUD-NORMAL', 12 + wide / 2, 12 + indentH + vars_size.job[ 2 ], Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0,0,0 )  )

   


    draw.RoundedBox( 0, 12, 12 + height + 8, wide, vars_size.wallet[ 2 ], Color( 0, 0, 0, 80 ) )

    draw.SimpleTextOutlined( vars.wallet, 'GHUD-NORMAL', 12 + wide / 2, 12 + height + 8 + vars_size.wallet[ 2 ] / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0,0,0 ) )

    --hud.drawIcon( 12 + wide / 2 - vars_size.wallet[ 1 ] / 2 - 15, 12 + height + 8 + indentH, 'wallet' )

    if vars.license then

        draw.RoundedBox( 0, 12, 12 + height + 12 + vars_size.wallet[ 2 ], wide, vars_size.wallet[ 2 ], Color( 0, 0, 0, 80 ) )

        draw.SimpleText( vars.license, 'GHUD-NORMAL', 12 + wide / 2 + hud.iconSize / 2, 12 + height + 12 + vars_size.wallet[ 2 ] + vars_size.license[ 2 ] / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        hud.drawIcon( 12 + wide / 2 - vars_size.license[ 1 ] / 2 - hud.iconSize / 2, 12 + height + 12 + indentH + vars_size.wallet[ 2 ], 'license' )

    end

end )