module( 'gp_rg', package.seeall )

local meta = FindMetaTable( 'Player' )

util.AddNetworkString( 'prg_join' )
--util.AddNetworkString( 'rg_cmd' )


function meta:prg_chat( text )

	self:ChatAddText(Color(0, 161, 255),'[МВД] ',Color(255,255,255), text )

end

function meta:prg_Update()

	self:SetNWInt( 'prg_lvl', self:GetPData( 'prg_lvl', 1 ) )
	self:SetNWInt( 'prg_exp', self:GetPData( 'prg_exp', 0 ) )
	self:SetNWInt( 'prg_rep', self:GetPData( 'prg_rep', 0 ) )
	self:setDarkRPVar( 'prg_warn', self:GetPData( 'prg_warn', '[]' ) )
	self:setDarkRPVar( 'prg_com', self:GetPData( 'prg_com', '[]' ) )
	self:setDarkRPVar( 'prg_log', self:GetPData( 'prg_log', '[]' ) )

end

function meta:rg_SetLVL( lvl )

	--local l = lvl

	if lvl > 18 then
		lvl = 18
	end

	self:SetPData( 'prg_lvl', lvl )
	self:prg_Update()

end

function meta:pcalculatep()

	local rep = tonumber(self:GetNWInt( 'prg_rep', 0 ))

	if rep >= 200 then
		return 35000
	end

	if rep <= 0 then
		return 15000
	end

	return (rep / 0.01) + 15000

end

function meta:prg_Trane( ply )

	if not (ply:rg_GetLVL() == 8 or ply:rg_GetLVL() == 12) then return end
	if not ply:GetPData( 'prg_exp', 0 ) == self:rg_GetUP() then return end

	ply:SetPData( 'prg_exp', 0 )
	local old = ply:prg_GetRank()
	ply:prg_SetLVL( ply:rg_GetLVL() + 1 )
	ply:prg_chat( 'Инструктор '..self:Nick()..' аттестовал вас.' )
	self:prg_chat( 'Вы успешно аттестовали '..ply:Nick() )
	local new = ply:prg_GetRank()
	ply:prg_Log( 'Аттестован инструктором '..self:Nick()..'('..self:SteamID()..')' )
	ply:prg_Log( 'Повышение ('..old..'>'..new..')' )

end

function meta:prg_AddExp( exp )

	if self:prg_GetLVL() >= 18 then
		return
	end	

	local ply_exp = tonumber( self:GetPData( 'prg_exp', 0 ) )
	local total = ply_exp + exp

	if total >= self:prg_GetUP() then

		if self:prg_GetLVL() == 8 or self:prg_GetLVL() == 12 then
			self:SetPData( 'prg_exp', self:prg_GetUP() )
			self:prg_Update()
			self:prg_chat( 'Для дальнейшего повышения уровня необходима аттестация' )
			return
		end 
		local old = self:rg_GetRank()
		self:rg_SetLVL( self:prg_GetLVL() + 1 )
		self:SetPData( 'prg_exp', 0 )
		self:prg_Update()
		self:prg_chat( 'Вы получили '..exp..' опыта! Всего опыта: '..self:prg_GetUP()..'/'..self:prg_GetUP() )
		self:prg_chat( 'Повышение! Ваше новое звание: '..self:prg_GetRank() )
		self:addMoney( self:pcalculatep() )
		self:prg_chat('Вы получили премию в размере '..DarkRP.formatMoney( self:pcalculatep() ) )
		
		local new = self:prg_GetRank()
		self:prg_Log( 'Повышение ('..old..'>'..new..')' )
		print( 'adding '..exp..'exp to '..self:Nick()..'' )
		print('LVLUP')
		
	else

		self:SetPData( 'prg_exp', total )
		self:prg_chat( 'Вы получили '..exp..' опыта! Всего опыта: '..total..'/'..self:prg_GetUP() )
		print( 'adding '..exp..' exp to '..self:Nick() )
		self:prg_Update()

	end
	
end

