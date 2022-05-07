module( 'gpgift', package.seeall )
--[[tbl = {
	['STEAM_0:0:126563194'] = {
		func = function( ply )			
			ply:AddDefInvItem( 'tfa_dragunov', 1 )
			ply:addMoney( 250000 )
			ply:ChatAddText( Color( 255, 187, 0 ), '[GPortalRP] ', color_white, 'Вы получили подарок в знак благодарности за пожертвование на открытие сервера. Содержимое: 250.000р игровой валюты, x1 СВД\nСпасибо за пожертвование ♥' )
		end,
	},
	['STEAM_0:0:148384115'] = {
		func = function( ply )			
			ply:AddDefInvItem( 'tfa_mosin9130', 1 )
			ply:addMoney( 200000 )
			ply:ChatAddText( Color( 255, 187, 0 ), '[GPortalRP] ', color_white, 'Вы получили подарок в знак благодарности за пожертвование на открытие сервера. Содержимое: 200.000р игровой валюты, x1 Винтовка мосина\nСпасибо за пожертвование ♥' )
		end,
	},
	['STEAM_0:0:103956682'] = {
		func = function( ply )			
			ply:AddDefInvItem( 'tfa_dragunov', 1 )
			ply:AddDefInvItem( 'tfa_mosin9130', 1 )
			ply:addMoney( 250000 )
			ply:AddCar( 'crsk_zaz_968m', false, color_white, 'а777уе' )
			ply:ChatAddText( Color( 255, 187, 0 ), '[GPortalRP] ', color_white, 'Вы получили подарок в знак благодарности за пожертвование на открытие сервера. Содержимое: 250.000р игровой валюты, x1 Винтовка мосина, 1x СВД, Запорожец\nСпасибо за пожертвование ♥' )
		end,
	},
	['STEAM_0:1:84968477'] = {
		func = function( ply )			
			ply:AddDefInvItem( 'tfa_dragunov', 1 )
			ply:AddDefInvItem( 'tfa_mosin9130', 1 )
			ply:addMoney( 250000 )
			ply:AddCar( 'crsk_zaz_968m', false, color_white, 'а777уе' )
			ply:ChatAddText( Color( 255, 187, 0 ), '[GPortalRP] ', color_white, 'Вы получили подарок в знак благодарности за пожертвование на открытие сервера. Содержимое: 250.000р игровой валюты, x1 Винтовка мосина, 1x СВД, Запорожец\nСпасибо за пожертвование ♥' )
		end,
	},
	['STEAM_0:1:147710354'] = {
		func = function( ply )			
			ply:AddDefInvItem( 'tfa_dragunov', 1 )
			ply:AddDefInvItem( 'tfa_mosin9130', 1 )
			ply:addMoney( 250000 )
			ply:ChatAddText( Color( 255, 187, 0 ), '[GPortalRP] ', color_white, 'Вы получили подарок в знак благодарности за пожертвование на открытие сервера. Содержимое: 250.000р игровой валюты, x1 СВД, x1 Винтовка мосина\nСпасибо за пожертвование ♥' )
		end,
	},
	['STEAM_0:1:169165404'] = {
		func = function( ply )			
			ply:AddDefInvItem( 'tfa_mosin9130', 1 )
			ply:addMoney( 200000 )
			ply:ChatAddText( Color( 255, 187, 0 ), '[GPortalRP] ', color_white, 'Вы получили подарок в знак благодарности за пожертвование на открытие сервера. Содержимое: 200.000р игровой валюты, x1 Винтовка мосина\nСпасибо за пожертвование ♥' )
		end,
	},
}


hook.Add( 'PlayerSay', 'gpgift', function( ply, text, public )
	if string.sub(text, 1, 5) == "!gift" then
		if tbl[ ply:SteamID() ] and ply:GetPData( 'gifted', false ) == false then
			tbl[ply:SteamID()].func( ply )
			ply:SetPData( 'gifted', true )
			return
		end
	end
end)--]]