local skinData = {
	skinName = "id6",
	ytdName = "id6",

	centerCoords = {0.8,0.8},

	lightsLoc = {0.015,0.12,0.018,0.02},
	blinkerLoc = {0.04,0.12,0.022,0.03},
	fuelLoc = {-0.005,0.12,0.012,0.025},
	oilLoc = {0.100,0.12,0.020,0.025},
	engineLoc = {0.130,0.12,0.020,0.025},

	SpeedoBGLoc = {0.053, 0.020, 0.25,0.23},
	SpeedoNeedleLoc = {0.000,5,0.076,0.15},

	TachoBGloc = {0.110,0.004,0.125,0.17},
	TachoNeedleLoc = {0.110,0.030,0.09,0.17},

	FuelBGLoc = {-0.035, -0.030,0.050, 0.040},
	FuelGaugeLoc = {0.060,0.000,0.030,0.080},

	GearLoc = {0.010,-0.033,0.025,0.055},  -- gear location
	Speed1Loc = {-0.024,0.042,0.025,0.06}, -- 3rd digit
	Speed2Loc = {-0.004,0.042,0.025,0.06}, -- 2nd digit
	Speed3Loc = {0.020,0.042,0.025,0.06},  -- 1st digit
	UnitLoc = {0.029,0.088,0.025,0.025},
	TurboBGLoc = {0.053, -0.130, 0.075,0.090},
	TurboGaugeLoc = {0.0533, -0.125, 0.045,0.060},

	RotMult = 2.036936,
	RotStep = 2.32833,

	rpmScale = 250
}

addSkin(skinData)

-- addon code
local labelType = "8k"
local curDriftAlpha = 0

function angle(vehicle)
	if not vehicle then return false end
	local vx,vy,vz = table.unpack(GetEntityVelocity(vehicle))
	local modV = math.sqrt(vx*vx + vy*vy)


	local rx,ry,rz = table.unpack(GetEntityRotation(vehicle,0))
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

	if GetEntitySpeed(vehicle)* 3.6 < 40 or GetVehicleCurrentGear(vehicle) == 0 then return 0,modV end --speed over 25 km/h

	local cosX = (sn*vx + cs*vy)/modV
	return math.deg(math.acos(cosX))*0.5, modV
end

local function BlinkDriftText(hide)
	if hide == true or goDown == true then
		curDriftAlpha = curDriftAlpha-15
	elseif not hide or goDown == false then
		curDriftAlpha = curDriftAlpha+15
	end
	if curDriftAlpha <= 0 then
		curDriftAlpha = 0
		goDown = false
	elseif curDriftAlpha >= 255 then
		curDriftAlpha = 255
		if driftSprite ~= "drift_yellow" then
			goDown = true
		end
	end
end

