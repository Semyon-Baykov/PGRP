AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
 
    self:SetModel( 'models/chamcontent/distributor.mdl' )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self.count = 5
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end



function ENT:Use( _, ply )

    if ply:IsNRG() and not self.kd then
        self.kd = true
        timer.Simple( 3, function() self.kd = false end)
        if self.count <= 0 then
           DarkRP.notify(ply, 0, 10, 'Перезагрузка. Осталось: '..os.date('%M:%S',self.countkd-os.time()))
           self:EmitSound( 'buttons/button11.wav', 75, 100, 1, CHAN_AUTO )
           return
        end
        
        self:EmitSound( 'garrysmod/save_load1.wav', 75, 100, 1, CHAN_AUTO )
        local _ = ents.Create( 'ent_mre2_rus' )
        _:SetPos( self:GetPos()-Vector( -5, 7, -60 ) )
        _:SetAngles( self:GetAngles()+Angle( 45, 90, 0 ) )
        _:SetModel('models/sngration/sngr_irp5.mdl')
        _:Spawn()
        self.count = self.count - 1
        if self.count <= 0 then
          self.countkd = os.time()+300
          timer.Simple( 300, function()
              self.count = 5
          end)
        end
    end

end