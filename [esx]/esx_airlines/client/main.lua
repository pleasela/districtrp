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

ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local OnJob                     = false
local CurrentCustomer           = nil
local CurrentCustomerBlip       = nil
local DestinationBlip           = nil
local IsNearCustomer            = false
local CustomerIsEnteringVehicle = false
local CustomerEnteredVehicle    = false
local TargetCoords              = nil

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

function DrawSub(msg, time)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING")
		AddTextComponentString(msg)
		N_0xbd12f8228410d9b4(type)
		Citizen.Wait(time)
		N_0x10d373323e5b9c0d()
	end)
end

function GetRandomWalkingNPC()

  local search = {}
  local peds   = ESX.Game.GetPeds()

  for i=1, #peds, 1 do
    if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
      table.insert(search, peds[i])
    end
  end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end

  print('Using fallback code to find walking ped')

  for i=1, 250, 1 do

    local ped = GetRandomPedAtCoord(0.0,  0.0,  0.0,  math.huge + 0.0,  math.huge + 0.0,  math.huge + 0.0,  26)

    if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
      table.insert(search, ped)
    end

  end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end

end

function ClearCurrentMission()

	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	TargetCoords              = nil

end

function StartAirlinesJob()

	ShowLoadingPromt('Taking service - ' .. 'Airlines', 5000, 3)
	ClearCurrentMission()

	OnJob = true

end

function StopAirlinesJob()

	local playerPed = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
		end

	end

 	ClearCurrentMission()

	OnJob = false

	DrawSub(_U('mission_complete'), 5000)

end

function OpenAirlinesActionsMenu()

	local elements = {
		{label = _U('spawn_veh'), value = 'spawn_vehicle'},
		--{label = _U('cloakroom'), value = 'cloakroom'},
		{label = _U('deposit_stock'), value = 'put_stock'},
 		{label = _U('take_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'airlines_actions',
		{
			title    = 'Airlines',
			elements = elements
		},
		function(data, menu)
		
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		end

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		end	

		if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

		if data.current.value == 'spawn_vehicle' then
			OpenVehicleSpawnerMenu()
		end

		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'airlines', function(data, menu)
				menu.close()
			end)
		end

		end,
		function(data, menu)

			menu.close()

			CurrentAction     = 'airlines_actions_menu'
			CurrentActionMsg  = _U('press_to_open')
			CurrentActionData = {}

		end
	)

end

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Jet",  value = 'luxor'},
		{label = "Velum",  value = 'velum'},
		{label = "Vestra",  value = 'vestra'},
		{label = "Dodo",  value = 'dodo'},
		{label = "Nimbus",  value = 'nimbus'},
		{label = "Frogger",  value = 'frogger'},

	}

	if PlayerData.job.grade >= 3 then
		table.insert(elements,{label = "Volito",  value = 'supervolito'})
	end
	
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_spawner',
		{
			title    = _U('spawn_veh'),
			align    = 'top-left',
			elements = elements,
		},
	function(data, menu)
		menu.close()
		local model = data.current.value
		ESX.Game.SpawnVehicle(model, {
			x = Config.Zones.VehicleSpawnPoint.Pos.x,
			y = Config.Zones.VehicleSpawnPoint.Pos.y,
			z = Config.Zones.VehicleSpawnPoint.Pos.z
		}, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
			local playerPed = GetPlayerPed(-1)
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
		end)
	end,
	function(data, menu)
		menu.close()
		CurrentAction     = 'airlines_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenCloakroomMenu()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = {
        {label = _U('airlines_clothes_civil'), value = 'citizen_wear'},
        {label = _U('airlines_clothes_airlines'), value = 'airlines_wear'},
      },
    },
    function(data, menu)

      menu.close()

      if data.current.value == 'citizen_wear' then

       	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			  local model = nil

			  if skin.sex == 0 then
				model = GetHashKey("mp_m_freemode_01")
			  else
				model = GetHashKey("mp_f_freemode_01")
			  end

			  RequestModel(model)
			  while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(1)
			  end

			  SetPlayerModel(PlayerId(), model)
			  SetModelAsNoLongerNeeded(model)

			  TriggerEvent('skinchanger:loadSkin', skin)
			  TriggerEvent('esx:restoreLoadout')
        end)
      end

      if data.current.value == 'airlines_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			--TODO This should probably just change outfit, not model
			if skin.sex == 0 or 1 then
				local model = GetHashKey("s_m_m_pilot_01") ----- Skin

				RequestModel(model)
				while not HasModelLoaded(model) do
					RequestModel(model)
					Citizen.Wait(0)
				end

				SetPlayerModel(PlayerId(), model)
				SetModelAsNoLongerNeeded(model)
			end

		end)

		end	

      CurrentAction     = 'airlines_actions_menu'
      CurrentActionMsg  = _U('open_menu')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
    end
  )

