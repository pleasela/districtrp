--[[--------------------------------------------------------------------------
	*
	* Mello Trainer
	* (C) Michael Goodwin 2017
	* http://github.com/thestonedturtle/mellotrainer/releases
	*
	* This menu used the Scorpion Trainer as a framework to build off of.
	* https://github.com/pongo1231/ScorpionTrainer
	* (C) Emre Cürgül 2017
	* 
	* A lot of useful functionality has been converted from the lambda menu.
	* https://lambda.menu
	* (C) Oui 2017
	*
	* Additional Contributors:
	* WolfKnight (https://forum.fivem.net/u/WolfKnight)
	*
---------------------------------------------------------------------------]]
--Not Needed? 
--require("map.lua") -- Require map.lua so we can call the toggleMapBlips function.

-- Variables used for this part of the trainer.
local playerdb = {}

-- Creates an empty table of tables to hold the blip/ped information for users.
for i=0, maxPlayers, 1 do
	playerdb[i] = {}
end




--[[
  _   _   _    _   _____      _____           _   _   _                      _          
 | \ | | | |  | | |_   _|    / ____|         | | | | | |                    | |         
 |  \| | | |  | |   | |     | |        __ _  | | | | | |__     __ _    ___  | | __  ___ 
 | . ` | | |  | |   | |     | |       / _` | | | | | | '_ \   / _` |  / __| | |/ / / __|
 | |\  | | |__| |  _| |_    | |____  | (_| | | | | | | |_) | | (_| | | (__  |   <  \__ \
 |_| \_|  \____/  |_____|    \_____|  \__,_| |_| |_| |_.__/   \__,_|  \___| |_|\_\ |___/
--]]



RegisterNUICallback("settingtoggle", function(data, cb)
	local action = data.action
	local newstate = data.newstate
	local text,text2

	if(newstate) then
		text = "~g~ON"
		text2 = "~r~OFF"
	else
		text = "~r~OFF"
		text2 = "~g~ON"
	end


	--Hud Toggle
	if(action == "hud")then
		featureHideHud = newstate
		DisplayHud(not featureHideHud)
		drawNotification("Hud Display: "..tostring(text2))

	-- Radr Toggle
	elseif(action == "radar")then
		featureHideMap = newstate
		DisplayRadar(not featureHideMap)
		drawNotification("Radar Display: "..tostring(text2))

	-- Large Map Toggle
	elseif(action == "enlarge")then
		featureBigHud = newstate
		SetRadarBigmapEnabled(featureBigHud, false)
		drawNotification("Large Map: "..tostring(text))	

	-- Player Blip Toggle
	elseif(action == "blips")then
		featurePlayerBlips = newstate
		drawNotification("Player Blips: "..tostring(text))

	-- Player Blip Name Toggle
	elseif(action == "blipnames")then
		featurePlayerBlipNames = newstate
		drawNotification("Player Blip Names: "..tostring(text))
	-- Player Overhead Name Toggle
	elseif(action == "text")then
		featurePlayerHeadDisplay = newstate
		drawNotification("Overhead Player Names: "..tostring(text))

	-- Street Name Toggle
	elseif(action == "streets")then
		featureAreaStreetNames = newstate
		drawNotification("Street Names: "..tostring(text2))

	-- Map Location Blips
	elseif(action == "mapblips")then
		featureMapBlips = newstate
		toggleMapBlips(featureMapBlips) -- In maps.lua
		drawNotification("Map Blips: "..tostring(text))

	-- Radio Always Off
	elseif(action=="radiooff")then
		featureRadioAlwaysOff = newstate
		drawNotification("Radio Always Off: "..text)

	-- Mobile Radio 
	elseif(action=="mobileradio")then
		featurePlayerRadio = newstate
		SetMobileRadioEnabledDuringGameplay(featurePlayerRadio);
		SetUserRadioControlEnabled(not featureRadioAlwaysOff)
		drawNotification("Player Radio: "..text)

	elseif(action=="skipradio")then
		SkipRadioForward();
	end
	--elseif(action == )then
end)



--[[
  ______                        _     _                       
 |  ____|                      | |   (_)                      
 | |__   _   _   _ __     ___  | |_   _    ___    _ __    ___ 
 |  __| | | | | | '_ \   / __| | __| | |  / _ \  | '_ \  / __|
 | |    | |_| | | | | | | (__  | |_  | | | (_) | | | | | \__ \
 |_|    \__,_| |_| |_|  \___|  \__| |_|  \___/  |_| |_| |___/
--]]



-- Toggle Radio Control
function toggleRadio(playerPed)
	if(IsPedInAnyVehicle(playerPed, false))then
		local veh = GetVehiclePedIsUsing(playerPed)
		SetVehicleRadioEnabled(veh, not featureRadioAlwaysOff)
	end

	SetUserRadioControlEnabled(not featureRadioAlwaysOff)
end

--[[
  _______   _                                 _ 
 |__   __| | |                               | |
    | |    | |__    _ __    ___    __ _    __| |
    | |    | '_ \  | '__|  / _ \  / _` |  / _` |
    | |    | | | | | |    |  __/ | (_| | | (_| |
    |_|    |_| |_| |_|     \___|  \__,_|  \__,_|
--]]



Citizen.CreateThread(function()
	while true do
		Wait(0)

		-- Street Names
		if(featureAreaStreetNames) then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(9)
		end


		-- Toggle minimap on keypress
		if IsControlJustPressed(0, 20) and not IsPauseMenuActive() and not blockinput then
			featureBigHud = not featureBigHud
			SetRadarBigmapEnabled( featureBigHud, false)
		end

	end
end)



-- Update vehicle whenever you entere a new vehicle
RegisterNetEvent('mellotrainer:playerEnteredVehicle')
AddEventHandler('mellotrainer:playerEnteredVehicle', function(veh)
	local playerPed = GetPlayerPed(-1)
	toggleRadio(playerPed)
	UpdateVehicleFeatureVariables(veh)
end)



-- Turn off Radio.
Citizen.CreateThread(function()
	local radioToggle = false
	while true do
		Wait(100)
		local playerPed = GetPlayerPed(-1)

		-- Radio Always Off
		if(featureRadioAlwaysOff)then
			if(featurePlayerRadio)then
				SetMobileRadioEnabledDuringGameplay(false);
				featurePlayerRadio = false;
			end

			if(not radioToggle)then
				toggleRadio(playerPed)
			end
			radioToggle = true
		else
			if(radioToggle)then
				toggleRadio(playerPed)
				radioToggle = false
			end
		end
	end
end)


-- Local Blip/Head Storage for removing on disconnect
local playersDB = {}
for i=0, maxPlayers, 1 do
	playersDB[i] = {}
end

--[[----------------------------------------------------------------------
	*
	* Head Display Stuff
	*
------------------------------------------------------------------------]]


-- Remove Head Display from entity
function clearPlayerHead(id)
	if(playersDB[id].headId ~= nil and IsMpGamerTagActive(playersDB[id].headId))then
		RemoveMpGamerTag(playersDB[id].headId)
	end
end

-- Create Head Display for entity
function createPlayerHead(id,ped)
	if(featurePlayerHeadDisplay)then
		headId = CreateMpGamerTag(ped, GetPlayerName(id), false, false, "", false )
		wantedLvl = GetPlayerWantedLevel(id)

		-- Wanted Levels
		if wantedLvl > 0 then
			SetMpGamerTagWantedLevel(headId, wantedLvl)
			SetMpGamerTagVisibility(headId, 7, true)
		else
			SetMpGamerTagWantedLevel(headId, 0)
			SetMpGamerTagVisibility(headId, 7, false)
		end

		-- Speaking Icon
		if NetworkIsPlayerTalking(id)then
			SetMpGamerTagVisibility(headId, 9, true)
		else
			SetMpGamerTagVisibility(headId, 9, false)
		end
		playersDB[id].headId = headId
		playersDB[id].wantedLvl = wantedLvl
	else
		if(playersDB[id].headId ~= nil and IsMpGamerTagActive(playersDB[id].headId))then
			RemoveMpGamerTag(playersDB[id].headId)
		end

		playersDB[id].headId = nil
		playersDB[id].wantedLvl = nil
	end
end



--[[----------------------------------------------------------------------
	*
	* Blip Display Stuff
	*
------------------------------------------------------------------------]]

-- Remove the player blip from the entity
function clearPlayerBlip(id)
	if(playersDB[id].blip ~= nil)then
		RemoveBlip(playersDB[id].blip)
	end
end

-- Which sprite should be displayed for current vehicle?
function getVehicleSpriteId(veh)
	vehClass = GetVehicleClass(veh)
	vehModel = GetEntityModel(veh)
	local sprite = 1
	
	if(vehClass == 8 or vehClass == 13)then
		sprite = 226 -- Bikes
	elseif(vehClass == 14)then
		sprite = 427 -- Boat
	elseif(vehClass == 15)then
		sprite = 422 -- Jet
	elseif(vehClass == 16)then
		sprite = 423 -- Planes
	elseif(vehClass == 19)then
		sprite = 421 -- Military
	else
		sprite = 225 -- Car
	end

	-- Model Specific Icons override Class.					
	if(vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer"))then
		sprite = 424
	elseif(vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("limo2"))then
		sprite = 426
	elseif(vehModel == GetHashKey("rhino"))then
		sprite = 421
	end

	return sprite
end


-- Create/remove the blip from the player
function createPlayerBlip(id,ped,blip)
	if(featurePlayerBlips)then
		if(not DoesBlipExist(blip))then -- Create Generic Blip
			blip = AddBlipForEntity(ped)
			SetBlipSprite(blip, 1)
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true)
		end
		-- Update Blip Information
		veh = GetVehiclePedIsIn(ped, false)
		blipSprite = GetBlipSprite(blip)

		if not GetEntityHealth(ped) then -- Dead
			if blipSprite ~= 274 then
				SetBlipSprite(blip,274)
				Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false)		
			end

		elseif IsPedInAnyVehicle(ped, false) then -- Inside a vehicle
			local sprite = getVehicleSpriteId(veh)

			if blipSprite ~= sprite then
				SetBlipSprite(blip, sprite)
				Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false)
			end

			passengers = GetVehicleNumberOfPassengers(veh)
			if passengers then
				if not IsVehicleSeatFree(veh, -1)then
					passengers = passengers + 1
				end
				ShowNumberOnBlip(blip,passengers)
			else
				HideNumberOnBlip(blip)
			end
		else -- On foot
			HideNumberOnBlip(blip)
			if blipSprite ~= 1 then
				SetBlipSprite(blip, 1)
				Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
			end
		end

		SetBlipRotation(blip, math.ceil(GetEntityHeading(veh)))

		-- Show Blip Names on Pause Map?
		if(featurePlayerBlipNames)then
			SetBlipNameToPlayerName(blip, id)
		else
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Player")
			EndTextCommandSetBlipName(blip)
		end
		SetBlipScale(blip, 0.85)	


		-- Blip Alphas
		if IsPauseMenuActive() then
			SetBlipAlpha(blip, 255)
		else
			x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true ))
			x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true ))
			distance = ( math.floor( math.abs( math.sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) ) ) / -1 ) ) + 900
			-- Probably a way easier way to do this but whatever im an idiot -- Credits @Scammer ^

			if distance < 0 then
				distance = 0
			elseif distance > 255 then
				distance = 255
			end

			SetBlipAlpha(blip, distance)
		end

		playersDB[id].ped = ped
		playersDB[id].blip = blip
	else
		clearPlayerBlip(id)
	end
