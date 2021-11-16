local meta = FindMetaTable( 'Player' )

function meta:gp_VipAccess()

	return self:IsSecondaryUserGroup("premium")

end


function meta:gp_IsAdmin()

	return self:GetUserGroup() == 'moder' or self:GetUserGroup() == 'admin' or self:GetUserGroup() == 'admin+' or self:GetUserGroup() == 'donsuperadmin' or self:GetUserGroup() == 'owner' or self:GetUserGroup() == 'superadmin' or self:GetUserGroup() == 'sponsor+' or self:GetUserGroup() == 'nab_moder-' or self:GetUserGroup() == 'nab_moder+' or self:GetUserGroup() == 'nab_admin' or self:GetUserGroup() == 'rukovoditel'

end

function  meta:gp_IsSuperAdmin()

	return self:GetUserGroup() == 'superadmin'

end

function meta:gp_WepAccess()

	return self:GetUserGroup() == 'donsuperadmin' or self:GetUserGroup() == 'owner' or self:GetUserGroup() == 'superadmin' or self:GetUserGroup() == 'nab_admin' or self:GetUserGroup() == 'sponsor+' or self:GetUserGroup() == 'nab_moder+' or self:GetUserGroup() == 'rukovoditel'

end

function meta:gp_VehAccess()

	return self:GetUserGroup() == 'superadmin' or self:GetUserGroup() == 'sponsor+' or self:GetUserGroup() == 'owner' or self:GetUserGroup() == 'nab_moder+' or self:GetUserGroup() == 'nab_admin' or self:GetUserGroup() == 'rukovoditel'

end
function meta:gp_SentAccess()

	return self:GetUserGroup() == 'superadmin' or self:GetUserGroup() == 'sponsor+' or self:GetUserGroup() == 'nab_moder+' or self:GetUserGroup() == 'nab_admin' or self:GetUserGroup() == 'rukovoditel'

end

function meta:E2_FullAccess()

	return self:GetUserGroup() == 'superadmin' or self:GetUserGroup() == 'sponsor+'
	
end