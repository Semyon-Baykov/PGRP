local defaultblocked = {
"models/cranes/crane_frame.mdl",
"models/items/item_item_crate.mdl",
"models/props/cs_militia/silo_01.mdl",
"models/props/cs_office/microwave.mdl",
"models/props/de_train/biohazardtank.mdl",
"models/props_buildings/building_002a.mdl",
"models/props_buildings/collapsedbuilding01a.mdl",
"models/props_buildings/project_building01.mdl",
"models/props_buildings/row_church_fullscale.mdl",
"models/props_c17/consolebox01a.mdl",
"models/props_c17/oildrum001_explosive.mdl",
"models/props_c17/paper01.mdl",
"models/props_c17/trappropeller_engine.mdl",
"models/props_canal/canal_bridge01.mdl",
"models/props_canal/canal_bridge02.mdl",
"models/props_canal/canal_bridge03a.mdl",
"models/props_canal/canal_bridge03b.mdl",
"models/props_combine/combine_citadel001.mdl",
"models/props_combine/combine_mine01.mdl",
"models/props_combine/combinetrain01.mdl",
"models/props_combine/combinetrain02a.mdl",
"models/props_combine/combinetrain02b.mdl",
"models/props_combine/prison01.mdl",
"models/props_combine/prison01c.mdl",
"models/props_industrial/bridge.mdl",
"models/props_junk/garbage_takeoutcarton001a.mdl",
"models/props_junk/gascan001a.mdl",
"models/props_junk/glassjug01.mdl",
"models/props_junk/trashdumpster02.mdl",
"models/props_phx/amraam.mdl",
"models/props_phx/ball.mdl",
"models/props_phx/cannonball.mdl",
"models/props_phx/huge/evildisc_corp.mdl",
"models/props_phx/misc/flakshell_big.mdl",
"models/props_phx/misc/potato_launcher_explosive.mdl",
"models/props_phx/mk-82.mdl",
"models/props_phx/oildrum001_explosive.mdl",
"models/props_phx/torpedo.mdl",
"models/props_phx/ww2bomb.mdl",
"models/props_wasteland/cargo_container01.mdl",
"models/props_wasteland/cargo_container01.mdl",
"models/props_wasteland/cargo_container01b.mdl",
"models/props_wasteland/cargo_container01c.mdl",
"models/props_wasteland/depot.mdl",
"models/xqm/coastertrack/special_full_corkscrew_left_4.mdl",
"models/props_foliage/tree_springers_card_01.mdl",
"models/props_junk/propane_tank001a.mdl",
"models/props_building_details/Storefront_Template001a_Bars.mdl",
'models/props_building_details/storefront_template001a_bars.mdl',
'models/props_c17/TrapPropeller_Blade.mdl',
'models/props_junk/sawblade001a.mdl',
'models/press_printer/press_printer.mdl',
'models/props_phx/construct/metal_dome360.mdl',
'models/props_phx/construct/windows/window_dome360.mdl',
'models/props_phx/construct/glass/glass_dome360.mdl',
'models/props_phx/construct/wood/wood_dome360.mdl',
'models/hunter/blocks/cube4x4x2.mdl',
'models/hunter/blocks/cube4x4x4.mdl',
'models/hunter/blocks/cube4x6x2.mdl',
'models/hunter/blocks/cube4x6x4.mdl',
'models/hunter/blocks/cube4x6x6.mdl',
'models/hunter/blocks/cube6x6x2.mdl',
'models/hunter/blocks/cube6x6x6.mdl',
'models/hunter/blocks/cube6x8x2.mdl',
'models/hunter/tubes/circle2x2.mdl'

}

local blocked, whitelisted = {}, {}

for k,v in ipairs( defaultblocked ) do
	blocked[v] = true
end

/*---------------------------------------------------------------------------
Prevents spawning a prop or effect when its model is blocked
---------------------------------------------------------------------------*/
local function propSpawn(ply, model)
    if blocked[model] then
        DarkRP.notify(ply, 1, 4, "Модель этого пропа заблокирована!")
        return false
    end
end

local function propSpawned(ply, _, ent)
	--print( _, ent, ent:BoundingRadius() )
	if ent:BoundingRadius() > 250 then
		if ply.buildermod == true then return end
		DarkRP.notify(ply, 1, 4, "Ваш проп был удален, т.к он слишком большой")
		ent:Remove()
	end

	for k,v in ipairs( ents.FindInSphere( ent:GetPos(), ent:BoundingRadius() ) ) do
		if v:IsVehicle() then
			ent:Remove()
			return
		end
	end

end

hook.Add("PlayerSpawnedProp", "FPP_SpawnProp", propSpawned)
hook.Add("PlayerSpawnObject", "FPP_SpawnEffect", propSpawn) -- prevents precaching
hook.Add("PlayerSpawnProp", "FPP_SpawnProp", propSpawn) -- PlayerSpawnObject isn't always called
hook.Add("PlayerSpawnEffect", "FPP_SpawnEffect", propSpawn)
hook.Add("PlayerSpawnRagdoll", "FPP_SpawnEffect", propSpawn)
