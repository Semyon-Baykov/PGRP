module( 'gp_radio', package.seeall )
hook.Add( 'loadCustomDarkRPItems', 'gp_radio_load2', function()
	tbl = {
		['Полицейская частота'] = {
			id = 'police',
			jobs = {
				[TEAM_POLICE] = true,
				[TEAM_CHIEF] = true,
				[TEAM_MAYOR] = true,
				[TEAM_PPS] = true,
				[TEAM_OMON] = true,
				[TEAM_FBI] = true,
			}
		},
		['Частота Росгвардии'] = {
			id = 'nrg',
			jobs = {
				[TEAM_NRG1] = true,
			}
		}
	} 
end)