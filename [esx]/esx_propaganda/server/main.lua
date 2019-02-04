ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'reporter', "~b~News ~w~", true, true)
TriggerEvent('esx_society:registerSociety', 'reporter', 'Reporter', 'society_reporter', 'society_reporter', 'society_reporter', {type = 'private'})

RegisterServerEvent('esx_propaganda:success')
AddEventHandler('esx_propaganda:success', function(_source, total)

	math.randomseed(os.time())

	local xPlayer = ESX.GetPlayerFromId(_source)
  	local societyAccount = nil

  	if xPlayer.job.grade >= 3 then
  		total = total * 1.5
  	end

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_reporter', function(account)
  	societyAccount = account
  end)

  if societyAccount ~= nil then
	  local playerMoney  = math.floor(total / 100 * 70)
	  local societyMoney = math.floor(total / 100 * 30)

	  xPlayer.addMoney(playerMoney)
	  societyAccount.addMoney(societyMoney)

	  TriggerClientEvent('esx:showNotification', xPlayer.source, "You got paid ~g~$" .. playerMoney)
	  TriggerClientEvent('esx:showNotification', xPlayer.source, "Your company earned ~g~$" .. societyMoney)
	else
		xPlayer.addMoney(total)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "You got paid ~b~$" .. total)
	end

end)

RegisterServerEvent('esx_propaganda:getPaid')
AddEventHandler('esx_propaganda:getPaid', function(data)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.fetchAll(
	'SELECT * FROM paychecks WHERE receiver = @identifier', 
	{
      ['@identifier'] = xPlayer.identifier
    }, 
	function(rows)
	
		local topay = rows
		if #topay > 0 then 
			
			MySQL.Async.execute(
			'DELETE FROM paychecks WHERE receiver = @identifier', 
			{
			  ['@identifier'] = xPlayer.identifier
			}, function(rowschanged)
				
				local amount = 0
				
				for i=1, #topay, 1 do
					amount = amount + rows[i].amount
				end
				TriggerEvent('esx_propaganda:success', _source, amount)
			end
			)
			
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~No one liked your articles :(")
		end
	end
	)

end)

RegisterServerEvent('esx_propaganda:postArticle')
AddEventHandler('esx_propaganda:postArticle', function(dataTemp)
	
	local data = dataTemp
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.fetchAll(
	'SELECT * FROM users WHERE identifier = @identifier', 
	{
      ['@identifier'] = xPlayer.identifier
    }, 
	function(rows)
		
		local _name = "Top News" -- value here doesn't matter
		
		for i = 1, #rows, 1 do
			_name = rows[i].firstname .. ' ' .. rows[i].lastname
		end
		
		MySQL.Async.fetchAll(
		'INSERT INTO news_main (title, bait_title, content, author_name, author_id, news_type, imgurl) VALUES (@title, @bait, @content, @author_name, @uid, @type, @url); SELECT LAST_INSERT_ID();',
		{ 
		  ['@title'] = data.title,
		  ['@bait'] = data.bait_title,
		  ['@content'] = data.content,
		  ['@author_name'] = _name,
		  ['@uid'] = xPlayer.identifier,
		  ['@type'] = data.type,
		  ['@url'] = data.imgurl,
		},
		function (id)
		--[[
		 local n = 0
		 for k,v in pairs(id[1]) do
		    n=n+1
		    Citizen.Trace('key: ' .. k .. "\n")
		    Citizen.Trace('value: ' .. id[1][k] .. "\n")
		  end 
		  Citizen.Trace(id[1]["LAST_INSERT_ID()"]) ]]--
		  TriggerEvent('esx_news:articlePosted', data, id[1]["LAST_INSERT_ID()"], _name, xPlayer.identifier)
		  TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Article added!")
		  TriggerClientEvent('chatMessage', -1, "[WEAZEL NEWS]", {166,253,255}, "A new article has been posted!")
		end
		)
	end
	)
	
	MySQL.Async.execute(
	'DELETE FROM news_main WHERE id NOT IN (SELECT id FROM (SELECT id FROM news_main ORDER BY id DESC LIMIT 19 ) foo)', 
	{},
	function(rows2)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~w~Old articles ~r~removed~w~!")
	end
	)
	
	-- Uncomment if you want old likes to be removed
	MySQL.Async.execute(
	'DELETE FROM news_likes WHERE news_id NOT IN (SELECT id FROM (SELECT id FROM news_main ORDER BY id DESC LIMIT 20 ) foo)',
	{},
	function(rows3)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Old articles data removed!")
	end
	)
	--
end)


