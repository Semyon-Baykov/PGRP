module( 'gp_elections', package.seeall )

util.AddNetworkString( 'Elections_vote' )
util.AddNetworkString( 'Elections_menu' )
util.AddNetworkString( 'Elections_join' )
util.AddNetworkString( 'Elections_joinm' )

tbl = tbl or {}
vote_started = vote_started or false
vote_poststarted = vote_poststarted or false
all_voters = 0

local meta = FindMetaTable( 'Player' )

local function StartElections()

	if #tbl < 1 then
		return
	end

	if vote_poststarted == true then
		return
	end
	if vote_started == true then
		return
	end

	vote_poststarted = true

	ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'До начала выборов на пост Мэра осталась 1 минута.' )

	timer.Simple( 60, function()

		if #tbl < 1 then

			ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Мэр не избран, недостаточно кандидатов.' )

			vote_poststarted = false

			tbl = {}

			return

		end

		if #tbl == 1 then

			local ply = player.GetByUniqueID( tbl[1].id )
			if ply:IsPlayer() then
				ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, ply:Nick()..' становится Мэром всвязи с нехваткой кандидатов.' )

				ply:changeTeam( TEAM_MAYOR, true )
			end
			vote_poststarted = false

			tbl = {}

			return

		end
		
		vote_poststarted = false
		vote_started = true

		local rf = RecipientFilter()
		rf:AddAllPlayers()
		
		for k,v in ipairs( tbl ) do
			
			local pl = player.GetByUniqueID( v.id )

			rf:RemovePlayer( pl ) 

		end

		for k,v in ipairs( rf:GetPlayers() ) do 
			DarkRP.createQuestion( 'Начались выборы на пост Мэра. Желаете сделать свой выбор?', 'gp_elections_'..k, v, 60, function( s, _, _, _, _, ply2 )

				if s == true then
					ply2:OpenVoteMenu()
				end

			end)
		end

		timer.Simple( 60, function()

			local winner_votes = 0
			local winner

			vote_started = false
			
			ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Результаты выборов: ' )

			for k,v in ipairs( tbl ) do

				local ply = player.GetByUniqueID(v.id)
				if ply:IsPlayer() then
					ChatAddText( color_white, ply:Nick()..' — '..math.Round(( v.voters / all_voters ) * 100)..'%' )

					if v.voters > winner_votes then
						winner = v.id
						winner_votes = v.voters
					end
				end

			end

			if winner == nil then
				winner = tbl[1].id
			end

			local win_ply = player.GetByUniqueID(winner)

			if win_ply:IsPlayer() then
				ChatAddText( color_white, 'Победитель — '..win_ply:Nick() )

				win_ply:changeTeam( TEAM_MAYOR, true )
			end

			all_voters = 0

			tbl = {}

		end )

	end )

end

function meta:OpenVoteMenu()

	if self.el_voted == true then
		return
	end

	net.Start( 'Elections_menu' )
		net.WriteTable( tbl )
	net.Send( self )

end

function meta:ElectionsVote( id )

	if self.el_voted == true then
		return
	end
	
	print(id)
	if not tbl[id] then
		return
	end
	print(id)
	self.el_voted = true
	timer.Simple( 10, function() self.el_voted = false end )

	tbl[id].voters = tbl[id].voters + 1
	all_voters = all_voters + 1

	local ply = player.GetByUniqueID(tbl[id].id)

	self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Вы проголосовали за '..ply:Nick() )

end

net.Receive( 'Elections_vote', function( len, ply )

	local id = net.ReadInt( 5 )

	ply:ElectionsVote( id )	

end )

function meta:JoinElections( str )

	if team.NumPlayers( TEAM_MAYOR ) > 0 then
		self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Мэр уже избран' )
		return false
	end

	if vote_started then
		self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Выборы уже начались' )
		return false
	end

	for k, v in ipairs( tbl ) do
		if v.id == self:UniqueID() then
			self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Вы уже участвуете в выборах' )
			return false
		end
	end

	if string.len( str ) > 1000 then
		self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Слишком длинный агитационный текст' )
		return false
	end

	table.insert( tbl, { id = self:UniqueID(), str = str, voters = 0 } )

	if vote_poststarted ~= true then
		StartElections()
	end

end


function meta:ElectionsJoinMenu()

	if team.NumPlayers( TEAM_MAYOR ) > 0 then
		self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Мэр уже избран' )
		return false
	end

	if vote_started then
		self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Выборы уже начались' )
		return false
	end

	for k, v in ipairs( tbl ) do
		if v.id == self:UniqueID() then
			self:ChatAddText( Color( 255, 0, 0 ), '[Выборы] ', color_white, 'Вы уже участвуете в выборах' )
			return false
		end
	end

	net.Start( 'Elections_joinm' )
	net.Send( self )

end

net.Receive( 'Elections_join', function( len, ply )

	local str = net.ReadString()

	ply:JoinElections( str )

end )
