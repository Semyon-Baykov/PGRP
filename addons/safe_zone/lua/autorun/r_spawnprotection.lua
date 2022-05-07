RSP = RSP or { Data = {} }

if ( SERVER ) then
	include( "rsp/sv_init.lua")
	AddCSLuaFile( "rsp/cl_init.lua" )
	
	include( "rsp/shared.lua" )
	AddCSLuaFile( "rsp/shared.lua" )
	
	include( "rsp/config.lua" )
	AddCSLuaFile( "rsp/config.lua" )
else
	include( "rsp/shared.lua" )
	include( "rsp/cl_init.lua" )
	include( "rsp/config.lua" )
end