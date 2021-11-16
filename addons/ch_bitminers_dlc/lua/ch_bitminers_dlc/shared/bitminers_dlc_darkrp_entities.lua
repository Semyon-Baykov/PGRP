-- Add all categories and DarkRP entities here automatically.
--[[
function CH_Bitminers_DLC.DarkRPEntities()
	-- Weapon categories
	DarkRP.createCategory{
		name = "Bitminer Equipment",
		categorises = "weapons",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
		canSee = function(ply) return true end,
		sortOrder = 70,
	}
	
	DarkRP.createCategory{
		name = "Bitminer Equipment",
		categorises = "shipments",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
		canSee = function(ply) return true end,
		sortOrder = 71,
	}
	
	DarkRP.createCategory{
		name = "Bitminer Equipment",
		categorises = "entities",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
		canSee = function(ply) return true end,
		sortOrder = 50,
	}
	
	-- Entities
	DarkRP.createEntity("Hacking USB", {
        ent = "ch_bitminer_hacking_usb",
        model = "models/craphead_scripts/bitminers/dlc/usb.mdl",
        price = 1500,
        max = 2,
		category = "Bitminer Equipment",
        cmd = "buyhackingusb",
    })
	
	DarkRP.createEntity("Antivirus USB", {
        ent = "ch_bitminer_antivirus_usb",
        model = "models/craphead_scripts/bitminers/dlc/usb_second.mdl",
        price = 1500,
        max = 2,
		category = "Bitminer Equipment",
        cmd = "buyantivirususb",
    })

	-- Remote Tablet
	DarkRP.createShipment("Bitminers Remote Tablet", {
		model = "models/craphead_scripts/bitminers/dlc/mediapad.mdl",
		entity = "ch_bitminers_tablet",
		price = 5000,
		amount = 1,
		separate = true,
		pricesep = 2500,
		noship = true,
		--allowed = {TEAM_GANG, TEAM_CRIMINAL, TEAM_COCAINE, TEAM_ADMIN},
		category = "Bitminer Equipment",
	})
	
	DarkRP.createShipment("Bitminers Repair Wrench", {
		model = "models/craphead_scripts/the_cocaine_factory/wrench/w_wrench.mdl",
		entity = "ch_bitminers_repair_wrench",
		price = 4000,
		amount = 1,
		separate = true,
		pricesep = 1750,
		noship = true,
		--allowed = {TEAM_GANG, TEAM_CRIMINAL, TEAM_COCAINE, TEAM_ADMIN},
		category = "Bitminer Equipment",
	})
end
hook.Add( "loadCustomDarkRPItems", "CH_Bitminers_DLC.DarkRPEntities", CH_Bitminers_DLC.DarkRPEntities )
--]]