--  _               _            _   ____              _                      _       __  __           _            
-- | |    ___  __ _| | _____  __| | | __ ) _   _      | | ___  ___  ___ _ __ | |__   |  \/  | __ _ ___| |_ ___ _ __ 
-- | |   / _ \/ _` | |/ / _ \/ _` | |  _ \| | | |  _  | |/ _ \/ __|/ _ \ '_ \| '_ \  | |\/| |/ _` / __| __/ _ \ '__|
-- | |__|  __/ (_| |   <  __/ (_| | | |_) | |_| | | |_| | (_) \__ \  __/ |_) | | | | | |  | | (_| \__ \ ||  __/ |   
-- |_____\___|\__,_|_|\_\___|\__,_| |____/ \__, |  \___/ \___/|___/\___| .__/|_| |_| |_|  |_|\__,_|___/\__\___|_|   
--                                          |___/                      |_|                                          
include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel();
end;

function ENT:Initialize()
	AddNPCText( self, 'Борис Тайский', 'Барыга', Color( 250, 218, 90 ) )
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:BuildBonePositions( NumBones, NumPhysBones )
end
 
function ENT:SetRagdollBones( bIn )
	self.m_bRagdollSetup = bIn
end

function ENT:DoRagdollBone( PhysBoneNum, BoneNum )
--self:SetBonePosition( BoneNum, Pos, Angle )
end

--[[
size = 128;
draw_set_blend_mode(bm_subtract);
surface_set_target(light);
draw_ellipse_color(x-(size/2)-view_xview,y-(size/2)-view_yview,x+(size/2)-view_xview,y+(size/2)-view_yview, c_white, c_black, false);

surface_reset_target();
draw_set_blend_mode(bm_normal);
]]--