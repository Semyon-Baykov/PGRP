module( 'gp_rg', package.seeall )

local meta = FindMetaTable( 'Player' )

util.AddNetworkString( 'rg_join' )
util.AddNetworkString( 'rg_cmd' )


function meta:rg_chat( text )

	self:ChatAddText(Color(60,120,70),'[Штаб округа] ',Color(255,255,255), text )

end

function meta:rg_Update()

	self:SetNWInt( 'rg_lvl', self:GetPData( 'rg_lvl', 1 ) )
	self:SetNWInt( 'rg_exp', self:GetPData( 'rg_exp', 0 ) )
	self:SetNWInt( 'rg_rep', self:GetPData( 'rg_rep', 0 ) )
	self:setDarkRPVar( 'rg_warn', self:GetPData( 'rg_warn', '[]' ) )
	self:setDarkRPVar( 'rg_com', self:GetPData( 'rg_com', '[]' ) )
	self:setDarkRPVar( 'rg_log', self:GetPData( 'rg_log', '[]' ) )

end

function meta:rg_SetLVL( lvl )

	local l = lvl

	if l > 20 then
		l = 20
	end

	self:SetPData( 'rg_lvl', l )
	self:rg_Update()

end

function meta:calculatep()

	local rep = tonumber(self:GetNWInt( 'rg_rep', 0 ))

	if rep >= 200 then
		return 35000
	end

	if rep <= 0 then
		return 15000
	end

	return (rep / 0.01) + 15000

end

function meta:rg_Trane( ply )

	if not self:rg_IsCMD() then
		return
	end

	if not (ply:rg_GetLVL() == 8 or ply:rg_GetLVL() == 12) then
		return
	end

	if not ply:GetPData( 'rg_exp', 0 ) == self:rg_GetUP() then
		return
	end

	ply:SetPData( 'rg_exp', 0 )
	local old = ply:rg_GetRank()
	ply:rg_SetLVL( ply:rg_GetLVL() + 1 )
	ply:rg_chat( 'Инструктор '..self:Nick()..' аттестовал вас.' )
	self:rg_chat( 'Вы успешно аттестовали '..ply:Nick() )
	local new = ply:rg_GetRank()
	ply:rg_Log( 'Аттестован инструктором '..self:Nick()..'('..self:SteamID()..')' )
	ply:rg_Log( 'Повышение ('..old..'>'..new..')' )

end

function meta:rg_AddExp( exp )

	if self:rg_GetLVL() >= 20 then
		return
	end	

	local ply_exp = tonumber( self:GetPData( 'rg_exp', 0 ) )
	local total = ply_exp + exp
	--[[
	-- Premium
	if self:IsSecondaryUserGroup "premium" then
	
		local premtotal = ply_exp + exp + exp + exp
		local premexp = exp * 3
		
		if premtotal >= self:rg_GetUP() then

			if self:rg_GetLVL() == 8 or self:rg_GetLVL() == 12 then
				self:SetPData( 'rg_exp', self:rg_GetUP() )
				self:rg_Update()
				self:rg_chat( 'Для дальнейшего повышения уровня необходима аттестация' )
				return
			end 
			
			local old = self:rg_GetRank()
			self:rg_SetLVL( self:rg_GetLVL() + 1 )
			self:SetPData( 'rg_exp', 0 )
			self:rg_Update()
			self:rg_chat( '[PREMIUM] Вы получили '..premexp..' опыта! Всего опыта: '..self:rg_GetUP()..'/'..self:rg_GetUP() )
			self:rg_chat( 'Повышение! Ваше новое звание: '..self:rg_GetRank() )
			self:addMoney( self:calculatep() )
			self:rg_chat('[PREMIUM] Вы получили премию в размере '..DarkRP.formatMoney( self:calculatep() * 3 ) )
		
			local new = self:rg_GetRank()
			self:rg_Log( 'Повышение ('..old..'>'..new..')' )
			print( 'adding '..premexp..'exp to '..self:Nick()..'' )
			print('LVLUP')
		
		else

			self:SetPData( 'rg_exp', premtotal )
			self:rg_chat( '[PREMIUM] Вы получили '..premexp..' опыта! Всего опыта: '..premtotal..'/'..self:rg_GetUP() )
			print( 'adding '..premexp..' exp to '..self:Nick() )
			self:rg_Update()

		end
		
		return
		
	end
	]]--
	-- Normal
	if total >= self:rg_GetUP() then

		if self:rg_GetLVL() == 8 or self:rg_GetLVL() == 12 then
			self:SetPData( 'rg_exp', self:rg_GetUP() )
			self:rg_Update()
			self:rg_chat( 'Для дальнейшего повышения уровня необходима аттестация' )
			return
		end 
		local old = self:rg_GetRank()
		self:rg_SetLVL( self:rg_GetLVL() + 1 )
		self:SetPData( 'rg_exp', 0 )
		self:rg_Update()
		self:rg_chat( 'Вы получили '..exp..' опыта! Всего опыта: '..self:rg_GetUP()..'/'..self:rg_GetUP() )
		self:rg_chat( 'Повышение! Ваше новое звание: '..self:rg_GetRank() )
		self:addMoney( self:calculatep() )
		self:rg_chat('Вы получили премию в размере '..DarkRP.formatMoney( self:calculatep() ) )
		
		local new = self:rg_GetRank()
		self:rg_Log( 'Повышение ('..old..'>'..new..')' )
		print( 'adding '..exp..'exp to '..self:Nick()..'' )
		print('LVLUP')
		
	else

		self:SetPData( 'rg_exp', total )
		self:rg_chat( 'Вы получили '..exp..' опыта! Всего опыта: '..total..'/'..self:rg_GetUP() )
		print( 'adding '..exp..' exp to '..self:Nick() )
		self:rg_Update()

	end
	
end

function meta:rg_Join( job )

	local t = tbl[self:rg_GetRank()]

	if self:Team() == TEAM_NRG1 then
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

	if not self:rg_IsCMD() then
		return
	end
	
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

hook.Add( 'PlayerInitialSpawn', 'rgInitialSpawn', function( ply )

	ply:rg_Update()

end )

net.Receive( 'rg_join', function( _, ply )

	local job = net.ReadString()

	ply:rg_Join( job )

end )

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

hook.Add( 'PlayerSpawn', 'rg_spawn', function( ply )

	if ply:IsNRG() then
		timer.Simple( 1, function()
			local t = tbl[ply:rg_GetRank()]
			ply:SetModel( table.Random(t.models) )
			if t.body then
				ply:SetBodygroup( 1, t.body )
			end
		end)
	end

end )


hook.Add( 'loadCustomDarkRPItems', 'nrg_fix', function() 
	timer.Simple( 0.1, function() 
		for k,v in pairs(RPExtraTeams) do
			 if v.command == 'nrg1' or v.command == 'nrg2' or v.command == 'nrg3' or v.command == 'nrg4' then
			 	DarkRP.removeChatCommand( v.command )
			 end
		end
		DarkRP.removeChatCommand( 'mayor' )
		DarkRP.removeChatCommand( 'mobboss' )
	end)
end)