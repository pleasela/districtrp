--DO-NOT-EDIT-BELLOW-THIS-LINE--

Key = 201 -- ENTER

vehicleWashStation = {
	{26.5906,  -1392.0261,  27.3634},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139},
	{1362.25,  3591.86,  34.0}
}


Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipAsShortRange(stationBlip, true)
	end
    return
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
				DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 5 then
					DrawSpecialText("Tryk enter for at vaske bilen") -- danish
					DrawSpecialText("Press enter to wash the car")
					if(IsControlJustPressed(1, Key)) then
						TriggerServerEvent('carwash:checkmoney')
					end
				end
			end
		end
	end
end)

RegisterNetEvent('carwash:success')
AddEventHandler('carwash:success', function(price)
	SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),  false),  0.0000000001)
	SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
	TriggerEvent('chatMessage', 'carwash', {255, 0, 0}, "Your car has been washed for " .. price .. "$")
	--TriggerEvent('chatMessage', 'Bilvasken', {255, 0, 0}, "Din bil er blevet vasket for " .. price .. "kr") -- danish
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

RegisterNetEvent('carwash:notenoughmoney')
AddEventHandler('carwash:notenoughmoney', function(moneyleft)
--	TriggerEvent('chatMessage', 'Bilvasken', {255, 0, 0}, "Du har ikke penge nok, du mangler " .. moneyleft .. "kr") -- danish
	TriggerEvent('chatMessage', 'carwash', {255, 0, 0}, "You do not have enough money you're missing " .. moneyleft .. "$") 
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

RegisterNetEvent('carwash:free')
AddEventHandler('carwash:free', function()
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
	-- TriggerEvent('chatMessage', 'carwash', {255, 0, 0}, "bilvasken er gratis" .. price .. "kr")  -- danish
	TriggerEvent('chatMessage', 'carwash', {255, 0, 0}, "carwash its free" .. price .. "$") 
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)