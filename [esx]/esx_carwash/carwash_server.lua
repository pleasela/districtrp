--Settings--
ESX = nil

enableprice = true -- true = carwash is paid, false = carwash is free

price = 225 -- you may edit this to your liking. if "enableprice = false" ignore this one

--DO-NOT-EDIT-BELLOW-THIS-LINE--
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function()
	local mysource = source
	local xPlayer = ESX.GetPlayerFromId(source)		
		if(enableprice == true) then
			if(xPlayer.getMoney() >= price) then
				xPlayer.removeMoney((price))
				TriggerClientEvent('carwash:success', mysource, price)
				
			else
				moneyleft = price - xPlayer.getMoney()
				TriggerClientEvent('carwash:notenoughmoney', mysource, moneyleft)
			end
		else
			TriggerClientEvent('carwash:free', mysource)
		end
end)