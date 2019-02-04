local ignorePlayerNameDistance = false
local playerNamesDist = 15

Citizen.CreateThread(function()
	while true do
		for id = 0, 31 do
			local pedID = GetPlayerPed(id)
			local myPed = GetPlayerPed(-1)
			if  NetworkIsPlayerActive(id) and pedID ~= myPed then
				local x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed(-1), true))
				local x2, y2, z2 = table.unpack( GetEntityCoords( pedID, true))
				distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))

				if ((distance < playerNamesDist)) then
					if not (ignorePlayerNameDistance) then
						if NetworkIsPlayerTalking(id) then
							DrawMarker(25,x2,y2,z2 - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 150, 50, 230, 85, 0, 0, 2, 0, 0, 0, 0)
						else
							DrawMarker(25, x2,y2,z2 - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 150, 150, 235, 85, 0, 0, 2, 0, 0, 0, 0)
						end
					end
				end
			end
		end
		Citizen.Wait(0)
	end
end)