hook.Add( 'ShouldCollide', 'WalkOnWater', function( ent1, ent2 )

	if ent1.waterent or ent2.waterent then
		
		if ent1.ply == ent2 or ent2.ply == ent1 then

			return true

		end

		return false 

	end

end )


hook.Add( 'PlayerDisconnected', 'WalkOnWater', function( ply )

	if ply.walkwaterEnt and IsValid( ply.walkwaterEnt ) then

		ply.walkwaterEnt:Remove()

	end

end )


hook.Add( 'Move', 'WalkOnWater', function( ply, cmd )

	if ply:Team() == TEAM_JESUS or ply.canWalkWater then

		if ply:WaterLevel() > 0 then

			if not ply.walkwaterEnt or not IsValid( ply.walkwaterEnt ) then

				ply.walkwaterEnt = ents.Create( 'prop_physics' )

				ply.walkwaterEnt:SetModel( 'models/hunter/tubes/circle2x2.mdl' )

				ply.walkwaterEnt:SetPos( ply:GetPos() )

				ply.walkwaterEnt:SetAngles( Angle( 0, 0, 0 ) )

				ply.walkwaterEnt:Spawn()

				-- ply.walkwaterEnt:SetRenderMode( RENDERMODE_TRANSALPHA )

				-- ply.walkwaterEnt:SetColor( 0, 0, 0, 0 )

				ply.walkwaterEnt:SetMaterial( 'Models/effects/vol_light001' )

				ply.walkwaterEnt:SetCustomCollisionCheck( true )

				ply.walkwaterEnt:Activate()

				ply.walkwaterEnt:PhysWake()

				ply.walkwaterEnt:GetPhysicsObject():EnableMotion( false )

				ply.walkwaterEnt.waterent = true 

				ply.walkwaterEnt.ply = ply

			else

				ply.walkwaterEnt:SetPos( ply:GetPos() - Vector( 0, 0, 1.57 ) )

			end

		else

			if ply.walkwaterEnt and IsValid( ply.walkwaterEnt ) then

				ply.walkwaterEnt:Remove()

			end

		end

	else

		if ply.walkwaterEnt and IsValid( ply.walkwaterEnt ) then

			ply.walkwaterEnt:Remove()

		end

	end


end )