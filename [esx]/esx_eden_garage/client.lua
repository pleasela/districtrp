-- Local
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local CurrentAction = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

local this_Garage = {}

-- Fin Local

-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	refreshBlips()
end)
-- Fin init ESX


function refreshBlips()
	local zones = {}
	local blipInfo = {}

	for zoneKey,zoneValues in pairs(Config.Garages)do

		local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
		SetBlipSprite (blip, Config.BlipInfos.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.2)
		SetBlipColour (blip, Config.BlipInfos.Color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(zoneKey)
		EndTextCommandSetBlipName(blip)
		
		if zoneValues.MunicipalPoundPoint then
			local blip = AddBlipForCoord(zoneValues.MunicipalPoundPoint.Pos.x, zoneValues.MunicipalPoundPoint.Pos.y, zoneValues.MunicipalPoundPoint.Pos.z)
			SetBlipSprite (blip, Config.BlipPound.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.2)
			SetBlipColour (blip, Config.BlipPound.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Pound")
			EndTextCommandSetBlipName(blip)
		end
	end
end
-- Fin Gestion des Blips

--Fonction Menu

function OpenMenuGarage(PointType)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	if PointType == 'spawn' then
		table.insert(elements,{label = "List of vehicles", value = 'list_vehicles'})
	end

	if PointType == 'delete' then
		table.insert(elements,{label = "Store Vehicle", value = 'stock_vehicle'})
	end

	if PointType == 'pound' then
		table.insert(elements,{label = "Get vehicle", value = 'return_vehicle'})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			title    = 'Garage',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'list_vehicles') then
				ListVehiclesMenu()
			end
			if(data.current.value == 'stock_vehicle') then
				StockVehicleMenu()
			end
			if(data.current.value == 'return_vehicle') then
				ReturnVehicleMenu()
			end

			--local playerPed = GetPlayerPed(-1)
			--SpawnVehicle(data.current.value)

		end,
		function(data, menu)
			menu.close()

		end
	)
end


-- Afficher les listes des vehicules
function ListVehiclesMenu()
	local elements = {}

	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)

		for _,v in pairs(vehicles) do

			local hashVehicule = v.vehicle.model
			local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			local labelvehicle

			if(v.state)then
			labelvehicle = vehicleName..': Garage'

			else
			labelvehicle = vehicleName..': Pound'
			end
			table.insert(elements, {label =labelvehicle , value = v})

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = 'Garage',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if(data.current.value.state)then
				menu.close()
				SpawnVehicle(data.current.value.vehicle)
			else
				TriggerEvent('esx:showNotification', 'This vehicle is at the pound')
			end
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end
	)
	end)
end
-- Fin Afficher les listes des vehicules
function reparation(prix,vehicle,vehicleProps)

	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Repair and store ("..prix.."$)", value = 'yes'},
		{label = "Leave", value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			title    = 'damaged vehicle',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				TriggerServerEvent('eden_garage:payhealth', prix)
				ranger(vehicle,vehicleProps)
			end
			if(data.current.value == 'no') then
				ESX.ShowNotification('You need to repair first.')
			end

		end,
		function(data, menu)
			menu.close()

		end
	)
end

function ranger(vehicle,vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	print('vehprops modle')
	TriggerServerEvent('eden_garage:modifystate', vehicleProps, true)
	TriggerEvent('esx:showNotification', 'Your vehicle is in the garage')
end

-- Fonction qui permet de rentrer un vehicule
function StockVehicleMenu()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then

		local coords        = GetEntityCoords(playerPed)
		local vehicle       = GetVehiclePedIsIn(playerPed,false)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local engineHealth  = GetVehicleEngineHealth(vehicle)

		ESX.TriggerServerCallback('eden_garage:storev',function(valid)

			if (valid) then
				--TriggerServerEvent('eden_garage:debug', "Vehicle plate returned to the garage: "  .. vehicleProps.plate)
				--TriggerServerEvent('eden_garage:logging',"Vehicle returned to the garage: " .. engineHealth)
				if engineHealth < 1000 then
					local fraisRep= math.floor((1000 - engineHealth)*16)
					reparation(fraisRep,vehicle,vehicleProps)
				else
					ranger(vehicle,vehicleProps)
				end
			else
				TriggerEvent('esx:showNotification', 'You can not store this vehicle')
			end
		end,vehicleProps)
	else
		TriggerEvent('esx:showNotification', 'Il n\' there is no vehicle to enter')
	end

end
-- Fin fonction qui permet de rentrer un vehicule
--Fin fonction Menu


--Fonction pour spawn vehicule
function SpawnVehicle(vehicle)
	print("Vehicle heading " .. tostring(this_Garage.SpawnPoint.Heading))
	ESX.Game.SpawnVehicle(vehicle.model,{
		x=this_Garage.SpawnPoint.Pos.x ,
		y=this_Garage.SpawnPoint.Pos.y,
		z=this_Garage.SpawnPoint.Pos.z + 1
		},this_Garage.SpawnPoint.Heading, function(callback_vehicle)
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
			local plate = GetVehicleNumberPlateText(callback_vehicle)
			TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		end)

	TriggerServerEvent('eden_garage:modifystate', vehicle, false)

end
--Fin fonction pour spawn vehicule

--Fonction pour spawn vehicule fourriere
function SpawnPoundedVehicle(vehicle)

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnMunicipalPoundPoint.Pos.x ,
		y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
		z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1
		},180, function(callback_vehicle) --TODO ADD Headings to pound spawners
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
			local plate = GetVehicleNumberPlateText(callback_vehicle)
			TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		end)

	TriggerServerEvent('eden_garage:modifystate', vehicle, false)
