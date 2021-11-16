CH_FireSystem.Trucks = CH_FireSystem.Trucks or {}

-- Default Firetrucks
CH_FireSystem.Trucks[ "FIRETRUCK_EOneLadder" ] = { 
	Name = "E-One Cyclone II Ladder",
	Description = "Realistic E-One Ladder firetruck for the fire fighter team.",
	Model = "models/perrynsvehicles/pierce_arrow_xt/pierce_arrow_xt.mdl",
	Script = "scripts/vehicles/perryn/pierce_arrow_xt.txt",
	Health = 200,
	VehicleSkin = 0,
	AllowedTeamNames = {
		"Fire Fighter",
	},
	AllowedTeams = {
		TEAM_FIREFIGHTERCHIEF,
	},
	ULXRanksAllowed = {
		"user",
		"admin",
		"superadmin",
	},
}

CH_FireSystem.Trucks[ "FIRETRUCK_HeavyRescue" ] = { 
	Name = "Heavy Rescue Firetruck",
	Description = "Heavy rescue firetruck specifically for large tasks and only for the chief.",
	Model = "models/perrynsvehicles/rescue_truck/rescue_truck.mdl",
	Script = "scripts/vehicles/perryn/rescue_truck.txt",
	Health = 200,
	VehicleSkin = 0,
	AllowedTeamNames = {
		"Fire Fighter Chief",
		"Fire Fighter",
		"Fire fighter pussy"
	},
	AllowedTeams = {
		TEAM_FIREFIGHTERCHIEF,
	},
	ULXRanksAllowed = {
		"user",
		"admin",
		"superadmin",
		"user",
		"admin",
		"superadmin",
	},
}

-- Looking for more fire trucks? I have pre-configured more fire trucks.
-- You can find the codes here: https://www.gmodstore.com/help/addon/302/adding-firetrucks