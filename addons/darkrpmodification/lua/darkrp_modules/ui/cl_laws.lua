function showlawlist()
	local laws = ""


for k, v in pairs(DarkRP.getLaws()) do		


	laws = laws .. "\n" .. k .. ". " .. v


end
		local frame = vgui.Create("gpFrame")
		frame:SetSize(500,500)
		frame:Center()
		frame:ShowCloseButton(false)
		frame:MakePopup()
		frame:SetTitle('Свод законов')

	 	
		local label = frame:Add("RichText")
		function label:Paint()
			self:SetFontInternal("DermaDefault")
			self.Paint = nil
		end

		label:Dock(FILL)
		label:SetWrap(true)
		label:InsertColorChange(255, 255, 255, 255)
		label:AppendText(laws:sub(2))
		


end