SpeedChimeActive = false
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if getCurrentSkin() == skinData.skinName then
			speedTable = {}
			toggleFuelGauge(false)

			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(playerPed)
			local vehicleClass = GetVehicleClass(vehicle)

			if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
				if vehicleClass >= 0 and vehicleClass <= 5 then
					labelType = "8k"
					skinData.rpmScale = 200
				elseif vehicleClass == 6 then
					labelType = "9k"
					skinData.rpmScale = 222
				elseif vehicleClass == 7 then
					labelType = "10k"
					skinData.rpmScale = 222
				elseif vehicleClass == 8 then
					labelType = "13k"
					skinData.rpmScale = 220
				end

				for i,theName in ipairs(Config.SpecialCars) do
					if GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == theName then
						labelType = "86"
						cst.rpmScale = 242
						if not SpeedChimeActive and GetEntitySpeed(vehicle) * 3.6 > 105.0 then
							SpeedChimeActive = true
							TriggerEvent('fivem-speedometer:playSound', 'initiald', 0.7, true)
						elseif SpeedChimeActive and GetEntitySpeed(vehicle) * 3.6 < 105.0 then
							SpeedChimeActive = false
							TriggerEvent('fivem-speedometer:stopSound')
						end

						break
					end
				end

				_,lightson,highbeams = GetVehicleLightsState(vehicle)
				if lightson == 1 or highbeams == 1 then
					curTachometer = "night_labels_"..labelType
					if useKMH then
						curTurbo = "turbo"
					else
						curTurbo = "turbo_psi"
					end
					curTurboNeedle = "needle"
				else
					curTachometer = "labels_" .. labelType
					if useKMH then
						curTurbo = "turbo_day"
					else
						curTurbo = "turbo_day_psi"
					end
					curTurboNeedle = "needle_day"
				end
				curSpeedometer = "nodrift_background"

				local gear = GetVehicleCurrentGear(vehicle) + 1

				if not gear then gear = 1 end
				if gear == 1 then gear = 0 end


				DrawSprite(skinData.ytdName, curSpeedometer, skinData.centerCoords[1]+skinData.SpeedoBGLoc[1],skinData.centerCoords[2]+skinData.SpeedoBGLoc[2],skinData.SpeedoBGLoc[3],skinData.SpeedoBGLoc[4], 0.0, 255, 255, 255, curAlpha)
				DrawSprite(skinData.ytdName, curTachometer, skinData.centerCoords[1]+skinData.TachoBGloc[1],skinData.centerCoords[2]+skinData.TachoBGloc[2],skinData.TachoBGloc[3],skinData.TachoBGloc[4], 0.0, 255, 255, 255, curAlpha)
				DrawSprite(skinData.ytdName, "gear_"..gear, skinData.centerCoords[1]+skinData.GearLoc[1],skinData.centerCoords[2]+skinData.GearLoc[2],skinData.GearLoc[3],skinData.GearLoc[4], 0.0, 255, 255, 255, curAlpha)

				local speed = GetEntitySpeed(vehicle)

				if useKMH then
					speed = speed * 3.6
					DrawSprite(skinData.ytdName, "kmh", skinData.centerCoords[1]+skinData.UnitLoc[1],skinData.centerCoords[2]+skinData.UnitLoc[2],skinData.UnitLoc[3],skinData.UnitLoc[4], 0.0, 255, 255, 255, curAlpha)
				else
					speed = speed * 2.236936
					DrawSprite(skinData.ytdName, "mph", skinData.centerCoords[1]+skinData.UnitLoc[1],skinData.centerCoords[2]+skinData.UnitLoc[2],skinData.UnitLoc[3],skinData.UnitLoc[4], 0.0, 255, 255, 255, curAlpha)
				end

				if not speed then speed = "0.0" end
				speed = tonumber(string.format("%." .. (0) .. "f", speed))
				speed = tostring(speed)
				for i = 1, string.len(speed) do
					speedTable[i] = speed:sub(i, i)
				end
				if string.len(speed) == 1 then
					DrawSprite(skinData.ytdName, "speed_digits_"..speedTable[1], skinData.centerCoords[1]+skinData.Speed3Loc[1],skinData.centerCoords[2]+skinData.Speed3Loc[2],skinData.Speed3Loc[3],skinData.Speed3Loc[4], 0.0, 255, 255, 255, curAlpha)
				elseif string.len(speed) == 2 then
					DrawSprite(skinData.ytdName, "speed_digits_"..speedTable[1], skinData.centerCoords[1]+skinData.Speed2Loc[1],skinData.centerCoords[2]+skinData.Speed2Loc[2],skinData.Speed2Loc[3],skinData.Speed2Loc[4], 0.0, 255, 255, 255, curAlpha)
					DrawSprite(skinData.ytdName, "speed_digits_"..speedTable[2], skinData.centerCoords[1]+skinData.Speed3Loc[1],skinData.centerCoords[2]+skinData.Speed3Loc[2],skinData.Speed3Loc[3],skinData.Speed3Loc[4], 0.0, 255, 255, 255, curAlpha)
				elseif string.len(speed) == 3 then
					DrawSprite(skinData.ytdName, "speed_digits_"..speedTable[1], skinData.centerCoords[1]+skinData.Speed1Loc[1],skinData.centerCoords[2]+skinData.Speed1Loc[2],skinData.Speed1Loc[3],skinData.Speed1Loc[4], 0.0, 255, 255, 255, curAlpha)
					DrawSprite(skinData.ytdName, "speed_digits_"..speedTable[2], skinData.centerCoords[1]+skinData.Speed2Loc[1],skinData.centerCoords[2]+skinData.Speed2Loc[2],skinData.Speed2Loc[3],skinData.Speed2Loc[4], 0.0, 255, 255, 255, curAlpha)
					DrawSprite(skinData.ytdName, "speed_digits_"..speedTable[3], skinData.centerCoords[1]+skinData.Speed3Loc[1],skinData.centerCoords[2]+skinData.Speed3Loc[2],skinData.Speed3Loc[3],skinData.Speed3Loc[4], 0.0, 255, 255, 255, curAlpha)
				elseif string.len(speed) >= 4 then
					DrawSprite(skinData.ytdName, "speed_digits_9", skinData.centerCoords[1]+skinData.Speed3Loc[1],skinData.centerCoords[2]+skinData.Speed3Loc[2],skinData.Speed3Loc[3],skinData.Speed3Loc[4], 0.0, 255, 255, 255, curAlpha)
					DrawSprite(skinData.ytdName, "speed_digits_9", skinData.centerCoords[1]+skinData.Speed2Loc[1],skinData.centerCoords[2]+skinData.Speed2Loc[2],skinData.Speed2Loc[3],skinData.Speed2Loc[4], 0.0, 255, 255, 255, curAlpha)
					DrawSprite(skinData.ytdName, "speed_digits_9", skinData.centerCoords[1]+skinData.Speed1Loc[1],skinData.centerCoords[2]+skinData.Speed1Loc[2],skinData.Speed1Loc[3],skinData.Speed1Loc[4], 0.0, 255, 255, 255, curAlpha)
				end

				if IsToggleModOn(vehicle, 18) then -- turbo
					DrawSprite(skinData.ytdName, curTurbo, skinData.centerCoords[1]+skinData.TurboBGLoc[1],skinData.centerCoords[2]+skinData.TurboBGLoc[2],skinData.TurboBGLoc[3],skinData.TurboBGLoc[4], 0.0, 255, 255, 255, curAlpha)
					DrawSprite(skinData.ytdName, curTurboNeedle, skinData.centerCoords[1]+skinData.TurboGaugeLoc[1],skinData.centerCoords[2]+skinData.TurboGaugeLoc[2],skinData.TurboGaugeLoc[3],skinData.TurboGaugeLoc[4], (GetVehicleTurboPressure(vehicle)*100)-625, 255, 255, 255, curAlpha)
				end

				if GetPedInVehicleSeat(vehicle, -1) == playerPed and vehicleClass >= 0 and vehicleClass < 13 or vehicleClass >= 17 then
					if angle(vehicle) >= 10 and angle(vehicle) <= 18 then
						driftSprite = "drift_blue"
						DrawSprite(skinData.ytdName, driftSprite, skinData.centerCoords[1]+skinData.FuelBGLoc[1],skinData.centerCoords[2]+skinData.FuelBGLoc[2],skinData.FuelBGLoc[3],skinData.FuelBGLoc[4], 0.0, 255, 255, 255, curDriftAlpha)
						BlinkDriftText(false)
					elseif angle(vehicle) > 18 then
						driftSprite = "drift_yellow"
						DrawSprite(skinData.ytdName, driftSprite, skinData.centerCoords[1]+skinData.FuelBGLoc[1],skinData.centerCoords[2]+skinData.FuelBGLoc[2],skinData.FuelBGLoc[3],skinData.FuelBGLoc[4], 0.0, 255, 255, 255, curDriftAlpha)
						BlinkDriftText(false)
					elseif angle(vehicle) < 10 then
						driftSprite = "drift_blue"
						DrawSprite(skinData.ytdName, driftSprite, skinData.centerCoords[1]+skinData.FuelBGLoc[1],skinData.centerCoords[2]+skinData.FuelBGLoc[2],skinData.FuelBGLoc[3],skinData.FuelBGLoc[4], 0.0, 255, 255, 255, curDriftAlpha)
						BlinkDriftText(true)
					end
				else
					curDriftAlpha = 0
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)