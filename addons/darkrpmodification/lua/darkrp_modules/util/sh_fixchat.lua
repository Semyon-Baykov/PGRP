if (CLIENT) then
	
	hook.Add( 'StartChat', 'fix#StartChat', function()

		RunConsoleCommand( 'f_StartChat' )

	end )

	hook.Add( 'FinishChat', 'fix#FinishChat', function()

		RunConsoleCommand( 'f_FinishChat' )

	end )

else

	concommand.Add( 'f_StartChat', function( ply )

		ply:SetNWBool( 'typing', true )

	end )

	concommand.Add( 'f_FinishChat', function( ply )

		ply:SetNWBool( 'typing', false )

	end )	


end