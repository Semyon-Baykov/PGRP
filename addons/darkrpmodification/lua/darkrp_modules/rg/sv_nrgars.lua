module( 'gp_wep', package.seeall )

util.AddNetworkString( 'nrg_arsm' )
util.AddNetworkString( 'nrg_arsm_get' )
local meta = FindMetaTable( 'Player' )


local function epoe_print( text )

	MsgC( Color(60, 120, 70),'[NRG-Ars Log] ',Color(255,255,255), text..'\n')

end

function meta:isvip()

	return self:IsSecondaryUserGroup "premium"

end

function meta:NRGAR_Give( pack )

	local tbl = tbl[pack]

	if !tbl then return end
	if !self:IsNRG() then return end
	if self.nrgarskd then
		self:ChatAddText(Color(60,120,70),'[Арсенал росгвардии] ',Color(255,255,255), 'Вы не можете использовать арсенал так часто. Подождите немного.' )
		return 
	end

	if self.nrgnb then 
		self:ChatAddText(Color(60,120,70),'[Арсенал росгвардии] ',Color(255,255,255), 'Вы уже взяли один набор.' )
		return 
	end
	if !self:GetNWBool( 'nrg_access_wep', false ) and !self:rg_IsCMD() then 
		self:ChatAddText(Color(60,120,70),'[Арсенал росгвардии] ',Color(255,255,255), 'У вас нету доступа к арсеналу росгвардии' )
		return 
	end
	if tbl.access and self:rg_GetLVL() < tbl.access then 
		self:ChatAddText(Color(60,120,70),'[Арсенал росгвардии] ',Color(255,255,255), 'У вас нету доступа к "'..pack..'"' )
		return 
	end
	if tbl.vip and not self:isvip() then 
		self:ChatAddText(Color(60,120,70),'[Арсенал росгвардии] ',Color(255,255,255), 'У вас нету доступа к "'..pack..'". Набор доступен только для Премиум.' )
		return 
	end
	
	for k,v in pairs( tbl.wpns ) do
		
		self:Give( v )
		self:GetWeapon( v ).DisableDrop = true

	end

	if  tbl.armor and tbl.armor > 0 then
		self:SetArmor( self:Armor() + tbl.armor )
		if self:Armor() > 100 then self:SetArmor( 100 ) end
	end

	self.nrgarskd = true
	timer.Simple( 300, function() 
		self.nrgarskd = nil
	end)
	self.nrgnb = pack
	self:SetNWString( 'nrgars_pack', pack )

	epoe_print( self:Nick()..' взял набор "'..pack..'"' )

end

function meta:NRGAR_Get( pack )

	local tbl = tbl[pack]

	if !tbl then return end
	if !self:IsNRG() then return end	

	for k,v in pairs( tbl.wpns ) do
		
		self:StripWeapon( v )

	end

	epoe_print( self:Nick()..' сдал набор "'..pack..'"' )

	self.nrgnb = nil
	self:SetNWString( 'nrgars_pack', '' )

end

net.Receive( 'nrg_arsm', function( _, ply )

	local pack = net.ReadString()

	ply:NRGAR_Give( pack )

end)

net.Receive( 'nrg_arsm_get', function( _, ply )

	local pack = net.ReadString()

	if ply.nrgnb == pack  and ply:IsNRG() then
		ply:NRGAR_Get( pack )
	end

end)


hook.Add( 'canDropWeapon', 'nrg_arsm', function( ply, weapon ) 

	if weapon.DisableDrop then return false end

end)

hook.Add( 'PlayerDeath', 'nrg_die', function( ply )

	if ply.nrgnb then
		ply.nrgnb = nil
		ply:SetNWString( 'nrgars_pack', '' )
	end

end )