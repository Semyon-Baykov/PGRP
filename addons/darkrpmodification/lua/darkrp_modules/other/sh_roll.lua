DarkRP.declareChatCommand{
	command = "roll",
	description = "Кинуть кубик.",
	delay = 1.5
}

if SERVER then
	DarkRP.defineChatCommand("roll", function(ply, n)
		n = tonumber(n) or 2
		DarkRP.talkToRange(ply, "/roll", ("%s кидает кубик с числом (%d). Выпало число %d."):format(ply:Name(), n, math.random(1, n)), 250)
		return ""
	end)
end