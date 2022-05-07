function wyozicr.GetCarEnts()
	local possible_ents = {}
	table.Add(possible_ents, ents.FindByClass("prop_vehicle_jeep"))
	table.Add(possible_ents, ents.FindByClass("prop_vehicle_jeep_old"))
	table.Add(possible_ents, ents.FindByClass("sent_sakarias_car_*"))
	table.Add(possible_ents, ents.FindByClass("gmod_sent_vehicle_fphysics_base"))
	return possible_ents
end
