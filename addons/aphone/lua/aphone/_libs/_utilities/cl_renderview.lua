aphone.RV = {}

// Function caching
local get_rt = GetRenderTarget
local create_mat = CreateMaterial
local push_rt = render.PushRenderTarget
local pop_rt = render.PopRenderTarget
local clear_rt = render.Clear
local renderview = render.RenderView

function aphone.RenderView_Start(name, params)
	aphone.RV[name] = aphone.RV[name] or {
		rt = get_rt("aphone_RV" .. name, params.w, params.h),
		texture = create_mat("aphone_RVMat" .. name, "UnlitGeneric", {["$basetexture"] = "aphone_RV" .. name}),
	}

	params.fov = params.fov or 60
	params.zfar = params.zfar or 6000
	params.drawviewmodel = params.drawviewmodel or false

	aphone["RV"][name].params = params
end

function aphone.RenderView_RequestTexture(name)
	if aphone.RV[name] then
		return aphone.RV[name].texture
	end
end

function aphone.RenderView_RequestScreenshot(name, dir, addgallery)
	if aphone.RV[name] then
		local param = aphone["RV"][name].params

		aphone.RV[name].Screenshot = {
			dir = dir,
			format = "jpg",
			quality = 90,
			x = param.x, y = param.y,
			w = param.w, h = param.h,
		}

		aphone.RV[name].addg = addgallery
	end
end

function aphone.RenderView_End(name)
	aphone.RV[name] = nil
end

local lp_rt = false
hook.Add( "ShouldDrawLocalPlayer", "aphone_DrawLocalPlayerRT", function( ply )
	if ( lp_rt ) then
		return true
	end
end)

local smileys = {}

for i=0, 9 do
	smileys[i] = Material("akulla/aphone/smiley_" .. i .. ".png", "smooth 1")
end

hook.Add("PostRender", "aphone_RTRefresh", function()
	in_aphonert = true
	for k,v in pairs(aphone.RV) do
		if v.params.drawviewmodel then
			lp_rt = true
		end

		push_rt(v.rt)
			clear_rt(255, 255, 255, 255)
			renderview(v.params)

			surface.SetDrawColor(color_white)
			local localply = LocalPlayer()
			local l_ang = localply:GetShootPos()

			if v.params.Smileys then
				cam.Start3D()
					for i, j in ipairs(player.GetAll()) do
						if j == localply then continue end

						local bone = j:LookupBone("ValveBiped.Bip01_Head1")
						if bone then
							local pos = j:GetBonePosition(bone)
							local before_ang = (l_ang - j:GetShootPos()):Angle()
							local ang = Angle(0, before_ang.y + 90, before_ang.x + 90)
							render.SetMaterial( smileys[j:UserID()%9] )
							render.DrawQuadEasy( pos + ang:Up()*12, ang:Up(), 16, 16, color_white, 180 )
						end
					end
				cam.End3D()
			end

			if v.Screenshot then
				local data = render.Capture(v.Screenshot)
				file.Write(v.Screenshot.dir .. ".jpg", data)

				if v.addg then
					local mat = Material("../data/" .. v.Screenshot.dir .. ".jpg")
					table.insert(aphone.Pictures, mat)
				end

				v.Screenshot = nil
			end
		pop_rt()
		lp_rt = false
	end
end)