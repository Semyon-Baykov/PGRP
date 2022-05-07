local Player = FindMetaTable( 'Player' )

function Player:isTaxist()
	return self:getJobTable().taxist == true
end

for _, cmd in pairs{"requestmed", "medrequest"} do
    DarkRP.declareChatCommand{
        command = cmd,
        description = "Вызвать медика",
        delay = 1.5
    }
end