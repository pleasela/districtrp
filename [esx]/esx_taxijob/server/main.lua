ESX = nil

local hackNotification = GetConvar("hackNotification", "https://discordapp.com/api/webhooks/459994097785110538/dhDsO6ScTlqUgmulakjKY3I_g-KbRSKI_1ROylSWIPzK36Un-XZKcnqAaQDDIszfOiJC")
local hackNotificationPrivate = GetConvar("hackNotificationPrivate", "https://discordapp.com/api/webhooks/459993735028146186/Rz3Dl6SWMlfhTb5hIn6XUBScYeAYikEY9TzaXdP7CxeEUtJaNfOqbWPUztJCwO-n1_mM")

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'private'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function(seed)
  local sxPlayer = ESX.GetPlayerFromId(source)
  if (seed and seed == "didComplete") then
    if sxPlayer and sxPlayer.job.name ~= 'taxi' then
      print("ESX_TAXIJOB Malicious success from " .. sxPlayer.name)
      SendWebhookMessage(hackNotification, "ESX_TAXIJOB Malicious success from " .. sxPlayer.name)
      SendWebhookMessage(hackNotificationPrivate, "ESX_TAXIJOB Malicious success from " .. sxPlayer.name)
      return
    else
      math.randomseed(os.time())

      local xPlayer        = ESX.GetPlayerFromId(source)
      local total          = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);
      local societyAccount = nil

      if xPlayer.job.grade >= 3 then
        total = total * 2
      end

      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
        societyAccount = account
      end)

      if societyAccount ~= nil then

        local playerMoney  = math.floor(total / 100 * 75)
        local societyMoney = math.floor(total / 100 * 25)

        xPlayer.addMoney(playerMoney)
        societyAccount.addMoney(societyMoney)

        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. playerMoney)
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. societyMoney)

      else
        xPlayer.addMoney(total)
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. total)
      end
    end
  else
    SendWebhookMessage(hackNotification, "ESX_TAXIJOB Malicious seed from " .. sxPlayer.name)
    SendWebhookMessage(hackNotificationPrivate, "ESX_TAXIJOB Malicious seed from " .. sxPlayer.name)
  end

end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

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

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

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

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