end


function OpenMobileAirlinesActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'mobile_airlines_actions',
		{
			title    = 'Airlines',
			elements = {
				{label = _U('billing'), value = 'billing'}
			}
		},
		function(data, menu)

			if data.current.value == 'billing' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = _U('invoice_amount')
					},
					function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil then
							ESX.ShowNotification(_U('amount_invalid'))
						else

							menu.close()

							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification(_U('no_players_near'))
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_airlines', 'Airlines', amount)
							end

						end

					end,
					function(data, menu)
						menu.close()
					end
				)

			end

		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_airlinesjob:getStockItems', function(items)

		print(json.encode(items))

		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

	  ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'stocks_menu',
	    {
	      title    = 'Airlines Stock',
	      elements = elements
	    },
	    function(data, menu)

	    	local itemName = data.current.value

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
						title = _U('quantity')
					},
					function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
				    	menu.close()
				    	OpenGetStocksMenu()

							TriggerServerEvent('esx_airlinesjob:getStockItem', itemName, count)
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

	    end,
	    function(data, menu)
	    	menu.close()
	    end
	  )

	end)

end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_airlinesjob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end

		end

	  ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'stocks_menu',
	    {
	      title    = _U('inventory'),
	      elements = elements
	    },
	    function(data, menu)

	    	local itemName = data.current.value

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
					{
						title = _U('quantity')
					},
					function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
				    	menu.close()
				    	OpenPutStocksMenu()

							TriggerServerEvent('esx_airlinesjob:putStockItems', itemName, count)
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

	    end,
	    function(data, menu)
	    	menu.close()
	    end
	  )

	end)

end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('esx_airlinesjob:hasEnteredMarker', function(zone)

	if zone == 'AirlinesActions' then
		CurrentAction     = 'airlines_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleter' then

		local playerPed = GetPlayerPed(-1)

		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
		

	end

end)

AddEventHandler('esx_airlinesjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

	local specialContact = {
		name       = 'Airlines',
		number     = 'airlines',
		base64Icon = 'data:image/png;base64,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',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

-- Create Blips
Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.AirlinesActions.Pos.x, Config.Zones.AirlinesActions.Pos.y, Config.Zones.AirlinesActions.Pos.z)

	SetBlipSprite (blip, 90)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Airline Pilot")
	EndTextCommandSetBlipName(blip)

end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'airlines' then

			local coords = GetEntityCoords(GetPlayerPed(-1))

			for k,v in pairs(Config.Zones) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end

		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'airlines' then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_airlinesjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_airlinesjob:hasExitedMarker', LastZone)
			end

		end

	end
end)

