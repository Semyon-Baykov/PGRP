local tbl = {
	'Если вы застряли, напишите в чат "застрял"',
	'Покупая донат вы помогаете серверу в развитии! (F9)',
	'Канал в discord: https://discord.gg/Nt4jkRg',
	'Только в дискорде вы можете оставлять жалобы!'
}

function gpinfo( text )
	if text then
		chat.AddText( Color(0, 186, 255), '[!] ', Color(255,255,255), text )
	end
end


local function rotate()
	timer.Simple( 600, function()
		for k,v in pairs( tbl ) do
			gpinfo(v)
		end
		rotate()
	end)
end

hook.Add( 'InitPostEntity', 'gpinfo_init', function() 
	rotate()
end)