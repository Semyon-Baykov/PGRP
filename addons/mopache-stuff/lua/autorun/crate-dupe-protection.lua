AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_crate_dupe_protection") then CreateConVar( "pgrp_crate_dupe_protection", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end

local cr_count = 0
hook.Add("playerBoughtShipment", "crate_dupe_protection_onbought", function (ply, tbl, ent, price) 
	cr_count = cr_count + 1
	
	if cr_count > 10 then
		ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-багоюз] ', Color( 255, 255, 255 ), 'Вы привысилы номер допустимых заспавненых поставок на сервере!' )
		-- cr_count = cr_count - 1
		ent:Remove()
		ply:addMoney(price)
		print("Removing shipment due to the limit")
	end
end )
hook.Add("onShipmentRemoved", "crate_dupe_protection_onbought2", function (ply, tbl, ent, price) 
	cr_count = cr_count - 1
	print("Shipments after removal: "..cr_count)
end )