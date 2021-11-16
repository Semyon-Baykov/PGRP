AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Arrest Baton"
    SWEP.Slot = 1
    SWEP.SlotPos = 3
end

DEFINE_BASECLASS("stick_base")

SWEP.Instructions = "Left click to arrest\nRight click to switch batons"
SWEP.IsDarkRPArrestStick = true

SWEP.Spawnable = true
SWEP.Category = "DarkRP (Utility)"

SWEP.StickColor = Color(255, 0, 0)

SWEP.Switched = true

DarkRP.hookStub{
    name = "canArrest",
    description = "Whether someone can arrest another player.",
    parameters = {
        {
            name = "arrester",
            description = "The player trying to arrest someone.",
            type = "Player"
        },
        {
            name = "arrestee",
            description = "The player being arrested.",
            type = "Player"
        }
    },
    returns = {
        {
            name = "canArrest",
            description = "A yes or no as to whether the arrester can arrest the arestee.",
            type = "boolean"
        },
        {
            name = "message",
            description = "The message that is shown when they can't arrest the player.",
            type = "string"
        }
    },
    realm = "Server"
}

function SWEP:Deploy()
    self.Switched = true
    return BaseClass.Deploy(self)
end

function SWEP:PrimaryAttack()
    BaseClass.PrimaryAttack(self)

    if CLIENT then return end

    self:GetOwner():LagCompensation(true)
    local trace = util.QuickTrace(self:GetOwner():EyePos(), self:GetOwner():GetAimVector() * 90, {self:GetOwner()})
    self:GetOwner():LagCompensation(false)

    local ent = trace.Entity
    if IsValid(ent) and ent.onArrestStickUsed then
        ent:onArrestStickUsed(self:GetOwner())
        return
    end

    ent = self:GetOwner():getEyeSightHitEntity(nil, nil, function(p) return p ~= self:GetOwner() and p:IsPlayer() and p:Alive() and p:IsSolid() end)

    local stickRange = self.stickRange * self.stickRange
    if not IsValid(ent) or (self:GetOwner():EyePos():DistToSqr(ent:GetPos()) > stickRange) or not ent:IsPlayer() then return end
	if ent:Team() == TEAM_POLICE or ent:Team() == TEAM_DPS or ent:Team() == TEAM_PPS or ent:Team() == TEAM_CHIEF or ent:Team() == TEAM_MAYOR or ent:Team() == TEAM_ADMIN or ent:Team() == TEAM_NRG1 or ent:Team() == TEAM_FBI or ent:Team() == TEAM_OMON then
		DarkRP.notify(self:GetOwner(), 1, 5, 'Вы не можете арестовать этого игрока. Его профессия находится в списке гос-работников!')
		return
	end

    --ent:arrest(nil, self:GetOwner())
    --DarkRP.notify(ent, 0, 20, DarkRP.getPhrase("youre_arrested_by", self:GetOwner():Nick()))
	local activator = self:GetOwner() 
	ent:Lock()
	net.Start("RealisticPolice:HandCuff")
		net.WriteString("Jailer")
		net.WriteString(ent:GetName())
	net.Send(activator)
	
    if self:GetOwner().SteamName then
        DarkRP.log(self:GetOwner():Nick() .. " (" .. self:GetOwner():SteamID() .. ") arrested " .. ent:Nick(), Color(0, 255, 255))
    end

	timer.Simple( 15, function() ent:UnLock() self:GetOwner():UnLock() end )

end

function SWEP:startDarkRPCommand(usrcmd)
    if game.SinglePlayer() and CLIENT then return end
    if usrcmd:KeyDown(IN_ATTACK2) then
        if not self.Switched and self:GetOwner():HasWeapon("unarrest_stick") then
            usrcmd:SelectWeapon(self:GetOwner():GetWeapon("unarrest_stick"))
        end
    else
        self.Switched = false
    end
end
