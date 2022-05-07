local message = 'Данная команда пока-что на переработке'

function print_ustav (ply, text, teamChat) 
	if IsValid(ply) then
		if text == "!ustav" then
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-Устав] ', Color( 255, 255, 255 ), message )
			return ""
		end
	end
end

hook.Add( "PlayerSay", "show_ustav", print_ustav )