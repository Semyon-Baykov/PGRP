local cmd = {
   -- r_shadows = {0, GetConVarNumber},
    r_shadowrendertotexture = {0, GetConVarNumber},
    r_shadowmaxrendered = {0, GetConVarNumber},
    mat_shadowstate = {0, GetConVarNumber},
    cl_phys_props_enable = {0, GetConVarNumber},
    cl_phys_props_max = {0, GetConVarNumber},
    props_break_max_pieces = {0, GetConVarNumber},
    r_propsmaxdist = {0, GetConVarNumber},
    r_drawmodeldecals = {0, GetConVarNumber},
    cl_threaded_bone_setup = {1, GetConVarNumber},
    cl_threaded_client_leaf_system = {1, GetConVarNumber},
    r_threaded_client_shadow_manager = {1, GetConVarNumber},
    r_threaded_particles = {1, GetConVarNumber},
    r_threaded_renderables = {1, GetConVarNumber},
    r_queued_ropes = {1, GetConVarNumber},
    studio_queue_mode = {1, GetConVarNumber},
    mat_queue_mode = {2, GetConVarNumber},
    gmod_mcore_test = {1, GetConVarNumber}
}

local nazad = {}

print([[=============PGRP OPTIMIZER=============]])
for k, v in pairs(cmd) do
    nazad[k] = v[2](k)
    RunConsoleCommand(k, v[1])
    print(k.. ' optimized')
end
print([[===========================================]])

hook.Add('ShutDown', 'nazadblyat', function()
    for k, v in pairs(nazad) do
        RunConsoleCommand(k, v)
    end
end)

kal, ran = kal or hook.Call, ran or hook.Run
local pis = file.Exists("debug.gportal", "BASE_PATH")

function hook.Call(...)
	if pis then 
		print(debug.getinfo(2).short_src, ...)
	end

	return kal(...)
end

function hook.Run(...)
	if pis then 
		print(debug.getinfo(2).short_src, ...)
	end

	return ran(...)
end