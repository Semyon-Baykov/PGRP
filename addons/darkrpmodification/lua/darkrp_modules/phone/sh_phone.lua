phone = phone or {}

phone.tag = 'gmphone'
phone.cl_tag = 'gmphone_cl'

phone.Ringtones = {
	default = true,
	noiwex = true,
	noiwex2 = true,
	vitas = true,
	pururin = true,
}

local sound_mat = Material( 'icon16/sound.png' )

phone.SelectRingtone = function()
	local fr = vgui.Create( 'gpFrame' )
	fr:SetSize( 300, 150 )
	fr:SetTitle( 'Выбрать рингтон' )
	fr:Center()
	fr:MakePopup()

	function fr:Close()
		if playing then
			RunConsoleCommand( 'play', '---------------------' ) -- kostyl time
		end
		fr:Remove()
	end

	local ringpanel = fr:Add( 'DPanel' )
	ringpanel:SetSize( 224, 24 )
	ringpanel:Center()

	local ringtones = ringpanel:Add( "DComboBox" )
	ringtones:SetSize(200, 24)
	ringtones:SetValue( LocalPlayer():GetNWString('phone_ringtone', 'default') )

	for k,v in pairs(phone.Ringtones) do
		ringtones:AddChoice( k )
	end

	local ringtone = ringtones:GetValue()

	ringtones.OnSelect = function(self,index,value)
		ringtone = value
	end

	local playbtn = ringpanel:Add( 'gpButton' )
	playbtn:SetSize( 24, 24 )
	playbtn:SetPos(200)
	playbtn:CenterVertical()
	playbtn:setText("")

	playbtn.PaintOver = function(self, w, h)
		surface.SetMaterial( sound_mat )
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect( 4, 4, 16, 16 )
	end

	playbtn.DoClick = function()
		playing = true
		RunConsoleCommand( 'play', 'gmchan/ringtones/'..ringtone..'.wav')
	end

	local save = fr:Add( 'gpButton' )
	save:SetSize( 100, 24 )
	save:SetPos( 0, 100 )
	save:CenterHorizontal()
	save:setText("Сохранить")

	save.DoClick = function()
		RunConsoleCommand( 'darkrp', 'ringtone', ringtone )
		fr:Close()
	end

end

DarkRP.declareChatCommand{
	command = "call",
	description = "Позвонить игроку",
	delay = 1.5
}

DarkRP.declareChatCommand{
	command = "phone_reply",
	description = "Ответить на звонок",
	delay = 0
}

DarkRP.declareChatCommand{
	command = "phone_decline",
	description = "Ответить на звонок",
	delay = 0
}

DarkRP.declareChatCommand{
	command = "ringtone",
	description = "Сменить мелодию звонка",
	delay = 60
}

DarkRP.declareChatCommand{
	command = "toggleon_phone",
	description = "Включить телефон",
	delay = 5
}

DarkRP.declareChatCommand{
	command = "toggleoff_phone",
	description = "Выключить телефон",
	delay = 5
}

DarkRP.declareChatCommand{
	command = "taxi",
	description = "Вызвать такси",
	delay = 1.5
}

if CLIENT then
	phone.CreateVgui = function( ply, incoming, tmr )
		if phone.vgui then phone.vgui:Remove() end
		phone.vgui = vgui.Create( 'gpFrame' )
		phone.vgui:SetSize( 200, 100 )
		phone.vgui:AlignLeft(0.5)
		phone.vgui:SetTitle( 'Телефон' )
		phone.vgui:CenterVertical()
		phone.vgui.Close = function(self)
			self:Remove()
			RunConsoleCommand( 'darkrp', 'phone_decline')
		end
		
		local frame = phone.vgui

		local avatar = frame:Add( "AvatarImage" )
		avatar:SetPos(5,30)
		avatar:SetSize(40,40)
		avatar:SetPlayer(ply)

		local label = frame:Add( 'DLabel' )
		label:SetPos(55, 36)
		label:SetText( ply:GetName() )
		label:SizeToContents()

		if tmr then
			local starttime = CurTime()

			local timer = frame:Add( 'DLabel' )
			timer:SetPos(85, 2)
			timer.Think = function(self)
				local ct = math.floor( CurTime() - starttime )
				local timeformat = (ct>3600 and "%H:" or "") .. "%M:%S"
				if ct > 86400 then timeformat = 'охуел весь день звонить?' end
				self:SetText(os.date(timeformat, ct))
			end
		end

		local job = frame:Add( 'DLabel' )
		job:SetPos(55, 50)
		job:SetText( ply:getJobTable().name )
		job:SizeToContents()

		if incoming then

			local button1 = frame:Add( 'DButton' )
			button1:SetPos( 5, 75)
			button1:SetSize(95,20)
			button1:SetText('Принять')
			button1.DoClick = function()
				phone.vgui:Remove()
				RunConsoleCommand( 'darkrp', 'phone_reply' )
			end

			button1.Paint = function(_,w,h)

			draw.RoundedBox(0,0,0,w,h,Color(30,230,30))
			--draw.DrawText('Ответить','HudHintTextLarge',w/2,h/2-7,Color(255,255,255),TEXT_ALIGN_CENTER)
		
		end

		end


		local button2 = frame:Add( 'DButton' )
		button2:SetPos( incoming and 100 or 5, 75)
		button2:SetSize( incoming and 95 or 190,20)
		button2:SetText('Отклонить')
		button2.DoClick = function()
			frame:Close()
		end
		button2.Paint = function(_,w,h)

			draw.RoundedBox(0,0,0,w,h,Color(230,30,30))
			--draw.DrawText('Сбросить','HudHintTextLarge',w/2,h/2-7,Color(255,255,255),TEXT_ALIGN_CENTER)

		end


	end
	
	phone.CloseVgui = function()
		if IsValid( phone.vgui ) then
			phone.vgui:Remove()
		end
	end
	
	phone.EmitRingtone = function( ply )
		
		if !ply then return end

		local snd = ply:GetNWString( 'phone_ringtone', 'default' ) or 'default'
		snd = 'gmchan/ringtones/'..snd..'.wav'
		if ply.ringtone then
			ply.ringtone:Stop()
			ply.ringtone = nil
		end
		
		util.PrecacheSound(snd)
		
		local VSnd = CreateSound(ply, snd)
		VSnd:SetSoundLevel(60)
		VSnd:Stop() VSnd:Play()
		VSnd:ChangePitch(100,0)
		VSnd:ChangeVolume(0.9, 0)
		
		ply.ringtone = VSnd
	end
	
	phone.ReadStatus = function()
		local status, data = net.ReadString(), net.ReadTable()
		
		if status == 'stopringtone' then
			if data.ply.ringtone then
				data.ply.ringtone:Stop()
				data.ply.ringtone = nil
			end
		end
		
		if status == 'decline' then
			phone.CloseVgui()
		end
		
		if status == 'started' then
			if LocalPlayer() == data.talker then
				phone.CreateVgui( data.receiver, false, true )
			else
				phone.CreateVgui( data.talker, false, true )
			end
		end
		
		if status == 'calling' then
			phone.CreateVgui( data.ply, false, true )
		end
		
		if status == 'incoming' then
			phone.CreateVgui( data.ply, true, true )
		end
		
		if status == 'ringtone' then
			phone.EmitRingtone( data.ply )
		end
		
	end
	net.Receive( phone.cl_tag, phone.ReadStatus )
end
