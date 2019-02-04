ESX = nil
local uninterestedPeds = {}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function table.removeKey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(120000)
		uninterestedPeds = {}
	end
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local selling = false
	local success = false
	local copscalled = false
	local notintrested = false
	local amountSelling = 0
  
RegisterNetEvent('drugs:trigger')
AddEventHandler('drugs:trigger', function()
	selling = true
	    if selling == true then
			TriggerEvent('pass_or_fail')
  			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
  			TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Trying to convince person to buy the product",
            type = "error",
            queue = "lmao",
            timeout = 2500,
            layout = "Centerleft"
        	})
 	end
end)

RegisterServerEvent('fetchjob')
AddEventHandler('fetchjob', function()
    local xPlayer  = ESX.GetPlayerFromId(source)
    TriggerClientEvent('getjob', source, xPlayer.job.name)
end)


RegisterNetEvent('drugs:sell')
AddEventHandler('drugs:sell', function(pedId)
  	local xPlayer = ESX.GetPlayerFromId(source)
	local meth = xPlayer.getInventoryItem('meth_pooch').count
	local coke 	  = xPlayer.getInventoryItem('coke_pooch').count
	local weed = xPlayer.getInventoryItem('weed_pooch').count
	local opium = xPlayer.getInventoryItem('opium_pooch').count

	if (coke < amountSelling) and (coke >= 1) then
		amountSelling = amountSelling - 1
	end
	if (weed < amountSelling) and (weed >= 1) then
		amountSelling = amountSelling - 1
	end
	if (meth < amountSelling) and (meth >= 1) then
		amountSelling = amountSelling - 1
	end
	if (opium < amountSelling) and (opium >= 1) then
		amountSelling = amountSelling - 1
	end

	local paymentc = math.random (475,800) * amountSelling
	local paymentw = math.random (800,1000) * amountSelling
	local paymentm = math.random (975,1100) * amountSelling
	local paymento = math.random (1200,1300) * amountSelling

	if not has_value(uninterestedPeds, pedId) then
		if coke >= amountSelling and success == true then
		 	TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "You have sold " .. amountSelling .. " bag(s) of cocaine for $" .. paymentc,
				type = "success",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			TriggerClientEvent("animation", source)
			xPlayer.removeInventoryItem('coke_pooch', amountSelling)
			xPlayer.addAccountMoney('black_money', paymentc)
			selling = false
		elseif weed >= amountSelling and success == true then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "You have sold " .. amountSelling .. " bag(s) of joints for $" .. paymentw ,
				type = "success",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			TriggerClientEvent("animation", source)
			TriggerClientEvent("test", source)
			xPlayer.removeInventoryItem('weed_pooch', amountSelling)
			xPlayer.addAccountMoney('black_money', paymentw)
			selling = false
		elseif meth >= amountSelling and success == true then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "You have sold " .. amountSelling .. " methbag(s) for $" .. paymentm ,
				type = "success",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			TriggerClientEvent("animation", source)
				xPlayer.removeInventoryItem('meth_pooch', amountSelling)
				xPlayer.addAccountMoney('black_money', paymentm)
				selling = false
		elseif opium >= amountSelling and success == true then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "You have sold " .. amountSelling .. " bag(s) of heroin for $" .. paymento ,
				type = "success",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			TriggerClientEvent("animation", source)
			xPlayer.removeInventoryItem('opium_pooch', amountSelling)
			xPlayer.addAccountMoney('black_money', paymento)
			selling = false
		elseif selling == true and success == false and notintrested == true then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "They are not interested",
				type = "error",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			selling = false
		elseif meth < 1 and coke < 1 and weed < 1 and opium < 1 then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "You dont have any drugs",
				type = "error",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
		elseif copscalled == true and success == false then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "They are calling the cops",
				type = "error",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			TriggerClientEvent("notifyc", source)
			selling = false
		end
		if copscalled == true and success == true then
			TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
			TriggerClientEvent("pNotify:SendNotification", source, {
				text = "Someone snitched on you to the cops",
				type = "error",
				progressBar = false,
				queue = "lmao",
				timeout = 2000,
				layout = "CenterLeft"
			})
			TriggerClientEvent("notifyc", source)
			selling = false
		end
		setSold(pedId)
	else
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = "This person doesn't want any more drugs",
			type = "error",
			progressBar = false,
			queue = "lmao",
			timeout = 1200,
			layout = "CenterLeft"
		})
		selling = false
	end

	
