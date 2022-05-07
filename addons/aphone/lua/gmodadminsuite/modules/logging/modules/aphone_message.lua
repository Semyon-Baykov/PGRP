local MODULE = GAS.Logging:MODULE()

MODULE.Category = "APhone"
MODULE.Name = "Messages"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("aphone_insertmessages", "Blogs_InsertMessages", function(user1, user2, body)
		MODULE:Log(aphone.L("BLogs_Message") .. body, GAS.Logging:FormatPlayer(user1), GAS.Logging:FormatPlayer(user2))
	end)

	MODULE:Hook("aphone_insertmessagesoffline", "Blogs_InsertMessages", function(user1, user2, body)
		MODULE:Log(aphone.L("BLogs_MessageOffline", user2) .. body, GAS.Logging:FormatPlayer(user1))
	end)
end)

GAS.Logging:AddModule(MODULE) // This function adds the module object to the registry.