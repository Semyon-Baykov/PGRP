local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/craphead_scripts/bitminers/rack/rack.mdl")
ITEM:SetDescription( function( self, item, ent )
	local tbl = {}
	
	local miners_allowed = item.data.MinersAllowed
	local miners_installed = item.data.MinersInstalled
	local ups_installed = item.data.UPSInstalled
	local fans_installed = item.data.FansInstalled
	local rgb_installed = item.data.RGBInstalled
	local temperature = item.data.Temperature
	local bitcoins_mined = item.data.BitcoinsMined
	local health = item.data.Health
	
	tbl[#tbl + 1] = "Shelf used to operate bitminers"
	
	if miners_allowed then
		tbl[#tbl + 1] = "Miners Allowed: ".. miners_allowed
	end
	
	if miners_installed then
		tbl[#tbl + 1] = "Miners Installed: ".. miners_installed
	end
	
	if ups_installed then
		tbl[#tbl + 1] = "UPS's Installed: ".. ups_installed
	end
	
	if fans_installed then
		tbl[#tbl + 1] = "Cooling Level: ".. fans_installed
	end
	
	if rgb_installed then
		tbl[#tbl + 1] = "RGB Installed: Yes"
	else
		tbl[#tbl + 1] = "RGB Installed: No"
	end
	
	if temperature then
		tbl[#tbl + 1] = "Shelf Temperature: ".. math.Round( temperature, 2 ) .."c"
	end
	
	if health then
		tbl[#tbl + 1] = "Health: ".. health .."%"
	end
	
	if bitcoins_mined then
		tbl[#tbl + 1] = "Bitcoins Mined: ".. math.Round( bitcoins_mined, 2 ) .." ("..DarkRP.formatMoney( math.Round( bitcoins_mined * CH_Bitminers.Config.BitcoinRate ) ) ..")"
	end
	
	return tbl
end )
	

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
	ent:CPPISetOwner( ply )
	
	-- Set default values
	ent:SetHP( data.Health )
	ent:SetMinersInstalled( data.MinersInstalled )
	ent:SetMinersAllowed( data.MinersAllowed )
	
	ent:SetUPSInstalled( data.UPSInstalled )
	ent:SetFansInstalled( data.FansInstalled )
	ent:SetTemperature( data.Temperature )
	ent:SetBitcoinsMined( data.BitcoinsMined )
	
	ent:SetRGBInstalled( data.RGBInstalled )

	-- Initialize bodygroups and skin
	for i = 1, data.MinersInstalled do 
		ent:SetBodygroup( i, 1 ) -- Miners
	end
	ent:SetBodygroup( 17, data.UPSInstalled ) -- UPS's
	ent:SetBodygroup( 18, data.FansInstalled ) -- Fans
	
	if data.RGBInstalled then
		ent:SetSkin( 2 ) -- white fans
	end
end)

function ITEM:GetData(ent)
    return {
		MinersAllowed = ent:GetMinersAllowed(),
		MinersInstalled = ent:GetMinersInstalled(),
		UPSInstalled = ent:GetUPSInstalled(),
		FansInstalled = ent:GetFansInstalled(),
		BitcoinsMined = ent:GetBitcoinsMined(),
		RGBInstalled = ent:GetRGBInstalled(),
		Temperature = ent:GetTemperature(),
		Health = ent:GetHP(),
    }
end

function ITEM:GetName(item)
	return "Bitminer Shelf"
end

ITEM:Register("ch_bitminer_shelf")
