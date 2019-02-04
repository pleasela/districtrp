snail = "not 🐌" -- don't touch the snail

-- you can touch this tho
ScanningDistance = 30.0 -- how far the Plate Reader should look
ControlInputGroup = 27 -- control stuff for changing the key, leave if you don't understand this
ControlKey = 178 -- Default Key is the Control key

-- you shouldn't touch anything under this if you don't understand it


function GetVehicleInfrontOfEntity(entity)
	local coords = GetOffsetFromEntityInWorldCoords(entity,0.0,1.0,0.3)
	local coords2 = GetOffsetFromEntityInWorldCoords(entity, 0.0, ScanningDistance,0.0)
	local rayhandle = CastRayPointToPoint(coords, coords2, 10, entity, 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	local model = GetEntityModel(vehicle)
	local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
	local licenseplate = GetVehicleNumberPlateText(vehicle)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString("Model: "..vehname.."\nPlate: "..licenseplate)
	DrawText(0.45, 0.9)
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist(GetVehiclePedIsIn(GetPlayerPed(-1))) then
			if snail == "🐌" and IsControlJustPressed(ControlInputGroup,ControlKey) then
				snail = "not 🐌"
			elseif snail ~= "🐌" and IsControlJustPressed(ControlInputGroup,ControlKey) then
				snail = "🐌"
			end
			if snail == "🐌" then
				local vehicle_detected = GetVehicleInfrontOfEntity(GetVehiclePedIsIn(GetPlayerPed(-1)))
				if DoesEntityExist(vehicle_detected) then
					RenderVehicleInfo(vehicle_detected)
				end
			end
		end
	end
end)


