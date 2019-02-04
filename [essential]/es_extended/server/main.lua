local flagNotification = GetConvar("flagNotification", "https://discordapp.com/api/webhooks/495400054669180929/JT96zcPxj1yZ88Bzwa4c8_50GzwxVeEcqvluDPMX4eN1wXyPHX6Ia_x_DPZo4-zPG_Z4")
local flagNotificationPrivate = GetConvar("flagNotificationPrivate", "https://discordapp.com/api/webhooks/495397291906170880/uVWlexcBVvgA3Tl_nXMqz4damlJPWBX_JvLErTnXY3NJOqJ3Z2gnTi46TX6apD-Cc5x9")

function SendWebhookMessage(webhook,message)
  if webhook ~= "false" then
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
  end
end

AddEventHandler('es:playerLoaded', function(source, _player)

  local _source = source
  local tasks   = {}

  local userData = {
    accounts     = {},
    inventory    = {},
    job          = {},
    loadout      = {},
    playerName   = GetPlayerName(_source),
    lastPosition = nil
  }

  TriggerEvent('es:getPlayerFromId', _source, function(player)

    -- Update user name in DB
    table.insert(tasks, function(cb)

      MySQL.Async.execute(
        'UPDATE `users` SET `name` = @name WHERE `identifier` = @identifier',
        {
          ['@identifier'] = player.getIdentifier(),
          ['@name']       = userData.playerName
        },
        function(rowsChanged)
          cb()
        end
      )

    end)

    -- Get accounts
    table.insert(tasks, function(cb)

      MySQL.Async.fetchAll(
        'SELECT * FROM `user_accounts` WHERE `identifier` = @identifier',
        {
          ['@identifier'] = player.getIdentifier()
        },
        function(accounts)

          for i=1, #Config.Accounts, 1 do
            for j=1, #accounts, 1 do
              if accounts[j].name == Config.Accounts[i] then
                table.insert(userData.accounts, {
                  name  = accounts[j].name,
                  money = accounts[j].money,
                  label = Config.AccountLabels[accounts[j].name]
                })
              end
            end

          end

          cb()
        end
      )

    end)

    -- Get Inventory
    table.insert(tasks, function(cb)

      MySQL.Async.fetchAll(
        'SELECT * FROM `user_inventory` WHERE `identifier` = @identifier',
        {
          ['@identifier'] = player.getIdentifier()
        },
        function(inventory)

          local tasks2 = {}

          for i=1, #inventory, 1 do
			if ESX.Items[inventory[i].item] then
            table.insert(userData.inventory, {
              name      = inventory[i].item,
              count     = inventory[i].count,
              label     = ESX.Items[inventory[i].item].label,
              limit     = ESX.Items[inventory[i].item].limit,
              usable    = ESX.UsableItemsCallbacks[inventory[i].item] ~= nil,
              rare      = ESX.Items[inventory[i].item].rare,
              canRemove = ESX.Items[inventory[i].item].canRemove,
            })
			else
				print("ERROR: Unknown item '"..inventory[i].item.."' tried loading")
			end
          end

          for k,v in pairs(ESX.Items) do

            local found = false

            for j=1, #userData.inventory, 1 do
              if userData.inventory[j].name == k then
                found = true
                break
              end
            end

            if not found then

              table.insert(userData.inventory, {
                name      = k,
                count     = 0,
                label     = ESX.Items[k].label,
                limit     = ESX.Items[k].limit,
                usable    = ESX.UsableItemsCallbacks[k] ~= nil,
                rare      = ESX.Items[k].rare,
                canRemove = ESX.Items[k].canRemove,
              })

              local scope = function(item, identifier)

                table.insert(tasks2, function(cb2)

                  MySQL.Async.execute(
                    'INSERT INTO user_inventory (identifier, item, count) VALUES (@identifier, @item, @count)',
                    {
                      ['@identifier'] = identifier,
                      ['@item']       = item,
                      ['@count']      = 0
                    },
                    function(rowsChanged)
                      cb2()
                    end
                  )

                end)

              end

              scope(k, player.getIdentifier())

            end

          end

          Async.parallelLimit(tasks2, 5, function(results) end)

          table.sort(userData.inventory, function(a,b)
            return a.label < b.label
          end)

          cb()
        end
      )

    end)

    -- Get job and loadout
    table.insert(tasks, function(cb)

      local tasks2 = {}

      -- Get job name, grade and last position and job_extra
      table.insert(tasks2, function(cb2)

        MySQL.Async.fetchAll(
          'SELECT * FROM `users` WHERE `identifier` = @identifier',
          {
            ['@identifier'] = player.getIdentifier()
          },
          function(result)

            userData.job['name']  = result[1].job
            userData.job['grade'] = result[1].job_grade
            userData.job['extra'] = result[1].job_extra

            if result[1].loadout ~= nil then
              userData.loadout = json.decode(result[1].loadout)
            end

            if result[1].position ~= nil then
              userData.lastPosition = json.decode(result[1].position)
            end

            cb2()

          end
        )

      end)

      -- Get job label
      table.insert(tasks2, function(cb2)

        MySQL.Async.fetchAll(
          'SELECT * FROM `jobs` WHERE `name` = @name',
          {
            ['@name'] = userData.job.name
          },
          function(result)

            userData.job['label'] = result[1].label

            cb2()

          end
        )

      end)

      -- Get job grade data
      table.insert(tasks2, function(cb2)

        MySQL.Async.fetchAll(
          'SELECT * FROM `job_grades` WHERE `job_name` = @job_name AND `grade` = @grade',
          {
            ['@job_name'] = userData.job.name,
            ['@grade']    = (userData.job.name=="unemployed") and 0 or userData.job.grade
          },
          function(result)

            userData.job['grade_name']   = result[1].name
            userData.job['grade_label']  = result[1].label
            userData.job['grade_salary'] = result[1].salary

            userData.job['skin_male']   = {}
            userData.job['skin_female'] = {}

            if result[1].skin_male ~= nil then
              userData.job['skin_male'] = json.decode(result[1].skin_male)
            end

            if result[1].skin_female ~= nil then
              userData.job['skin_female'] = json.decode(result[1].skin_female)
            end

            cb2()

          end
        )

      end)

      Async.series(tasks2, cb)

    end)

    -- Run Tasks
    Async.parallel(tasks, function(results)

      local xPlayer = CreateExtendedPlayer(player, userData.accounts, userData.inventory, userData.job, userData.loadout, userData.playerName, userData.lastPosition)

      xPlayer.getMissingAccounts(function(missingAccounts)

        if #missingAccounts > 0 then

          for i=1, #missingAccounts, 1 do
            table.insert(xPlayer.accounts, {
              name  = missingAccounts[i],
              money = 0,
              label = Config.AccountLabels[missingAccounts[i]]
            })
          end

          xPlayer.createAccounts(missingAccounts)
        end

        ESX.Players[_source] = xPlayer

        TriggerEvent('esx:playerLoaded', _source)

        TriggerClientEvent('esx:playerLoaded', _source, {
          identifier   = xPlayer.identifier,
          accounts     = xPlayer.getAccounts(),
          inventory    = xPlayer.getInventory(),
          job          = xPlayer.getJob(),
          loadout      = xPlayer.getLoadout(),
          lastPosition = xPlayer.getLastPosition(),
          money        = xPlayer.get('money')
        })

        xPlayer.player.displayMoney(xPlayer.get('money'))

      end)

    end)

  end)

end)

