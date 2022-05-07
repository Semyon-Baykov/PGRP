if CLIENT then
	DarkRP.addChatReceiver( '/looc', ' LOOC', function( ply ) return LocalPlayer():GetPos():DistToSqr( ply:GetPos() ) < 302500 end )
	DarkRP.addChatReceiver( '/it', ' IT', function( ply ) return LocalPlayer():GetPos():DistToSqr( ply:GetPos() ) < 62500 end )
else
	local function LOOC( ply, args )	
		local DoSay = function( text )
			if text == '' then
				DarkRP.notify( ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", "") )
				return ''
			end

			DarkRP.talkToRange( ply, '(LOOC) '..ply:Nick(), text, 550 )
		end
		return args, DoSay
	end

	DarkRP.defineChatCommand( 'looc', LOOC, 1.5 )

	local function IT( ply, args ) 
		local DoSay = function( text )
			if text == '' then 
				DarkRP.notify( ply, 1, 4, DarkRP.getPhrase( 'invalid_x', 'argument', '' ) ) 
				return ''
			end

			DarkRP.talkToRange( ply, text..' ('..ply:Nick()..')', '', 250 )
		end

		return args, DoSay
	end

	DarkRP.defineChatCommand( 'it', IT, 1.5)
end

