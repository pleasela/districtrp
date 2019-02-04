function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end

RegisterNetEvent("rc:getClientIds")
AddEventHandler('rc:getClientIds', function()
	local ptable = GetPlayers()
	TriggerServerEvent("rc:putIds", ptable)
end)