AddEventHandler('playerDropped', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if xPlayer ~= nil then

    TriggerEvent('esx:playerDropped', _source)

    ESX.SavePlayer(xPlayer, function()
      ESX.Players[_source]        = nil
      ESX.LastPlayerData[_source] = nil
    end)

  end

end)

RegisterServerEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(loadout)
  local xPlayer   = ESX.GetPlayerFromId(source)
  xPlayer.loadout = loadout
end)

RegisterServerEvent('esx:updateLastPosition')
AddEventHandler('esx:updateLastPosition', function(position)
  local xPlayer        = ESX.GetPlayerFromId(source)
  xPlayer.lastPosition = position
end)


RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount, ammotogive)

  local _source = source

  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if type == 'item_standard' then

    local sourceItem    = sourceXPlayer.getInventoryItem(itemName)
    local targetItem    = targetXPlayer.getInventoryItem(itemName)

    if itemCount > 0 and sourceItem.count >= itemCount then

      if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
        TriggerClientEvent('esx:showNotification', target, _U('ex_inv_lim') .. targetXPlayer.name)
      else
        sourceXPlayer.removeInventoryItem(itemName, itemCount)
        targetXPlayer.addInventoryItem   (itemName, itemCount)

        TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' ~g~x' .. itemCount .. ' ' .. ESX.Items[itemName].label .. _U('to')   .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', target,  _U('youreceived') .. ' ~g~x'  .. itemCount .. ' ' .. ESX.Items[itemName].label .. _U('by') .. sourceXPlayer.name)

        TriggerEvent("esx:giveitemalert",sourceXPlayer.name,targetXPlayer.name,ESX.Items[itemName].label,itemCount)
      end

    else
      TriggerClientEvent('esx:showNotification', target, _U('imp_invalid_quantity'))
    end

  elseif type == 'item_money' then
    if itemCount > 0 and sourceXPlayer.player.get('money') >= itemCount then
      local sourcePlayerMoneyLeft = sourceXPlayer.player.get('money')
      if (itemCount >= 100000) then
        SendWebhookMessage(flagNotification, "FLAG: $" .. itemCount .. " given from " .. sourceXPlayer.name .. " to " .. targetXPlayer.name .. ", has a total of $" .. sourcePlayerMoneyLeft)
        SendWebhookMessage(flagNotificationPrivate, "FLAG: $" .. itemCount .. " given from " .. sourceXPlayer.name .. " to " .. targetXPlayer.name .. ", has a total of $" .. sourcePlayerMoneyLeft)
        sourceXPlayer.removeMoney(itemCount)
        targetXPlayer.addMoney(itemCount)

        TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' ~g~$' .. itemCount .. _U('to')   .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', target,  _U('youreceived') .. ' ~g~$'  .. itemCount .. _U('by') .. sourceXPlayer.name)

        TriggerEvent("esx:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
      elseif (itemCount >= 1000000) then
        SendWebhookMessage(flagNotification, "FLAG: $" .. itemCount .. " given from " .. sourceXPlayer.name .. " to " .. targetXPlayer.name .. ", has a total of $" .. sourcePlayerMoneyLeft)
        SendWebhookMessage(flagNotificationPrivate, "FLAG: $" .. itemCount .. " given from " .. sourceXPlayer.name .. " to " .. targetXPlayer.name .. ", has a total of $" .. sourcePlayerMoneyLeft)
        -- sourceXPlayer.removeMoney(itemCount)
        TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' ~g~$' .. itemCount .. _U('to')   .. targetXPlayer.name)
      else
        sourceXPlayer.removeMoney(itemCount)
        targetXPlayer.addMoney(itemCount)

        TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' ~g~$' .. itemCount .. _U('to')   .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', target,  _U('youreceived') .. ' ~g~$'  .. itemCount .. _U('by') .. sourceXPlayer.name)

        TriggerEvent("esx:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
      end

    else
      TriggerClientEvent('esx:showNotification', target, _U('imp_invalid_amount'))
    end

  elseif type == 'item_account' then

    if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
      local sourcePlayerMoneyLeft = sourceXPlayer.player.get('money')
      if (itemCount >= 100000) then
        SendWebhookMessage(flagNotification, "FLAG: $" .. itemCount .. " transferred from " .. sourceXPlayer.name .. " to " .. targetXPlayer.name .. ", has a total of $" .. sourcePlayerMoneyLeft)
        SendWebhookMessage(flagNotificationPrivate, "FLAG: $" .. itemCount .. " transferred from " .. sourceXPlayer.name .. " to " .. targetXPlayer.name .. ", has a total of $" .. sourcePlayerMoneyLeft)
        sourceXPlayer.removeAccountMoney(itemName, itemCount)
        targetXPlayer.addAccountMoney(itemName, itemCount)

        TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' [' .. Config.AccountLabels[itemName] .. '] ~g~$' .. itemCount .. _U('to')   .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', target,  _U('youreceived') .. ' ['  .. Config.AccountLabels[itemName] .. '] ~g~$' .. itemCount .. _U('by') .. sourceXPlayer.name)

        TriggerEvent("esx:givemoneybankalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
      else
        sourceXPlayer.removeAccountMoney(itemName, itemCount)
        targetXPlayer.addAccountMoney(itemName, itemCount)

        TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' [' .. Config.AccountLabels[itemName] .. '] ~g~$' .. itemCount .. _U('to')   .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', target,  _U('youreceived') .. ' ['  .. Config.AccountLabels[itemName] .. '] ~g~$' .. itemCount .. _U('by') .. sourceXPlayer.name)

        TriggerEvent("esx:givemoneybankalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
      end

    else
      TriggerClientEvent('esx:showNotification', target, _U('imp_invalid_amount'))
    end

  elseif type == 'item_weapon' then

    sourceXPlayer.removeWeapon(itemName)
    targetXPlayer.addWeapon(itemName, itemCount)

    local weaponLabel = itemName

    for i=1, #Config.Weapons, 1 do
      if Config.Weapons[i].name == itemName then
        weaponLabel = Config.Weapons[i].label
        break
      end
    end

    TriggerClientEvent('esx:showNotification', _source, _U('yougave') .. ' x1 ~g~' .. weaponLabel .. _U('to')   .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', target,  _U('youreceived')  .. ' x1 ~g~' .. weaponLabel .. _U('by') .. sourceXPlayer.name)

    TriggerEvent("esx:giveweaponalert",sourceXPlayer.name,targetXPlayer.name,weaponLabel)
  end

end)

RegisterServerEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)

  local _source = source

  if type == 'item_standard' then

    if itemCount == nil or itemCount <= 0 then
      TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
    else

      local xPlayer   = ESX.GetPlayerFromId(source)
      local foundItem = nil

      for i=1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].name == itemName then
          foundItem = xPlayer.inventory[i]
        end
      end

      if itemCount > foundItem.count then
        TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
      else

        TriggerClientEvent('esx:showNotification', _source, _U('delete_five_min'))

        SetTimeout(Config.RemoveInventoryItemDelay, function()

          local remainingCount = xPlayer.getInventoryItem(itemName).count
          local total          = itemCount

          if remainingCount < itemCount then
            total = remainingCount
          end

          if total > 0 then
            xPlayer.removeInventoryItem(itemName, total)
            ESX.CreatePickup('item_standard', itemName, total, foundItem.label, _source)
            TriggerClientEvent('esx:showNotification', _source, _U('threw') .. ' ' .. foundItem.label .. ' x' .. total)
          end

        end)

      end

    end

  elseif type == 'item_money' then

    if itemCount == nil or itemCount <= 0 then
      TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
    else

      local xPlayer = ESX.GetPlayerFromId(source)

      if itemCount > xPlayer.player.get('money') then
        TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
      else

        TriggerClientEvent('esx:showNotification', _source, _U('delete_five_min'))

        SetTimeout(10 * 60000, function()

          local remainingCount = xPlayer.player.get('money')
          local total          = itemCount

          if remainingCount < itemCount then
            total = remainingCount
          end

          if total > 0 then
            if (total >= 15000) then
              SendWebhookMessage(flagNotification, "Suspicious $" .. total .. " drop from " .. xPlayer.name .. ", left with $" .. remainingCount)
              SendWebhookMessage(flagNotificationPrivate, "Suspicious $" .. total .. " drop from " .. xPlayer.name .. ", left with $" .. remainingCount)
            else
              xPlayer.removeMoney(total)
              ESX.CreatePickup('item_money', 'money', total, 'Cash', _source)
              TriggerClientEvent('esx:showNotification', _source, _U('threw') .. ' [Cash] $' .. total)
            end
          end

        end)

      end

    end

  elseif type == 'item_account' then

    if itemCount == nil or itemCount <= 0 then
      TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
    else

      local xPlayer = ESX.GetPlayerFromId(source)

      if itemCount > xPlayer.getAccount(itemName).money then
        TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
      else

        TriggerClientEvent('esx:showNotification', _source, _U('delete_five_min'))

        SetTimeout(Config.RemoveInventoryItemDelay, function()

          local remainingCount = xPlayer.getAccount(itemName).money
          local total          = itemCount

          if remainingCount < itemCount then
            total = remainingCount
          end

          if total > 0 then
            xPlayer.removeAccountMoney(itemName, total)
            ESX.CreatePickup('item_account', itemName, total, 'Cash', _source)
            TriggerClientEvent('esx:showNotification', _source, _U('threw') .. ' [Cash] $' .. total)
          end

        end)

      end

    end

  elseif type == 'item_weapon' then

    local xPlayer      = ESX.GetPlayerFromId(source)
    local weaponLabel  = itemName
    local weaponName   = nil
    local weaponPickup = nil

    for i=1, #Config.Weapons, 1 do
      if Config.Weapons[i].name == itemName then
        weaponLabel = Config.Weapons[i].label
        weaponName = Config.Weapons[i].name
        weaponPickup = 'PICKUP_'..weaponName
        break
      end
    end

    SetTimeout(Config.RemoveInventoryItemDelay, function()

      xPlayer.removeWeapon(itemName)

      if Config.EnableWeaponPickup then
        TriggerClientEvent('esx:pickupWeapon', _source, weaponPickup, weaponName, itemCount)
      end

      TriggerClientEvent('esx:showNotification', _source, _U('threw') .. ' x1 ~g~' .. weaponLabel .. _U('withammo').. '~r~' .. itemCount .. _U('ammogiven'))

    end)

  end

end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)

  local xPlayer = ESX.GetPlayerFromId(source)
  local count   = xPlayer.getInventoryItem(itemName).count

  if count > 0 then
    ESX.UseItem(source, itemName)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('act_imp'))
  end

