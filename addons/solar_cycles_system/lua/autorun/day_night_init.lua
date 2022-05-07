--Made by AeroMatix || https://www.youtube.com/channel/UCzA_5QTwZxQarMzwZFBJIAw || http://steamcommunity.com/profiles/76561198176907257
--This took me quite a while to do so if you can subscribe to my YouTube in return that would be fab, thanks! https://www.youtube.com/channel/UCzA_5QTwZxQarMzwZFBJIAw

AddCSLuaFile();
AddCSLuaFile( "day_night/shared.lua" );
AddCSLuaFile( "day_night/cl_init.lua" );

include( "day_night/shared.lua" );

if SERVER then

	include("day_night/init.lua");

else

	include("day_night/cl_init.lua");

end
