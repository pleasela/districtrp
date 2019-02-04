ESX               					= nil
local hasShot 	  					= false
local playerPed 					= nil
local GunpowderSaveTime 			= 5 * 60 * 1000 -- 15 minutes standard.

----- Kommando

-- RegisterCommand("guntest", function(source)
--     TriggerEvent("esx_guntest:checkGun", source)
-- end, false)


-- Koll om närmaste spelaren har krutstänk
RegisterNetEvent('esx_guntest:checkGun')
AddEventHandler('esx_guntest:checkGun', function(source)
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then	
		ESX.ShowNotification('Checking for gunpowder')
		TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
		
		Citizen.Wait(10000)
		
		ClearPedTasksImmediately(playerPed)

		-- Fråga servern om spelaren man undersöker (närmaste spelaren) har krutstänk på sig
		ESX.TriggerServerCallback('esx_guntest:hasPlayerRecentlyFiredAGun', function(hasGunpowder)
			if hasGunpowder then
				ESX.ShowNotification('The person has gunpowder on their clothes.')
			else
				ESX.ShowNotification('No traces of gunpowder was found.')
			end
		end, GetPlayerServerId(player))
	else
		ESX.ShowNotification('No person nearby.')
	end
end)


-- First load
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	-- Hämta spelarens ped en gång
	playerPed = GetPlayerPed(-1)
end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsPedShooting(GetPlayerPed(-1)) then
			hasShot = true
			-- Om man skjuter så lagra status på server 1 gång
			TriggerServerEvent('esx_guntest:storePlayerGunpowderStatus')
		end

		if hasShot then
			-- Om man har skjutit så vänta en stund och ta sedan bort statusen
			Citizen.Wait(GunpowderSaveTime)
			hasShot = false
			TriggerServerEvent('esx_guntest:removePlayerGunpowderStatus')
		end

		-- När man är nära en person så körs en serverfunktion 1 gång i framen, kommer ta extremt mycket på servern
		--[[if (hasShot) then
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('esx_guntest:storeStatusTrue', GetPlayerServerId(player))
			end
		else
			TriggerServerEvent('esx_guntest:storeStatusFalse', GetPlayerServerId(player))
		end]]
	end
end)
