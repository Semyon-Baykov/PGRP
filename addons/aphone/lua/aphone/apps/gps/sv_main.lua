util.AddNetworkString("aphone_AskPath")

// Thanks to https://wiki.facepunch.com/gmod/Simple_Pathfinding
local function heuristic_cost_estimate( start, goal )
	// Perhaps play with some calculations on which corner is closest/farthest or whatever
	return start:GetCenter():DistToSqr( goal:GetCenter() )
end

// using CNavAreas as table keys doesn't work, we use IDs
local function reconstruct_path( cameFrom, current )
	local total_path = { current }

	current = current:GetID()
	while ( cameFrom[ current ] ) do
		current = cameFrom[ current ]
		table.insert( total_path, navmesh.GetNavAreaByID( current ) )
	end
	return total_path
end

local function Astar( vec1, vec2 )
	local start = navmesh.GetNearestNavArea(vec1)
	local goal = navmesh.GetNearestNavArea(vec2)

	if ( !IsValid( start ) || !IsValid( goal ) ) then return false end
	if ( start == goal ) then return true end

	start:ClearSearchLists()

	start:AddToOpenList()

	local cameFrom = {}

	start:SetCostSoFar( 0 )

	start:SetTotalCost( heuristic_cost_estimate( start, goal ) )
	start:UpdateOnOpenList()

	while ( !start:IsOpenListEmpty() ) do
		local current = start:PopOpenList() // Remove the area with lowest cost in the open list and return it
		if ( current == goal ) then
			return reconstruct_path( cameFrom, current )
		end

		current:AddToClosedList()

		for k, neighbor in pairs( current:GetAdjacentAreas() ) do
			local newCostSoFar = current:GetCostSoFar() + heuristic_cost_estimate( current, neighbor )

			if ( neighbor:IsUnderwater() ) then // Add your own area filters or whatever here
				continue
			end

			if ( ( neighbor:IsOpen() || neighbor:IsClosed() ) && neighbor:GetCostSoFar() <= newCostSoFar ) then
				continue
			else
				neighbor:SetCostSoFar( newCostSoFar );
				neighbor:SetTotalCost( newCostSoFar + heuristic_cost_estimate( neighbor, goal ) )

				if ( neighbor:IsClosed() ) then

					neighbor:RemoveFromClosedList()
				end

				if ( neighbor:IsOpen() ) then
					// This area is already on the open list, update its position in the list to keep costs sorted
					neighbor:UpdateOnOpenList()
				else
					neighbor:AddToOpenList()
				end

				cameFrom[ neighbor:GetID() ] = current:GetID()
			end
		end
	end

	return false
end

// My part
local gps_ply = {}

local function send_newpath(ply, vec2)
	local i = Astar(ply:GetPos(), vec2)

	if istable(i) then
		i = table.Reverse(i)
		for k,v in ipairs(i) do
			i[k] = v:GetCenter()
		end

		net.Start("aphone_AskPath")
			net.WriteUInt(#i, 16)

			for index = 1, #i do
				net.WriteVector(i[index])
			end
		net.Send(ply)
	end
end

timer.Create("aphone_Paths", 2, 0, function()
	for k,v in pairs(gps_ply) do
		if !IsValid(v.ply) then
			gps_ply[k] = nil
			continue
		else
			send_newpath(v.ply, v.target)
		end
	end
end)

net.Receive("aphone_AskPath", function(_, ply)
	if !aphone.NetCD(ply, "AskPath", 0.33) then return end
	local id = aphone.GPS[net.ReadUInt(8)]
	local s = ply:SteamID64()

	gps_ply[s] = (id and !gps_ply[s]) and {ply = ply, target = id.vec} or nil
	if id then send_newpath(ply, ply:GetPos(), id.vec) end
end)