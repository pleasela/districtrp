ESX = nil
RallyTimes = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function()
	MySQL.Async.fetchAll(	
	'SELECT * FROM rally_times WHERE 1',
    {},
    function (result)								
      for i = 1, #result, 1 do
        table.insert(RallyTimes, result[i])
      end
    end)
end)


ESX.RegisterServerCallback('esx_rallyjob:getTimes', function(source, cb)
	cb(RallyTimes)
end)

RegisterServerEvent('esx_rallyjob:onRecord')
AddEventHandler('esx_rallyjob:onRecord', function(track, laptime)						
	
	local _track = track --Such use, much efficient.
	local _laptime = laptime
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _driver = GetPlayerName(_source)
	
	Citizen.Trace("Track record on track " .. _track .. ", name :" .. GetPlayerName(source) .. " laptime: " .. _laptime .. "\n")
	
	local found = false
	local record = false
	
	for i = 1, #RallyTimes, 1 do
		if RallyTimes[i].track == _track then
			found = true
			if RallyTimes[i].laptime > _laptime then
				record = true
				RallyTimes[i].laptime = _laptime
				RallyTimes[i].driver = _driver
			end
			break
		end
	end
	
	if not found then
		table.insert(RallyTimes, {id = -1, track = _track, driver = _driver, laptime = _laptime})
		xPlayer.addMoney(5000)
		TriggerClientEvent('esx:showNotification', _source, '~g~Uusi ~w~rataennätys!~g~+~w~5000~g~€ ~w~bonus!')
		Citizen.Trace("Lap record inserted!\n")
		MySQL.Async.execute(
		'INSERT INTO `rally_times` (`track`, `driver`, `laptime`) VALUES (@track, @driver, @laptime)',
		{
			['@track']   = _track,
			['@driver'] = _driver,
			['@laptime'] = _laptime
		})	
	elseif found and record then
		table.insert(RallyTimes, {id = -1 , track = _track, driver = _driver, laptime = _laptime})
		xPlayer.addMoney(5000)
		TriggerClientEvent('esx:showNotification', _source, '~g~Rikoit~w~ rataennätyksen! ~g~+~w~5000~g~€ ~w~bonus!')
		Citizen.Trace("Lap record updated!\n")
		MySQL.Async.execute(
		'UPDATE `rally_times` SET laptime = @laptime, driver = @driver WHERE track = @track',
		{
			['@laptime']   = _laptime,
			['@driver'] = _driver,
			['@track'] = _track
		})
	else
		TriggerClientEvent('esx:showNotification', _source, '~w~Valitettavasti ratennätyksesi ~r~rikottiin ~w~kotimatkallasi!')
	end
end)

RegisterServerEvent('esx_rallyjob:getPaid')
AddEventHandler('esx_rallyjob:getPaid', function(amount)						
	local xPlayer = ESX.GetPlayerFromId(source)					
	xPlayer.addMoney(math.floor(amount))
end)

RegisterServerEvent('esx_rallyjob:getPunished')
AddEventHandler('esx_rallyjob:getPunished', function(amount)					
	local xPlayer = ESX.GetPlayerFromId(source)		
	xPlayer.removeMoney(math.floor(amount)) 
end)

RegisterServerEvent('esx_rallyjob:giveAward')
AddEventHandler('esx_rallyjob:giveAward', function(award)					
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(award, 1)
end)