function meta:prg_Join( job )

	local t = tbl[self:prg_GetRank()]

	if self:Team() == TEAM_NRG1 then												-- CHANGE!
		self:setDarkRPVar( 'job', job..' росгвардии' )
		self:SetModel( table.Random(t.models) )
		if t.body then
			self:SetBodygroup( 1, t.body )
		end
	else
		if self:changeTeam( TEAM_NRG1 ) then
			self:setDarkRPVar( 'job', job..' росгвардии' )
			self:SetModel( table.Random(t.models) )
			if t.body then
				self:SetBodygroup( 1, t.body )
			end
		end
	end

end

function meta:rg_Log( text )

	local log = util.JSONToTable( self:GetPData( 'rg_log', '[]' ) )

	table.insert( log, {text = text, time = os.time()} )

	self:SetPData( 'rg_log', util.TableToJSON( log ) )

	self:rg_Update()

end

function meta:rg_AddWarn( ply, reason )

	if not self:rg_IsCMD() then
		return
	end
	
	if self.rg_warnkd then
		self:rg_chat( 'Нельзя выдавать предупреждения так часто. Попробуйте позднее.' )
		return
	end 

	local total = ply:rg_GetWarnCount() + 1

	local warn_tbl = util.JSONToTable( ply:GetPData( 'rg_warn', '[]' ) )

	if total >= 3 then
		local old = ply:rg_GetRank()
		ply:rg_chat( self:rg_GetRank()..' '..self:Nick()..' выдал вам предупреждение. Причина: '..reason )
		ply:rg_chat( 'Вы понижены из за критического количества предупреждений.' )
		ply:rg_SetLVL( ply:rg_GetLVL() - 1 )
		ply:SetPData( 'rg_warn', '[]' )
		ply:rg_Update()
		local new = ply:rg_GetRank()
		ply:rg_Log( self:rg_GetRank()..' '..self:Nick()..'('..self:SteamID()..') выдал предупреждение. Причина: "'..reason..'". Всего предупреждений: '..total..'/3.' )
		ply:rg_Log( 'Понижение всвязи с предупреждениями. ('..old..'>'..new..')' )
		self:rg_chat( 'Предупреждение выдано, солдат понижен. ('..old..'>'..new..')' )
	else
		ply:rg_chat( self:rg_GetRank()..' '..self:Nick()..' выдал вам предупреждение. Причина: '..reason..'\nВсего предупреждений: '..total..'/3.' )
		table.insert( warn_tbl, { cmd = self:SteamID(), cmd_name = self:Nick(), rank = self:rg_GetRank(), reason = reason } )
		ply:SetPData( 'rg_warn', util.TableToJSON( warn_tbl ) )
		ply:rg_Update()
		ply:rg_Log( self:rg_GetRank()..' '..self:Nick()..'('..self:SteamID()..') выдал предупреждение. Причина: "'..reason..'". Всего предупреждений: '..total..'/3.' )
		self:rg_chat( 'Предупреждение выдано. Всего предупреждений: '..total..'/3.' )
	end

	self.rg_warnkd = true

	timer.Simple( 120, function()
		self.rg_warnkd = false
	end )

end

function meta:rg_SetRep( rep )

	self:SetPData( 'rg_rep', rep )

	self:rg_Update()

end

function meta:rg_AddCom( ply, com, rep )
	
	if ply.rg_repkd then
		self:rg_chat( 'Нельзя писать отзывы одному игроку так часто. Попробуйте позднее.' )
		return
	end

	local reps = util.JSONToTable( ply:GetPData( 'rg_com', '[]' ) )

	if rep then

		ply:rg_chat( self:rg_GetRank()..' '..self:Nick()..' оставил вам положительный отзыв. (см. личное дело)' )
		table.insert( reps, { text = com, author = self:rg_GetRank()..' '..self:Nick(), rep = rep } )
		ply:SetPData( 'rg_com', util.TableToJSON( reps ) )
		ply:rg_SetRep( ply:rg_GetRep() + 1 )
		ply:rg_Log( self:rg_GetRank()..' '..self:Nick()..'('..self:SteamID()..') оставил положительный отзыв: '..com )
		self:rg_chat( 'Отзыв оставлен.' )
	else

		ply:rg_chat( self:rg_GetRank()..' '..self:Nick()..' оставил вам отрицательный отзыв. (см. личное дело)' )
		table.insert( reps, { text = com, author = self:rg_GetRank()..' '..self:Nick(), rep = rep } )
		ply:SetPData( 'rg_com', util.TableToJSON( reps ) )
		ply:rg_SetRep( ply:rg_GetRep() - 1 )
		ply:rg_Log( self:rg_GetRank()..' '..self:Nick()..'('..self:SteamID()..') оставил отрицательный отзыв: '..com )
		self:rg_chat( 'Отзыв оставлен.' )
	end
	ply.rg_repkd = true
	timer.Simple( 120, function()
		ply.rg_repkd = false
	end )

