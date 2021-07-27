local id = 1333773331

net.Receive( 'admingift', function( len, ply )

	if net.ReadBool() then

		if net.ReadBool() then

			local permanentShow = net.ReadBool()
			
			if permanentShow then

				notification.AddProgress( id, net.ReadString() )

			else

				local showTime = net.ReadUInt( 4 )

				local text = net.ReadString()	

				notification.AddLegacy( text, 0, showTime )

			end

		else

			local showTime = net.ReadUInt( 4 )

			local text = net.ReadString()

			notification.AddLegacy( text, 1, showTime )

		end

	else

		notification.Kill( id )

	end
	
end )