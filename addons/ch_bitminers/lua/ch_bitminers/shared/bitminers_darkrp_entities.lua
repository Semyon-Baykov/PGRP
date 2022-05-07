-- Add all categories and DarkRP entities here automatically.
--[[
function CH_BITMINERS_DarkRPEntities()
	-- Categories
	DarkRP.createCategory{
		name = "Bitminer Equipment",
		categorises = "entities",
		startExpanded = true,
		color = Color(0, 107, 0, 255),
		canSee = function(ply) return true end,
		sortOrder = 50,
	}

	-- Entities
	DarkRP.createEntity("Power Cable", {
        ent = "ch_bitminer_power_cable",
        model = "models/craphead_scripts/bitminers/utility/plug.mdl",
        price = 150,
        max = 5,
		category = "Bitminer Equipment",
        cmd = "buypowercable",
    })

    DarkRP.createEntity("Generator", {
        ent = "ch_bitminer_power_generator",
        model = "models/craphead_scripts/bitminers/power/generator.mdl",
        price = 1500,
        max = 4,
		category = "Bitminer Equipment",
        cmd = "buypowergenerator",
    })
	
	DarkRP.createEntity("Solar Panel", {
        ent = "ch_bitminer_power_solar",
        model = "models/craphead_scripts/bitminers/power/solar_panel.mdl",
        price = 3000,
        max = 2,
		category = "Bitminer Equipment",
        cmd = "buysolarpanel",
    })
	
	DarkRP.createEntity("Power Combiner", {
        ent = "ch_bitminer_power_combiner",
        model = "models/craphead_scripts/bitminers/power/power_combiner.mdl",
        price = 1000,
        max = 2,
		category = "Bitminer Equipment",
        cmd = "buypowercombiner",
    })
	
	DarkRP.createEntity("Radioisotope Thermoelectric Generator", {
        ent = "ch_bitminer_power_rtg",
        model = "models/craphead_scripts/bitminers/power/rtg.mdl",
        price = 4500,
        max = 2,
		category = "Bitminer Equipment",
        cmd = "buynucleargenerator",
    })

    DarkRP.createEntity("Bitmining Shelf", {
        ent = "ch_bitminer_shelf",
        model = "models/craphead_scripts/bitminers/rack/rack.mdl",
        price = 5000,
        max = 10,
		category = "Bitminer Equipment",
        cmd = "buyminingshelf",
    })
	
	DarkRP.createEntity("Cooling Upgrade 1", {
        ent = "ch_bitminer_upgrade_cooling1",
        model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_1.mdl",
        price = 3000,
        max = 10,
		category = "Bitminer Equipment",
        cmd = "buycooling1",
    })

    DarkRP.createEntity("Cooling Upgrade 2", {
        ent = "ch_bitminer_upgrade_cooling2",
        model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_2.mdl",
        price = 4000,
        max = 10,
		category = "Bitminer Equipment",
        cmd = "buycooling2",
    })
	
	DarkRP.createEntity("Cooling Upgrade 3", {
        ent = "ch_bitminer_upgrade_cooling3",
        model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_3.mdl",
        price = 5000,
        max = 10,
		category = "Bitminer Equipment",
        cmd = "buycooling3",
    })

    DarkRP.createEntity("Single Miner", {
        ent = "ch_bitminer_upgrade_miner",
        model = "models/craphead_scripts/bitminers/utility/miner_solo.mdl",
        price = 350,
        max = 8,
		category = "Bitminer Equipment",
        cmd = "buysingleminer",
    })

    DarkRP.createEntity("RGB Kit Upgrade", {
        ent = "ch_bitminer_upgrade_rgb",
        model = "models/craphead_scripts/bitminers/utility/rgb_kit.mdl",
        price = 1000,
        max = 8,
		category = "Bitminer Equipment",
        cmd = "buyrgbkit",
    })
	
	DarkRP.createEntity("Power Supply Upgrade", {
        ent = "ch_bitminer_upgrade_ups",
        model = "models/craphead_scripts/bitminers/utility/ups_solo.mdl",
        price = 500,
        max = 8,
		category = "Bitminer Equipment",
        cmd = "buyupsupgrade",
    })
	
	DarkRP.createEntity("Fuel - Small", {
        ent = "ch_bitminer_power_generator_fuel_small",
        model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
        price = 500,
        max = 5,
		category = "Bitminer Equipment",
        cmd = "buygeneratorfuelsmall",
    })
	
	DarkRP.createEntity("Fuel - Medium", {
        ent = "ch_bitminer_power_generator_fuel_medium",
        model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
        price = 1000,
        max = 5,
		category = "Bitminer Equipment",
        cmd = "buygeneratorfuelmedium",
    })
	
	DarkRP.createEntity("Fuel - Large", {
        ent = "ch_bitminer_power_generator_fuel_large",
        model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
        price = 1500,
        max = 5,
		category = "Bitminer Equipment",
        cmd = "buygeneratorfuellarge",
    })
	
	DarkRP.createEntity("Cleaning Fluid", {
        ent = "ch_bitminer_upgrade_clean_dirt",
        model = "models/craphead_scripts/bitminers/cleaning/spraybottle.mdl",
        price = 500,
        max = 5,
		category = "Bitminer Equipment",
        cmd = "buydirtcleanfluid",
    })
end	
hook.Add( "loadCustomDarkRPItems", "CH_BITMINERS_DarkRPEntities", CH_BITMINERS_DarkRPEntities )	--]]