if SERVER then
	
	AddCSLuaFile( 'cl_admingift.lua' )

	include( 'sv_admingift.lua' )	

else

	include( 'cl_admingift.lua' )	

end
