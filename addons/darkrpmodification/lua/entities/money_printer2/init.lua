AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")




function ENT:Initialize()
    self:initVars()
    self:SetModel(self.model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()
    self:SetUseType( SIMPLE_USE )

    self:SetHealth( 100 )
    self:Initialize_sv()
    if self.info.owner != NULL then
        self:Setowning_ent( self.info.owner )
    end

end

function ENT:OnTakeDamage(dmg)
    
    if self.CanUnArrest then return end
    local d = dmg:GetDamage()

    self:SetHealth( self:Health() - d )
    if self:Health() <= 0 then
       if self.info.fired == true then return end
       self:Fire_mp()

       if dmg:GetAttacker():isCP() then
            DarkRP.notify( dmg:GetAttacker(), 0, 5, 'Вы получили '..DarkRP.formatMoney( 3500 )..' за уничтожение денежного принтера.' )
            dmg:GetAttacker():addMoney( 3500 )
       end
    end



end


function ENT:Think()
    if self:WaterLevel() > 0 then
        
        self:Remove()
        return
    end
    self:NextThink( CurTime() )
    return true
end

function ENT:OnRemove()

    if self.sound then
        self.sound:Stop()
    end

end

function ENT:Use( ply )
    if self.info.arrested and not ply:isCP() then
        self:UnArrest_mp( ply )
    else
        self:OpenMenu( ply )
    end

end
