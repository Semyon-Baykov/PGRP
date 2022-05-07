util.AddNetworkString( 'gp_vehsys.RadioSet' )


local function IsPlayerDriving( ply )

	return ply:GetSimfphys() and ply:GetSimfphys():GetDriver() and ply:GetSimfphys():GetDriver() == ply

end

net.Receive( 'gp_vehsys.RadioSet', function( _, ply )

	if not IsPlayerDriving( ply ) then
		return
	end

	local channel = net.ReadInt( 7 )

	ply:GetSimfphys():SetNWInt( 'wcr_station', channel )

end )