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

ESX               = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentVehicle = nil
local CurrentVehicleSpawnTime = 0
local CurrentThief = nil
local ThiefJob = 'carthief'
local PoliceJob = 'police'
local CarBlip = nil
local StealBlip1 = nil
local StealBlip2 = nil
local StealBlip3 = nil
local StealBlip4 = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenCarthiefActionsMenu()

	local vehicleInteraction = {}
	local citizenInteraction = {}

	if Config.EnableVehicleInteraction then
		vehicleInteraction = {label = Config.STRING_VEHICLE_INTERACTION, value = 'vehicle_interaction'}
	end

	if Config.EnableCitizenInteraction then 
		citizenInteraction = {label = Config.STRING_CITIZEN_INTERACTION, value = 'citizen_interaction'}
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'carthief_actions',
		{
			title    = Config.STRING_CARTHIEF_MENU_TITLE,
			align    = 'top-left',
			elements = {
		  	vehicleInteraction,
		  	citizenInteraction
			},
		},
		function(data, menu)
			if data.current.value == 'citizen_interaction' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = Config.STRING_CITIZEN_INTERACTION,
						align    = 'top-left',
						elements = {
						{label = Config.STRING_SEARCH,        value = 'body_search'},
						{label = Config.STRING_HANDCUFF,    value = 'handcuff'},
						},
					},
					function(data2, menu2)

					local player, distance = ESX.Game.GetClosestPlayer()

					if distance ~= -1 and distance <= 3.0 then

					if data2.current.value == 'body_search' then
						OpenBodySearchMenu(player)
					end

					if data2.current.value == 'handcuff' then
						TriggerServerEvent('esx_carthief:handcuff', GetPlayerServerId(player))
					end

					if data2.current.value == 'drag' then
						TriggerServerEvent('esx_carthief:drag', GetPlayerServerId(player))
					end

					if data2.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_carthief:putInVehicle', GetPlayerServerId(player))
					end

					if data2.current.value == 'out_the_vehicle' then
						TriggerServerEvent('esx_carthief:OutVehicle', GetPlayerServerId(player))
					end

					else
						ESX.ShowNotification(Config.STRING_NO_PLAYERS_NEARBY)
					end

					end,
					function(data2, menu2)
					menu2.close()
					end
				)

				end

			if data.current.value == 'vehicle_interaction' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'vehicle_interaction',
					{
						title    = Config.STRING_VEHICLE_INTERACTION,
						align    = 'top-left',
						elements = {
					  	{label = Config.STRING_PICK_LOCK,  	 value = 'hijack_vehicle'},
						},
					},
					function(data2, menu2)

						local playerPed = GetPlayerPed(-1)
						local coords    = GetEntityCoords(playerPed)
						local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

						if DoesEntityExist(vehicle) then

							local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

							if data2.current.value == 'hijack_vehicle' then

					      local playerPed = GetPlayerPed(-1)
					      local coords    = GetEntityCoords(playerPed)

					      if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

									local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

					        if DoesEntityExist(vehicle) then

					        	Citizen.CreateThread(function()

											TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

											Wait(20000)

											ClearPedTasksImmediately(playerPed)

						        	SetVehicleDoorsLocked(vehicle, 1)
					            SetVehicleDoorsLockedForAllPlayers(vehicle, false)

					            TriggerEvent('esx:showNotification', Config.STRING_VEHICLE_UNLOCKED)

					        	end)

					        end

					      end

							end

						else
							ESX.ShowNotification(Config.STRING_NO_PLAYERS_NEARBY)
						end

					end,
					function(data2, menu2)
						menu2.close()
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

  ESX.TriggerServerCallback('esx_carthief:getStockItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = Config.STRING_CARTHIEF_INVENTORY,
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = Config.STRING_AMOUNT
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Config.STRING_INVALID_QUANTITY)
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_carthief:getStockItem', itemName, count)
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

  ESX.TriggerServerCallback('esx_carthief:getPlayerInventory', function(inventory)

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
        title    = Config.STRING_CARTHIEF_INVENTORY,
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = Config.STRING_AMOUNT
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(Config.STRING_INVALID_QUANTITY)
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_carthief:putStockItems', itemName, count)
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

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = Config.STRING_STORE_WEAPON,
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_carthief:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('esx_carthief:getArmoryWeapons', function(weapons)

		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
			end
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'armory_get_weapon',
			{
			title    = Config.STRING_RETRIEVE_WEAPON,
			align    = 'top-left',
			elements = elements,
			},
			function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('esx_carthief:removeArmoryWeapon', function()
			OpenGetWeaponMenu()
			end, data.current.value)

			end,
			function(data, menu)
			menu.close()
			end
		)

	end)

