function RSP:AddNewZone( map, tab )
	if ( string.lower( map ) != game.GetMap():lower() ) then return end
	
	tab.SizeForwards.x = math.abs( tab.SizeForwards.x )
	tab.SizeForwards.y = math.abs( tab.SizeForwards.y )
	tab.SizeForwards.z = math.abs( tab.SizeForwards.z )
	
	for k,v in pairs( { "x", "y", "z" } ) do
		tab.SizeForwards[ v ] = math.abs( tab.SizeForwards[ v ] )
		
		if ( tab.SizeBackwards[ v ] > 0 ) then
			tab.SizeBackwards[ v ] = tab.SizeBackwards[ v ] * -1
		end
	end
	
	table.insert( self.Data, tab )
end

function RSP:InsideSafeZone( pos )
	for k,v in pairs( self.Data ) do
		if ( pos:WithinAABox( v.Center + v.SizeBackwards, v.Center + v.SizeForwards ) ) then
			return true
		end
	end
	
	return false
end