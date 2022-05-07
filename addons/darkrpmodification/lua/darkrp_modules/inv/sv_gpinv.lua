module( 'gp_ninv', package.seeall )


util.AddNetworkString( 'gp_ninv_update' )
util.AddNetworkString( 'gp_ninv_setslot' )
util.AddNetworkString( 'gp_ninv_act' )

local meta = FindMetaTable( 'Player' )

local slots = 12

function meta:LoadGPInv()

	self.inventory = util.JSONToTable( self:GetPData( 'gp_inventoryitems_new', '[]' ) )

	self:SetNWInt( 'maxweight', self:GetUPG('bag') and 45 or 20 )

	if #self.inventory <= 0 then
		for i = 1, slots do
			self.inventory[i] = {}
		end
		self:SaveGPInv()
	end
	net.Start( 'gp_ninv_update' )
		net.WriteTable( self.inventory )
	net.Send( self )

end

function meta:SaveGPInv()

	self:SetPData( 'gp_inventoryitems_new', util.TableToJSON( self.inventory ) )

	net.Start( 'gp_ninv_update' )
		net.WriteTable( self.inventory )
	net.Send( self )

end


function meta:GetSlotIDByClass( class, amount )

	local inv = self.inventory
	if not items[class] then return end

	local item = items[class]

	for k,v in pairs( inv ) do
		if v.class and v.class == class then
			return k
		end
	end

end

function meta:GetEmplySlot( class, amount )

	if not items[class] then return end

	local item = items[class]

	local inv = self.inventory

	if self:GetSlotIDByClass( class, amount ) then
		return self:GetSlotIDByClass( class, amount )
	else
		for k,v in pairs( inv ) do
			if not inv[k].class then
				return k
			end 
		end	
	end
	return false

end

function meta:AddDefInvItem( class, amount )
	
	if not items[class] then return end
	if self:CalcInvWeight() >= self:GetMaxWeight()  or self:CalcInvWeight() + ( items[class].weight*amount ) > self:GetMaxWeight() then
		DarkRP.notify( self, 1, 10, 'Недостаточно места в инвентаре!' )
		return false
	end 

	local sl = self:GetEmplySlot( class, amount )

	if sl != false then
		if self.inventory[sl].class then
			self.inventory[sl].amount = self.inventory[sl].amount + amount
			self:SaveGPInv()
			return true
		else
			self.inventory[sl] = {
				class = class,
				amount = amount
			}
			self:SaveGPInv()
			return true
		end
	else
		DarkRP.notify( self, 1, 10, 'Недостаточно места в инвентаре!' )
		return false
	end
end

function meta:GetSlotByClass( class )

	local inv = self.inventory

	for k,v in pairs( inv ) do
		if v.class == class then
			return k
		end
	end
	
end

function meta:SetItemSlot( class, slot )

	local inv = self.inventory
	local setitemslot = self:GetSlotByClass( class )
	if inv[slot].class then
		local item1 = inv[slot]
		local item2 = inv[setitemslot]

		inv[slot] = item2
		inv[setitemslot] = item1
		self:SaveGPInv()
	else
		local item = inv[self:GetSlotByClass( class )]
		local setitemslot = self:GetSlotByClass( class )

		inv[setitemslot] = {}
		inv[slot] = item
		self:SaveGPInv()
	end

end

function meta:InvTakeItem( class, amount )

	local inv = self.inventory
	local slot = self:GetSlotByClass( class )

	if inv[slot].amount < amount then return false end

	if inv[slot].amount == amount then
		inv[slot] = {}
		self:SaveGPInv()
	else
		inv[slot].amount = inv[slot].amount - amount
		self:SaveGPInv()
	end
	return true

end

function meta:InvUse( class )

	if !items[class].notake and self:InvTakeItem( class, 1 ) then

		items[class].OnUse( self, class )

	else

		items[class].OnUse( self, class )

	end

end

function meta:InvDropItem( class, amount )

	if items[class].spawn == false then return end
	if amount < 1 then
		for i = 1, 10 do
			print( self:SteamID()..' '..self:Nick()..' попытался дюпнуть через инвентарь. Amount = '..amount )
		end
		return
	end
	if amount > 20 then
		for i = 1, 10 do
			print( self:SteamID()..' '..self:Nick()..' вероятно попытался дюпнуть через инвентарь. Amount = '..amount )
		end
		return
	end
	if self:getDarkRPVar('Arrested') then return end
	print(amount)
	if self:InvTakeItem( class, amount ) then

		items[class].OnSpawn( self, class, amount )

	end

end

function meta:InvPickupItem( entity )


	if not entity:IsValid() then return end

	local amount
	local class

	if entity:GetClass() == 'spawned_shipment' then
		amount = entity:Getcount()
		class = CustomShipments[entity:Getcontents()].entity
	elseif entity:GetClass() == 'spawned_weapon' then
		amount = entity:Getamount()
		if (entity.weaponclass) then class = entity.weaponclass end
		if (entity.GetWeaponClass) then class = entity:GetWeaponClass() end
	else
		amount = 1
		class = entity:GetClass()
	end

	if self:AddDefInvItem( class, amount ) then
		entity:Remove()
	end
end

net.Receive( 'gp_ninv_setslot', function( _, ply )

	local class = net.ReadString()
	local slot = net.ReadInt( 5 )

	ply:SetItemSlot( class, slot ) 
	print(class, slot)

end )

net.Receive( 'gp_ninv_act', function( _, ply )

	local act = net.ReadString()
	local item = net.ReadString()
	local amount = net.ReadInt( 7 )

	if act == 'use' then
		ply:InvUse( item )
	elseif act == 'drop' then
		ply:InvDropItem( item, amount )
	elseif act == 'remove' then
		ply:InvTakeItem( item, amount )
	end

end )


hook.Add( 'PlayerButtonDown', 'gp_pickupitem', function( ply, key )

	if key == KEY_T then
		local ent = ply:GetEyeTrace().Entity

		if ply:GetPos():DistToSqr(ent:GetPos()) >= (100 * 100) then return end

		if !IsValid( ent ) then return end

		ply:InvPickupItem( ent )

	end
end )

hook.Add( 'PlayerInitialSpawn', 'gp_inv_init', function( ply )

	ply:LoadGPInv()

end )