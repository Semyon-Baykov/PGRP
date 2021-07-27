hook.Add( 'PlayerSay', 'gp_AdminChat', function( ply, text, public )


	if string.sub(text, 1, 3) == "///" and not ( ply:GetUserGroup() == 'moder' or ply:gp_IsAdmin() ) then
		
		ply:ChatAddText( Color( 255, 0, 0 ), '[Связь с администрацией] ', Color( 255,255,255 ), 'Вы отправили сообщение: '..string.sub(text, 4) )
		for k,v in pairs( player.GetAll() ) do
			if v:GetUserGroup() == 'moder' or v:gp_IsAdmin() then
				v:ChatAddText( Color( 255,0,0 ), '[Связь с администрацией] ', team.GetColor(ply:Team()), ply:Nick(), ': ', Color( 255,255,255 ),  string.sub(text, 4) )
			end
		end
		return ''


	end



	if string.sub(text, 1, 3) == "///" and  ( ply:GetUserGroup() == 'moder' or ply:gp_IsAdmin() ) then

		for k,v in pairs( player.GetAll() ) do
			if v:GetUserGroup() == 'moder' or v:gp_IsAdmin() then
				v:ChatAddText( Color( 255,0,0 ), '[Админ-чат]',Color( 255,255,255 ), ' ['..ply:GetUserGroup()..'] ',team.GetColor(ply:Team()), ply:Nick(), ':', Color( 255,255,255 ),  string.sub(text, 4))
			end
		end
		return ''

	end
end )