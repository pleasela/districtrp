ESX                 = nil
Jobs                = {}
RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local hackNotification = GetConvar("hackNotification", "https://discordapp.com/api/webhooks/495398672134307851/U42Y5mJPFpELKi_18rnNGogdIUxlsk7iww7lvpcQ00OOIHKG13RtmUdpZPna0uSXYydD")
local hackNotificationPrivate = GetConvar("hackNotificationPrivate", "https://discordapp.com/api/webhooks/495397052277063711/q-U1xIvCtZxDKGwl0dqhxjhFtro8Fpu8tajkf2njvpRCMobgpHrSOoSDnZptdRp4EqOP")

local societyFundsLogsNotification = "https://discordapp.com/api/webhooks/495397536207601687/yrkh-jdHR2GW-8L6yZv-FUk0It15mFm3bBiJQG13pO6GkhD3nL7aZ-IU9keD561a32uu"

function stringsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function GetSociety(name)
  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      return RegisteredSocieties[i]
    end
  end
end

AddEventHandler('onMySQLReady', function()

  local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

  for i=1, #result, 1 do
    Jobs[result[i].name]        = result[i]
    Jobs[result[i].name].grades = {}
  end

  local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

  for i=1, #result2, 1 do
    Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
  end

end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)

  local found = false

  local society = {
    name      = name,
    label     = label,
    account   = account,
    datastore = datastore,
    inventory = inventory,
    data      = data,
  }

  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      found                  = true
      RegisteredSocieties[i] = society
      break
    end
  end

  if not found then
    table.insert(RegisteredSocieties, society)
  end

end)

AddEventHandler('esx_society:getSocieties', function(cb)
  cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
  cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)

    if amount > 0 and account.money >= amount then

      account.removeMoney(amount)
      xPlayer.addMoney(amount)

      SendWebhookMessage(societyFundsLogsNotification, "ESX_SOCIETY fund withdrawn by " .. GetPlayerName(source) .. " (" .. xPlayer.identifier .. ") - $" .. amount .. " from " .. society.account)
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. amount)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
    end

  end)

end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  if amount > 0 and xPlayer.get('money') >= amount then

    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
      xPlayer.removeMoney(amount)
      account.addMoney(amount)
    end)

    SendWebhookMessage(societyFundsLogsNotification, "ESX_SOCIETY fund deposit by " .. GetPlayerName(source) .. " (" .. xPlayer.identifier .. ") - $" .. amount .. " to " .. society.account)
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited') .. amount)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end

end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if amount > 0 and account.money >= amount then

    xPlayer.removeAccountMoney('black_money', amount)

      MySQL.Async.execute(
        'INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@society']    = society,
          ['@amount']     = amount
        },
        function(rowsChanged)
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', amount))
        end
      )

  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end

end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    local garage = store.get('garage') or {}
    table.insert(garage, vehicle)
    store.set('garage', garage)
  end)

end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    
    local garage = store.get('garage') or {}

    for i=1, #garage, 1 do
      if garage[i].plate == vehicle.plate then
        table.remove(garage, i)
        break
      end
    end

    store.set('garage', garage)

  end)

end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)

  local society = GetSociety(societyName)

  if society ~= nil then

    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
      cb(account.money)
    end)

  else
    cb(0)
  end

end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)

  if Config.EnableESXIdentity then
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC',
      { ['@job'] = society },
      function (results)
        local employees = {}

        for i=1, #results, 1 do
          table.insert(employees, {
            name                 = results[i].firstname .. ' ' .. results[i].lastname,
            identifier  = results[i].identifier,
            job = {
              name        = results[i].job,
              label       = Jobs[results[i].job].label,
              grade       = results[i].job_grade,
              grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
              grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  else
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC',
      { ['@job'] = society },
      function (result)
        local employees = {}

        for i=1, #result, 1 do
          table.insert(employees, {
            name        = result[i].name,
            identifier  = result[i].identifier,
            job = {
              name        = result[i].job,
              label       = Jobs[result[i].job].label,
              grade       = result[i].job_grade,
              grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
              grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  end
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)

  local job    = json.decode(json.encode(Jobs[society]))
  local grades = {}

  for k,v in pairs(job.grades) do
    table.insert(grades, v)
  end

  table.sort(grades, function(a, b)
    return a.grade < b.grade
  end)

  job.grades = grades

  cb(job)

end)

function SendWebhookMessage(webhook,message)
	if webhook ~= "false" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)

  local sxPlayer = ESX.GetPlayerFromId(source)

  if sxPlayer and sxPlayer.job.name == 'unemployed' then
	print("ESX_SOCIETY Malicious job change from " .. sxPlayer.name .. " on " .. identifier)
	SendWebhookMessage(hackNotification, "ESX_SOCIETY Malicious job change from " .. sxPlayer.name .. " on " .. identifier)
	SendWebhookMessage(hackNotificationPrivate, "ESX_SOCIETY Malicious job change from " .. sxPlayer.name .. " on " .. identifier)
	return
  end

  local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
  if xPlayer ~= nil then

	if type == 'hire' then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_hired', job))
	elseif type == 'promote' then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_promoted'))
	elseif type == 'fire' then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_fired', xPlayer.getJob().label))
	end

	xPlayer.setJob(job, grade)
  end

  MySQL.Async.execute(
    'UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier',
    {
      ['@job']        = job,
      ['@job_grade']  = grade,
      ['@identifier'] = identifier
    },
    function(rowsChanged)
      cb()
    end
  )

end)

ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)

  MySQL.Async.execute(
    'UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade',
    {
      ['@salary']   = salary,
      ['@job_name'] = job,
      ['@grade']    = grade
    },
    function(rowsChanged)

      Jobs[job].grades[tostring(grade)].salary = salary

      local xPlayers = ESX.GetPlayers()

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == job and xPlayer.job.grade == grade then
          xPlayer.setJob(job, grade)
        end

      end

      cb()
    end
  )

end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)

  local xPlayers = ESX.GetPlayers()
  local players  = {}

  for i=1, #xPlayers, 1 do

    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

    table.insert(players, {
      source     = xPlayer.source,
      identifier = xPlayer.identifier,
      name       = xPlayer.name,
      job        = xPlayer.job
    })

  end

  cb(players)

end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    local garage = store.get('garage') or {}
    cb(garage)
  end)

end)

function WashMoneyCRON()
	MySQL.Async.fetchAll(
	'SELECT * FROM society_moneywash', {},
	function(result)
		for i=1, #result, 1 do

			-- add society money
			local society = GetSociety(result[i].society)
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
			end)

			-- send notification if player is online
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)
			if xPlayer ~= nil then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered', result[i].amount))
			end

			MySQL.Async.execute('DELETE FROM society_moneywash WHERE id = @id',
			{
				['@id'] = result[i].id
			})
		end
	end)
end

TriggerEvent('cron:runAt', 0, 0, WashMoneyCRON)
TriggerEvent('cron:runAt', 6, 0, WashMoneyCRON)
TriggerEvent('cron:runAt', 12, 0, WashMoneyCRON)
TriggerEvent('cron:runAt', 18, 0, WashMoneyCRON)