util.AddNetworkString( 'gpChat' )

net.Receive( 'gpChat', function( _, ply )

	local text = net.ReadString()

	if utf8.len( text ) > 350 then
		print(utf8.len( text ))
		return
	end

	local t = net.ReadBool()
	hook.Run( 'PlayerSay', ply, text, t )

end )