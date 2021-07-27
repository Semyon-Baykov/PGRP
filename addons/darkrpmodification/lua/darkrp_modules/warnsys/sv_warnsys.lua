module( 'gp_warns', package.seeall )

util.AddNetworkString( 'gp_warns_menu' )
util.AddNetworkString( 'gp_warns_disa' )

local meta = FindMetaTable( 'Player' )

local function epoe_print( text )
	MsgC( Color( 170, 0, 0 ), '[Warnsys] ', Color( 255, 255, 255 ), text..'\n' )
end

function meta:gpwarn_chat( text )
	self:ChatAddText( Color( 170, 0, 0 ), '[Warnsys] ', Color( 255, 255, 255 ), text )
end


function meta:AddWarn( sid, count, reason )

	if !reason or string.len(reason) < 1 then
		reason = 'нет причины'
	end

	local online = false
	local ply 

	if player.GetBySteamID( sid ) then
		online = true
		ply = player.GetBySteamID( sid )
	end

	local warnstbl = util.JSONToTable( util.GetPData( sid, 'gp_warnst', '[]' ) )
	local warns = util.GetPData( sid, 'gp_warns', 0 )

	if online == true then
		ply:gpwarn_chat( 'Администратор '..self:Nick()..' выдал вам '..count..' предупреждение(-я). Подробнее: !warns' )
		epoe_print( 'Администратор '..self:Nick()..' выдал '..ply:Nick()..' '..count..' предупреждение(-я).' )
	else
		epoe_print( 'Администратор '..self:Nick()..' выдал "'..sid..'" '..count..' предупреждение(-я).' )
	end

	table.insert( warnstbl, { adm = self:Nick(), adms = self:SteamID(), count = count, time = os.time(), reason = reason, active = true } )


	if ( warns + count ) >= 3 then
		if online then
			local userInfo = ULib.ucl.authed[ self:UniqueID() ]
			ULib.ucl.addUser( ply:SteamID(), userInfo.allow, userInfo.deny, 'user' )
			ply:gpwarn_chat( 'У вас собралось максимальное количество предупреждений и вы пониженны до ранга "user"' )
			ply:gpwarn_chat( 'Не согласны с решением администрации? > https://steamcommunity.com/groups/gportalroleplay/discussions/3/' )
			if warnstbl and #warnstbl >= 1 then
				for i = 1, #warnstbl do
					warnstbl[i].active = false
				end	
			end
			ply:SetPData( 'gp_warnst', util.TableToJSON( warnstbl ) )
			ply:SetPData( 'gp_warns', 0 )
			return
		else
			epoe_print( 'У "'..sid..'" максимальное количество предупреждений, он будет понижен до "user" при заходе.' )
		end
	end
	
	util.SetPData( sid, 'gp_warns', warns + count )

	util.SetPData( sid, 'gp_warnst', util.TableToJSON( warnstbl ) )

end


function meta:DeactivateWarn( sid, warn_id )

	local warnstbl = util.JSONToTable( util.GetPData( sid, 'gp_warnst', '[]' ) )
	local warns = util.GetPData( sid, 'gp_warns', 0 )

	local online = false
	local ply 

	if player.GetBySteamID( sid ) then
		online = true
		ply = player.GetBySteamID( sid )
	end

	if !warnstbl or !warnstbl[warn_id] then
		return
	end
	if warnstbl[warn_id].active == false then
		return
	end

	warnstbl[warn_id].active = false

	warns = warns - warnstbl[warn_id].count

	util.SetPData( sid, 'gp_warns', warns )

	util.SetPData( sid, 'gp_warnst', util.TableToJSON( warnstbl ) )

	if online then
		ply:gpwarn_chat( 'Администратор '..self:Nick()..' снял у вас '..warnstbl[warn_id].count..' предупреждение(-я). Подробнее: !warns' )
		epoe_print( 'Администратор '..self:Nick()..' снял у '..ply:Nick()..' '..warnstbl[warn_id].count..' предупреждение(-я).' )
	else
		epoe_print( 'Администратор '..self:Nick()..' снял у "'..sid..'" '..warnstbl[warn_id].count..' предупреждение(-я).' )
	end

end

function meta:OpenWarnsMenu( sid )

	net.Start( 'gp_warns_menu' )
		net.WriteTable( util.JSONToTable( util.GetPData( sid, 'gp_warnst', '[]' ) ) )
		net.WriteInt( util.GetPData( sid, 'gp_warns', 0 ), 5 )
		net.WriteString( sid )
	net.Send( self )

end

net.Receive( 'gp_warns_disa', function( _, ply )

	if !ply:IsSuperAdmin() then return end

	local warn_id = net.ReadInt( 5 )
	local sid = net.ReadString()

	ply:DeactivateWarn( sid, warn_id )
	timer.Simple( 0.1, function() ply:OpenWarnsMenu( sid ) end )

end )

hook.Add( 'PlayerInitialSpawn', 'gpwarnsys_check', function( ply )

	if tonumber(ply:GetPData( 'gp_warns', 0 )) >= 3 then
		local userInfo = ULib.ucl.authed[ ply:UniqueID() ]
		ULib.ucl.addUser( ply:SteamID(), userInfo.allow, userInfo.deny, 'user' )
		ply:gpwarn_chat( 'У вас собралось максимальное количество предупреждений и вы пониженны до ранга "user"' )
		ply:gpwarn_chat( 'Не согласны с решением администрации? > https://steamcommunity.com/groups/gportalroleplay/discussions/3/' )
		local warnstbl = util.JSONToTable( ply:GetPData( 'gp_warnst', '[]' ) )
		if warnstbl and #warnstbl >= 1 then
				for i = 1, #warnstbl do
					warnstbl[i].active = false
				end	
			end
		ply:SetPData( 'gp_warnst', util.TableToJSON( warnstbl ) )
		ply:SetPData( 'gp_warns', 0 )
	end

end )