RegisterNetEvent("VLM:Title")
AddEventHandler("VLM:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("VLM:Option")
AddEventHandler("VLM:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("VLM:Int")
AddEventHandler("VLM:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("VLM:Update")
AddEventHandler("VLM:Update", function()
	Menu.updateSelection()
end)

local menu = false
local trailer = false

Citizen.CreateThread(function()
	local text
	local vehicle
	local index = -1
	local name
	while true do
	
		local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(playerVeh)
		index = GetVehicleLivery(vehicle)
		name = GetLabelText(GetLiveryName(vehicle, index))

		if IsControlJustPressed(1, 166) or IsDisabledControlJustPressed(1, 166) then
			if not menu then
				if IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
					menu = true
				else
					drawNotification("~r~You have to be the driver of a vehicle to use this Menu.")
				end
			elseif menu then
				menu = false
			end
		end
		
		if IsDisabledControlJustPressed(1, 177) then
			if menu then
				menu = false
			elseif trailer then
				trailer = false
				menu = true
			end
		elseif not (IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))) then
			menu = false
			trailer = false
		end

		if (menu) then
			TriggerEvent("VLM:Title", "~y~~bold~Vehicle Liverys Menu")
			
			if (GotTrailer) then
				if GetVehicleLiveryCount(TrailerHandle) > 0 then
					TriggerEvent("VLM:Option", "~y~>> ~s~Trailer Liverys", function(cb)
						if(cb) then
							menu = false
							trailer = true
						end
					end)
				end
			end
		elseif trailer then
			TriggerEvent("VLM:Title", "~y~~bold~Trailer Liverys Menu")
		end
		
		if menu or trailer then
			if menu then
				vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				text = "Vehicle"
			elseif trailer then
				_, vehicle = GetVehicleTrailerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
				text = "Trailer"
			end
			
			if GetVehicleLiveryCount(vehicle) > 0 then
				TriggerEvent("VLM:Option", "Your " .. text .. " has ~y~" .. GetVehicleLiveryCount(vehicle) .. " ~s~Liverys", function(cb)
					if(cb) then
						drawNotification("Your " .. text .. " has ~y~" .. GetVehicleLiveryCount(vehicle) .. " ~s~Liverys!")
					end
				end)
			else
				TriggerEvent("VLM:Option", "Your " .. text .. " has no Liverys", function(cb)
					if(cb) then
						drawNotification("Your " .. text .. " has no Liverys!")
					end
				end)
			end
			
			TriggerEvent("VLM:Int", "Livery", index, 0, (GetVehicleLiveryCount(vehicle) - 1), function(cb)
				index = cb
				SetVehicleLivery(vehicle, index)
				name = GetLabelText(GetLiveryName(vehicle, index))
			end)

			if GetVehicleClass(vehicle) ~= 18 then
				if (index == -1) then
					TriggerEvent("VLM:Option", "~r~No Livery", function(cb)
						if (cb) then
							drawNotification("~r~No Livery")
						end
					end)
				else
					name = GetLabelText(GetLiveryName(vehicle, index))
					TriggerEvent("VLM:Option", "~g~" .. name, function(cb)
						if (cb) then
							drawNotification("~g~" .. name)
						end
					end)
				end
			end
			
			TriggerEvent("VLM:Update")
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function() --Disables Controls Used In The Menu, When Menu Is Active
	while true do
		Citizen.Wait(1)
		if menu then
			DisableControlAction(1, 20, true)
			DisableControlAction(1, 21, true)
			DisableControlAction(1, 45, true)
			DisableControlAction(1, 73, true)
			DisableControlAction(1, 74, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 80, true)
			DisableControlAction(1, 85, true)
			DisableControlAction(1, 99, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 172, true)
			DisableControlAction(1, 173, true)
			DisableControlAction(1, 174, true)
			DisableControlAction(1, 175, true)
			DisableControlAction(1, 176, true)
			DisableControlAction(1, 177, true)
			DisableControlAction(1, 178, true)
			DisableControlAction(1, 179, true)
		end
	end
end)

Citizen.CreateThread(function() --Disables Menu When In Pausemenu
	while true do
		Citizen.Wait(0)
		local CF = Citizen.InvokeNative(0x2309595AD6145265)
		if (CF == -1171018317) then
			menu = false
			trailer = false
		end
	end
end)

function drawNotification(text) --Just Don't Edit!
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

