local RankIcons = {}
local function mat(texture) return Material(texture, 'smooth') end

hook.Add('Initialize', 'SetupPixVis', function()
    pixvis = util.GetPixelVisibleHandle()
end)



local function DrawRankIcons( self )

    local pos = self:EyePos()
    local nick = self:Nick()
    local visible = util.PixelVisible( self:GetPos(), 16, pixvis )
    

    pos.z = pos.z + 25
    pos = pos:ToScreen()

    if self:rg_GetRank() and gp_rg.tbl[ self:rg_GetRank()  ] and self:IsNRG() then
        if visible > 0.1 then
            surface.SetMaterial( Material(gp_rg.tbl[ self:rg_GetRank()  ].icon, 'smooth') )
            surface.SetDrawColor(255,255,255,255)
            surface.DrawTexturedRect(pos.x - 25, pos.y - 105, 50, 85)
        end
    end

end

local function ranksys_ld()

    local LP = LocalPlayer()
    local shootPos = LP:GetShootPos()
    local aimVec = LP:GetAimVector()
    local tr = LP:GetEyeTrace()
    local allPlayers = player.GetAll()

    for i = 1, #allPlayers do

        local ply = allPlayers[i]

        if ply == LP or not ply:Alive() or ply:GetNoDraw() then continue end

        local hisPos = ply:GetShootPos()

        if hisPos:DistToSqr(shootPos) < 160000 then

            local pos = hisPos - shootPos

            local unitPos = pos:GetNormalized()

            if unitPos:Dot(aimVec) > 0.45 then

                local trace = util.QuickTrace(shootPos, pos, LP)

                DrawRankIcons(ply)

            end

        end

    end

end

local function rIHUD()
    ranksys_ld()
end
hook.Add("HUDPaint","drawRankIconsHUD",rIHUD)
