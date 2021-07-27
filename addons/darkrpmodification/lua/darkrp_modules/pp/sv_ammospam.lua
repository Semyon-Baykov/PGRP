local function da(t)
	for k,v in pairs(t) do
		local ph = v:GetPhysicsObject()
		if ph:IsPenetrating() then
			v:SetCollisionGroup(20)
			ph:SetVelocity(Vector())
		end
	end
end

timer.Create( ", ammo", 1, 0, function()
	local e1, e2 = ents.FindByClass( "food" ), ents.FindByClass("spawned_ammo")
	da(e1) da(e2)
end)
