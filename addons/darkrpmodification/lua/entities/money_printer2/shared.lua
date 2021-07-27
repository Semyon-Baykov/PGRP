ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "gprp_printer"
ENT.Author = "KaiL"
ENT.Spawnable = true
ENT.Category    = "GPRP"
ENT.IsMoneyPrinter = true
ENT.AutomaticFrameAdvance = true


function ENT:initVars()
    self.model = "models/props_c17/consolebox01a.mdl"
    self.DisplayName = "Денежный принтер"

end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 0, "owning_ent")
end

