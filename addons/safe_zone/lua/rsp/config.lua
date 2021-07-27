RSP.Data = {}

// use rsp_view_all in console to view all safe zones.

RSP:AddNewZone( "rp_downtown_v8g_gp", {
	Center = Vector( -2532.693115 -2616.245361 -131.968750 ),
	SizeBackwards = Vector( 300, -15, 0 ),
	SizeForwards = Vector( -300, 15, 300 )
} )

--[[
	RSP:AddNewZone( MAP, {
		Center = CENTER OF BOX,
		SizeBackwards = SIZE, GOING BACKWARDS,
		SizeForwards = SIZE, GOING FORWARDS
	} )
]]