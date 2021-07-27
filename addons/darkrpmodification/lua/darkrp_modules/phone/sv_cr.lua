local function init()
	
	do
		local cooldown = {}
		
		local function CombineRequest(ply, args)
			if ply:GetNWBool( 'phone_status', false ) == false then
				DarkRP.notify( ply, 1, 3, 'Ваш телефон выключен' )
				return
			end
			
			if cooldown[ply] and cooldown[ply] > CurTime() then
				DarkRP.notify( ply, 1, 4, DarkRP.getPhrase( 'wait_with_that' ) )
				return ""
			end
			if args == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return ""
			end

			local DoSay = function(text)
				if text == "" then
					DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
					return
				end
				local cps = {}
				for k, v in pairs(player.GetAll()) do
					if v:isCP() or v == ply then
						DarkRP.talkToPerson(v, team.GetColor(ply:Team()), DarkRP.getPhrase("request") .. " " .. ply:Nick(), Color(255, 0, 0, 255), text, ply)
						table.insert(cps, v)
					end
				end

				umsg.Start('markmsg')
                    umsg.Vector( ply:GetPos() )
                    umsg.String( DarkRP.getPhrase( "request" ) .. " " .. ply:Nick() .. ':' .. text )
                    umsg.String( 'request' )
                umsg.End()

				cooldown[ply] = CurTime() + 120
			end
			return args, DoSay
		end
		for _, cmd in pairs{"cr", "911", "999", "112", "000", "requestmed", "medrequest"} do
			DarkRP.removeChatCommand(cmd)
			DarkRP.defineChatCommand(cmd, CombineRequest, 1.5)
		end
	end
	
	/*do
		local cooldown = {}
		
		local function MedRequest(ply, args)
			if ply:GetNWBool( 'phone_status', false ) == false then
				DarkRP.notify( ply, 1, 3, 'Ваш телефон выключен' )
				return
			end
			
			if cooldown[ply] and cooldown[ply] > CurTime() then
				DarkRP.notify( ply, 1, 4, DarkRP.getPhrase( 'wait_with_that' ) )
				return ""
			end
			if args == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return ""
			end

			local DoSay = function(text)
				if text == "" then
					DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
					return
				end
				local cps = {}
				for k, v in pairs(player.GetAll()) do
					if v:isMedic() or v == ply then
						DarkRP.talkToPerson(v, team.GetColor(ply:Team()), DarkRP.getPhrase("request") .. " " .. ply:Nick(), Color(255, 0, 0, 255), text, ply)
						table.insert(cps, v)
					end
				end
				markers.AddMarker( cps, DarkRP.getPhrase( "request" ) .. " " .. ply:Nick(), text, "icon16/error.png", "buttons/blip1.wav", ply:GetPos(), Color( 255,54,54 ), 120 )
				cooldown[ply] = CurTime() + 120
			end
			return args, DoSay
		end
		for _, cmd in pairs{"requestmed", "medrequest"} do
			DarkRP.defineChatCommand(cmd, MedRequest, 1.5)
		end
		
	end*/
	
	/*do
		local cooldown = {}
	
		DarkRP.defineChatCommand( 'taxi', function( ply )
			if ply:GetNWBool( 'phone_status', false ) == false then
				DarkRP.notify( ply, 1, 3, 'Ваш телефон выключен' )
				return
			end
			
			if cooldown[ply] and cooldown[ply] > CurTime() then
				DarkRP.notify( ply, 1, 4, DarkRP.getPhrase( 'wait_with_that' ) )
				return ""
			end
			
			local tosend = {}
			
			for k,v in pairs( player.GetAll() ) do
				if v:isTaxist() or v == ply then
					DarkRP.talkToPerson(v, team.GetColor(ply:Team()), DarkRP.getPhrase("request") .. " " .. ply:Nick(), Color(255, 0, 0, 255), 'Вызываю такси', ply)
					table.insert( tosend, v )
				end
			end
			
			markers.AddMarker( tosend, DarkRP.getPhrase( "request" ) .. " " .. ply:Nick(), 'Вызов такси', "icon16/car.png", "buttons/blip1.wav", ply:GetPos(), Color( 255,54,54 ), 120 )
			cooldown[ply] = CurTime() + 120
		end)
	end
	*/
end

timer.Simple( .1, init )