end

hook.Add( 'PlayerInitialSpawn', 'prgInitialSpawn', function( ply )

	ply:prg_Update()

end )

net.Receive( 'prg_join', function( _, ply )

	local job = net.ReadString()

	ply:prg_Join( job )

end )

--[[
net.Receive( 'rg_cmd', function( _, ply )

	if not ply:rg_IsCMD() then
		return
	end
	local cmd = net.ReadString()
	local pl = net.ReadEntity()
	local arg = net.ReadString()

	if cmd == 'SetDN' then

		pl:SetNWString( 'rg_dn', arg )
		ply:rg_chat( pl:rg_GetRank()..' '..pl:Nick()..' назначен на дежурство - '..arg )
		pl:rg_chat( ply:rg_GetRank()..' '..ply:Nick()..' назначил вас на дежурство - '..arg )

		elseif cmd == 'Uval' then

			if not pl:IsNRG() then
				return
			end

			pl:changeTeam( TEAM_CITIZEN, true )
			ply:rg_chat( pl:rg_GetRank()..' '..pl:Nick()..' уволен' )
			pl:rg_chat( ply:rg_GetRank()..' '..ply:Nick()..' уволил вас' )

			elseif cmd == 'Warn' then

				ply:rg_AddWarn( pl, arg )

				elseif cmd == 'Trane' then

					ply:rg_Trane( pl )

					elseif cmd == 'Com' then

						ply:rg_AddCom( pl, arg, net.ReadBool() )

						elseif cmd == 'wep' then

							local b = net.ReadBool()

							pl:SetNWBool( 'nrg_access_wep', b )
							print(b)
							if b == false then
								pl:rg_chat( ply:rg_GetRank()..' '..ply:Nick()..' забрал у вас доступ к арсеналу' )
								ply:rg_chat( 'Вы забрали доступ к арсеналу у '..pl:Nick() )
							else
								pl:rg_chat( ply:rg_GetRank()..' '..ply:Nick()..' дал вам доступ к арсеналу' )
								ply:rg_chat( 'Вы выдали доступ к арсеналу '..pl:Nick() )
							end
							
							elseif cmd == 'veh' then

								local b = net.ReadBool()

								pl:SetNWBool( 'nrg_access_veh', b )

								if b == false then
									pl:rg_chat( ply:rg_GetRank()..' '..ply:Nick()..' забрал у вас доступ к транспорту' )
									ply:rg_chat( 'Вы забрали доступ к транспорту у '..pl:Nick() )
								else
									pl:rg_chat( ply:rg_GetRank()..' '..ply:Nick()..' дал вам доступ к транспорту' )
									ply:rg_chat( 'Вы выдали доступ к транспорту '..pl:Nick() )
								end


	end

end )
--]]

hook.Add( 'PlayerSpawn', 'prg_spawn', function( ply )

	if ply:IsPRG() then
		timer.Simple( 1, function()
			local rank = tbl[ply:rg_GetRank()]
			ply:SetModel( table.Random(rank.models) )
			if rank.body then
				ply:SetBodygroup( 1, rank.body )
			end
		end)
	end

end )


hook.Add( 'loadCustomDarkRPItems', 'prg_fix', function() 
	timer.Simple( 0.1, function() 
		for k,v in pairs(RPExtraTeams) do
			 if v.command == 'prg' then
			 	DarkRP.removeChatCommand( v.command )
			 end
		end
	end)
end)