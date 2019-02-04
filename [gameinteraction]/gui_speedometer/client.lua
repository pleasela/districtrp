showFuelGauge	= true  -- use fuel gauge?
overwriteChecks	= false -- debug value to display all icons
useKMH			= (GetProfileSetting(227) == 1)
skins			= {}

function addSkin(skin)
	table.insert(skins, skin)
end

function getAvailableSkins()
	local skinList = {}
	for i,theSkin in pairs(skins) do
		table.insert(skinList, theSkin.skinName)
	end
	return skinList
end

function toggleFuelGauge(toggle)
	showFuelGauge = toggle
end

overwriteAlpha = false
function changeSkin(skin)
	for i,theSkin in pairs(skins) do
		if theSkin.skinName == skin then
			cst = theSkin
			currentSkin = theSkin.skinName
			SetResourceKvp("fivem-speedometer:skin", skin)
			showFuelGauge = true
			overwriteAlpha = false
			return true
		end
	end
	return false
end

function DoesSkinExist(skinName)
	for i,theSkin in pairs(getAvailableSkins()) do
		if theSkin == skinName then
			return true
		end
	end
	return false
end

function getCurrentSkin()
	return currentSkin
end

function toggleSpeedo(state)
	if state == true then
		overwriteAlpha = false
	elseif state == false then
		overwriteAlpha = true
	else
		overwriteAlpha = not overwriteAlpha
	end
end

Citizen.CreateThread(function()
	currentSkin = GetResourceKvpString("fivem-speedometer:skin")
	if not currentSkin then
		currentSkin = Config.DefaultSkin
		SetResourceKvp("fivem-speedometer:skin", Config.DefaultSkin)
	end

	if currentSkin == "default" then
		if DoesSkinExist("default") then
			currentSkin = "default"
			changeSkin("default")
		else
			currentSkin = skins[1].skinName
			changeSkin(skins[1].skinName)
		end
	else
		for i,theSkin in pairs(skins) do
			if theSkin.skinName == currentSkin then
				cst = theSkin
				break
			end
		end
		if not cst then changeSkin(skins[1].skinName) end
	end
end)

