RegisterNetEvent("VEM:Title")
AddEventHandler("VEM:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("VEM:Option")
AddEventHandler("VEM:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("VEM:Bool")
AddEventHandler("VEM:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("VEM:Update")
AddEventHandler("VEM:Update", function()
	Menu.updateSelection()
end)

local ExtraCount = 0
local extra = {}
local menu = false
local trailer = false
local bool = true

Citizen.CreateThread(function()
	
	while true do
	
		local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(playerVeh)
		local text
		local vehicle

		if IsControlJustPressed(0, 11) or IsDisabledControlJustPressed(0, 11) then
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
				bool = true
				ExtraCount = 0
			elseif trailer then
				trailer = false
				bool = true
				ExtraCount = 0
				menu = true
			end
		elseif not (IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))) then
			menu = false
			trailer = false
			bool = true
			ExtraCount = 0
		end

		if (menu) then
			TriggerEvent("VEM:Title", "~y~~bold~Vehicle Extra Menu")
			
			if (GotTrailer) then
				TriggerEvent("VEM:Option", "~y~>> ~s~Trailer Extras", function(cb)
					if(cb) then
						menu = false
						trailer = true
						bool = true
						ExtraCount = 0
					end
				end)
			end
		elseif trailer then
			TriggerEvent("VEM:Title", "~y~~bold~Trailer Extra Menu")
		end
		
		if menu or trailer then
			if menu then
				vehicle = playerVeh
				text = "Vehicle"
			elseif trailer then
				vehicle = TrailerHandle
				text = "Trailer"
			end
			
			if ExtraCount == 0 then
				TriggerEvent("VEM:Option", "Your " .. text .. " has no Extras", function(cb)
					if(cb) then
						drawNotification("Your " .. text .. " has no Extras!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "Your " .. text .. " has ~y~" .. ExtraCount .. " ~s~Extras", function(cb)
					if(cb) then
						drawNotification("Your " .. text .. " has ~y~" .. ExtraCount .. " ~s~Extras!")
					end
				end)
			end
			
			if (DoesExtraExist(vehicle, 1) == 1) then
				TriggerEvent("VEM:Bool", "Extra 1", extra[1], function(cb)
					extra[1] = cb
					if extra[1] then
						SetVehicleExtra(vehicle, 1, false)
						drawNotification("~g~Extra 1 Enabled!")
					else
						SetVehicleExtra(vehicle, 1, true)
						drawNotification("~r~Extra 1 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 1 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 1 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 2) == 1) then
				TriggerEvent("VEM:Bool", "Extra 2", extra[2], function(cb)
					extra[2] = cb
					if extra[2] then
						SetVehicleExtra(vehicle, 2, false)
						drawNotification("~g~Extra 2 Enabled!")
					else
						SetVehicleExtra(vehicle, 2, true)
						drawNotification("~r~Extra 2 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 2 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 2 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 3) == 1) then
				TriggerEvent("VEM:Bool", "Extra 3", extra[3], function(cb)
					extra[3] = cb
					if extra[3] then
						SetVehicleExtra(vehicle, 3, false)
						drawNotification("~g~Extra 3 Enabled!")
					else
						SetVehicleExtra(vehicle, 3, true)
						drawNotification("~r~Extra 3 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 3 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 3 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 4) == 1) then
				TriggerEvent("VEM:Bool", "Extra 4", extra[4], function(cb)
					extra[4] = cb
					if extra[4] then
						SetVehicleExtra(vehicle, 4, false)
						drawNotification("~g~Extra 4 Enabled!")
					else
						SetVehicleExtra(vehicle, 4, true)
						drawNotification("~r~Extra 4 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 4 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 4 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 5) == 1) then
				TriggerEvent("VEM:Bool", "Extra 5", extra[5], function(cb)
					extra[5] = cb
					if extra[5] then
						SetVehicleExtra(vehicle, 5, false)
						drawNotification("~g~Extra 5 Enabled!")
					else
						SetVehicleExtra(vehicle, 5, true)
						drawNotification("~r~Extra 5 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 5 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 5 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 6) == 1) then
				TriggerEvent("VEM:Bool", "Extra 6", extra[6], function(cb)
					extra[6] = cb
					if extra[6] then
						SetVehicleExtra(vehicle, 6, false)
						drawNotification("~g~Extra 6 Enabled!")
					else
						SetVehicleExtra(vehicle, 6, true)
						drawNotification("~r~Extra 6 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 6 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 6 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 7) == 1) then
				TriggerEvent("VEM:Bool", "Extra 7", extra[7], function(cb)
					extra[7] = cb
					if extra[7] then
						SetVehicleExtra(vehicle, 7, false)
						drawNotification("~g~Extra 7 Enabled!")
					else
						SetVehicleExtra(vehicle, 7, true)
						drawNotification("~r~Extra 7 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 7 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 7 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 8) == 1) then
				TriggerEvent("VEM:Bool", "Extra 8", extra[8], function(cb)
					extra[8] = cb
					if extra[8] then
						SetVehicleExtra(vehicle, 8, false)
						drawNotification("~g~Extra 8 Enabled!")
					else
						SetVehicleExtra(vehicle, 8, true)
						drawNotification("~r~Extra 8 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 8 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 8 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 9) == 1) then
				TriggerEvent("VEM:Bool", "Extra 9", extra[9], function(cb)
					extra[9] = cb
					if extra[9] then
						SetVehicleExtra(vehicle, 9, false)
						drawNotification("~g~Extra 9 Enabled!")
					else
						SetVehicleExtra(vehicle, 9, true)
						drawNotification("~r~Extra 9 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 9 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 9 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 10) == 1) then
				TriggerEvent("VEM:Bool", "Extra 10", extra[10], function(cb)
					extra[10] = cb
					if extra[10] then
						SetVehicleExtra(vehicle, 10, false)
						drawNotification("~g~Extra 10 Enabled!")
					else
						SetVehicleExtra(vehicle, 10, true)
						drawNotification("~r~Extra 10 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 10 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 10 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 11) == 1) then
				TriggerEvent("VEM:Bool", "Extra 11", extra[11], function(cb)
					extra[11] = cb
					if extra[11] then
						SetVehicleExtra(vehicle, 11, false)
						drawNotification("~g~Extra 11 Enabled!")
					else
						SetVehicleExtra(vehicle, 11, true)
						drawNotification("~r~Extra 11 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 11 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 11 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 12) == 1) then
				TriggerEvent("VEM:Bool", "Extra 12", extra[12], function(cb)
					extra[12] = cb
					if extra[12] then
						SetVehicleExtra(vehicle, 12, false)
						drawNotification("~g~Extra 12 Enabled!")
					else
						SetVehicleExtra(vehicle, 12, true)
						drawNotification("~r~Extra 12 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 12 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 12 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 13) == 1) then
				TriggerEvent("VEM:Bool", "Extra 13", extra[13], function(cb)
					extra[13] = cb
					if extra[13] then
						SetVehicleExtra(vehicle, 13, false)
						drawNotification("~g~Extra 13 Enabled!")
					else
						SetVehicleExtra(vehicle, 13, true)
						drawNotification("~r~Extra 13 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 13 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 13 Not Existing!")
					end
				end)
			end

			if (DoesExtraExist(vehicle, 14) == 1) then
				TriggerEvent("VEM:Bool", "Extra 14", extra[14], function(cb)
					extra[14] = cb
					if extra[14] then
						SetVehicleExtra(vehicle, 14, false)
						drawNotification("~g~Extra 14 Enabled!")
					else
						SetVehicleExtra(vehicle, 14, true)
						drawNotification("~r~Extra 14 Disabled!")
					end
				end)
			else
				TriggerEvent("VEM:Option", "~r~Extra 14 Not Existing!", function(cb)
					if (cb) then
						drawNotification("~r~Extra 14 Not Existing!")
					end
				end)
			end

			TriggerEvent("VEM:Update")
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

Citizen.CreateThread(function() --Gets Extra States
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			if bool then
				for i = 1, 14 do
					if trailer then
						if DoesExtraExist(TrailerHandle, i) == 1 then
							ExtraCount = ExtraCount + 1
							if (IsVehicleExtraTurnedOn(TrailerHandle, i) == 1) then
								extra[i] = true
							else
								extra[i] = false
							end
						end
					else
						if DoesExtraExist(GetVehiclePedIsIn(GetPlayerPed(-1), false), i) == 1 then
							ExtraCount = ExtraCount + 1
							if (IsVehicleExtraTurnedOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), i) == 1) then
								extra[i] = true
							else
								extra[i] = false
							end
						end
					end
				end
				bool = false
			end
		else
			bool = true
			ExtraCount = 0
		end
	end
end)

function drawNotification(text) --Just Don't Edit!
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

