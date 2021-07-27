hook.Add( 'RenderScreenspaceEffects', 'RenderScreenspaceEffects', function()

	local tab = { }

	tab[ "$pp_colour_addr" ] 		= 0
	tab[ "$pp_colour_addg" ] 		= 0
	tab[ "$pp_colour_addb" ] 		= 0
	tab[ "$pp_colour_brightness" ] 	= 0
	tab[ "$pp_colour_contrast" ] 	= 1
	tab[ "$pp_colour_colour" ] 		= 1.5
	tab[ "$pp_colour_mulr" ] 		= 0
	tab[ "$pp_colour_mulg" ] 		= 0
	tab[ "$pp_colour_mulb" ] 		= 0
	DrawColorModify( tab )

end )