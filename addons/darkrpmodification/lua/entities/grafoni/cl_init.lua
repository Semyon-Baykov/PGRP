 include("shared.lua");


function ENT:DrawTranslucent()
	self:Draw();


end;

function ENT:Initialize()
	AddNPCText( self, 'Нариман Графонов', 'Мастер тюнинга и колхоза', Color( 0, 255, 102 ) )
end




function ENT:BuildBonePositions(NumBones, NumPhysBones)
end;

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn;
end;

function ENT:DoRagdollBone(PhysBoneNum, BoneNum)
	--self:SetBonePosition( BoneNum, Pos, Angle )
end;

