local serverIdentifiers = {}
local identifierToSearch = nil
local serverIdFound = nil

RegisterServerEvent("rc:putIds")
AddEventHandler('rc:putIds', function(ptable)
	for _, i in ipairs(ptable) do
        local identifier = GetPlayerIdentifiers(i)[1]
        if identifierToSearch == identifier then
        	serverIdFound = i
        end
    end
end)

RegisterCommand('rgetserverid', function(source, args)
    if source == 0 then
    	identifierToSearch = args[1]
        TriggerClientEvent('rc:getClientIds', -1)
        print(serverIdFound)
	    serverIdentifiers = {}
	    serverIdFound = nil
    else
    	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You cannot use this command!")
    end
end, false)