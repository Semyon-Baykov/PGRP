print( "[BITMINERS BY CRAP-HEAD] Initializing Script" )

-- Workshop content
resource.AddWorkshop( "2072136134" )

-- Network strings
util.AddNetworkString( "CH_BITMINERS_UpdateBitcoinRates" )

-- Initialize
local function CH_BITMINERS_Initialize()
	timer.Simple( 5, function()
		CH_BITMINERS_RandomizeBitcoinRate()
		
		-- Spawn bitcoin rate screens
		if not file.IsDir( "craphead_scripts/ch_bitminers/".. string.lower( game.GetMap() ) .."/screens/", "DATA" ) then
			file.CreateDir( "craphead_scripts/ch_bitminers/".. string.lower( game.GetMap() ) .."/screens/", "DATA" )
		end
		
		CH_BITMINERS_SpawnBitcoinScreens()
	end )
end
hook.Add( "Initialize", "CH_BITMINERS_Initialize", CH_BITMINERS_Initialize )

print( "[BITMINERS BY CRAP-HEAD] Initialized" )