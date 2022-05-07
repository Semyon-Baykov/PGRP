techrpmarkers = {}
nav = {
    ['Отдел МВД России'] = {
        pos =Vector( -7936.010254, -5899.739258, -13943.968750 ),
        img = 'icon16/information.png'
    },
    ['В/Ч Росгвардии'] = {
        pos =Vector( -2191.310547, -9437.777344, -13951.968750 ),
        img = 'icon16/information.png'
    },
    ['Шахта'] = {
        pos =Vector( 13274.474609, -2648.391113, -13631.968750 ),
        img = 'icon16/information.png'
    },
    ['Сбербанк'] = {
        pos =Vector(-2873.246582, -2880.161621, -13919.968750 ),
        img = 'icon16/information.png'
    },
    ['Транспортный терминал'] = {
        pos =Vector(1292.151733, 8698.389648, -13407.968750 ),
        img = 'icon16/information.png'
    },
}
local function receiveMarkers(um)
    
    local pos = um:ReadVector()
    local txt = um:ReadString()
    local typ = um:ReadString()
    
    AddSupMarker( txt, typ, pos )
end


function util.gmodUnitToReal( units )
	
	return (units*0.75)*0.0254

end


usermessage.Hook('markmsg',receiveMarkers)

function SupMarkerDlg(type)
    
    local name  = ''
    local pos   = LocalPlayer():GetPos()
    local tbl = {}
    
    local frame = vgui.Create('DFrame')
    frame:SetSize(400,400)
    frame:Center()
    frame:SetTitle('Вызов служб')
    frame:MakePopup()
    
    local combo = vgui.Create('DComboBox',frame)
    combo:SetPos(10,30)
    combo:SetSize(380,20)
    combo:SetValue( "Выбор.." )
    combo:AddChoice('Полиция')
    combo:AddChoice('Медик')
    combo:AddChoice('Такси')
    combo.OnSelect = function( panel, index, value )
        if value == 'Такси' then
            if frame.pnl then frame.pnl:Remove() end
            
            frame.pnl = vgui.Create('DPanel',frame)
            frame.pnl:SetPos(10,60)
            frame.pnl:SetSize(380,90)
            frame:SetSize(400,160)
            frame:Center()
            
            local ch = vgui.Create("DCheckBoxLabel",frame.pnl)
            ch:SetPos(5, 10)						
            ch:SetText("Срочный вызов")				 
            ch:SetValue(0)		
            ch:SizeToContents()	
            
            local text = vgui.Create('DTextEntry',frame.pnl)
            text:SetPos(5,32)
            text:SetSize(370,22)
            text:SetValue('Сколько вы готовы заплатить?')
            text:RequestFocus()
            
            local btn = vgui.Create('DButton',frame.pnl)
            btn:SetText('')
            btn:SetPos(275,61)
            btn:SetSize( 100, 26 )
            btn.Paint = function(self)
                draw.RoundedBox(2,0,0,self:GetWide(),self:GetTall(),Color(86, 124, 164))
                draw.DrawText('Вызвать','HUDSELECTIONTEXT',self:GetWide()/2,4,Color(255,255,255),TEXT_ALIGN_CENTER)
            end
            
            btn.DoClick = function()
            RunConsoleCommand('calltaxist', tostring(ch:GetValue()) , text:GetValue() )
            end
        end
        
        if value == 'Полиция' then
            if frame.pnl then frame.pnl:Remove() end
            
            frame.pnl = vgui.Create('DPanel',frame)
            frame.pnl:SetPos(10,60)
            frame.pnl:SetSize(380,290)
            frame:SetSize(400,360)
            frame:Center()
            
            local ch = vgui.Create("DCheckBoxLabel",frame.pnl)
            ch:SetPos(5, 10)						
            ch:SetText("Срочный вызов")				 
            ch:SetValue(0)		
            ch:SizeToContents()	
            
            local text = vgui.Create('DTextEntry',frame.pnl)
            text:SetPos(5,32)
            text:SetSize(370,222)
            text:SetValue('Опишите ситуацию')
            text:SetMultiline(true)
            text:SetVerticalScrollbarEnabled(true)
            text:RequestFocus()
            
            local btn = vgui.Create('DButton',frame.pnl)
            btn:SetText('')
            btn:SetPos(275,261)
            btn:SetSize( 100, 26 )
            btn.Paint = function(self)
                draw.RoundedBox(2,0,0,self:GetWide(),self:GetTall(),Color(86, 124, 164))
                draw.DrawText('Вызвать','HUDSELECTIONTEXT',self:GetWide()/2,4,Color(255,255,255),TEXT_ALIGN_CENTER)
            end
            btn.DoClick = function()
            RunConsoleCommand('callpolice', tostring(ch:GetValue()) , text:GetValue() )
            end
        end
        if value == 'Медик' then
            if frame.pnl then frame.pnl:Remove() end
            
            frame.pnl = vgui.Create('DPanel',frame)
            frame.pnl:SetPos(10,60)
            frame.pnl:SetSize(380,290)
            frame:SetSize(400,360)
            frame:Center()
            
            local ch = vgui.Create("DCheckBoxLabel",frame.pnl)
            ch:SetPos(5, 10)						
            ch:SetText("Срочный вызов")				 
            ch:SetValue(0)		
            ch:SizeToContents()	
            
            local text = vgui.Create('DTextEntry',frame.pnl)
            text:SetPos(5,32)
            text:SetSize(370,222)
            text:SetValue('Опишите ситуацию')
            text:SetMultiline(true)
            text:SetVerticalScrollbarEnabled(true)
            text:RequestFocus()
            
            local btn = vgui.Create('DButton',frame.pnl)
            btn:SetText('')
            btn:SetPos(275,261)
            btn:SetSize( 100, 26 )
            btn.Paint = function(self)
                draw.RoundedBox(2,0,0,self:GetWide(),self:GetTall(),Color(86, 124, 164))
                draw.DrawText('Вызвать','HUDSELECTIONTEXT',self:GetWide()/2,4,Color(255,255,255),TEXT_ALIGN_CENTER)
            end
            btn.DoClick = function()
            RunConsoleCommand('callmedic', tostring(ch:GetValue()) , text:GetValue() )
            end
        end
    end
    if type == '' then type = 'Выбор..' end
    combo:SetValue( type )
    combo.OnSelect( _,_,type )
