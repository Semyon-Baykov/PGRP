SG = SG or {
    incsv = SERVER and include or function() end,
    inccl = SERVER and AddCSLuaFile or include,
    incsh = function( f ) SG.incsv( f ) SG.inccl( f ) end,
    Print = function( text, ... ) local c = 0 local opts = { ... } MsgC( Color( 0, 178, 238 ), "[Secondary Groups] ", color_white, tostring( text ):gsub( "#", function() c = c + 1 return opts[ c ] end ) .. "\n" ) end,
    cfg = {},
    Users = {}
}

-- Include config

SG.incsh "sg/secondary_groups_config.lua"

-- Include saving

if SG.cfg.UseMySQL and SERVER then
    SG.cfg.MySQL = {}

    SG.incsv "sg/secondary_groups_mysql_config.lua"

    SG.incsv( "sg/save/" .. SG.cfg.MySQL.Module .. ".lua" )
elseif SERVER then
    SG.incsv "sg/save/sqlite.lua"
end

SG.incsh "sg/save/compress.lua"

-- Include networking - shoutout stoned

SG.incsh "sg/network/sh_network.lua"

-- Include pon - shoutout last

SG.incsh "sg/pon/pon.lua"

-- Include various libs - mostly thanks to stoned

SG.incsh "sg/lib/table.lua"

-- Include player setup

SG.incsh "sg/player/sh_player.lua"

-- Include data handler

SG.incsv "sg/core/sv_data.lua"
SG.inccl "sg/core/cl_data.lua"

-- Include command handler

SG.incsv "sg/core/sv_commands.lua"

-- Include the menu vgui then load the menu

for _, f in ipairs( file.Find( "sg/vgui/*.lua", "LUA" ) ) do
    SG.inccl( "sg/vgui/" .. f )
end

SG.inccl "sg/menu/sg_menu.lua"
