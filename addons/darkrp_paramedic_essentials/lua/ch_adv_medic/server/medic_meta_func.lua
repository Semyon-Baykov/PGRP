local PMETA = FindMetaTable( "Player" )

function PMETA:CreateCorpse()
    -- Create the corpse and connect it with the player
    local corpse = ents.Create( "prop_ragdoll" )
    corpse:SetPos( self:GetPos() )
    corpse:SetAngles( self:GetAngles() )
    corpse:SetModel( self:GetModel() )
    corpse:SetOwner( self )
    corpse:SetNWBool( "RagdollIsCorpse", true )
	if self.HasLifeAlert then
		corpse:SetNWBool( "HasLifeAlert", true )
		
		if CH_AdvMedic.Config.LifeAlertNotifyMedic then
			for k, ply in ipairs( player.GetAll() ) do
				if table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
					DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["A player with a life alert has died. Their location is marked on your map!"][CH_AdvMedic.Config.Language] )
				end
			end
		end
	end
	
	-- Thanks to https://wiki.garrysmod.com/page/Entity/GetPhysicsObjectCount and https://wiki.garrysmod.com/page/Entity/GetPhysicsObjectNum and a bit of looking at TTT code :)
    for i = 0, corpse:GetPhysicsObjectCount() - 1 do
        local bone = self:GetPhysicsObjectNum( i )

        if IsValid( bone ) then
            local bonepos, boneang = self:GetBonePosition( corpse:TranslatePhysBoneToBone( i ) )

            if bonepos and boneang then
                bone:SetPos( bonepos )
                bone:SetAngles( boneang )
            end
        end
    end

    corpse:Spawn()
    corpse:Activate()
	corpse:AddEFlags( EFL_IN_SKYBOX )
	
	-- Update bodygroups, color and skin accordingly
	corpse:SetColor( self:GetColor() )
	corpse:SetRenderMode( RENDERMODE_TRANSCOLOR )
	corpse:SetSkin( self:GetSkin() )
	
    for k, v in pairs( self:GetBodyGroups() ) do
        corpse:SetBodygroup( k - 1, self:GetBodygroup( k - 1 ) )
    end
	
    self.DeathRagdoll = corpse
    return corpse
end

function PMETA:GetPlayersSex()
	if string.find( string.sub( self:GetModel(), 2 ), "f" ) then
		return "Female"
	elseif table.HasValue( CH_AdvMedic.Config.AlternativeFemaleModels, team.GetName( self:GetModel() ) ) then
		return "Female"
	elseif string.find( string.sub( self:GetModel(), 2 ), "m" ) then
		return "Male"
	elseif table.HasValue( CH_AdvMedic.Config.AlternativeMaleModels, team.GetName( self:GetModel() ) ) then
		return "Male"
	end
end

function PMETA:HasInjury()
	if self.HasBrokenArm or self.HasBrokenLeg or self.HasInternalBleedings then
		return true
	else 
		return false
	end
end
