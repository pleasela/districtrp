---------------------------------
-- Created SimpleRP & By Toni Morton      --
-- Please, Leave these credits --
---------------------------------


RegisterServerEvent("SyncTaxi")
AddEventHandler('SyncTaxi', function(inputText)
TriggerClientEvent('DisplayTaxi', -1, inputText)
end)


AddEventHandler('chatMessage', function(from, name, message)
	if message == "/taxi" then
		CancelEvent()
		TriggerClientEvent("Taxi", from)
	end
end)

---------------------------------
-- Created By SimpleRP & Toni Morton      --
-- Please, Leave these credits --
---------------------------------
