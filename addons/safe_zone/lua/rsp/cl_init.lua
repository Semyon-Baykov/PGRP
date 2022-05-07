
surface.CreateFont( "SafeZoneBig", {
	font = "Trebuchet MS",
	size = 35,
	weight = 400,
	antialias = true,
} )

surface.CreateFont( "SafeZoneSmall", {
	font = "Trebuchet MS",
	size = 25,
	weight = 400,
	antialias = true,
} )

concommand.Add( "rsp_view_all", function()
	hook.Add( "PostDrawOpaqueRenderables", "rspRenderZones", function()
		for k,v in pairs( RSP.Data ) do
			render.DrawWireframeBox( v.Center, Angle( 0, 0, 0 ), v.SizeBackwards, v.SizeForwards, color_white, true )
		end
	end )
end )

timer.Create( "rsp_manage", 1, 0, function()
	if ( !IsValid( LocalPlayer() ) or !LocalPlayer().GetPos ) then return end
	
	RSP.DrawHUD = RSP:InsideSafeZone( LocalPlayer():GetPos() )
end )
