module( 'derma_notify', package.seeall )

util.AddNetworkString( 'derma_notify' )

function Send( ply, id, title, text )

	net.Start( 'derma_notify' )
		net.WriteInt( id, 3 )
		net.WriteString( title )
		net.WriteString( text )
	net.Send( ply )

end
