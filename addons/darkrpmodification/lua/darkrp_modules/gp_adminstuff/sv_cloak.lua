local CloakThink

function fCloak(ply)
    local target = ply

        if IsValid(target) and not target:GetNWBool( 'gpa_cloaked' ) then
            target:SetNWBool( 'gpa_cloaked', true )
            target:SetCollisionGroup( 11 )
            target:SetNoDraw(true)
            for k, v in pairs(target:GetWeapons()) do
                v:SetNoDraw(true)
            end

            for k,v in pairs(ents.FindByClass("physgun_beam")) do
                if v:GetParent() == target then
                    v:SetNoDraw(true)
                end
            end

            hook.Add("Think", "FAdmin_Cloak", CloakThink)
        return true
    end
end

function fUnCloak(ply)
        local target = ply

        if IsValid(target) and target:GetNWBool( 'gpa_cloaked' ) then
            target:SetNWBool( 'gpa_cloaked', false )

            target:SetNoDraw(false)
            target:SetCollisionGroup( 5 )

            for k, v in pairs(target:GetWeapons()) do
                v:SetNoDraw(false)
            end

            for k,v in pairs(ents.FindByClass("physgun_beam")) do
                if v:GetParent() == target then
                    v:SetNoDraw(false)
                end
            end

            target.FAdmin_CloakWeapon = nil

            local RemoveThink = true
            for k,v in pairs(player.GetAll()) do
                if v:GetNWBool( 'gpa_cloaked' ) then
                    RemoveThink = false
                    break
                end
            end
            if RemoveThink then hook.Remove("Think", "FAdmin_Cloak") end
        end
    


    return true
end


function CloakThink()
    for k,v in pairs(player.GetAll()) do
        local ActiveWeapon = v:GetActiveWeapon()
        if v:GetNWBool( 'gpa_cloaked' ) and IsValid(ActiveWeapon) and ActiveWeapon ~= v.FAdmin_CloakWeapon then
            v.FAdmin_CloakWeapon = ActiveWeapon
            ActiveWeapon:SetNoDraw(true)

            if ActiveWeapon:GetClass() == "weapon_physgun" then
                for a,b in pairs(ents.FindByClass("physgun_beam")) do
                    if b:GetParent() == v then
                        b:SetNoDraw(true)
                    end
                end
            end
        end
    end
end

hook.Add( 'EntityTakeDamage', 'FAdmin_Cloak', function( ent, dmginfo )

    if ent:IsPlayer() then
        if ent:GetNWBool( 'gpa_cloaked' ) then
            return dmginfo:ScaleDamage( 0 )
        end
    end

end )