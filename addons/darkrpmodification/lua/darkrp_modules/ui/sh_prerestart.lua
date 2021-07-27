if CLIENT then
	local mat = Material'icon16/error.png'

	local restart_text = "Сервер будет перезапущен через несколько минут!"

	hook.Add( 'HUDPaint', 'Restart', function()
		if GetGlobalBool( 'restart_near', false ) == false then
			return
		end

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
	end)
else
	concommand.Add( '_prerestart', function(d)
		if IsValid(d) then return end
		SetGlobalBool("restart_near", true)
		BroadcastLua[[surface.PlaySound("sound/blip1.wav")]]
	end, nil, nil, FCVAR_SERVER_CAN_EXECUTE)
end