end)

function setSold(pedId)
	table.insert(uninterestedPeds, pedId)
end

RegisterNetEvent('pass_or_fail')
AddEventHandler('pass_or_fail', function()
  		
  		local percent = math.random(1, 11)
  		local multiplePercent = math.random(1, 11)

  		if percent == 10 or percent == 9 then
  			success = false
  			notintrested = true
  			copscalled = false
  		elseif percent == 8 or percent == 7 or percent == 6 or percent == 5 then
  			success = true
  			notintrested = false
  			copscalled = false
		elseif percent == 4 or percent == 3 then
  			success = true
  			notintrested = false
  			copscalled = true
  		else
  			notintrested = false
  			success = false
  			copscalled = true
  		end

  		if multiplePercent == 10 or multiplePercent == 9 then
  			amountSelling = 2
  		elseif  multiplePercent == 8 then
  			amountSelling = 3
  		else
  			amountSelling = 1
  		end
end)

RegisterNetEvent('sell_dis')
AddEventHandler('sell_dis', function()
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
		text = "You moved too far away",
		type = "error",
		progressBar = false,
		queue = "lmao",
		timeout = 2000,
		layout = "CenterLeft"
	})
end)

RegisterNetEvent('checkD')
AddEventHandler('checkD', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then 
	local meth = xPlayer.getInventoryItem('meth_pooch').count
	local coke = xPlayer.getInventoryItem('coke_pooch').count
	local weed = xPlayer.getInventoryItem('weed_pooch').count
	local opium = xPlayer.getInventoryItem('opium_pooch').count

	if meth >= 1 or coke >= 1 or weed >= 1 or opium >= 1 then
		TriggerClientEvent("checkR", source, true)
	else
		TriggerClientEvent("checkR", source, false)
	end
	end

end)


-- OL
RegisterServerEvent('sellDrugsInProgress')
AddEventHandler('sellDrugsInProgress', function(street1, street2, sex)
	-- local xPlayers = ESX.GetPlayers()
	-- for i=1, #xPlayers, 1 do
	-- 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

	-- 	if xPlayer.job.name == 'police' then
	-- 		TriggerClientEvent("pNotify:SetQueueMax", -1, "drugsnotify", 10)
	-- 	    TriggerClientEvent("pNotify:SendNotification", -1, {
	-- 	          text = "Illegal drug activity has been reported. Suspect is a "..sex.." at "..street1.." and "..street2,
	-- 	          type = "error",
	-- 	          queue = "drugsnotify",
	-- 	          timeout = 3500,
	-- 	          layout = "centerRight"
	-- 	        })
	-- 	end	
	-- end
	local alert = "Illegal drug activity has been reported. Suspect is a "..sex.." at "..street1.." and "..street2
	TriggerClientEvent("drugs:notify", -1, alert)
end)

RegisterServerEvent('sellDrugsInProgressS1')
AddEventHandler('sellDrugsInProgressS1', function(street1, sex)
	-- local xPlayers = ESX.GetPlayers()
	-- for i=1, #xPlayers, 1 do
	-- 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

	-- 	if xPlayer.job.name == 'police' then
	-- 		TriggerClientEvent("pNotify:SetQueueMax", -1, "drugsnotify", 10)
	-- 	    TriggerClientEvent("pNotify:SendNotification", -1, {
	-- 	          text = "Illegal drug activity has been reported. Suspect is a "..sex.." at "..street1,
	-- 	          type = "error",
	-- 	          queue = "drugsnotify",
	-- 	          timeout = 3500,
	-- 	          layout = "centerRight"
	-- 	        })
	-- 	end	
	-- end
	local alert = "Illegal drug activity has been reported. Suspect is a "..sex.." at "..street1
	TriggerClientEvent("drugs:notifyS1", -1, alert)
end)

RegisterServerEvent('sellDrugsInProgressPos')
AddEventHandler('sellDrugsInProgressPos', function(tx, ty, tz)
	TriggerClientEvent('sellDrugsPlace', -1, tx, ty, tz)
end)