end)

RegisterServerEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(id)

  local pickup  = ESX.Pickups[id]
  local xPlayer = ESX.GetPlayerFromId(source)

  if pickup.type == 'item_standard' then
    xPlayer.addInventoryItem(pickup.name, pickup.count)
  elseif pickup.type == 'item_money' then
    xPlayer.addMoney(pickup.count)
  elseif pickup.type == 'item_account' then
    xPlayer.addAccountMoney(pickup.name, pickup.count)
  end

  TriggerClientEvent('esx:removePickup', -1, id)

end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  cb({
    identifier   = xPlayer.identifier,
    accounts     = xPlayer.getAccounts(),
    inventory    = xPlayer.getInventory(),
    job          = xPlayer.getJob(),
    loadout      = xPlayer.getLoadout(),
    lastPosition = xPlayer.getLastPosition(),
    money        = xPlayer.get('money')
  })

end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)

  local xPlayer = ESX.GetPlayerFromId(target)

  cb({
    identifier   = xPlayer.identifier,
    accounts     = xPlayer.getAccounts(),
    inventory    = xPlayer.getInventory(),
    job          = xPlayer.getJob(),
    loadout      = xPlayer.getLoadout(),
    lastPosition = xPlayer.getLastPosition(),
    money        = xPlayer.get('money')
  })

end)

TriggerEvent("es:addGroup", "jobmaster", "user", function(group) end)

ESX.StartDBSync()
ESX.StartPayCheck()
