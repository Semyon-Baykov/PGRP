------------------------------------------------------
--      _     _                            _        --
--     | |   (_)                          | |       --
--  ___| |__  _ _ __  _ __ ___   ___ _ __ | |_ ___  --
-- / __|  _ \| |  _ \|  _   _ \ / _ \  _ \| __/ __| --
-- \__ \ | | | | |_) | | | | | |  __/ | | | |_\__ \ --
-- |___/_| |_|_|  __/|_| |_| |_|\___|_| |_|\__|___/ --
--             | |                                  --
--             |_|                 by TylerB.       --
------------------------------------------------------

-- AddCSLuaFile("cl_shipments_tylerb.lua") -- pretty sure wire does it already but just to be safe...

local shipments = CustomShipments

local broken = 
	{
		amount		=	-1,
		price		=	-1,
		pricesep	=	-1,
		noship		=	false,
		entity		=	"invalid_shipment",
		model		=	"models/error.mdl",
		separate	=	false,
		name		=	"Invalid Shipment",
	}

local function getTable(ent)
	-- usually we would do validity checks, but we added support for string identifiers.
	
	if ent == NULL then return broken end
	if ent == nil then return broken end
	
	for k,v in ipairs(shipments) do
		if (IsEntity(ent) and (v.entity == ent:GetClass() or (ent.Getcontents and k == ent:Getcontents()) or (ent.GetWeaponClass and v.entity == ent:GetWeaponClass()))) or (not IsEntity(ent) and (string.lower(v.entity) == string.lower(ent) or string.lower(v.name) == string.lower(ent))) then
			return v
		end
	end
	
	return broken
end

local function getCount(ent)
	if not IsValid(ent) then return -1 end
	if ent:GetClass() != "spawned_shipment" then return -1 end
	
	return ent:Getcount()
end

--------

e2function string entity:shipmentName()
	return getTable(this).name
end

e2function string shipmentName(string str) -- if you have the class or something
	return getTable(str).name
end

----

e2function normal entity:isShipment()
	if not IsValid(this) then return 0 end
	if this:GetClass() == "spawned_shipment" then return 1 end
	return 0
end

----

e2function string entity:shipmentType()
	return getTable(this).entity
end

e2function string shipmentType(string str)
	return getTable(str).entity
end

----

e2function string entity:shipmentClass() -- alias of shipmentType()
	return getTable(this).entity
end

e2function string shipmentClass(string str)
	return getTable(str).entity
end

----

e2function normal entity:shipmentSize() -- size of orig shipment
	return getTable(this).amount
end

e2function normal shipmentSize(string str) -- size of orig shipment
	return getTable(str).amount
end

----

e2function normal entity:shipmentAmount() -- remaining in current shipment
	return getCount(this)
end

-- note: we do not need a string version of this, that would be useless.

----

e2function string entity:shipmentModel()
	return getTable(this).model
end

e2function string shipmentModel(string str)
	return getTable(str).model
end

----

e2function normal entity:shipmentPrice()
	return (getTable(this).price) and getTable(this).price or 0
end

e2function normal shipmentPrice(string str)
	return (getTable(str).price) and getTable(str).price or 0
end

----

e2function normal entity:shipmentSeparate()
	return getTable(this).separate and 1 or 0
end

e2function normal shipmentSeparate(string str)
	return getTable(str).separate and 1 or 0
end

-- add a misspelled version just to cover our bases

e2function normal entity:shipmentSeperate()
	return getTable(this).separate and 1 or 0
end

e2function normal shipmentSeperate(string str)
	return getTable(str).separate and 1 or 0
end

----

e2function normal entity:shipmentPriceSep()
	return (getTable(this).pricesep) and getTable(this).pricesep or 0
end

e2function normal shipmentPriceSep(string str)
	return (getTable(str).pricesep) and getTable(str).pricesep or 0
end

--------

print("Loaded TylerB's shipment e2 functions.")