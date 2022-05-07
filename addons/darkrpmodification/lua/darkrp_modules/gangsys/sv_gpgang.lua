module( 'gp_gangsys_new', package.seeall )

gang_table = gang_table or {}

local meta = FindMetaTable( 'Player' )

util.AddNetworkString( 'gp_gang_new' )
util.AddNetworkString( 'gp_gang_menu' )
util.AddNetworkString( 'gp_gangs_kick' )
util.AddNetworkString( 'gp_gangs_invite' )
util.AddNetworkString( 'gp_gangs_rasf' )

function meta:IsPlayerInGang()

	if self:GetNWBool('gp_gangsys_ingang',false) == false then return end

	for k, v in pairs( gang_table ) do

		if table.HasValue( v.members, self ) then

			return true

		end

	end

	return false

end

function meta:getPlayerGangID()

	for k, v in pairs( gang_table ) do

		if table.HasValue( v.members, self ) then

			return k

		end

	end

end


function meta:CreateNewGang( name, p_members )

	for k,v in pairs( gang_table ) do
		if v.name == name then
			DarkRP.notify( self, 1, 4, 'ОПГ с таким названием уже существует, придумайте что то более оригинальное!' )
			return false
		end
	end

	if #p_members < 2 or #player.GetAll() < 2 then

		DarkRP.notify( self, 1, 4, 'Вы должны выбрать не менее двух участников для создания ОПГ' )
		return false

	end

	for k, v in pairs( p_members ) do

		if v:Team() != TEAM_GANG then

			DarkRP.notify( self, 1, 4, 'Все участники ОПГ должны иметь профессию гопника' )
			return false

		end

	end

	local _ = {
		name = name,
		members = { self },
		creator = self,
		potential = { members = p_members, gang = true },
	}
	PrintTable(_)
	table.insert( gang_table, _ )
	local gangid = #gang_table
	local gang = gang_table[gangid]
	local creator = gang.creator
	for k,v in pairs( gang.potential.members ) do

		self:SendGangInvite( v, gangid, function( ply )
			table.RemoveByValue(  gang.potential.members, ply)
			table.insert( gang.members, ply )

			DarkRP.notify( gang.members, 0, 4, ply:Nick() .. ' присоединился к ОПГ!' )

			if #gang.members > 2 and gang.potential.gang then

				gang.potential.gang = false

				gang.creator:SetNWBool( 'gp_gangsys_gangowner', true )

				DarkRP.notifyAll( 0, 5, creator:Nick() .. ' создал опг ' .. name )

				for k, v in pairs( gang.members ) do

					if v == creator then

						local setTeam = v.changeTeam or v.SetTeam 

						setTeam( v, TEAM_MOB, true, true )

						v:setDarkRPVar( 'job', 'Глава ' .. name )

					else

						v:setDarkRPVar( 'job', RPExtraTeams[ v:Team() ].name .. ' ' .. name )

					end

					v:SetNWBool( 'gp_gangsys_ingang', true )

				end

			elseif not gang.potential.gang then

				ply:setDarkRPVar( 'job', RPExtraTeams[ ply:Team() ].name .. ' ' .. name )

				ply:SetNWBool( 'gp_gangsys_ingang', true )

			elseif #gang.members < 3 then

				DarkRP.notify( ply, 1, 4, 'ВНИМАНИЕ!\nОПГ еще формируется, для его создания нужен еще один человек!' )

			end

		end, function( ply )
			
			table.RemoveByValue( gang.potential.members, ply )

			DarkRP.notify( creator, 1, 4, ply:Nick() .. ' отказался вступать в вашу опг!' )
			
		end)



	end
	

	timer.Simple( 7, function()

		if gang.potential.gang then

			DarkRP.notify( gang.members, 0, 4, 'К сожалению опг недостаточно игроков для формирования!' )

			gang.creator:SetNWBool( 'gp_gangsys_gangowner', false )

			gang_table[ gangid ] = nil

			gang = nil

		end

	end )

