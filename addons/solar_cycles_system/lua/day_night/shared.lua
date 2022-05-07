--Made by AeroMatix || https://www.youtube.com/channel/UCzA_5QTwZxQarMzwZFBJIAw || http://steamcommunity.com/profiles/76561198176907257
--This took me quite a while to do so if you can subscribe to my YouTube in return that would be fab, thanks! https://www.youtube.com/channel/UCzA_5QTwZxQarMzwZFBJIAw

daynight_enabled = CreateConVar( "daynight_enabled", "1", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Day & Night enabled." );
daynight_paused = CreateConVar( "daynight_paused", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Day & Night time progression enabled." );
daynight_realtime = CreateConVar( "daynight_realtime", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Whether or not Day & Night progresses based on the servers time zone." );
daynight_logging = CreateConVar( "daynight_log", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Turn Day & Night logging to console on or off." );

daynight_length_day = CreateConVar( "daynight_length_day", "3600", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration modifier of daytime in seconds." );
daynight_length_night = CreateConVar( "daynight_length_night", "3600", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration modifier of nighttime in seconds." );

daynight_version = 2.0;
daynight_dev = false;

DaynightHeightMin = 300;

function daynight_log( ... )

	if ( daynight_logging:GetInt() < 1 ) then return end

	print( "[day and night] " .. string.format( ... ) .. "\n" );

end

function daynight_Outside( pos )

	if ( pos != nil ) then

		local trace = { };
		trace.start = pos;
		trace.endpos = trace.start + Vector( 0, 0, 32768 );
		trace.mask = MASK_BLOCKLOS;

		local tr = util.TraceLine( trace );

		DaynightHeightMin = ( tr.HitPos - trace.start ):Length();

		if ( tr.StartSolid ) then return false end
		if ( tr.HitSky ) then return true end

	end

	return false;

end

function daynight_outside( pos )

	return daynight_Outside( pos );

end

-- usergroup support
local meta = FindMetaTable( "Player" )

function meta:DaynightAdmin()

	return self:IsSuperAdmin() or self:IsAdmin();

end