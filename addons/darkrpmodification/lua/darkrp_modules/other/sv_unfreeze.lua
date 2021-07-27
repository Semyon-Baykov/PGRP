hook.Add( "PlayerSay", "uf_ps", function( ply, text, team )
	-- Make the chat message entirely lowercase
	if ( string.sub( string.lower( text ), 1, 3 ) == "/uf" ) then
		if not (ply:GetUserGroup() == 'superadmin' or ply:GetUserGroup() == 'sponsor+' or ply:GetUserGroup() == 'slavaukraine') then return end 
		if ply:GetEyeTrace() and ply:GetEyeTrace().Entity then
			local phys = ply:GetEyeTrace().Entity:GetPhysicsObject()
			phys:EnableMotion(true) 
		end
		return false 
	end
end )
local meta = FindMetaTable('Player')
function meta:build_chat( text )
	self:ChatAddText( Color(255, 120, 70), '[GPRP AdminStuff] ', Color( 255, 255, 255 ), text )
end

hook.Add( "PlayerSay", "bm_ps", function( ply, text, team )
	-- Make the chat message entirely lowercase
	if ( string.sub( string.lower( text ), 1, 10 ) == "/buildmode" ) then
		if not (ply:GetUserGroup() == 'superadmin' or ply:GetUserGroup() == 'sponsor+' or ply:GetUserGroup() == 'slavaukraine') then return end 
			if ply.buildermod == true then
				ply.buildermod = false
				ply:build_chat('Вы отключили режим строителя.')
			else
				ply.buildermod = true
				ply:build_chat('Вы включили режим строителя. Будьте аккуратны, большое количество физически-активных пропов сильно нагружает сервер.')
			end
			return false
		end 

	if ( string.sub( string.lower( text ), 1, 10 ) == "/anon" ) then
		if not (ply:GetUserGroup() == 'superadmin'  or ply:GetUserGroup() == 'slavaukraine') then return end 
			if ply:GetNWBool( 'anon', false ) == true then
				ply:SetNWBool( 'anon', false )
				ply:build_chat('Вы отключили режим anon.')
			else
				ply:SetNWBool( 'anon', true )
				ply:build_chat('Вы включили режим anon. Теперь вы не отображаетесь в табе.')
			end
			return false
		end 
end )