curNeedle, curTachometer, curSpeedometer, curFuelGauge, curAlpha = "needle_day", "tachometer_day", "speedometer_day", "fuelgauge_day", 0
RPM, degree, blinkertick, showBlinker = 0, 0, 0, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(playerPed)
		if overwriteAlpha then curAlpha = 0 end

		-- fade away
		if not overwriteAlpha then
			if IsPedInAnyVehicle(playerPed, true) and GetSeatPedIsTryingToEnter(playerPed) == -1 or GetPedInVehicleSeat(vehicle, -1) == playerPed then
				if curAlpha >= 255 then
					curAlpha = 255
				else
					curAlpha = curAlpha + 5
				end
			elseif not IsPedInAnyVehicle(playerPed, false) then
				if curAlpha <= 0 then
					curAlpha = 0
					Citizen.Wait(500)
				else
					curAlpha = curAlpha - 5
				end
			end
		end

		if not HasStreamedTextureDictLoaded(cst.ytdName) then
			RequestStreamedTextureDict(cst.ytdName, true)
			while not HasStreamedTextureDictLoaded(cst.ytdName) do
				Citizen.Wait(1)
			end
		else
			if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
				degree, step = 0, cst.RotStep
				RPM = GetVehicleCurrentRpm(vehicle)
				if not GetIsVehicleEngineRunning(vehicle) then RPM = 0 end
				if RPM > 0.99 then
					RPM = RPM * 100
					RPM = RPM + math.random(-2, 2)
					RPM = RPM / 100
				end

				blinkerState = GetVehicleIndicatorLights(vehicle)
				if blinkerState == 0 then
					blinkerLeft,blinkerRight = false,false
				elseif blinkerState == 1 then
					blinkerLeft,blinkerRight = true,false
				elseif blinkerState == 2 then
					blinkerLeft,blinkerRight = false,true
				elseif blinkerState == 3 then
					blinkerLeft,blinkerRight = true,true
				end

				engineHealth = GetVehicleEngineHealth(vehicle)
				if engineHealth <= 350 and engineHealth > 100 then
					showDamageYellow,showDamageRed = true,false
				elseif engineHealth <= 100 then
					showDamageYellow,showDamageRed = false, true
				else
					showDamageYellow,showDamageRed = false, false
				end

				OilLevel = GetVehicleOilLevel(vehicle)
				FuelLevel = GetVehicleFuelLevel(vehicle)
				MaxFuelLevel = Citizen.InvokeNative(0x642FC12F, vehicle, "CHandlingData", "fPetrolTankVolume", Citizen.ReturnResultAnyway(), Citizen.ResultAsFloat())
				if FuelLevel <= MaxFuelLevel*0.25 and FuelLevel > MaxFuelLevel*0.13 then
					showLowFuelYellow,showLowFuelRed = true,false
				elseif FuelLevel <= MaxFuelLevel*0.2 then
					showLowFuelYellow,showLowFuelRed = false,true
				else
					showLowFuelYellow,showLowFuelRed = false,false
				end
				if OilLevel <= 0.5 then
					showLowOil = true
				else
					showLowOil = false
				end

				_,lightson,highbeams = GetVehicleLightsState(vehicle)
				if lightson == 1 or highbeams == 1 then
					curNeedle, curTachometer, curSpeedometer, curFuelGauge = "needle", "tachometer", "speedometer", "fuelgauge"
					if highbeams == 1 then
						showHighBeams,showLowBeams = true,false
					elseif lightson == 1 and highbeams == 0 then
						showHighBeams,showLowBeams = false,true
					end
				else
					curNeedle, curTachometer, curSpeedometer, curFuelGauge, showHighBeams, showLowBeams = "needle_day", "tachometer_day", "speedometer_day", "fuelgauge_day", false, false
				end

				if GetEntitySpeed(vehicle) > 0 then degree=(GetEntitySpeed(vehicle)*2.036936)*step end
				if degree > 290 then degree=290 end
				if GetVehicleClass(vehicle) >= 0 and GetVehicleClass(vehicle) < 13 or GetVehicleClass(vehicle) >= 17 then
				else
					curAlpha = 0
				end
			else
				RPM, degree = 0, 0
			end

			if RPM < 0.12 or not RPM then
				RPM = 0.12
			end

			if overwriteChecks then
				showHighBeams, showLowBeams, showBlinker, blinkerLeft, blinkerRight, showDamageRed, showLowFuelRed, showLowOil = true, true, true, true, true, true, true, true
			end
			if showHighBeams then
				DrawSprite(cst.ytdName, cst.BeamLight or "lights", cst.centerCoords[1]+cst.lightsLoc[1],cst.centerCoords[2]+cst.lightsLoc[2],cst.lightsLoc[3],cst.lightsLoc[4],0, 0, 50, 240, curAlpha)
			elseif showLowBeams then
				DrawSprite(cst.ytdName, cst.BeamLight or "lights", cst.centerCoords[1]+cst.lightsLoc[1],cst.centerCoords[2]+cst.lightsLoc[2],cst.lightsLoc[3],cst.lightsLoc[4],0, 0, 255, 0, curAlpha)
			end
			if blinkerLeft and showBlinker then
				DrawSprite(cst.ytdName, cst.BlinkerLight or "blinker", cst.centerCoords[1]+cst.blinkerLoc[1],cst.centerCoords[2]+cst.blinkerLoc[2],cst.blinkerLoc[3],cst.blinkerLoc[4],180.0, 124,252,0, curAlpha)
			end
			if blinkerRight and showBlinker then
				DrawSprite(cst.ytdName, cst.BlinkerLight or "blinker", cst.centerCoords[1]+cst.blinkerLoc[1]+0.03,cst.centerCoords[2]+cst.blinkerLoc[2]-0.001,cst.blinkerLoc[3],cst.blinkerLoc[4],0.0, 124,252,0, curAlpha)
			end
			if MaxFuelLevel ~= 0 then
				if showLowFuelYellow then
					DrawSprite(cst.ytdName, cst.FuelLight or "fuel", cst.centerCoords[1]+cst.fuelLoc[1],cst.centerCoords[2]+cst.fuelLoc[2],cst.fuelLoc[3],cst.fuelLoc[4],0, 255, 191, 0, curAlpha)
				elseif showLowFuelRed then
					DrawSprite(cst.ytdName, cst.FuelLight or "fuel", cst.centerCoords[1]+cst.fuelLoc[1],cst.centerCoords[2]+cst.fuelLoc[2],cst.fuelLoc[3],cst.fuelLoc[4],0, 255, 0, 0, curAlpha)
				end
				if showLowOil then
					DrawSprite(cst.ytdName, cst.OilLight or "oil", cst.centerCoords[1]+cst.oilLoc[1],cst.centerCoords[2]+cst.oilLoc[2],cst.oilLoc[3],cst.oilLoc[4],0, 255, 0, 0, curAlpha)
				end -- MAKE SURE TO DRAW THIS BEFORE THE TACHO NEEDLE, OTHERWISE OVERLAPPING WILL HAPPEN!
			end
			if showDamageYellow then
				DrawSprite(cst.ytdName, cst.EngineLight or "engine", cst.centerCoords[1]+cst.engineLoc[1],cst.centerCoords[2]+cst.engineLoc[2],cst.engineLoc[3],cst.engineLoc[4],0, 255, 191, 0, curAlpha)
			elseif showDamageRed then
				DrawSprite(cst.ytdName, cst.EngineLight or "engine", cst.centerCoords[1]+cst.engineLoc[1],cst.centerCoords[2]+cst.engineLoc[2],cst.engineLoc[3],cst.engineLoc[4],0, 255, 0, 0, curAlpha)
			end
			DrawSprite(cst.ytdName, cst.SpeedometerBG or curSpeedometer, cst.centerCoords[1]+cst.SpeedoBGLoc[1],cst.centerCoords[2]+cst.SpeedoBGLoc[2],cst.SpeedoBGLoc[3],cst.SpeedoBGLoc[4], 0.0, 255, 255, 255, curAlpha)
			if MaxFuelLevel ~= 0 then
				DrawSprite(cst.ytdName, cst.TachometerBG or curTachometer, cst.centerCoords[1]+cst.TachoBGloc[1],cst.centerCoords[2]+cst.TachoBGloc[2],cst.TachoBGloc[3],cst.TachoBGloc[4], 0.0, 255, 255, 255, curAlpha)
				DrawSprite(cst.ytdName, cst.Needle or curNeedle, cst.centerCoords[1]+cst.TachoNeedleLoc[1],cst.centerCoords[2]+cst.TachoNeedleLoc[2],cst.TachoNeedleLoc[3],cst.TachoNeedleLoc[4],RPM*(cst.rpmScale)-(cst.rpmScaleDecrease or 0), 255, 255, 255, curAlpha)
			end
			DrawSprite(cst.ytdName, curNeedle, cst.centerCoords[1]+cst.SpeedoNeedleLoc[1],cst.centerCoords[2]+cst.SpeedoNeedleLoc[2],cst.SpeedoNeedleLoc[3],cst.SpeedoNeedleLoc[4],-5.00001+degree, 255, 255, 255, curAlpha)
			if showFuelGauge and FuelLevel and MaxFuelLevel ~= 0 then
				DrawSprite(cst.ytdName, cst.FuelGauge or curFuelGauge, cst.centerCoords[1]+cst.FuelBGLoc[1],cst.centerCoords[2]+cst.FuelBGLoc[2],cst.FuelBGLoc[3],cst.FuelBGLoc[4], 0.0, 255,255,255, curAlpha)
				DrawSprite(cst.ytdName, cst.FuelNeedle or curNeedle, cst.centerCoords[1]+cst.FuelGaugeLoc[1],cst.centerCoords[2]+cst.FuelGaugeLoc[2],cst.FuelGaugeLoc[3],cst.FuelGaugeLoc[4],80.0+FuelLevel/MaxFuelLevel*110, 255, 255, 255, curAlpha)
			end
		end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if blinkerLeft or blinkerRight then
			showBlinker = true
			Citizen.Wait(500)
			showBlinker = false
			Citizen.Wait(500)
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Keep updating the selected measurement unit
Citizen.CreateThread(function()
	local fakeTimer = 0
	while true do
		Citizen.Wait(1000)
		fakeTimer = fakeTimer + 1000

		if fakeTimer == 5000 then
			useKMH		= (GetProfileSetting(227) == 1)
			fakeTimer	= 0
		end
	end
end)