end

function OpenArmoryMenu(station)


	local elements = {
		{label = Config.STRING_RETRIEVE_WEAPON, value = 'get_weapon'},
		{label = Config.STRING_STORE_WEAPON, value = 'put_weapon'},
		{label = Config.STRING_WITHDRAW_ITEM,  value = 'get_stock'},
		{label = Config.STRING_STORE_ITEM,  value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
			title    = 'Armory',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		end

		if data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		end

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		end

		if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

		end,
		function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = 'Open Armory'
		CurrentActionData = {station = station}
		end
	)

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_carthief:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = Config.STRING_CONFISCATE_DIRTY_MONEY .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Arms ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = Config.STRING_CONFISCATE .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = Config.STRING_CONFISCATE .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = Config.STRING_SEARCH,
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_carthief:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function UpgradeVehicle() 
	local carIndex = 1

	SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), Config.Cars[carIndex].WheelType)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
	SetVehicleTyreSmokeColor(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, 0, 127)
end

RegisterNetEvent('esx_carthief:handcuff')
AddEventHandler('esx_carthief:handcuff', function()

	IsHandcuffed    = not IsHandcuffed;
	local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()

		if IsHandcuffed then

			RequestAnimDict('mp_arresting')

			while not HasAnimDictLoaded('mp_arresting') do
				Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed,  true)

		else

			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed,  true)
			FreezeEntityPosition(playerPed, false)

		end

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

AddEventHandler('esx_carthief:hasEnteredMarker', function(zone)
	if PlayerData.job.name == ThiefJob then 
		if zone == 'SellCar' then
			CurrentActionMsg  = Config.STRING_SELL_VEHICLE_MSG
			CurrentAction = 'sell_car'
		end

		if zone == 'DropOffPointCheapCar' then
			CurrentActionMsg  = Config.STRING_SELL_VEHICLE_MSG
			CurrentAction = 'sell_car'
		end

		if zone == 'StealCarPosition1' then
			CurrentActionMsg  = Config.STRING_STEAL_VEHICLE_MSG
			CurrentAction = 'steal_car_1'
		end

		if zone == 'StealCarPosition2' then
			CurrentActionMsg  = Config.STRING_STEAL_VEHICLE_MSG
			CurrentAction = 'steal_car_2'
		end

		if zone == 'StealCarPosition3' then
			CurrentActionMsg  = Config.STRING_STEAL_VEHICLE_MSG
			CurrentAction = 'steal_car_3'
		end

		if zone == 'StealCarPosition4' then
			CurrentActionMsg  = Config.STRING_STEAL_VEHICLE_MSG
			CurrentAction = 'steal_car_4'
		end

		if zone == 'StealCheapCarPosition' then
			CurrentActionMsg  = Config.STRING_STEAL_VEHICLE_MSG
			CurrentAction = 'steal_car_5'
		end

		if zone == 'CarthiefOptions' then
			CurrentActionMsg  = Config.STRING_ACCESS_INVENTORY_MSG
			CurrentAction = 'access_inventory'
		end
	end
end)

AddEventHandler('esx_carthief:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

RegisterNetEvent('esx_carthief:deleteStolenVehicle')
AddEventHandler('esx_carthief:deleteStolenVehicle', function(value)
	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerPed, false)

	if IsPedInAnyVehicle(playerPed,  false) then
		TriggerServerEvent('esx_carthief:delivered', value)
		DeleteVehicle(vehicle)
	end
end)

