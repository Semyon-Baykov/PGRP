-- прописываем мемные консольные команды.

local daddywho = {"gmod_mcore_test 2","mat_specular 0","datacachesize 512","net_graphshowlatency 1","net_graphsolid 1","net_graphtext 1","r_fastzreject -1","cl_ejectbrass 1","Muzzleflash_light 0","cl_wpn_sway_interp 0","in_usekeyboardsampletime 0","rope_wind_dist 0", "cl_playerspraydisable 1", "mat_disable_fancy_blending 0", "r_decals 70","rope_shake 0","net_graphheight 60","net_graphmsecs 400", "r_dynamic 1", "r_decal_cullsize 0", "cl_smooth 0", "studio_queue_mode 1", "cl_show_splashes 0 ","net_graphproportionalfont 0","net_graphshowinterp 1", "r_shadows 1 " , "mp_decals 50" , "mat_forceaniso 1 ", "cl_phys_props_enable 0 ", "mat_disable_bloom 1 ", "props_break_max_pieces 0" , "violence_agibs 0" , "violence_hgibs 0" ,"r_WaterDrawReflection 0","cl_threaded_client_leaf_system 1","r_threaded_client_shadow_manager 1","r_threaded_particles 1","r_threaded_renderables 1","r_queued_ropes 1","joystick 0","violence_ablood 1","violence_hblood 1","r_cheapwaterstart 1","r_cheapwaterend 1","r_waterforceexpensive 0","r_WaterDrawRefraction 0","mat_wateroverlaysize 4", "r_lod -1" ,"cl_threaded_bone_setup 1","rope_smooth 0","cl_detaildist 400","r_3dsky 0" ,"mat_hdr_enabled","mat_hdr_level 1","mat_disable_lightwarp 1","r_drawmodeldecals 1","r_teeth 0","fov_desired 90", "mat_queue_mode 2" ,"cl_forcepreload 1","voice_recordtofile 0 ","cl_detail_avoid_radius 30","net_compressvoice 1","r_maxmodeldecal 50","r_eyemove 0","snd_mix_async 1","r_drawflecks 0","demo_avellimit 0","r_worldlights 1"}

hook.Add("PlayerAuthed","smeshno",function(pl)
	if IsValid(pl) then
		for k,v in pairs(daddywho) do
    		pl:ConCommand(v)
    	end
	end
end)

-- тут мы будем ебаться в жопу (гмодерам не привыкать)

if timer.Exists("CheckHookTimes") then
	timer.Remove("CheckHookTimes")
end

-- тут мы удаляем лишнее говно с карты которое как бы нагружает и нахуй не сдалось на самом деле...
-- пока что тут пусто ибо дед будед тестировать в дальнейшем что нах не надо.

local listgovna = {
	"env_fire",
	"trigger_hurt",
	"prop_physics",
	"light",
	"spotlight_end",
	"beam",
	"point_spotlight",
	"env_sprite",
	"func_tracktrain",
	"light_spot",
	"point_template"
}

for _, class in pairs(listgovna) do
	for __, ent in pairs(ents.FindByClass(class)) do
		ent:Remove()
	end
end

-- убираем нах ненужное гавноицо
-- если ты трушный разберешься блять.

local GM = GAMEMODE

local CalcMainActivity = GM.CalcMainActivity
local animcs = 1 / 5
function GM:CalcMainActivity(pl, ...)
	local now = CurTime()
	pl.__LastMainAct = pl.__LastMainAct or now
	if pl.__LastMainAct > now then return pl.CalcIdeal, pl.CalcSeqOverride end
	pl.__LastMainAct = now + animcs
	return CalcMainActivity(self, pl, ...)
end

local function gavnooff() end
GM.MouthMoveAnimation = gavnooff
GM.GrabEarAnimation = gavnooff