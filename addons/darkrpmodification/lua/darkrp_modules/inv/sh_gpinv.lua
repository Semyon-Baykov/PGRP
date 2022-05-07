module( 'gp_ninv', package.seeall )

items = items or {}
maxweight = 15

local meta = FindMetaTable( 'Player' )

function meta:GetMaxWeight()

	return self:GetNWInt( 'maxweight', 20 ) or 20

end

function inv_AddNewItem( class, name, model, desc, weight, spawn, use, OnDropi, OnUse, notake )

	items[ class ] = {
		name = name,
		model = model,
		desc = desc or '',
		weight = weight or 0.1,
		spawn = spawn or false,
		use = use or false,
		notake = notake or false
	}

	if SERVER then
		if spawn then
			items[class].OnSpawn = OnDropi
		end
		if use then
			items[class].OnUse = OnUse
		end
	end

end

hook.Add( 'loadCustomDarkRPItems', 'gpinv_load', function()
for k,v in pairs(CustomShipments) do
   inv_AddNewItem(v.entity, v.name, v.model, '', 1, true, true, 
   function( ply, item, amount )
   	    local _ = ents.Create( 'spawned_shipment' )
   	    _:SetModel(items[item].model)
   	    local shipID
	    for k,v in pairs(CustomShipments) do
	        if v.entity == item then
	            shipID = k
	            break
	        end
	    end
		_:SetContents( shipID, amount )
		_:Spawn()
		_:Activate()
		
		local pos, mins = _:GetPos(), _:WorldSpaceAABB()
		local offset = pos.z - mins.z
		
		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply
		
		local tr = util.TraceLine(trace)
		_:SetPos(tr.HitPos + Vector(0, 0, offset))
		
		local phys = _:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end

   end, function( ply, item ) 
   		ply:Give( item ) 
   	end)
end


inv_AddNewItem( 'gp_klad', 'Клад', 'models/props_junk/garbage_bag001a.mdl', '', 1, false, false, function() end, function() end )
inv_AddNewItem( 'gp_truegift', 'Кейс Багоюзера', 'models/items/cs_gift.mdl', '', 1, false, true, function() end, function( ply, item ) //изменить название

	ply:OpenCase( 'Кейс Багоюзера' )

end, true )

inv_AddNewItem( 'ent_radio', 'Рация', 'models/radio/w_radio.mdl', '', 1, true, true, function( ply, item )

	local radio = ents.Create( 'ent_radio' )
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	radio:SetPos(tr.HitPos + Vector(0, 0, offset))
	radio:SetModel( 'models/radio/w_radio.mdl' )
	radio:Setowning_ent( ply )	
	radio:Spawn()

end, function( ply )
	
	ply:SetNWBool( 'gp_radio', true )
	ply:SetNWBool( 'gp_radio_off', false )
	DarkRP.notify(ply, 2, 6, 'Нажмите "B" для использования рации')

end )

inv_AddNewItem( 'ge_armor', 'Бронежилет', 'models/weapons/armor/armor.mdl', '', 1, true, true, function( ply, item )

	local radio = ents.Create( 'ge_armor' )
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	radio:SetPos(tr.HitPos + Vector(0, 0, offset))
	radio:SetModel( 'models/weapons/armor/armor.mdl' )
	radio:Spawn()

end, function( ply )
	
	ply:SetArmor( 100 )

end )



inv_AddNewItem( 'spawned_food', 'Хлеб', 'models/props_misc/bread-4.mdl', '', 1, true, true, function( ply, item )

	local bread_models = {
		'models/props_misc/bread-1.mdl',
		'models/props_misc/bread-1b.mdl',
		'models/props_misc/bread-2.mdl',
		'models/props_misc/bread-3.mdl',
		'models/props_misc/bread-4.mdl'

	}
	local bread = ents.Create( 'spawned_food' )
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply
	
	local tr = util.TraceLine(trace)
	bread:SetPos(tr.HitPos + Vector(0, 0, offset))
	bread:SetModel( table.Random( bread_models ) )
	bread:Setowning_ent( ply )	

	if math.random( 1, 3 ) == 3 then bread:SetColor( Color( 103, 84, 31 ) ) end

	bread.FoodName = 'Украiнский Хлiб'
	bread.FoodEnergy = 70
	bread.FoodPrice = 100 

	bread.foodItem = { model = 'models/props_misc/bread-1.mdl', energy = 70, price = 100, name = 'Украiнский Хлiб' }

	bread:Spawn()

end, function( ply, item ) ply:SetEnergy( ply:getDarkRPVar('Energy')+70 ) end )


local meta = FindMetaTable( 'Player' )
function meta:CalcInvWeight()

	local a = 0
	for k,v in pairs( self.inventory or gpinvitems ) do
		if v.class then
			a = a + (items[v.class].weight*v.amount)
		end
	end
	return a
end

end)

if CLIENT then

function CalcInvWeight()

	local a = 0
	for k,v in pairs(gpinvitems ) do
		if v.class then
			a = a + (items[v.class].weight*v.amount)
		end
	end
	return a
end
end