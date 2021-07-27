local MODULE = GAS.Logging:MODULE()

MODULE.Category = "APhone"
MODULE.Name = "Deepweb"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("aphone_deepweb", "Blogs_Deepweb", function(owner, target, price)
		MODULE:Log(aphone.L("BLogs_Deepweb_Create") .. aphone.Gamemode.Format(price), GAS.Logging:FormatPlayer(owner), GAS.Logging:FormatPlayer(target))
	end)

	MODULE:Hook("aphone_deepwebdelete", "Blogs_Deepweb", function(owner, target, price)
		MODULE:Log(aphone.L("BLogs_Deepweb_Remove") .. aphone.Gamemode.Format(price) .. " est fini", GAS.Logging:FormatPlayer(owner), GAS.Logging:FormatPlayer(target))
	end)
end)

GAS.Logging:AddModule(MODULE) // This function adds the module object to the registry.