-- INITIALIZE SCRIPT
if SERVER then
	for k, v in pairs( file.Find( "ch_fire_system/server/*.lua", "LUA" ) ) do
		include( "ch_fire_system/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_fire_system/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_fire_system/client/" .. v )
		--print("cs client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_fire_system/shared/*.lua", "LUA" ) ) do
		include( "ch_fire_system/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_fire_system/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_fire_system/shared/" .. v )
		--print("cs shared: ".. v)
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_fire_system/client/*.lua", "LUA" ) ) do
		include( "ch_fire_system/client/" .. v )
		--print("client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_fire_system/shared/*.lua", "LUA" ) ) do
		include( "ch_fire_system/shared/" .. v )
		--print("shared client: ".. v)
	end
end