end


function meta:SendGangInvite( ply, gangid, success, fail )


	local gang = gang_table[gangid]
	if not gang then
		return false
	end
	if ply:GetNWBool( 'gp_gangsys_invited', false ) == true then
		print('a')
		return false
	end
	if ply:Team() != TEAM_GANG then
		return false
	end
	ply:SetNWBool( 'gp_gangsys_invited', true )


	local players = {}

	for k, v in pairs( player.GetAll() ) do

		if v == ply then continue end

		players[ v ] = true

	end

	DarkRP.createVote( gang.creator:Nick() .. ' пригласил вас в ' .. ( gang.potential.gang and 'потенциальную' or '' ) .. ' опг ' .. gang.name .. '. Желаете вступить?', 'gang_invite', Player(0), 6, function( self ) 

		if self.yea == 1 then

			success( ply )

			else

			fail( ply )

		end

		ply:SetNWBool( 'gp_gangsys_invited', false )

	end, players, function( self )
		print('asuka')
		fail( ply )

		ply:SetNWBool( 'gp_gangsys_invited', false )

	end )

end

function meta:InviteToGang( ply )

	local gangid = self:getPlayerGangID()
	local gang = gang_table[gangid]

	if gang.creator ~= self then
		return
	end

	DarkRP.notify( gang.creator, 1, 4, 'Вы пригласили '..ply:Nick()..' в ОПГ!' )

	self:SendGangInvite( ply, gangid, function( ply ) 

		AddMember( gangid, ply )

	end, function( ply )

		DarkRP.notify( creator, 1, 4, ply:Nick() .. ' отказался вступать в вашу опг!' )

	end )

end

function RemoveGang( gangid, reason )

	local gang = gang_table[gangid]

	if not gang then
		return
	end

	DarkRP.notify( gang.members, 0, 4, 'ОПГ расформирована. '..reason )

	for k, v in pairs( gang.members ) do

		if not IsValid( v ) then continue end

		v:setDarkRPVar( 'job', RPExtraTeams[ v:Team() ].name )

		v:SetNWBool( 'gp_gangsys_ingang', false )

	end

	if IsValid( gang.creator ) and gang.creator:Team() == TEAM_MOB then

		local setTeam = gang.creator.changeTeam or gang.creator.SetTeam 

		setTeam( gang.creator, TEAM_GANG, true, true )

		gang.creator:SetNWBool( 'gp_gangsys_gangowner', false )

	end

	gang_table[gangid] = nil

end

function AddMember( gangid, ply )

	local gang = gang_table[gangid]

	if not gang then
		return
	end

	DarkRP.notify( gang.members, 0, 4, ply:Nick() .. ' присоединился к вашей ОПГ!' )

	DarkRP.notify( ply, 0, 4, 'Вы присоединились к ОПГ!' )
	DarkRP.notify( ply, 0, 4, 'Вам доступен чат ОПГ. (/o text)' )
	ply:setDarkRPVar( 'job', RPExtraTeams[ ply:Team() ].name .. ' ' .. gang.name )

	ply:SetNWBool( 'gp_gangsys_ingang', false )

	table.insert( gang.members, ply )

end

function RemoveMember( gangid, ply )


	local gang = gang_table[gangid]

	if not gang then
		return
	end

	if ply:GetNWBool( 'gp_gangsys_gangowner', false ) == true then
		RemoveGang( gangid, 'Лидер покинул ОПГ' )
		return
	end

	ply:SetNWBool( 'gp_gangsys_ingang', false )

	ply:setDarkRPVar( 'job', RPExtraTeams[ ply:Team() ].name )

	table.RemoveByValue( gang.members, ply )

	DarkRP.notify( ply, 0, 4, 'Вы вышли из ОПГ!' )

	DarkRP.notify( gang.members, 0, 4, ply:Nick() .. ' покинул вашу ОПГ!' )

	if #gang.members < 3 then
		RemoveGang(gangid, 'Недостаточно участников ОПГ.')
		return
	end


