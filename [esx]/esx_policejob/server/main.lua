ESX = nil

local hackNotification = GetConvar("hackNotification", "https://discordapp.com/api/webhooks/495398672134307851/U42Y5mJPFpELKi_18rnNGogdIUxlsk7iww7lvpcQ00OOIHKG13RtmUdpZPna0uSXYydD")
local hackNotificationPrivate = GetConvar("hackNotificationPrivate", "https://discordapp.com/api/webhooks/495397052277063711/q-U1xIvCtZxDKGwl0dqhxjhFtro8Fpu8tajkf2njvpRCMobgpHrSOoSDnZptdRp4EqOP")

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end
-- number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon
TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

local copList = {}

local function sendCops()
	for i, c in pairs(copList) do
		TriggerClientEvent('esx_policejob:copsInService', i, copList)
	end
end

ESX.RegisterServerCallback('esx_policejob:refreshJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		cb(xPlayer.job)
		if xPlayer.job.name == "police" then
			copList[source] = true
			sendCops()
		end
	end
end)

AddEventHandler('playerDropped', function()
	if(copList[source]) then
		copList[source] = nil
		sendCops()
	end
end)

RegisterServerEvent('esx_policejob:goOffDuty')
AddEventHandler('esx_policejob:goOffDuty', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		xPlayer.goOffDuty()
		copList[source] = nil
		sendCops()
	end
end)

RegisterServerEvent('esx_policejob:goOnDuty')
AddEventHandler('esx_policejob:goOnDuty', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		xPlayer.goOnDuty()
		copList[source] = true
		sendCops()
	end
end)

function SendWebhookMessage(webhook,message)
	if webhook ~= "false" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target, force, state)
	local sxPlayer = ESX.GetPlayerFromId(source)
	if sxPlayer and sxPlayer.job.name ~= 'police' then
		print("ESX_POLICEJOB Malicious cuff from " .. sxPlayer.name)
		SendWebhookMessage(hackNotification, "ESX_POLICEJOB Malicious cuff from " .. sxPlayer.name)
    SendWebhookMessage(hackNotificationPrivate, "ESX_POLICEJOB Malicious cuff from " .. sxPlayer.name)
		return
	end
	
	TriggerClientEvent('esx_policejob:handcuff', target, force, state)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
  local _source = source

	local sxPlayer = ESX.GetPlayerFromId(source)
	if sxPlayer and sxPlayer.job.name ~= 'police' then
		print("ESX_POLICEJOB Malicious drag from " .. sxPlayer.name)
		SendWebhookMessage(hackNotification, "ESX_POLICEJOB Malicious drag from " .. sxPlayer.name)
    SendWebhookMessage(hackNotificationPrivate, "ESX_POLICEJOB Malicious drag from " .. sxPlayer.name)
		return
	end

  TriggerClientEvent('esx_policejob:drag', target, _source)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
  TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

RegisterServerEvent('esx_policejob:checkFines')
AddEventHandler('esx_policejob:checkFines', function(target)
    TriggerClientEvent('esx_policejob:checkFines', target)
end)

RegisterServerEvent('esx_policejob:Timeout')
AddEventHandler('esx_policejob:Timeout', function(target)
	TriggerClientEvent("EasyAdmin:teleportUser", target, 226.853, -986.62, -99.0)
	TriggerClientEvent('showNotification', target, "You are in time-out, talk to an admin on discord.")
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

local allowedConfiscatedRetrievals = {3,5,6,20,30}

RegisterServerEvent('esx_policejob:getConfiscatedItem')
AddEventHandler('esx_policejob:getConfiscatedItem', function(itemName, count)
  local xPlayer = ESX.GetPlayerFromId(source)

  local pullAllowed = false

  for i=1, #allowedConfiscatedRetrievals, 1 do
    if (xPlayer.job.grade == allowedConfiscatedRetrievals[i]) then
      pullAllowed = true
      break
    end
  end

  if (pullAllowed) then
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police_confiscated', function(inventory)

      local item = inventory.getItem(itemName)

      if item.count >= count then
        inventory.removeItem(itemName, count)
        xPlayer.addInventoryItem(itemName, count)
      else
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
      end

      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdraw') .. count .. ' ' .. item.label)
    end)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('confiscated_no_authority'))
  end

end)

RegisterServerEvent('esx_policejob:getConfiscatedMoney')
AddEventHandler('esx_policejob:getConfiscatedMoney', function(itemName, count)
  local xPlayer = ESX.GetPlayerFromId(source)

  local pullAllowed = false
  for i=1, #allowedConfiscatedRetrievals, 1 do
    if (xPlayer.job.grade == allowedConfiscatedRetrievals[i]) then
      pullAllowed = true
      break
    end
  end

  if (pullAllowed) then
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police_confiscated', function(account)
      account.removeMoney(count)
      xPlayer.addAccountMoney('black_money', count)
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdraw_money') .. count .. ' ' .. "Black Money")
    end)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('confiscated_no_authority'))
  end


end)

RegisterServerEvent('esx_policejob:putConfiscatedItems')
AddEventHandler('esx_policejob:putConfiscatedItems', function(itemName, count, itemType)

  local xPlayer = ESX.GetPlayerFromId(source)

  if itemType == 'item_standard' then
      TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police_confiscated', function(inventory)
        local item = inventory.getItem(itemName)

        if item.count >= 0 then
          xPlayer.removeInventoryItem(itemName, count)
          inventory.addItem(itemName, count)
        else
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
        end
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)
      end)
    end

    if itemType == 'item_account' then
      xPlayer.removeAccountMoney(itemName, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police_confiscated', function(account)
        account.addMoney(count)
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added_money') .. count .. ' ' .. "Dirty Money")
      end)
    end

    -- if itemType == 'item_weapon' then
    --   xPlayer.removeWeapon(itemName, count)
    --   inventory.addItem(itemName, count)
    -- end

end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)

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

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
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

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles WHERE vehicle LIKE @plate',
      {
        ['@plate'] = '%' .. plate .. '%'
      },
      function(result)

        local foundidentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundidentifier = result[i].owner
            break
          end

        end

        if foundidentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundidentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundidentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundidentifier = result[i].owner
            break
          end

        end

        if foundidentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundidentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

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

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

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


ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)


ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_policejob:getConfiscatedItems', function(source, cb)

  local elements = {}

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police_confiscated', function(account)
    elements[1] = {
        label  = "Dirty Money",
        name  = "black_money",
        count = account.money,
        type = "item_account"
      }
  end)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police_confiscated', function(inventory)
    table.insert(elements, inventory.items)
    for i=1, #inventory.items, 1 do
      elements[i+1] = inventory.items[i]
    end

  end)

  cb(elements)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

local trafficLevel = 0.3
local trafficOverride = true

TriggerEvent( 'es:addGroupCommand', 'traf', 'admin', function( source, args, user )
	local val = tonumber(args[1])
	if val then
		trafficLevel = val
		trafficOverride = true
		if trafficLevel == 1.0 then 
			trafficOverride = false
		end
		TriggerClientEvent("esx_policejob:setTraffic", -1, trafficOverride, trafficLevel + 0.0)
	end
end, function( source, args, user )
	TriggerClientEvent( 'chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficient permissions!" )
end )

ESX.RegisterServerCallback('esx_policejob:getTraffic', function(source, cb)
	cb(trafficOverride, trafficLevel)
end)

