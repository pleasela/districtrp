---------------------------------
-- Created By Toni Morton      --
-- Please, Leave these credits --
---------------------------------


RegisterServerEvent("SyncTrafficAlert")
AddEventHandler('SyncTrafficAlert', function(inputText)
TriggerClientEvent('DisplayTrafficAlert', -1, inputText)
end)


AddEventHandler('chatMessage', function(from, name, message)
	if message == "/trafficalert" then
		CancelEvent()
		TriggerClientEvent("TrafficAlert", from)
	end
end)

---------------------------------
-- Created By Toni Morton      --
-- Please, Leave these credits --
---------------------------------
