module( 'gp_mp', package.seeall )

local meta = FindMetaTable( 'Entity' )

tbl = {
	[1] = { name = 'Bomj tier', color = Color( 134, 0, 0, 100 ) },
	[2] = { name = 'Medium tier', price = 2500, color = Color( 255, 215, 0, 100 ) },
	[3] = { name = 'God tier', price = 5500, color = Color( 0, 125, 0, 100 ) }
}

function meta:GetCash()

	local tbl = util.JSONToTable(self:GetNWString( 'gp_mp.info', '{}' ))

	return tbl.cash or 0

end