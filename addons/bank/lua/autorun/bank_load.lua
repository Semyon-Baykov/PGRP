MsgN("[BankRS]: Version 1.8.1 Loaded!")

if (SERVER) then
    AddCSLuaFile("bank_config.lua")
    include("bank_config.lua")
	
	
	resource.AddFile("resource/fonts/coolvetica.ttf")
	
	else	
	include("bank_config.lua")
end
