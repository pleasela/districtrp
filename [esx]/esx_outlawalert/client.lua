ESX                           = nil
local PlayerData              = {}
Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.PlayerData
	ESX.TriggerServerCallback('esx_airlinesjob:refreshJob', function(job) 
		PlayerData.job = job
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

--Config
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 60 --in second
local blipMeleeTime = 60 --in second
local blipJackingTime = 60 -- in second
local showcopsmisbehave = false  --show notification when cops steal too
--End config

GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
            Notify(alert)
        end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(tx, ty, tz)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if carJackingAlert then
			local transT = 250
			local thiefBlip = AddBlipForCoord(tx, ty, tz)
			SetBlipSprite(thiefBlip,  10)
			SetBlipColour(thiefBlip,  1)
			SetBlipAlpha(thiefBlip,  transT)
			SetBlipAsShortRange(thiefBlip,  1)
			while transT ~= 0 do
				Wait(blipJackingTime * 4)
				transT = transT - 1
				SetBlipAlpha(thiefBlip,  transT)
				if transT == 0 then
					SetBlipSprite(thiefBlip,  2)
					return
				end
			end
			
		end
	end
end)

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(gx, gy, gz)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if gunshotAlert then
			local transG = 250
			local gunshotBlip = AddBlipForCoord(gx, gy, gz)
			SetBlipSprite(gunshotBlip,  1)
			SetBlipColour(gunshotBlip,  1)
			SetBlipAlpha(gunshotBlip,  transG)
			SetBlipAsShortRange(gunshotBlip,  1)
			while transG ~= 0 do
				Wait(blipGunTime * 4)
				transG = transG - 1
				SetBlipAlpha(gunshotBlip,  transG)
				if transG == 0 then
					SetBlipSprite(gunshotBlip,  2)
					return
				end
			end
		   
		end
	end
end)

RegisterNetEvent('meleePlace')
AddEventHandler('meleePlace', function(mx, my, mz)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if meleeAlert then
			local transM = 250
			local meleeBlip = AddBlipForCoord(mx, my, mz)
			SetBlipSprite(meleeBlip,  270)
			SetBlipColour(meleeBlip,  17)
			SetBlipAlpha(meleeBlip,  transG)
			SetBlipAsShortRange(meleeBlip,  1)
			while transM ~= 0 do
				Wait(blipMeleeTime * 4)
				transM = transM - 1
				SetBlipAlpha(meleeBlip,  transM)
				if transM == 0 then
					SetBlipSprite(meleeBlip,  2)
					return
				end
			end
			
		end
	end
end)

function tellServer(sePos, seS1, se, extra)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local sex = nil
		if skin.sex == 0 then
			sex = "male"
		else
			sex = "female"
		end
		local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
		local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
		local street1 = GetStreetNameFromHashKey(s1)
		local street2 = GetStreetNameFromHashKey(s2)
		TriggerServerEvent(sePos, plyPos.x, plyPos.y, plyPos.z)
		if s2 == 0 then
			TriggerServerEvent(seS1, street1, sex, extra)
		elseif s2 ~= 0 then
			TriggerServerEvent(se, street1, street2, sex, extra)
		end
	end)
end

--IS_VEHICLE_PREVIOUSLY_OWNED_BY_PLAYER ?
Citizen.CreateThread( function()
	while true do
		Wait(0)
		local playerPed = GetPlayerPed(-1)
		-- if IsPedTryingToEnterALockedVehicle(playerPed) or IsPedJacking(playerPed) then
		-- 	if showcopsmisbehave or (PlayerData.job ~= nil and PlayerData.job.name ~= 'police') then
		-- 		local veh = GetVehiclePedIsTryingToEnter(playerPed)
		-- 		if GetVehiclePedIsIn(playerPed, true) ~= veh then
		-- 			local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
		-- 			local vehName2 = GetLabelText(vehName)
		-- 			tellServer('thiefInProgressPos', 'thiefInProgressS1', 'thiefInProgress', vehName2)
		-- 			Wait(5000)
		-- 		end
		-- 	end
		-- end
		
		--[[if IsPedInMeleeCombat(playerPed) and IsControlJustPressed(1, 24) and GetMeleeTargetForPed(playerPed) > 0 then
			if showcopsmisbehave or (PlayerData.job ~= nil and PlayerData.job.name ~= 'police') then
				tellServer('meleeInProgressPos', 'meleeInProgressS1', 'meleeInProgress')
				Wait(5000)
			end
		end]]
		if IsPedShooting(playerPed) then
			if showcopsmisbehave or (PlayerData.job ~= nil and PlayerData.job.name ~= 'police') then
				tellServer('gunshotInProgressPos', 'gunshotInProgressS1', 'gunshotInProgress')
				Wait(3000)
			end
		end
		ClearPlayerHasDamagedAtLeastOnePed(playerPed)
	end
end)
