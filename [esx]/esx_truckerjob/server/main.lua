ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local hackNotification = GetConvar("hackNotification", "https://discordapp.com/api/webhooks/495398672134307851/U42Y5mJPFpELKi_18rnNGogdIUxlsk7iww7lvpcQ00OOIHKG13RtmUdpZPna0uSXYydD")
local hackNotificationPrivate = GetConvar("hackNotificationPrivate", "https://discordapp.com/api/webhooks/495397052277063711/q-U1xIvCtZxDKGwl0dqhxjhFtro8Fpu8tajkf2njvpRCMobgpHrSOoSDnZptdRp4EqOP")

function SendWebhookMessage(webhook,message)
	if webhook ~= "false" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (xPlayer.job.name and xPlayer.job.name ~= 'trucker') or amount > 2000000 then
		SendWebhookMessage(hackNotification, "ESX_TRUCKER Malicious money amount from " .. xPlayer.name .. " $" .. (amount or '??'))
		SendWebhookMessage(hackNotificationPrivate, "ESX_TRUCKER Malicious money amount from " .. xPlayer.name .. " $" .. (amount or '??'))
		return
	end
	if amount and amount < 40000 then
		xPlayer.addAccountMoney('bank', tonumber(amount))
	end
end)
