util.AddNetworkString('RPDtraumatize')
local foot = {'ValveBiped.Bip01_R_Foot', 'ValveBiped.Bip01_L_Foot', 'ValveBiped.Bip01_R_Toe0', 'ValveBiped.Bip01_L_Toe0', 'ValveBiped.Bip01_R_Calf', 'ValveBiped.Bip01_L_Calf'}

-- def run - 250
-- def walk - 160
-- def jup - 200
local function traumatize(ply)
    if not IsValid(ply) then return end

    if ply:GetNWBool('FootIsCerebro', false) == false then
        ply.rpdmg_wspeed = ply:GetWalkSpeed()
        ply.rpdmg_rspeed = ply:GetRunSpeed()
        ply.rpdmg_jpower = ply:GetJumpPower()
    end

    ply:SetWalkSpeed(90)
    ply:SetRunSpeed(90)
    ply:SetJumpPower(90)
    ply:SetNWBool('FootIsCerebro', true)

    timer.Simple(15, function()
        if not IsValid(ply) then return end
        ply:SetWalkSpeed(ply.rpdmg_wspeed or 160)
        ply:SetRunSpeed(ply.rpdmg_rspeed or 250)
        ply:SetJumpPower(ply.rpdmg_jpower or 200)
        ply:SetNWBool('FootIsCerebro', false)
    end)

    net.Start('RPDtraumatize')
    net.Send(ply)
end

hook.Add('EntityTakeDamage', 'SRPDamage', function(ent, dmginfo)
    if ent:GetClass() == 'gmod_cameraprop' then

        if not ent.hpp then

            ent.hpp = true 

            ent:SetHealth( 100 )

        end

        ent:SetHealth( ent:Health() - dmginfo:GetDamage() )

        if ent:Health() <= 0 then

            ent:Remove()

            local effect = EffectData()

            effect:SetStart( ent:GetPos() )

            effect:SetOrigin( ent:GetPos() )

            effect:SetScale( 0.2 )

            effect:SetRadius( 20 )

            effect:SetMagnitude( 29 )


            util.Effect( 'Explosion', effect, true, true )

        end

        return

    end


    if not ent:IsPlayer() then return end
    if ent:GetNWBool('FootIsCerebro', false) then return end

    if dmginfo:IsFallDamage() then

        if ent:GetNWBool( 'DoNotFall', false ) then

            return dmginfo:ScaleDamage( 0 )

        else

            if dmginfo:GetDamage() > 20 then
                traumatize(ent)

                return dmginfo:ScaleDamage( 1.2 )
            end

        end

        return
    end

    if not dmginfo:IsBulletDamage() then return end

    for i = 1, ent:GetBoneCount() do
        if not ent:GetBonePosition(i) then return end
        if not dmginfo:GetDamagePosition() then return end

        if ent:GetBonePosition(i):Distance(dmginfo:GetDamagePosition()) < 10 then
            if ent:GetBoneName(i) == 'ValveBiped.Bip01_Head1' then
                ent:EmitSound( 'headshot.mp3' )
            end
            if table.HasValue(foot, ent:GetBoneName(i) or '') then
                traumatize(ent)
            end
        end
    end
end)