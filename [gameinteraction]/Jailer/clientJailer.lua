--Coded by Albo1125.

local cJ = false
local eJE = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("JP")
AddEventHandler("JP", function(jT)
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
			cJ = true
			eJE = false
			while jT > 0 and not eJE do
				pP = GetPlayerPed(-1)
				RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jT % 1 == 0 then
					TriggerEvent('chatMessage', 'JAIL', { 0, 0, 0 }, jT .." more minute(s) until release.")
				end
				Citizen.Wait(60000)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(1677.233, 2658.618, 45.216, pL['x'], pL['y'], pL['z'])
				if D > 90 then
					SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
					if D > 110 then
						-- jT = jT + 60
						-- if jT > 1500 then
						-- 	jT = 1500
						-- end
						-- TriggerEvent('chatMessage', 'JUDGE', { 0, 0, 0 }, "Your jail time was extended for an unlawful escape attempt.")
						SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
						TriggerEvent('chatMessage', 'JUDGE', { 0, 0, 0 }, "You were teleported back for going too far.")
					end
				end
				if math.fmod(jT, 5) then
					TriggerServerEvent('Jailer:setJailSave', jT)
				end
				jT = jT - 1
			end
			RemoveAllPedWeapons(pP, true)
			TriggerServerEvent('Jailer:leftJail')
			
			SetEntityCoords(pP, 1855.807, 2601.949, 45.323)
			cJ = false
			SetEntityInvincible(pP, false)
		end)
	end
end)

RegisterNetEvent("UnJP")
AddEventHandler("UnJP", function()
	eJE = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	--Wait a few seconds before killing player again
	Citizen.Wait(8000)
	ESX.TriggerServerCallback('Jailer:checkJail',function(jailed, length)
		if jailed then
			TriggerEvent('JP', length)
			TriggerEvent('chatMessage', "SYSTEM", { 255, 0, 0 }, "You were in jail before you left, enjoy your time." )
		end
	end)
end)