-- Airlines Job
Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		local playerPed = GetPlayerPed(-1)

		if OnJob then

			if CurrentCustomer == nil then

				DrawSub(_U('drive_search_pass'), 5000)

				if IsPedInAnyVehicle(playerPed,  false) and GetEntitySpeed(playerPed) > 0 then

					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000,  45000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed,  false) and GetEntitySpeed(playerPed) > 0 then

						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then

							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, 1)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip,  true)

							SetEntityAsMissionEntity(CurrentCustomer,  true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)

							local standTime = GetRandomIntInRange(60000,  180000)

							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification(_U('customer_found'))

						end

					end

				end

			else

				if IsPedFatallyInjured(CurrentCustomer) then

					ESX.ShowNotification(_U('client_unconcious'))

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer,  false, true)

					CurrentCustomer           = nil
					CurrentCustomerBlip       = nil
					DestinationBlip           = nil
					IsNearCustomer            = false
					CustomerIsEnteringVehicle = false
					CustomerEnteredVehicle    = false
					TargetCoords              = nil

				end

				if IsPedInAnyVehicle(playerPed,  false) then

					local vehicle          = GetVehiclePedIsIn(playerPed,  false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = GetDistanceBetweenCoords(playerCoords.x,  playerCoords.y,  playerCoords.z,  customerCoords.x,  customerCoords.y,  customerCoords.z)

					if IsPedSittingInVehicle(CurrentCustomer,  vehicle) then

						if CustomerEnteredVehicle then

							local targetDistance = GetDistanceBetweenCoords(playerCoords.x,  playerCoords.y,  playerCoords.z,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z)

							if targetDistance <= 10.0 then

								TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

								ESX.ShowNotification(_U('arrive_dest'))

								TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
								SetEntityAsMissionEntity(CurrentCustomer,  false, true)

								TriggerServerEvent('esx_airlinesjob:success')

								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer           = nil
								CurrentCustomerBlip       = nil
								DestinationBlip           = nil
								IsNearCustomer            = false
								CustomerIsEnteringVehicle = false
								CustomerEnteredVehicle    = false
								TargetCoords              = nil

							end

							if TargetCoords ~= nil then
								DrawMarker(1, TargetCoords.x, TargetCoords.y, TargetCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
							end

						else

							RemoveBlip(CurrentCustomerBlip)

							CurrentCustomerBlip = nil

							TargetCoords = Config.JobLocations[GetRandomIntInRange(1,  #Config.JobLocations)]

							local street = table.pack(GetStreetNameAtCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format(_U('take_me_to_near', GetStreetNameFromHashKey(street[1]),GetStreetNameFromHashKey(street[2])))
							else
								msg = string.format(_U('take_me_to', GetStreetNameFromHashKey(street[1])))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z)

							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString("Destination")
							EndTextCommandSetBlipName(blip)

							SetBlipRoute(DestinationBlip,  true)

							CustomerEnteredVehicle = true

						end

					else

						DrawMarker(1, customerCoords.x, customerCoords.y, customerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)

						if not CustomerEnteredVehicle then

							if customerDistance <= 30.0 then

								if not IsNearCustomer then
									ESX.ShowNotification(_U('close_to_client'))
									IsNearCustomer = true
								end

							end

							if customerDistance <= 100.0 then

								if not CustomerIsEnteringVehicle then

									ClearPedTasksImmediately(CurrentCustomer)

									local seat = 0

									for i=4, 0, 1 do
										if IsVehicleSeatFree(vehicle,  seat) then
											seat = i
											break
										end
									end

									TaskEnterVehicle(CurrentCustomer,  vehicle,  -1,  seat,  2.0,  1)

									CustomerIsEnteringVehicle = true

								end

							end

						end

					end

				else

					DrawSub(_U('return_to_veh'), 5000)

				end

			end

		end

	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'airlines' and (GetGameTimer() - GUI.Time) > 300 then

				if CurrentAction == 'airlines_actions_menu' then
					OpenAirlinesActionsMenu()
				end

				if CurrentAction == 'delete_vehicle' then

					local playerPed = GetPlayerPed(-1)

					if Config.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'airlines', vehicleProps)
					else
						if GetEntityModel(CurrentActionData.vehicle) == GetHashKey('airlines') then
							if Config.MaxInService ~= -1 then
								TriggerServerEvent('esx_service:disableService', 'airlines')
							end
						end
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end

		end

		if IsControlPressed(0,  Keys['F6']) and Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'airlines' and (GetGameTimer() - GUI.Time) > 150 then
			OpenMobileAirlinesActionsMenu()
			GUI.Time = GetGameTimer()
		end

		if IsControlPressed(0,  Keys['DELETE']) and (GetGameTimer() - GUI.Time) > 150 then

			if OnJob then
				StopAirlinesJob()
			else

				if PlayerData.job ~= nil and PlayerData.job.name == 'airlines' then

					local playerPed = GetPlayerPed(-1)

					if IsPedInAnyVehicle(playerPed,  false) then

						local vehicle = GetVehiclePedIsIn(playerPed,  false)

						if PlayerData.job.grade >= 1 then
							StartAirlinesJob()
						else
							if GetEntityModel(vehicle) == GetHashKey('airlines') then
								StartAirlinesJob()
							else
								ESX.ShowNotification(_U('must_in_airlines'))
							end
						end

					else

						if PlayerData.job.grade >= 1 then
							ESX.ShowNotification(_U('must_in_vehicle'))
						else
							ESX.ShowNotification(_U('must_in_airlines'))
						end

					end

				end

			end

			GUI.Time = GetGameTimer()

		end

	end
end)
