--gprp.ru
NPC_TBL = NPC_TBL or {}

function AddNPCText( ent, name, job, jobcol )

    NPC_TBL[ent] = {
        name = name,
        job = job,
        jobcol = jobcol
    }

end

hook.Add('Initialize', 'SetupPixVis2', function()
    pixvis2 = util.GetPixelVisibleHandle()
end)

surface.CreateFont( 'hud_arial_bars', {

    font = 'Roboto',
    size = 16,
    weight = 600,
    shadow = false,
    antialis = false,

} )

surface.CreateFont( 'hud_arial_inf', {

    font = 'Roboto',
    size = 19,
    weight = 600,
    shadow = false,
    antialis = false,

} )
surface.CreateFont( 'hud_arial_inf_sh', {

    font = 'Roboto',
    size = 20,
    weight = 600,
    shadow = false,
    antialis = false,
    blursize = 1


} )
surface.CreateFont( 'hud_arial_overhead', {

    font = 'Roboto',
    size = 25,
    weight = 500,
    shadow = false,
    antialis = false,

} )
surface.CreateFont( 'hud_arial_overhead_sh', {

    font = 'Roboto',
    size = 25,
    weight = 500,
    shadow = false,
    antialis = false,
    blursize = 1

} )
surface.CreateFont( 'hud_arial_bars_sh', {

    font = 'Roboto',
    size = 17,
    weight = 600,
    shadow = false,
    antialis = false,
    blursize = 1


} )
local function draw_shadowtext( text, font, x, y, color, ax, ay )

/*
    local s = {}

    s['text'] = text
    s['pos'] = {x, y}
    s['color'] = color
    s['font'] = font 
    s['xalign'] = ax
    s['yalign'] = ay

    draw.TextShadow( s, 1, 200 )
*/

    draw.SimpleTextOutlined( text, font..'_sh', x, y, color_black, ax, ay, 2, Color( 0, 0, 0, 50 ) )
    draw.SimpleText( text, font, x, y, color, ax, ay )
 
    
end

local function typing_pos( ply, pos )

    local pos = pos.y - 16 - 80

    if ply:getDarkRPVar('HasGunlicense') then
        pos = pos - 20
    end
    if ply:getDarkRPVar('wanted') then
        pos = pos - 20
    end

    return pos

end

local function draw_overhead_text( ply )

  	local v = ply

    local pos = v:EyePos()
    pos.z = pos.z + 10
    pos = pos:ToScreen()
    
    draw_shadowtext( v:Nick(), 'hud_arial_overhead', pos.x, pos.y-45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw_shadowtext( v:getDarkRPVar('job'), 'hud_arial_overhead', pos.x, pos.y-20, team.GetColor( v:Team() ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if v:getDarkRPVar('HasGunlicense') then
    	 draw_shadowtext( 'Имеется лицензия', 'hud_arial_overhead', pos.x, pos.y-70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    if v:getDarkRPVar('wanted') then
    	draw_shadowtext( 'Находится в розыске', 'hud_arial_overhead', pos.x, v:getDarkRPVar('HasGunlicense') and pos.y-95 or pos.y-70, Color( 255, 0, 0) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    if v:GetNWBool( 'typing', false ) == true then

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( Material( 'ui/writing.png' ) )

        surface.DrawTexturedRect( pos.x-5, typing_pos(v, pos), 32, 32 )

    end

end
local function draw_overhead_text_npc( ply, name, job, jobcol )

    local v = ply

    local pos = v:EyePos()
    pos.z = pos.z + 10
    pos = pos:ToScreen()
    
    draw_shadowtext( name, 'hud_arial_overhead', pos.x, pos.y-45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw_shadowtext( job, 'hud_arial_overhead', pos.x, pos.y-20, jobcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end


hook.Add( 'HUDPaint', 'hl2rp_overhead', function()
	local localplayer = LocalPlayer()
    local shootPos = localplayer:GetShootPos()
    local aimVec = localplayer:GetAimVector()

    for _, ply in pairs( player.GetAll() ) do
    	if not IsValid(ply) or ply == localplayer or not ply:Alive() or ply:GetNoDraw() or ply:IsDormant() then continue end
    	
    	local hisPos = ply:GetShootPos()

    	if hisPos:DistToSqr(shootPos) < 160000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, localplayer)
                if trace.Hit and trace.Entity ~= ply then break end
                draw_overhead_text( ply ) 
            end
        end

    end

  for ply, v in pairs( NPC_TBL ) do
        
        if not IsValid(ply) then continue end
        local visible = util.PixelVisible( ply:GetPos(), 16, pixvis2 )
        if visible < 0.1 then continue end
        if ply:GetPos():Distance( LocalPlayer():GetPos() ) > 200 then continue end
        draw_overhead_text_npc( ply, v.name, v.job, v.jobcol )
    end
end )

hook.Add('HUDDrawTargetID', 'name', function() return false end)