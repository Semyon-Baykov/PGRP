local meta = FindMetaTable("Player")

function meta:newHungerData()
    if not IsValid(self) then return end
    self:setSelfDarkRPVar("Energy", 100)
end

function meta:SetEnergy( amount )

    self:setSelfDarkRPVar( 'Energy', amount )

end

function meta:hungerUpdate()
    if not IsValid(self) then return end
    if not GAMEMODE.Config.hungerspeed then return end

    local energy = self:getDarkRPVar("Energy")
    local override = hook.Call("hungerUpdate", nil, self, energy)

    if override then return end
    if self:gp_VipAccess() then
        self:setSelfDarkRPVar("Energy", energy and math.Clamp(energy - 0.0625, 0, 100) or 100)
    else
        self:setSelfDarkRPVar("Energy", energy and math.Clamp(energy - 0.25, 0, 100) or 100)
    end
    if self:getDarkRPVar("Energy") == 0 then
        if self:Health() <= 10 then return end
        self:SetHealth(self:Health() - GAMEMODE.Config.starverate)
        if self:Health() <= 0 then
            self.Slayed = true
            self:Kill()
            hook.Call("playerStarved", nil, self)
        end
    end
end
