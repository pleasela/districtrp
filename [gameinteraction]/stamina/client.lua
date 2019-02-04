Citizen.CreateThread( function()
 while true do
    Citizen.Wait(0)
    RestorePlayerStamina(GetPlayerPed(-1), 1.0)
	-- it's that simple
	end
end)