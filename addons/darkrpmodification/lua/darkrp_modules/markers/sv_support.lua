concommand.Add('callpolice',function(ply,_,args)

    if ply.Reqtime && CurTime() < ply.Reqtime then ply:ChatPrint('Необходимо подождать '.. math.floor(ply.Reqtime - CurTime())..' чтобы вызвать службы' ) return end
    
   
    local cit = args[2]
    local sss = args[1]
    
    if sss == 'true' && cit == 'Опишите ситуацию' then
        ply:ChatPrint('Укажите причину срочного вызова') return
    elseif sss == 'true' then
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_CHIEF or v:Team() == TEAM_POLICE or v:Team() == TEAM_MAYOR then
                umsg.Start('markmsg', v)
                    umsg.Vector( ply:GetPos() )
                    umsg.String( cit )
                    umsg.String( 'police' )
                umsg.End()
            end
        end
    else
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_CHIEF or v:Team() == TEAM_POLICE or v:Team() == TEAM_MAYOR then
                umsg.Start('markmsg', v)
                    umsg.Vector( ply:GetPos() )
                    umsg.String( 'Вызов полицейских' )
                    umsg.String( 'police' )
                umsg.End()
            end
        end
    end
    
    ply.Reqtime = CurTime() + 20
    DarkRP.notify( ply, 2, 3, "Вы вызвали полицейских.")
end)

concommand.Add('callmedic',function(ply,_,args)

    if ply.Reqtime && CurTime() < ply.Reqtime then ply:ChatPrint('Необходимо подождать '.. math.floor(ply.Reqtime - CurTime())..' чтобы вызвать службы' ) return end
    
   
    local cit = args[2]
    local sss = args[1]
    
    if sss == 'true' && cit == 'Опишите ситуацию' then
        ply:ChatPrint('Укажите причину срочного вызова') return
    elseif sss == 'true' then
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_CHIEF or v:Team() == TEAM_POLICE or v:Team() == TEAM_MAYOR then
                umsg.Start('markmsg', v)
                    umsg.Vector( ply:GetPos() )
                    umsg.String( cit )
                    umsg.String( 'medic' )
                umsg.End()
            end
        end
    else
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_CHIEF or v:Team() == TEAM_POLICE or v:Team() == TEAM_MAYOR then
                umsg.Start('markmsg', v)
                    umsg.Vector( ply:GetPos() )
                    umsg.String( 'Вызов скорой помощи' )
                    umsg.String( 'medic' )
                umsg.End()
            end
        end
    end
    
    ply.Reqtime = CurTime() + 60
end)
/*
concommand.Add('calltaxist',function(ply,_,args)

    if ply.Reqtime && CurTime() < ply.Reqtime then ply:ChatPrint('Необходимо подождать '.. math.floor(ply.Reqtime - CurTime())..' чтобы вызвать службы' ) return end
    
   
    local cit = args[2]
    local sss = args[1]
    
    if sss == 'true' && cit == 'Сколько вы готовы заплатить?' then
        ply:ChatPrint('Укажите кол-во денег для срочного вызова') return
    elseif sss == 'true' then
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_TAXI then
                umsg.Start('markmsg', v)
                    umsg.Vector( ply:GetPos() )
                    umsg.String( 'Срочный вызов! Плата:' .. cit )
                    umsg.String( 'taxi' )
                umsg.End()
            end
        end
    else 
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_TAXI then
                umsg.Start('markmsg', v)
                    umsg.Vector( ply:GetPos() )
                    umsg.String( 'Плата: '..cit )
                    umsg.String( 'taxi' )
                umsg.End()
            end
        end
    end
    
    ply.Reqtime = CurTime() + 60
end)
*/
concommand.Add( 'sendpos', function( ply, _, args )
	
	local i = args[1]
	local p = Player( i )

	if ! IsValid( p ) then
		
		DarkRP.notify( ply, 1, 3, 'Игрок не найден. Некому отправлять :)' )
		return
		
	end
	
	if ply.pos_sent and ply.pos_sent[ p ] and ply.pos_sent[ p ] > CurTime() then
		
		DarkRP.notify( ply, 1, 3, "Подождите некоторое время.")
		return
	
	end
	

	ply.pos_sent = ply.pos_sent or {}
	
	ply.pos_sent[ p ] = CurTime() + 20
	
	umsg.Start('markmsg', p)
    umsg.Vector( ply:GetPos() )
    umsg.String( 'Позиция игрока '..ply:Nick() )
    umsg.String( 'yadebil' )
    umsg.End()
	
	DarkRP.notify( ply, 2, 3, "Местоположение отправлено")
	DarkRP.notify( p, 2, 3, ( "%s отправил местоположение" ):format( ply:Nick() ) )
	
end)
