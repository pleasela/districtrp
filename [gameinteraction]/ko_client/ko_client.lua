local knockedOut = false
local wait = 10
local count = 60

function doKnockout()
	local myPed = GetPlayerPed(-1)
	SetEntityInvincible(myPed, true)
	SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
	ShowNotification("~r~You were knocked tf out!")
	wait = 10
	knockedOut = true
	SetEntityHealth(myPed, 150)
end

AddEventHandler('ko_client:knockout', function()
	doKnockout()
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		local myPed = GetPlayerPed(-1)
		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 115 then
				doKnockout()
			end
		end
		if knockedOut == true then
			SetEntityInvincible(myPed, true)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 71,  true)
			DisableControlAction(0, 72,  true)
			DisableControlAction(0, 59,  true)
			DisableControlAction(0, 75,  true) -- VehicleExit
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					wait = wait - 1
				end
			else
				SetEntityInvincible(myPed, false)
				ShowNotification("~g~You feel well enough to move again")
				knockedOut = false
			end
		end
		
		
		if not IsPedInAnyVehicle(myPed, false) then --  
			if IsControlPressed(0, 112) and not IsControlPressed(0,196) then
				--Numpad5, Normal ragdoll
				SetPedToRagdoll(myPed, 100, 100, 0, true, false, false)
				ResetPedRagdollTimer(myPed)

			elseif IsControlPressed(0, 111) and not IsControlPressed(0,40) then
				--Numpad8, Narrow stumble
				SetPedToRagdoll(myPed, 100, 100, 2, false, true, true)
				ResetPedRagdollTimer(myPed)

			end
		end
		--]]
		
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
