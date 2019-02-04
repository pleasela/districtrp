ESX = nil

local numEMS = 0
local deadPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function CountEMS()

  local xPlayers = ESX.GetPlayers()

  numEMS = 0

  for i=1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if xPlayer.job.name == 'ambulance' then
      numEMS = numEMS + 1
    end
  end
  SetTimeout(Config.CountEMSTimer, CountEMS)
end

if Config.NoPenaltyWithoutEMS then
  CountEMS()
end

ESX.RegisterServerCallback('esx_ambulancejob:checkDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if deadPlayers[xPlayer.identifier] then
		--Reconnected while dead
		--Kill them again
		cb(true)
		return
	end
	cb(false)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getNumEMS', function(source, cb)
	cb(numEMS)
end)

RegisterServerEvent('esx_ambulancejob:didDie')
AddEventHandler('esx_ambulancejob:didDie', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	deadPlayers[xPlayer.identifier] = true
end)

ESX.RegisterServerCallback('esx_ambulancejob:refreshJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then cb(xPlayer.job) end
end)

RegisterServerEvent('esx_ambulancejob:goOffDuty')
AddEventHandler('esx_ambulancejob:goOffDuty', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.goOffDuty()
end)

RegisterServerEvent('esx_ambulancejob:goOnDuty')
AddEventHandler('esx_ambulancejob:goOnDuty', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.goOnDuty()
end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
  TriggerClientEvent('esx_ambulancejob:revive', target)
  local xPlayer = ESX.GetPlayerFromId(target)
  --print("Was a revive")
  if (xPlayer) then
	deadPlayers[xPlayer.identifier] = nil
  end

end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
  TriggerClientEvent('esx_ambulancejob:heal', target, type)
  local xPlayer = ESX.GetPlayerFromId(target)
  if (xPlayer) then
	deadPlayers[xPlayer.identifier] = nil
  end
end)

RegisterServerEvent('esx_ambulancejob:notDead')
AddEventHandler('esx_ambulancejob:notDead', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  if (xPlayer) then
	deadPlayers[xPlayer.identifier] = nil
  end
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  --Don't remove anything if no EMS
  if Config.NoPenaltyWithoutEMS and numEMS > 0 then
    if Config.RemoveCashAfterRPDeath then

      if xPlayer.getMoney() > 0 then
        xPlayer.removeMoney(xPlayer.getMoney())
      end

      if xPlayer.getAccount('black_money').money > 0 then
        xPlayer.setAccountMoney('black_money', 0)
      end

    end

    if Config.RemoveItemsAfterRPDeath then
      for i=1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].count > 0 then
          xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
        end
      end
    end

    if Config.RemoveWeaponsAfterRPDeath then
      for i=1, #xPlayer.loadout, 1 do
        xPlayer.removeWeapon(xPlayer.loadout[i].name)
      end
    end
  end

  if Config.RespawnFine then
    xPlayer.removeAccountMoney('bank', Config.RespawnFineAmount)
  end

  cb()

end)

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
  local xPlayer = ESX.GetPlayerFromId(source)
  local qtty = xPlayer.getInventoryItem(item).count
  cb(qtty)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.removeInventoryItem(item, 1)
  if item == 'bandage' then
    TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
  elseif item == 'medikit' then
    TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
  end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local limit = xPlayer.getInventoryItem(item).limit
  local delta = 1
  local qtty = xPlayer.getInventoryItem(item).count
  if limit ~= -1 then
    delta = limit - qtty
  end
  if qtty < limit then
    xPlayer.addInventoryItem(item, delta)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
  end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'user', function(source, args, user)
  local isAdmin = user.getGroup() == "admin" or user.getGroup() == "superadmin"
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name ~= "ambulance" and not isAdmin then
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
	return
  end
  if args[1] ~= nil then
    TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]))
	local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
		if (xPlayer) then
			deadPlayers[xPlayer.identifier] = nil
		end
  elseif isAdmin or numEMS == 1 then
    TriggerClientEvent('esx_ambulancejob:revive', source)
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer) then
			deadPlayers[xPlayer.identifier] = nil
		end
  end
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = _U('revive_help'), params = {{name = 'id'}}})

ESX.RegisterUsableItem('medikit', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('medikit', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'big')
  TriggerClientEvent('esx:showNotification', source, _U('used_medikit'))
end)

ESX.RegisterUsableItem('bandage', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('bandage', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'small')
  TriggerClientEvent('esx:showNotification', source, _U('used_bandage'))
end)