RegisterNetEvent('esx_carthief:createStolenVehicle')
AddEventHandler('esx_carthief:createStolenVehicle', function(carIndex)
	local createThisCar = nil
	local iterator = 0

	for k,v in pairs(Config.Cars) do
		if iterator == carIndex then
			createThisCar = v
		end
		iterator = iterator + 1
	end

	local vehicleModel = GetHashKey(createThisCar.Car)

	RequestModel(vehicleModel)

	while not HasModelLoaded(vehicleModel) do
		Citizen.Wait(0)
	end

	CurrentVehicle = CreateVehicle(vehicleModel, createThisCar.Pos.x, createThisCar.Pos.y, createThisCar.Pos.z, createThisCar.Heading, true, false)
	
	local props = ESX.Game.GetVehicleProperties(CurrentVehicle)
	props.plate = CurrentVehicle
	props.color1 = 42
	props.color2 = 42
	props.tyreSmokeColor = {0, 255, 0}

	ESX.Game.SetVehicleProperties(CurrentVehicle, props)

	CurrentVehicleSpawnTime = GetGameTimer()
	TaskWarpPedIntoVehicle(GetPlayerPed(-1),  CurrentVehicle,  -1)
	ESX.ShowNotification(Config.STRING_DELIVER_CAR)

	while IsPedInAnyVehicle(GetPlayerPed(-1),  false) == false do
		Wait(0)
	end

	-- Send information about vehicle to the server
	TriggerServerEvent('esx_carthief:pongStolenVehicle', CurrentVehicle, createThisCar.Value)

	if carIndex == 4 then
		TriggerServerEvent('esx_phone:send', ThiefJob, Config.STRING_NO_HEAT, false, false)
		SetNewWaypoint(Config.Zones.DropOffPointCheapCar.Pos.x, Config.Zones.DropOffPointCheapCar.Pos.y)
	else
		UpgradeVehicle()

		SetNewWaypoint(Config.Zones.SellCar.Pos.x, Config.Zones.SellCar.Pos.y)

		-- Send message to delivery guys
		TriggerServerEvent('esx_phone:send', ThiefJob, Config.STRING_LOSE_HEAT, false, false)

		-- Send alert to police
		TriggerServerEvent('esx_phone:send', PoliceJob, Config.STRING_POLICE_MSG_P1 .. createThisCar.CarName .. Config.STRING_POLICE_MSG_P2 .. CurrentVehicle, false, false)

		-- Remove blips on map
		TriggerServerEvent('esx_carthief:removeCarBlips')

		for i = 0, Config.AmountOfTimeBlipWillFollowStolenCar, 1 do
			Wait(1000)
			local vehicleCoords = GetEntityCoords(CurrentVehicle)
			local Position = {x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z}
			TriggerServerEvent('esx_carthief:moveblip', Position)
		end
		TriggerServerEvent('esx_carthief:removeblip')
	end
end)

RegisterNetEvent('esx_carthief:setblip')
AddEventHandler('esx_carthief:setblip', function(position)
	CarBlip = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(CarBlip , 161)
	SetBlipScale(CarBlip , 2.0)
	SetBlipColour(CarBlip, 3)
	PulseBlip(CarBlip)
end)

RegisterNetEvent('esx_carthief:killblip')
AddEventHandler('esx_carthief:killblip', function()
    RemoveBlip(CarBlip)
end)

RegisterNetEvent('esx_carthief:removeStealCarBlips')
AddEventHandler('esx_carthief:removeStealCarBlips', function()
    RemoveBlip(StealBlip1)
    RemoveBlip(StealBlip2)
    RemoveBlip(StealBlip3)
    RemoveBlip(StealBlip4)
end)

