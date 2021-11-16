if CLIENT then return end
resource.AddSingleFile( "materials/icons/cf_tobacco.png" ) 
resource.AddSingleFile( "materials/icons/cf_paper.png" ) 
resource.AddSingleFile( "materials/icons/cf_engine_upgrade.png" ) 
resource.AddSingleFile( "materials/icons/cf_storage_upgrade.png" )
resource.AddSingleFile( "sound/cigarette_factory/cf_machine_loop.wav" )  
resource.AddSingleFile( "sound/cigarette_factory/cf_machine_eject.wav" )  
resource.AddSingleFile( "sound/cigarette_factory/cf_sell.wav" )  

util.AddNetworkString( "cf_notification" )

local function SendNotification(ply, notifytype, duration, text)
	net.Start( "cf_notification" )
		net.WriteInt( notifytype, 16 )
		net.WriteInt( duration, 16 )
		net.WriteString( text ) 
	net.Send( ply )
end

local function InitSpawnVars( ply )
	ply.cfCigsAmount = 0
	ply.cfCanPickUp = true
end
hook.Add( "PlayerSpawn", "cf_init_vars", InitSpawnVars )

local function CreateCigBox(amt, ply)
	if(ply.cfCigsAmount<=0) then return end
	CigBox=ents.Create("cf_delievery_box")
	CigBox:SetPos(ply:GetPos())
	CigBox:SetAngles(ply:GetAngles())
	CigBox:Spawn()
	CigBox.cigsStored = amt
end

local function SpawnDeathBoxes( ply )
	-- while(ply.cfCigsAmount>0) do
		-- if(ply.cfCigsAmount>=cf.maxCigsBox) then
			-- ply.cfCigsAmount = ply.cfCigsAmount - cf.maxCigsBox
			-- CreateCigBox(cf.maxCigsBox, ply)
		-- else
			-- CreateCigBox(ply.cfCigsAmount, ply)
			-- ply.cfCigsAmount = 0
		-- end
	-- end
	if(!IsValid(ply)) then return end
	CreateCigBox(ply.cfCigsAmount, ply)
	ply.cfCigsAmount = 0
end
hook.Add( "PlayerDeath", "cf_spawn_death_boxes", SpawnDeathBoxes )

concommand.Add( "cf_save", function(ply, command, args)
	if !ply:IsAdmin() then return end

	local Vans = {}
	for k, v in pairs( ents.GetAll() ) do
		if(v:GetClass()=="cf_export_van") then 
			Vans[k] = { pos = v:GetPos(), ang = v:GetAngles() }
		end
	end
	local tab = util.TableToJSON( Vans )
	file.Write( "cf_van_list.txt", tab ) 

	SendNotification(ply, 0, 5, cf.CommandText1)
end)

local function load_vans()
	if(file.Read( "cf_van_list.txt", "DATA" )!=nil) then
		local Vans = {}
		local Vans = util.JSONToTable( file.Read( "cf_van_list.txt", "DATA" ) )
		for k, v in pairs( Vans ) do
			Van=ents.Create("cf_export_van")
			Van:SetPos(v.pos )
			Van:SetAngles(v.ang)
			Van:Spawn() 
			Van:GetPhysicsObject():EnableMotion( false ) 
		end
	end
end

concommand.Add( "cf_load", function(ply, command, args)
	if !ply:IsAdmin() then return end
	load_vans()
	SendNotification(ply, 0, 5, cf.CommandText2)
end)

hook.Add( "InitPostEntity", "cf_spawn_vans", function()
	load_vans()
end)

hook.Add( "PostCleanupMap", "cf_spawn_vans_cleanup", function()
	if(!cf.AutoRespawn) then return end
	load_vans()
end)