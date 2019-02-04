Citizen.CreateThread(function()
	local lastVeh
	local lastAngle = 0.0
	local tempAngle = 0.0
	local tempTime = 0
    while true do
        Citizen.Wait(50)
        if IsPedInAnyVehicle(PlayerPedId(), true) then
			
			--Get the current angle of the wheels
            lastVeh = GetVehiclePedIsUsing(PlayerPedId())
            local newAngle = GetVehicleSteeringAngle(lastVeh)
			
			--Near 0 gets a little weird, sanitize some values
			if math.abs(newAngle) < 0.05 then newAngle = 0.0 else newAngle = math.floor(newAngle) end
			
            if tempAngle ~= newAngle then
				--This is a different angle, reset timer
				tempTime = GetGameTimer()
				tempAngle = newAngle
			elseif lastAngle ~= tempAngle and (GetGameTimer() - tempTime > (tempAngle ~= 0.0 and 300 or 800))  then
				--If we held the same angle for this long, confirm it (0 angle requires longer time)
				lastAngle = tempAngle
				tempTime = GetGameTimer()
				--print("Set wheel angle " .. lastAngle)
			end
			
        elseif lastVeh then
			if GetEntitySpeed(lastVeh) < 10 then
                SetVehicleSteeringAngle(lastVeh, lastAngle + 0.0)
				--print("Left vehicle at angle " .. lastAngle)
            end
			
			lastVeh = nil
		end
    end
end)