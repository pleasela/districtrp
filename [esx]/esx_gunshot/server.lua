ESX               = nil
local playersGunpowderStatuses = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_guntest:storePlayerGunpowderStatus')
AddEventHandler('esx_guntest:storePlayerGunpowderStatus', function()
	local _source = source
	-- spara source (serverId) i arrayen
	table.insert(playersGunpowderStatuses, _source)
end)

RegisterServerEvent('esx_guntest:removePlayerGunpowderStatus')
AddEventHandler('esx_guntest:removePlayerGunpowderStatus', function()
	-- tar bort spelaren från arrayen, reverse order for loop för att man inte ska ta bort ett element och sedan få nil
	for i=#playersGunpowderStatuses, 1, -1 do
		if playersGunpowderStatuses[i] == source then
			table.remove(playersGunpowderStatuses, i)
		end
	end
end)

ESX.RegisterServerCallback('esx_guntest:hasPlayerRecentlyFiredAGun', function(source, cb, target)
	local playerHasGunpowder = false

	-- loopa igenom alla spelare som har krutstänk på sig (behöver inte va reverse order)
	for i=#playersGunpowderStatuses, 1, -1 do
		if playersGunpowderStatuses[i] == target then
			playerHasGunpowder = true
		end
	end

	cb(playerHasGunpowder)
end)