end
--Fin fonction pour spawn vehicule fourriere
--Action das les markers
AddEventHandler('eden_garage:hasEnteredMarker', function(zone)

	if zone == 'spawn' then
		CurrentAction     = 'spawn'
		CurrentActionMsg  = "Press ~INPUT_PICKUP~ to get a vehicle"
		CurrentActionData = {}
	end

	if zone == 'delete' then
		CurrentAction     = 'delete'
		CurrentActionMsg  = "Press ~INPUT_PICKUP~ to store a vehicle"
		CurrentActionData = {}
	end

	if zone == 'pound' then
		CurrentAction     = 'pound_action_menu'
		CurrentActionMsg  = "Press ~INPUT_PICKUP~ to access the pound"
		CurrentActionData = {}
	end
end)

AddEventHandler('eden_garage:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)
--Fin Action das les markers

function ReturnVehicleMenu()

	ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)

		local elements = {}

		for _,v in pairs(vehicles) do

			local hashVehicule = v.model
			local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			v.price = exports["esx_vehicleshop"]:getVehiclePrice(hashVehicule) * 0.1
			local labelvehicle = vehicleName ..': $' .. v.price

			table.insert(elements, {label =labelvehicle , value = v})

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_vehicle',
		{
			title    = 'Garage',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('eden_garage:pay', data.current.value.price)
					SpawnPoundedVehicle(data.current.value)
				else
					ESX.ShowNotification('You n\'do not have enough d\'money')
				end
			end, data.current.value.price)
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end
		)
	end)
end

-- Affichage markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Garages) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, false, false, false, false)
			end
			if(v.MunicipalPoundPoint and GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)
				--DrawMarker(v.SpawnMunicipalPoundPoint.Marker, v.SpawnMunicipalPoundPoint.Pos.x, v.SpawnMunicipalPoundPoint.Pos.y, v.SpawnMunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnMunicipalPoundPoint.Size.x, v.SpawnMunicipalPoundPoint.Size.y, v.SpawnMunicipalPoundPoint.Size.z, v.SpawnMunicipalPoundPoint.Color.r, v.SpawnMunicipalPoundPoint.Color.g, v.SpawnMunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)
-- Fin affichage markers

-- Activer le menu quand player dedans
Citizen.CreateThread(function()
	local currentZone = 'garage'
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false

		for _,v in pairs(Config.Garages) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				this_Garage = v
				currentZone = 'spawn'
			end

			if(GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				this_Garage = v
				currentZone = 'delete'
			end
			if(v.MunicipalPoundPoint and GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < v.MunicipalPoundPoint.Size.x) then
				isInMarker  = true
				this_Garage = v
				currentZone = 'pound'
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('eden_garage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('eden_garage:hasExitedMarker', LastZone)
		end

	end
end)


-- Fin activer le menu fourriere quand player dedans

-- Controle touche
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

				if CurrentAction == 'pound_action_menu' then
					OpenMenuGarage('pound')
				end
				if CurrentAction == 'spawn' then
					OpenMenuGarage('spawn')
				end
				if CurrentAction == 'delete' then
					OpenMenuGarage('delete')
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end
		end
	end
end)
-- Fin controle touche
