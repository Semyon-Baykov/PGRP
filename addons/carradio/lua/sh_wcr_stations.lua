wyozicr.AllStations = {}

timer.Create("WyoziCR_UpdateStations", 1, 0, function()
	table.Empty(wyozicr.AllStations)
	table.Add(wyozicr.AllStations, wyozicr.Stations)

	local ctrls = ents.FindByClass("wdj_mastercontroller")
	table.sort(ctrls, function(a,b) return a:EntIndex() < b:EntIndex() end)

	for _,e in pairs(ctrls) do
		local name
		if e.GetChannelNameFormatted then
			name = e:GetChannelNameFormatted()
		else
			name = "Radio Ch. " .. e:GetChannel()
		end
		table.insert(wyozicr.AllStations, {
			Name = name,
			WDJ_Channel = e:GetChannel()
		})
	end
end)

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 