
-- Written by http://steamcommunity.com/id/10011001100000011 for LoneWolfie.
-- DO NOT REDISTRIBUTE, REUPLOAD OR MODIFY 

local state = 1 -- We need this to set our default position of 1, to start pos.

local function LWCPartMover(car, time, bone)
	if state == 1 then state = 0
		timer.Destroy("LW" .. bone .. 0 .. tostring(car:EntIndex()))
		timer.Create("LW" .. bone .. 1 .. tostring(car:EntIndex()), time, 0, function()
		if !IsValid(car) then return end -- Needed if someone does a remove/undo on our vehicle during the anim.
			if car:GetPoseParameter(bone) >= 1 then
				car:SetPoseParameter(bone, 1)
			else
				car:SetPoseParameter(bone, car:GetPoseParameter(bone) + time)
			end
			if car:GetPoseParameter(bone) == 1 then timer.Destroy("LW" .. bone .. 1 .. tostring(car:EntIndex())) end -- We need this to stop the timer inf loop.
		end)
	else state = 1
		timer.Destroy("LW" .. bone .. 1 .. tostring(car:EntIndex()))
		timer.Create("LW" .. bone .. 0 .. tostring(car:EntIndex()), time, 0, function()
		if !IsValid(car) then return end -- Needed if someone does a remove/undo on our vehicle during the anim.
			if car:GetPoseParameter(bone) <= 0 then
				car:SetPoseParameter(bone, 0)
			else
				car:SetPoseParameter(bone, car:GetPoseParameter(bone) - time)
			end
			if car:GetPoseParameter(bone) == 0 then timer.Destroy("LW" .. bone .. 0 .. tostring(car:EntIndex())) end -- We need this to stop the timer inf loop.
		end)
	end
	
end


function LWCPartHook(time, bone, name, keyp, model) -- This function allows us to use more than 1 movement part.

	hook.Add("KeyPress", name..bone.."kp", function(ply, key) -- This seems sorta hacky.
		if ply:InVehicle() then if key != keyp then return end
			local car = ply:GetVehicle()
			
			if car:GetModel() == model then
				LWCPartMover(car, time, bone)
			end
		end	
	end)
	
end
