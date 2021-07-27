local MODULE = GAS.Logging:MODULE()

MODULE.Category = "APhone"
MODULE.Name = "Calls"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("aphone_calls", "Blogs_APhoneCalls", function(id, user1, user2)
        if id == 1 then
		    MODULE:Log(aphone.L("BLogs_Call_Pending"), GAS.Logging:FormatPlayer(user1), GAS.Logging:FormatPlayer(user2))
        elseif id == 2 then
            MODULE:Log(aphone.L("BLogs_Call_Accept"), GAS.Logging:FormatPlayer(user1), GAS.Logging:FormatPlayer(user2))
        elseif id == 3 then
            MODULE:Log(aphone.L("BLogs_Call_Stop"), GAS.Logging:FormatPlayer(user1), GAS.Logging:FormatPlayer(user2))
        end
	end)
end)

GAS.Logging:AddModule(MODULE) // This function adds the module object to the registry.