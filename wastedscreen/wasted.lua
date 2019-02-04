local locksound = false

local deathMessages = {
    "You Messed Up!",
    "You Are Dead",
    "You Died",
    "Oh well",
    "Oh Darn",
    "Too Bad",
    "Rip",
    "Rekt",
    "Savage.",
    "Wow!",
    "Calculated.",
    "Check, Please?",
    "Whos on first.",
    "Need a revive?",
    "wasted",
    "Tubular.",
    "Wanna go Bowling Cousin?",
    "Dynamite",
    "3...2...1...  Oh...",
    "Thanks, Obama!",
    "I hope you have life insurance.",
    "MEDIC!",
    "What a ripoff!",
    "Shoulda looked both ways",
    "You're a lizard, Harry",
    "no",
    "WILSON!",
    "Finish Him!",
    "K.O.",
    "Flawless.",
    "How does dirt taste?",
    "D'oh",
    "Eat My Shorts",
    "Shoulda had a V8",
    "Redbull does NOT give you wings",
    "I told you not to eat those Tide pods",
    "Oh, bother.",
    "SNAAAAAAAAAAKE!!!",
    "Don't forget me!",
    "Game Over.",
    "Press [Q] to do nothing",
    "Will that be debit or credit?",
    "Only you can prevent forest fires",
    "Got Milk?",
    "Are you Army Strong?",
    "Just a little to the left, next time",
    "You missed.",
    "Not even close!",
    "Did you turn it off and on again?",
    "Everything is OK",
    "James Baxter!",
}

--SetPlayerInvincible(PlayerId(), true)
--SetPedToRagdoll(myPed, 100, 100, 2, false, true, true)
local fakeDead = false

function RespawnPed(ped, coords)
	--SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, false, false)
	SetEntityInvincible(ped, false)
	if not fakeDead then
		TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	end
end

AddEventHandler('playerSpawned', function()
	fakeDead = false
end)

function getFakeDead() return fakeDead end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if fakeDead then
			local playerPed = GetPlayerPed(-1)
			SetPedToRagdoll(playerPed, 100, 100, 0, false, true, true)
			ResetPedRagdollTimer(playerPed)
			SetEntityInvincible(playerPed, true)
			DisableControlAction(0, 289, true)
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsEntityDead(PlayerPedId()) and not fakeDead then
			--Revive player, forced Ragdoll
			fakeDead = true
			SetTimeout(5000,function()
				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)
				if fakeDead then
					RespawnPed(playerPed, {
						x = coords.x,
						y = coords.y,
						z = coords.z + 1.0
					})
				end
				end)
			if not locksound then
				PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
				locksound = true
			end
			ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
			
			local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
			
			while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(0) end
			
			if HasScaleformMovieLoaded(scaleform) then
				PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
				BeginTextComponent("STRING")
				AddTextComponentString("~r~" .. deathMessages[GetRandomIntInRange(1,#deathMessages)])
				EndTextComponent()
				PopScaleformMovieFunctionVoid()

				Citizen.Wait(500)

				PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
				while fakeDead do
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					Citizen.Wait(0)
					--Something else gets rid of fakeDead
				end
				
				locksound = false
			end
		end
	end
end)