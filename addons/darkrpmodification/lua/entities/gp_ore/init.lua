AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel( 'models/minestone_gprp/minestone_gprp.mdl' )
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetHealth(400)
    self.destroyed = false
    self.type = 0
    self:SetBodygroup( 0, 0 )
    self:SetBodygroup( 1, 0 )
    local rand = math.random( 1, 6)

    if rand == 1 then
    	self.type = 1
    elseif rand == 2 then
    	self.type = 2
    else
    	self.type = 3
    end

    if self.type == 1 then
    	self:SetSkin( 0 )
    end
    if self.type == 2 then
    	self:SetSkin( 1 )
    end
     if self.type > 2 then
    	self:SetBodygroup( 0, 5 )
    end

end

function ENT:OnTakeDamage(dmg)

    local ply = dmg:GetAttacker()

    if ply:Team() == TEAM_MINER then
   
        if ply:GetActiveWeapon():GetClass() == 'weapon_hl2pickaxe' then
   
            self:SetHealth(self:Health() - dmg:GetDamage())

            if self:Health() <= 0 and !self.destroyed then
            	self.destroyed = true
            	ply:SetNWInt( 'gp_mining_'..self.type, ply:GetNWInt( 'gp_mining_'..self.type  )  + 1 )
            	ply:ChatAddText( Color( 255, 196, 0 ), '[GPRP Mine] ', Color( 255, 255, 255 ), 'Вы добыли х1 '..gp_mining.tbl[self.type].name..'!' )
            	timer.Simple( 1800, function()

            		self:Initialize()

            	end )
            end


            if self:Health() <= 0 then
                self:SetBodygroup( 1, 5 )
                if self.type < 3 then
                	self:SetBodygroup( 0, 5 )
            	end
            elseif self:Health() <= 80 then
                self:SetBodygroup( 1, 4 )
                if self.type < 3 then
                	self:SetBodygroup( 0, 4 )
                end
            elseif self:Health() <= 170 then
                self:SetBodygroup( 1, 3 )
                if self.type < 3 then
                	self:SetBodygroup( 0, 3 )
           		end
           elseif self:Health() <= 280 then
                self:SetBodygroup( 1, 2 )
                if self.type < 3 then
                	self:SetBodygroup( 0, 2 )
          		end
           elseif self:Health() <= 350 then
                self:SetBodygroup( 1, 1 )
                if self.type < 3 then
                	self:SetBodygroup( 0, 1 )
            	end
            end

        end

    end

end

function ENT:OnRemove()

end