end


-- Faster Method to remove Blips/Names from players who disconnect.
RegisterNetEvent( 'mellotrainer:playerLeft' )
AddEventHandler( 'mellotrainer:playerLeft', function( person )
	Citizen.Trace(person.source)
	clearPlayerBlip(person.source)
	clearPlayerHead(person.source)
	playersDB[person.source] = "skip"

	-- 30 second skip period to ensure the name/blip don't reappear for a disconnected player.
	Wait(30000) 
	-- After 30 seconds if the source is still active it will recreate blips assuming its a new person.
	playersDB[person.source] = {} 
end )


-- Blip System
Citizen.CreateThread(function()
	while true do
		Wait(1)
		-- Show Blips/Head Names
		for id = 0, maxPlayers do
			if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) and playersDB[id] ~= "skip" then
				ped = GetPlayerPed(id)
				blip = GetBlipFromEntity(ped)

				-- Create Blip/Head depending on feature Toggles
				createPlayerHead(id,ped)
				createPlayerBlip(id,ped,blip)

			elseif(playersDB[id].ped ~= nil)then
				-- Remove Blip/Head depending on feature Toggles
				clearPlayerHead(id)
				clearPlayerBlip(id)

				-- Reset the playersDB
				playersDB[id] = {}
			end
		end
	end
end)