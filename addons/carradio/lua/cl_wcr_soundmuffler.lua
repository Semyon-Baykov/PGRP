
local wcr_mufflesounds = CreateConVar("wyozicr_mufflesounds", "0", FCVAR_ARCHIVE)

hook.Add("Think", "WCR_SoundMuffler", function()
	-- VCMod exists, shouldn't use our own implementation
	if vcmod1 ~= nil then return end

	local muffled = wyozicr.SoundMuffled
	local shouldbemuffled = IsValid(LocalPlayer():GetVehicle()) and wcr_mufflesounds:GetBool()

	if muffled ~= shouldbemuffled then
		LocalPlayer():SetDSP(shouldbemuffled and 31 or 0, false)
		wyozicr.SoundMuffled = shouldbemuffled
	end
end)

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 