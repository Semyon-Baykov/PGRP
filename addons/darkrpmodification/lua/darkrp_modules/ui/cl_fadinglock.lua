hook.Add("HUDPaint", "dawdawd", function()

	local lp = LocalPlayer()

	local tr = lp:GetEyeTraceNoCursor()

	if tr.Entity:IsValid() then

		local y = 28



		if tr.HitPos:DistToSqr(lp:EyePos()) < 22500 then

			local mat = hook.Run("TargetIDIcon", tr.Entity)

			if mat then

				surface.SetMaterial(mat)

				surface.SetDrawColor(color_white)

				surface.DrawTexturedRect(ScrW() / 2 - 8, ScrH() / 2 + y - 8, 16, 16)

				y = y + 26

			end

			local text = hook.Run("TargetIDText", tr.Entity)

			if text then

				draw.SimpleText(text, "TargetID", ScrW() / 2, ScrH() / 2 + y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				y = y + 24

			end

		end

	end

end)



local mat = Material("icon16/lock.png")

hook.Add("TargetIDIcon", "IsFadingDoor", function(ent)

	return ent:GetNWBool("IsFadingDoor") and mat or nil

end)