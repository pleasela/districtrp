
local text1 = "The server will automatically restart in 15 minutes! At 10h00 / 22h00"
local text2 = "The server will automatically restart in 10 minutes! At 10h00 / 22h00"
local text3 = "The server will automatically restart in 5 minutes! At 10h00 / 22h00 \n Please log out now to avoid the loss of any items!"

RegisterServerEvent("restart:checkreboot")

AddEventHandler('restart:checkreboot', function()
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	if date_local == '09:45:00' then
		TriggerClientEvent('chatMessage', -1, "SERVER", {0, 0, 0}, text1)
	elseif date_local == '09:50:00' then
		TriggerClientEvent('chatMessage', -1, "SERVER", {0, 0, 0}, text2)
	elseif date_local == '09:55:00' then
		TriggerClientEvent('chatMessage', -1, "SERVER", {0, 0, 0}, test3)
	elseif date_local == '21:45:00' then 
		TriggerClientEvent('chatMessage', -1, "SERVER", {0, 0, 0}, text1)
	elseif date_local == '21:50:00' then
		TriggerClientEvent('chatMessage', -1, "SERVER", {0, 0, 0}, text2)
	elseif date_local == '21:55:00' then
		TriggerClientEvent('chatMessage', -1, "SERVER", {0, 0, 0}, text3)
	end
end)

function restart_server()
	SetTimeout(1000, function()
		TriggerEvent('restart:checkreboot')
		restart_server()
	end)
end
restart_server()
