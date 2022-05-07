module( 'gp_wep', package.seeall )

util.AddNetworkString( 'prg_arsm' )
util.AddNetworkString( 'prg_arsm_get' )
local meta = FindMetaTable( 'Player' )


function meta:isvip()

	return self:IsSecondaryUserGroup("premium")

end