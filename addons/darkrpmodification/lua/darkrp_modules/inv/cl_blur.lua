module( 'gp_inv', package.seeall )


local blurs = Material( "pp/blurscreen" )
function blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blurs )

	for i = 1, 3 do
		blurs:SetFloat( "$blur", ( i / layers ) * density )
		blurs:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end