RegisterNetEvent('fivem-speedometer:playSound')
AddEventHandler('fivem-speedometer:playSound', function(soundFile, soundVolume, loop)
	if not Config.PlaySpeedChime then return end

	SendNUIMessage({
		action	= 'playSound',
		file	= soundFile,
		volume	= soundVolume,
		loop	= loop
	})
end)

RegisterNetEvent('fivem-speedometer:stopSound')
AddEventHandler('fivem-speedometer:stopSound', function()
	if not Config.PlaySpeedChime then return end

	SendNUIMessage({
		action = 'stopSound'
	})
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/speedoskin', 'change the speedometer skin', { {name='skin', help='the skin name'} } )
	TriggerEvent('chat:addSuggestion', '/speedoskins', 'show all available speedometer skins')
	TriggerEvent('chat:addSuggestion', '/speedotoggle', 'toggle the speedometer')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('chat:removeSuggestion', '/speedoskin')
		TriggerEvent('chat:removeSuggestion', '/speedoskins')
		TriggerEvent('chat:removeSuggestion', '/speedotoggle')
	end
end)

RegisterCommand('speedoskin', function(source, args, rawCommand)
	if args[1] and DoesSkinExist(args[1]) then
		changeSkin(args[1])
	else
		TriggerEvent('chat:addMessage', { args = { '^3ERROR', 'unknown skin' } })
	end
end, false)

RegisterCommand('speedoskins', function(source, args, rawCommand)
	local skins		= getAvailableSkins()
	local message	= ""
	local first		= true

	for i,skin in pairs(skins) do
		if first then
			message = skin 
			first = false
		else
			message = message .. ', ' .. skin
		end
	end

	TriggerEvent('chat:addMessage', { args = { '^2Available skins', message } })
end, false)

RegisterCommand('speedotoggle', function(source, args, rawCommand)
	toggleSpeedo()
end, false)