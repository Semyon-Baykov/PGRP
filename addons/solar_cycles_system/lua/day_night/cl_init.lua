//Made by AeroMatix || https://www.youtube.com/channel/UCzA_5QTwZxQarMzwZFBJIAw || http://steamcommunity.com/profiles/76561198176907257
//This took me quite a while to do so if you can subscribe to my YouTube in return that would be fab, thanks! https://www.youtube.com/channel/UCzA_5QTwZxQarMzwZFBJIAw

-- lightmap stuff
net.Receive( "daynight_lightmaps", function( len )

	render.RedownloadAllLightmaps();

end );

-- precache
hook.Add( "InitPostEntity", "daynightFirstJoinLightmaps", function()

	render.RedownloadAllLightmaps();

end );

net.Receive( "daynight_message", function( len )

	local tab = net.ReadTable();

	if ( #tab > 0 ) then

		chat.AddText( unpack( tab ) );

	end

end );

-- spawnmenu stuff
local function SaveValues( CPanel )

	if ( CPanel == nil ) then return end

	local tbl = {
		enabled = CPanel.enabled:GetChecked() and 1 or 0,
		paused = CPanel.paused:GetChecked() and 1 or 0,
		realtime = CPanel.realtime:GetChecked() and 1 or 0,
		dnclength_day = CPanel.length_day:GetValue(),
		dnclength_night = CPanel.length_night:GetValue(),
	};

	net.Start( "daynight_settings" );
		net.WriteTable( tbl );
	net.SendToServer();

end

local function UpdateValues( CPanel )

	if ( CPanel == nil ) then return end

	if ( CPanel.enabled ) then

		CPanel.enabled:SetValue( cvars.Number( "daynight_enabled" ) );

	end

	if ( CPanel.paused ) then

		CPanel.paused:SetValue( cvars.Number( "daynight_paused" ) );

	end

	if ( CPanel.realtime ) then

		CPanel.realtime:SetValue( cvars.Number( "daynight_realtime" ) );

	end

	if ( CPanel.length_day ) then

		CPanel.length_day:SetValue( cvars.Number( "daynight_length_day" ) );

	end

	if ( CPanel.length_night ) then

		CPanel.length_night:SetValue( cvars.Number( "daynight_length_night" ) );

	end

end

local function DaynightSettings( CPanel )
	-- Version
	CPanel:AddControl( "Header", { Description = "Day & Night Version " .. tostring( daynight_version ) } );

	-- day & night enabled
	language.Add( "daynight.enabled", "Enabled" );
	language.Add( "daynight.enabled.help", "Turn day & night on or off, requires map reload" );

	CPanel.enabled = CPanel:AddControl( "CheckBox", { Label = "#daynight.enabled", Help = true } );

	-- day & night paused
	language.Add( "daynight.paused", "Paused" );
	language.Add( "daynight.paused.help", "Turn day & night time progression on or off" );

	CPanel.paused = CPanel:AddControl( "CheckBox", { Label = "#daynight.paused", Help = true } );

	-- day & night realtime
	language.Add( "daynight.realtime", "Realtime" );
	language.Add( "daynight.realtime.help", "Whether or not day & night time progression is based on the servers local time zone" );

	CPanel.realtime = CPanel:AddControl( "CheckBox", { Label = "#daynight.realtime", Help = true } );

	-- day & night dnc length day
	language.Add( "daynight.dnclength_day", "Day Length" );
	language.Add( "daynight.dnclength_day.help", "The duration modifier of daytime in seconds" );

	CPanel.length_day = CPanel:AddControl( "Slider", { Label = "#daynight.dnclength_day", Type = "Int", Min = 30, Max = 7200, Help = true } );

	-- day & night dnc length night
	language.Add( "daynight.dnclength_night", "Night Length" );
	language.Add( "daynight.dnclength_night.help", "The duration modifier of nighttime in seconds" );

	CPanel.length_night = CPanel:AddControl( "Slider", { Label = "#daynight.dnclength_night", Type = "Int", Min = 30, Max = 7200, Help = true } );

	-- handle visually updating the values for settings
	timer.Simple( 0.1, function()

		UpdateValues( CPanel );

	end );

	concommand.Add( "daynight_cl_savesv", function( pl, cmd, args )

		if ( !pl:DaynightAdmin() ) then return end

		SaveValues( CPanel );

		timer.Simple( 0.1, function()

			UpdateValues( CPanel );

		end );

	end );

	concommand.Add( "daynight_cl_resetsv", function( pl, cmd, args )

		if ( !pl:DaynightAdmin() ) then return end

		RunConsoleCommand( "daynight_reset" );

		timer.Simple( 0.1, function()

			UpdateValues( CPanel );

		end );

	end );

	CPanel:AddControl( "Button", { Label = "Save Settings", Command = "daynight_cl_savesv" } );
	CPanel:AddControl( "Button", { Label = "Reset Settings", Command = "daynight_cl_resetsv" } );

end

hook.Add( "PopulateToolMenu", "PopulateDaynightMenus", function()

	spawnmenu.AddToolMenuOption( "Utilities", "Day & Night", "DaynightSettings", "Server", "", "", DaynightSettings );

end );

hook.Add( "AddToolMenuCategories", "CreateDaynightCategories", function()

	spawnmenu.AddToolCategory( "Utilities", "Day & Night", "Day & Night" );

end );