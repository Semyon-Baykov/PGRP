module( 'gp_upg', package.seeall )

util.AddNetworkString( 'gp_upg' )
util.AddNetworkString( 'gp_upg_op' )


local meta = FindMetaTable( 'Player' )

function meta:upg_chat( text )
	self:ChatAddText( Color( 102, 204, 255 ), '[Улучшения] ', Color( 255, 255, 255 ), text )
end

function meta:GetUPG( id )

	local ply_upg = util.JSONToTable( self:GetPData( 'gp_upgs', '{"death":false,"bag":false}' ) )

	return ply_upg[id]

end

function meta:BuyUPG( id )

	local upg_t = tbl[ id ]

	if not upg_t then
		return 
	end

	if not self:canAfford( upg_t.price ) then
		self:upg_chat( 'Недостаточно средств.' )
		return
	end

	local ply_upg = util.JSONToTable( self:GetPData( 'gp_upgs', '{"death":false,"bag":false}' ) )

	if ply_upg[ upg_t.id ] == true then
		self:upg_chat( 'У вас уже есть улучшение "'..upg_t.name..'"!' )
		return
	end

	self:addMoney( -upg_t.price )

	ply_upg[ upg_t.id ] = true

	self:SetPData( 'gp_upgs', util.TableToJSON( ply_upg ) )

	self:upg_chat( 'Вы успешно купили улучшение "'..upg_t.name..'"!' )
	self:ConCommand('gp_upg')

	if upg_t.id == 'bag' then
		timer.Simple( 0.5, function()
			self:LoadGPInv()
		end)

	end

end

net.Receive( 'gp_upg', function( _, ply )

	local id = net.ReadInt( 5 )

	ply:BuyUPG( id )

end )

concommand.Add( 'gp_upg', function( ply )

	net.Start( 'gp_upg_op' )
		net.WriteTable( util.JSONToTable( ply:GetPData( 'gp_upgs', '{"death":false,"bag":false}' ) ) )
	net.Send( ply )

end)