RegisterNetEvent('esx_carthief:addStealCarBlips')
AddEventHandler('esx_carthief:addStealCarBlips', function()
	if PlayerData.job.name == ThiefJob then
		StealBlip1 = AddBlipForCoord(Config.Zones.StealCarPosition1.Pos.x, Config.Zones.StealCarPosition1.Pos.y, Config.Zones.StealCarPosition1.Pos.z)

		SetBlipSprite (StealBlip1, 229)
		SetBlipDisplay(StealBlip1, 4)
		SetBlipScale  (StealBlip1, 0.6)
		SetBlipColour (StealBlip1, 1)
		SetBlipAsShortRange(StealBlip1, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Valuable Car")
		EndTextCommandSetBlipName(StealBlip1)

		StealBlip2 = AddBlipForCoord(Config.Zones.StealCarPosition2.Pos.x, Config.Zones.StealCarPosition2.Pos.y, Config.Zones.StealCarPosition2.Pos.z)

		SetBlipSprite (StealBlip2, 229)
		SetBlipDisplay(StealBlip2, 4)
		SetBlipScale  (StealBlip2, 0.6)
		SetBlipColour (StealBlip2, 1)
		SetBlipAsShortRange(StealBlip2, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Valuable Car")
		EndTextCommandSetBlipName(StealBlip2)

		StealBlip3 = AddBlipForCoord(Config.Zones.StealCarPosition3.Pos.x, Config.Zones.StealCarPosition3.Pos.y, Config.Zones.StealCarPosition3.Pos.z)

		SetBlipSprite (StealBlip3, 229)
		SetBlipDisplay(StealBlip3, 4)
		SetBlipScale  (StealBlip3, 0.6)
		SetBlipColour (StealBlip3, 1)
		SetBlipAsShortRange(StealBlip3, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Valuable Car")
		EndTextCommandSetBlipName(StealBlip3)

		StealBlip4 = AddBlipForCoord(Config.Zones.StealCarPosition4.Pos.x, Config.Zones.StealCarPosition4.Pos.y, Config.Zones.StealCarPosition4.Pos.z)

		SetBlipSprite (StealBlip4, 229)
		SetBlipDisplay(StealBlip4, 4)
		SetBlipScale  (StealBlip4, 0.6)
		SetBlipColour (StealBlip4, 1)
		SetBlipAsShortRange(StealBlip4, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Valuable Car")
		EndTextCommandSetBlipName(StealBlip4)

		local StealBlipCheap = AddBlipForCoord(Config.Zones.StealCheapCarPosition.Pos.x, Config.Zones.StealCheapCarPosition.Pos.y, Config.Zones.StealCheapCarPosition.Pos.z)

		SetBlipSprite (StealBlipCheap, 229)
		SetBlipDisplay(StealBlipCheap, 4)
		SetBlipScale  (StealBlipCheap, 0.6)
		SetBlipColour (StealBlipCheap, 1)
		SetBlipAsShortRange(StealBlipCheap, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Cheap Car")
		EndTextCommandSetBlipName(StealBlipCheap)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		TriggerServerEvent('esx_carthief:removeCarBlips')

		Wait(10000)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then --and PlayerData.job.name == ThiefJob) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

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
			LastZone = currentZone
			TriggerEvent('esx_carthief:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_carthief:hasExitedMarker', LastZone)
		end
	end
end)

-- Car Thief Logic
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if PlayerData.job ~= nil then
			if Config.EnablePlayerManagement and CurrentAction == 'access_inventory' and PlayerData.job.name == ThiefJob and IsControlPressed(0,  Keys['F10']) then
				TriggerEvent('esx_society:openBossMenu', 'carthief', function(data, menu)
					menu.close()

					CurrentAction     = 'menu_boss_actions'
					CurrentActionData = {}
				end)
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == ThiefJob and CurrentAction == 'access_inventory' and IsControlPressed(0,  Keys['E']) then
				OpenArmoryMenu('carthief')
				CurrentAction = nil
			end

			if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == ThiefJob and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'carthief_actions') then
				OpenCarthiefActionsMenu()
				CurrentAction = nil
			end
		end

		if CurrentAction ~= nil and PlayerData.job ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if CurrentAction == 'steal_car_1' and IsControlPressed(0,  Keys['E']) then
				TriggerServerEvent('esx_carthief:startJob', CurrentAction)
				CurrentAction = nil
			end

			if CurrentAction == 'steal_car_2' and IsControlPressed(0,  Keys['E']) then
				TriggerServerEvent('esx_carthief:startJob', CurrentAction)
				CurrentAction = nil
			end

			if CurrentAction == 'steal_car_3' and IsControlPressed(0,  Keys['E']) then
				TriggerServerEvent('esx_carthief:startJob', CurrentAction)
				CurrentAction = nil
			end

			if CurrentAction == 'steal_car_4' and IsControlPressed(0,  Keys['E']) then
				TriggerServerEvent('esx_carthief:startJob', CurrentAction)
				CurrentAction = nil
			end

			if CurrentAction == 'steal_car_5' and IsControlPressed(0,  Keys['E']) then
				TriggerServerEvent('esx_carthief:startJob', CurrentAction)
				CurrentAction = nil
			end

			if CurrentAction == 'sell_car' and PlayerData.job.name == ThiefJob and IsControlPressed(0,  Keys['E']) then
			--if CurrentAction == 'sell_car' and IsControlPressed(0,  Keys['E']) then
				
				local playerPed = GetPlayerPed(-1)
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				local props = ESX.Game.GetVehicleProperties(vehicle)

				if IsPedInAnyVehicle(playerPed,  false) then
					TriggerServerEvent('esx_carthief:sellVehicle', props.plate)
				else
					ESX.ShowNotification(Config.STRING_SIT_CAR)
				end

			--elseif CurrentAction == 'sell_car' and PlayerData.job.name ~= ThiefJob then
			--	ESX.ShowNotification('You do not have permission to contact the buyer.')
				CurrentAction = nil
			end
		end
	end
end)

