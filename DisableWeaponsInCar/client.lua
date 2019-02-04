local CivCar = nil
local CivCarSeat = nil
local checkDriver = GetPlayerPed(-1)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		--If player is in any vehicle, set those veriables.----
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			CivCar = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			CivCarSeat = GetPedInVehicleSeat(CivCar, -1)
		end
		
		--If player is in any vehicle and in the driver seat prevent player from using any weapon. and for player to have fists only.----
		if IsPedInAnyVehicle(GetPlayerPed(-1)) and CivCar ~= nil and CivCarSeat == checkDriver then
			SetPedCanSwitchWeapon(GetPlayerPed(-1), false)
			SetCurrentPedWeapon(GetPlayerPed(-1), 2725352035, true)
		else
			SetPedCanSwitchWeapon(GetPlayerPed(-1), true)
		end
	end
end)