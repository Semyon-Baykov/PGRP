hook.Add( "CanTool", "PrecisionFix", function(ply, tr, tool)
	if tool == "precision" then
		if ply:GetInfoNum(tool .. "_freeze", 0) ~= 1 then
			AdvDupe2.Notify( ply, "Some of precision settings is wrong. Reversed to defaults", NOTIFY_ERROR, 5)
			ply:ConCommand( tool .. "_freeze 1")
			return false
		end
	end
end)
