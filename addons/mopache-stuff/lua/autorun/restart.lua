local mat = Material'icon16/error.png'
local restart_text = "Сервер будет перезапущен через несколько минут!"

function show_restart_message ()
	
	if not GetGlobalBool('restart_near', false) then return end

	local w, h = 300, 120

	surface.SetDrawColor(255,255,255,2555)
	surface.DrawOutlinedRect(ScrW()/2-150,50,w,h)

	draw.RoundedBox(0, ScrW()/2-150, 50, w, h, Color(54,54,54,200))

	surface.SetMaterial(mat)
	surface.SetDrawColor(255,255,255)
	surface.DrawTexturedRect(ScrW()/2,60,16,16)
	
	surface.SetDrawColor(255,0,0,math.sin(CurTime()*2)*255)
	surface.DrawTexturedRect(ScrW()/2,60,16,16)

	local wrap_text = DarkRP.textWrap( restart_text, "DarkRPHUD1", w-100)

	draw.DrawText( 'Внимание!', 'DarkRPHUD2', ScrW()/2, 80, Color(200,54,54), TEXT_ALIGN_CENTER)
	draw.DrawText( wrap_text, 'DarkRPHUD1', ScrW()/2, 122, Color(200,54,54), TEXT_ALIGN_CENTER)
end

hook.Add( 'HUDPaint', 'PreRestartMessage', show_restart_message)

if SERVER then
concommand.Add( '_pgrp-restart', function( ply, cmd, args, argStr )
	print(ply, cmd, args, argStr)
	
	-- Make sure it's not a player running this command
	if IsValid(ply) then 
		-- ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-restart] ', Color( 255, 255, 255 ), 'Данную команду можно использовать только через консоль сервера!' )
		return 
	end
	
	-- Tell the hook that it's time to restart
	SetGlobalBool("restart_near", true)

end, nil, nil, FCVAR_SERVER_CAN_EXECUTE)
end