end

hook.Add( 'OnPlayerChangedTeam', 'gp_gangsys_new#OnPlayerChangedTeam', function( ply, before, after )

	if after ~= TEAM_MOB and after ~= TEAM_GANG then
		local gangid = ply:getPlayerGangID()
		RemoveMember(gangid, ply)
	end

end )


hook.Add( 'PlayerDisconnected', 'gp_gangsys_new#PlayerDisconnected', function( ply )

	if ply:IsPlayerInGang() then
		local gangid = ply:getPlayerGangID()
		RemoveMember(gangid, ply)
	end

end )

net.Receive( 'gp_gang_new', function( _, ply )

	local members = net.ReadTable()
	local name = net.ReadString()

	ply:CreateNewGang( name, members )

end )

net.Receive( 'gp_gangs_kick', function( _, ply )

	local ply_ = net.ReadEntity()

	if ply:GetNWBool( 'gp_gangsys_gangowner', false ) == false then
		return
	end
	local gangid = ply:getPlayerGangID()
	RemoveMember( gangid, ply_ )

end )

net.Receive( 'gp_gangs_rasf', function( _, ply )

	local gangid = ply:getPlayerGangID()
	RemoveMember( gangid, ply )

end )

net.Receive( 'gp_gangs_invite', function( _, ply ) 

	local ply_ = net.ReadEntity()

	if ply:GetNWBool( 'gp_gangsys_gangowner', false ) == false then
		return
	end
	local gangid = ply:getPlayerGangID()
	ply:InviteToGang(  ply_ )


end )


local function OpenGangOwnerMenu( ply )

	if ply:GetNWBool( 'gp_gangsys_gangowner', false ) == false then
		return
	end

	local gangid = ply:getPlayerGangID()

	local gang = gang_table[gangid]

	net.Start( 'gp_gang_menu' )
		net.WriteString( 'owner' )
		net.WriteTable( gang )
	net.Send( ply )

end


local function OpenGangMemberMenu( ply )

	local gangid = ply:getPlayerGangID()

	local gang = gang_table[gangid]

	net.Start( 'gp_gang_menu' )
		net.WriteString( 'member' )
		net.WriteTable( gang )
	net.Send( ply )

end
local function OpenGangDefMenu( ply )

	local gangid = ply:getPlayerGangID()

	local gang = gang_table[gangid]

	net.Start( 'gp_gang_menu' )
		net.WriteString( 'def' )
		net.WriteTable( {} )
	net.Send( ply )

end
concommand.Add( "gp_gangsys_menu", function( ply, cmd, args )

	local menutype = 'def'

	if ply:GetNWBool( 'gp_gangsys_gangowner', false ) == true then
		menutype = 'owner'
	elseif ply:GetNWBool( 'gp_gangsys_ingang', false ) == true then
		menutype = 'member'
	end

	if menutype == 'def' then
		OpenGangDefMenu(ply)
	elseif menutype == 'owner' then
		OpenGangOwnerMenu(ply)
	elseif menutype == 'member' then
		OpenGangMemberMenu(ply)
	end

end )


hook.Add( "PlayerSay", "GangChat", function( ply, text, team )
	if ( string.sub( string.lower( text ), 1, 2 ) == "/o" ) then
		if ply:GetNWBool( 'gp_gangsys_ingang', false ) == true then
			local gangid = ply:getPlayerGangID()

			local gang = gang_table[gangid]
			for k,v in pairs( gang.members ) do
				v:ChatAddText( Color( 25, 25, 25 ), '[ОПГ] '..ply:Nick(), Color(200,200,200), ': '..string.sub( text, 3 ) )
			end
			return ''
		end
	end
end )