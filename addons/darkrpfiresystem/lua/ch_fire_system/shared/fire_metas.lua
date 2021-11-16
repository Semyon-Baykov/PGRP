local PMETA = FindMetaTable( "Player" )
local EMETA = FindMetaTable( "Entity" )

function PMETA:IsFireFighter()
	return table.HasValue( CH_FireSystem.Config.AllowedTeams, team.GetName( self:Team() ) )
end

function EMETA:IsFireTruck()
	return table.HasValue( CH_FireSystem.Config.FiretruckModels, self:GetModel() )
end