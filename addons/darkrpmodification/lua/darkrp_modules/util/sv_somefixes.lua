hook.Add('CanPlayerSuicide','Nenadokillyastsyablyatmydaki', function(ply)
	return false
end )

hook.Add( 'playerSellVehicle', 'no_sell_vehicles', function( ply, ent )
	
	if ent:IsVehicle() then
		return false, 'Продать транспорт можно только через терминал'
	end
 
end )

hook.Add( 'canBuyCustomEntity', 'jail_buyFix', function( ply, ent )

	if ply.jail != nil then
		DarkRP.notify(ply, 1, 4, "Вы не можете купить это, находясь в jail!")
		return false
	end

end )