end

function AddSupMarker( name, type, pos )
    local ico = 'icon16/arrow_down.png'
    local pteam = LocalPlayer():Team()
    local sound = 'buttons/bell1.wav'
    local fadet = 60
    
    if type == 'police' then 
        if pteam != TEAM_POLICE and pteam != TEAM_CHIEF and pteam != TEAM_MAYOR then return end
        ico = 'icon16/error.png'
        sound = 'buttons/button17.wav'
        fadet = 60
    end
    
    if type == 'medic' then
        if pteam != TEAM_MEDIC then return end
        ico = 'icon16/information.png'
        sound = 'buttons/bell1.wav'
        fadet = 60
    end

    if type == 'request' then

        if not LocalPlayer():isCP() and not LocalPlayer():isMedic() then return end

        ico = 'icon16/error.png'

        sound = 'buttons/blip1.wav'

        fadet = 120

    end
    
    if type == 'taxi' then
        ico = 'icon16/arrow_down.png'
        fadet = 60
    end
   
    if type == 'nav' then
        if nav[name] then
                RunConsoleCommand( 'play', sound )
                table.insert( techrpmarkers, { name,nav[name].pos,Material(nav[name].img),CurTime()+fadet } )
                return
        end
    end
    if type == 'mission' then
        RunConsoleCommand( 'play', sound )
        table.insert( techrpmarkers, { name,pos,Material('icon16/information.png'),CurTime()+900 } )
        return
    end

    RunConsoleCommand( 'play', sound )
    
    table.insert( techrpmarkers, { name,pos,Material(ico),CurTime()+fadet } )
    
end

hook.Add('HUDPaint','DrawMarkersOnMap',function()
    for k,v in pairs( techrpmarkers ) do
        
        local pos   = v[2]:ToScreen()
        local ico   = v[3]
        local txt   = v[1]
        local dist  = util.gmodUnitToReal( v[2]:Distance( LocalPlayer():GetPos() ) )
        local fade  = v[4] 
        
        surface.SetMaterial(  ico  )
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(pos.x,pos.y,20,20)
        
        draw.DrawText(string.sub(v[1],0,120)..' ('..math.floor(dist)..' м. от вас)','Trebuchet24',pos.x + 10,pos.y+20,Color(255,255,255),TEXT_ALIGN_CENTER )
        
        if CurTime() > fade then table.remove( techrpmarkers, k ) end
		if math.floor(dist) < 5 then 
		table.remove( techrpmarkers, k ) 
		chat.AddText( Color(0, 186, 255), '[Навигатор] ', Color(255,255,255), 'Вы добрались до точки!' )
		end
    end
    
end)

concommand.Add('call03',function()
SupMarkerDlg('Медик')
end)
concommand.Add('call02',function()
SupMarkerDlg('Полиция')
end)
concommand.Add('calltaxi',function()
SupMarkerDlg('Такси')
end)



net.Receive( 'marker', function()

    local pos = net.ReadVector()

    AddSupMarker( 'Секретный груз', 'mission', pos )

end )