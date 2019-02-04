RegisterNetEvent("SendCoords")
AddEventHandler("SendCoords", function()
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, 0.0)
	local plyHeading = GetEntityHeading(GetPlayerPed(PlayerId()))
	TriggerEvent('chatMessage', "Your current coordinates are: " .. plyCoords ..  " and your current heading is:" .. plyHeading .. "")

end)