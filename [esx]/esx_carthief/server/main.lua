ESX = nil

local lastTimeCarWasStolen = 0
local currentVehiclePlates = {}
local currentVehicleValues = {}
local currentVehicle = nil
local ThiefJob = 'carthief'
local PoliceJob = 'police'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'carthief', 'Delivery', true, true)
TriggerEvent('esx_society:registerSociety', 'carthief', 'Delivery', 'society_carthief', 'society_carthief', 'society_carthief', {type = 'private'})

RegisterServerEvent('esx_carthief:confiscatePlayerItem')
AddEventHandler('esx_carthief:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ' You have confiscated ' .. amount .. ' ' .. label .. ' from ' .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. ' got robbed of ' .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ' You have confiscated ' .. amount .. ' from ' .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. ' got robbed of ' .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ' You have confiscated ' .. ESX.GetWeaponLabel(itemName) .. ' ' .. amount .. ' from ' .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. ' got robbed of ' .. ESX.GetWeaponLabel(itemName))

  end

end)

ESX.RegisterServerCallback('esx_carthief:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

RegisterServerEvent('esx_carthief:handcuff')
AddEventHandler('esx_carthief:handcuff', function(target)
  TriggerClientEvent('esx_carthief:handcuff', target)
end)

RegisterServerEvent('esx_carthief:drag')
AddEventHandler('esx_carthief:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_carthief:drag', target, _source)
end)

RegisterServerEvent('esx_carthief:putInVehicle')
AddEventHandler('esx_carthief:putInVehicle', function(target)
  TriggerClientEvent('esx_carthief:putInVehicle', target)
end)

RegisterServerEvent('esx_carthief:OutVehicle')
AddEventHandler('esx_carthief:OutVehicle', function(target)
    TriggerClientEvent('esx_carthief:OutVehicle', target)
end)

ESX.RegisterServerCallback('esx_carthief:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_carthief', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_carthief:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_carthief', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_carthief:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_carthief', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


RegisterServerEvent('esx_carthief:sellVehicle')
AddEventHandler('esx_carthief:sellVehicle', function(vehiclePlate)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- Check if the correct vehicle is being sold, the string find is there because something added a space to the vehicle plate, esx?
  for i=1, #currentVehiclePlates do
    if string.find(vehiclePlate, currentVehiclePlates[i]) then
      -- Found the car
      -- Correct vehicle being sold
      TriggerClientEvent('esx_carthief:deleteStolenVehicle', source, currentVehicleValues[i])
    else
      -- This needs work, not finished
      TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_WRONG_VEHICLE)
    end
  end
end)

RegisterServerEvent('esx_carthief:pongStolenVehicle')
AddEventHandler('esx_carthief:pongStolenVehicle', function(vehiclePlate, value)
  table.insert(currentVehiclePlates, vehiclePlate)
  table.insert(currentVehicleValues, value)
	currentVehicle = vehiclePlate
end)

RegisterServerEvent('esx_carthief:removeCarBlips')
AddEventHandler('esx_carthief:removeCarBlips', function()
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(source)

	local copsConnected = 0
	local thievesConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == PoliceJob then
			copsConnected = copsConnected + 1
		end
		if xPlayer.job.name == ThiefJob then
			thievesConnected = thievesConnected +1
		end
	end

	TriggerClientEvent('esx_carthief:removeStealCarBlips', source)
	
	if copsConnected >= Config.RequiredCops and thievesConnected >= Config.RequiredThieves then
		if GetGameTimer() - lastTimeCarWasStolen > Config.CooldownOnStealingCar * 1000 then
			TriggerClientEvent('esx_carthief:addStealCarBlips', source)
		end
	end
	
end)

RegisterServerEvent('esx_carthief:startJob')
AddEventHandler('esx_carthief:startJob', function(car)

	local copsConnected = 0
	local thievesConnected = 0

	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(source)

	local carIndex = 0

	if car == 'steal_car_1' then
		carIndex = 0
	end

	if car == 'steal_car_2' then
		carIndex = 1
	end

	if car == 'steal_car_3' then
		carIndex = 2
	end

	if car == 'steal_car_4' then
		carIndex = 3
	end

  if car == 'steal_car_5' then
    carIndex = 4
  end

	copsConnected = 0
	thievesConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == PoliceJob then
			copsConnected = copsConnected + 1
		end
		if xPlayer.job.name == ThiefJob then
			thievesConnected = thievesConnected +1
		end
	end

	local createThisCar = nil
	local iterator = 0

	for k,v in pairs(Config.Cars) do
		if iterator == carIndex then
			createThisCar = v
		end
		iterator = iterator + 1
	end

	local playerWhoStartedJob = ESX.GetPlayerFromId(source)

  if car == 'steal_car_5' then
    TriggerClientEvent('esx_carthief:createStolenVehicle', xPlayer.source, carIndex)
	elseif copsConnected >= Config.RequiredCops and thievesConnected >= Config.RequiredThieves then
		-- check cooldown
		if GetGameTimer() - lastTimeCarWasStolen > Config.CooldownOnStealingCar * 1000 then
			lastTimeCarWasStolen = GetGameTimer()
			TriggerClientEvent('esx_carthief:createStolenVehicle', xPlayer.source, carIndex)
		else 
			local cooldownTimer = Config.CooldownOnStealingCar * 1000 - (GetGameTimer() - lastTimeCarWasStolen)
			TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_COOLDOWN_P1 .. cooldownTimer/1000  .. Config.STRING_COOLDOWN_P2)
		end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_INSUFF_POLICE)
	end
end)

RegisterServerEvent('esx_carthief:removeblip')
AddEventHandler('esx_carthief:removeblip', function()
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == PoliceJob then
			TriggerClientEvent('esx_carthief:killblip', xPlayers[i])
		end
	end
end)

RegisterServerEvent('esx_carthief:moveblip')
AddEventHandler('esx_carthief:moveblip', function(position)
	local xPlayers = ESX.GetPlayers()

	-- Remove old one and place a new one
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == PoliceJob then
			TriggerClientEvent('esx_carthief:killblip', xPlayers[i])
		end
	end

	

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == PoliceJob then
			TriggerClientEvent('esx_carthief:setblip', xPlayers[i], position)
		end
	end
end)

RegisterServerEvent('esx_carthief:delivered')
AddEventHandler('esx_carthief:delivered', function(value)
	local xPlayer        = ESX.GetPlayerFromId(source)
	local total          = value;

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_carthief', function(account)
    account.addMoney(total)
  end)

	TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_SOLD_CAR_VALUE .. value)
end)

RegisterServerEvent('esx_carthief:getStockItem')
AddEventHandler('esx_carthief:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_carthief', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_INVALID_QUANTITY)
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_HAVE_WITHDRAWN .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_carthief:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_carthief', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_carthief:putStockItems')
AddEventHandler('esx_carthief:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_carthief', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, Config.STRING_ADDED .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_carthief:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
