AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')


 function ENT:Initialize()
	self:SetModel('models/Humans/Group01/Male_Cheaple.mdl')
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)
	self:SetNWInt("distance", 500)


end;

function ENT:AcceptInput(name, activator, caller)

	if caller:GetNWEntity( 'gpcard_veh' ) != NULL then
		local tbl = util.JSONToTable(caller:GetNWString( 'gpcard_cartable' ))
	
		if !tbl.info.gov  then
			caller:OpenTuneMenu( util.JSONToTable(caller:GetNWString( 'gpcard_cartable' )).info.class )
		end
	else

		caller:ChatAddText( Color( 102, 204, 255 ), '[GPRP Tune] ', Color( 255, 255, 255 ), 'Для того, чтобы воспользоватся тюнингом необходимо заспавнить т/c.' )

	end

end
