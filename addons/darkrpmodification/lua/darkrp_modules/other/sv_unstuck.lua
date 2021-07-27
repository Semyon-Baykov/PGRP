local Player = FindMetaTable( 'Player' )


function Player:SN_IsStucked()
	return util.TraceEntity( { start = self:GetPos(), endpos = self:GetPos(), mask = MASK_PLAYERSOLID, filter = self }, self ).StartSolid
end

function Player:SN_FindPlace( direction )
	local i = 0

	while i < 150 do
		local Origin = self:GetPos()
		
		Origin = Origin + direction
		
		self:SetPos( Origin )
		
		if not self:SN_IsStucked() then
			return true
		end
		
		i = i + 1
	end
	
	return false
end

function Player:SN_UnStuck()
	if self:SN_IsStucked() and not self:InVehicle() then
		if  not self:SN_FindPlace( self:GetRight() ) and
		   	not self:SN_FindPlace( -self:GetRight() ) and
		   	not self:SN_FindPlace( self:GetForward() ) and
		   	not self:SN_FindPlace( -self:GetForward() ) and
		   	not self:SN_FindPlace( self:GetUp() ) and
		   	not self:SN_FindPlace( -self:GetUp() )
		then
			self:ChatPrint( '[UnStuck] Невозможно найти поверхность' )
			return false
		end
	else
		return false
	end
end

hook.Add( 'PlayerSay', 'UnStuck', function( ply, text )
	text = string.lower( text )
	if string.find( text, 'застрял' ) or text == '!unstuck' then
		ply:SN_UnStuck()
	end
end )