local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX								= nil
local PlayerData				= {}
local GUI						= {}
GUI.Time						= 0

local ped = {}
local model			= 0
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.PlayerData
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('eden_animal:removePet')
AddEventHandler('eden_animal:removePet', function()
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local closest = GetClosestObjectOfType(coords.x,coords.y,coords.z,15.0,GetHashKey('a_c_retriever'),false,false,false)
	print("Found closest dog: " .. closest)
	if closest > 0 then
		DeletePed(closest)
		print("Attempted to delete something")
	end
end)

local ordre = false
local come = 0
local isAttached = false
local animation = {}

function OpenAnimal()

	local elements = {}

		if come == 1 then
			table.insert(elements, {label = ('Attach / detach the animal'), value = 'attached_animal'})
			
			if isInVehicle then
				table.insert(elements, {label = ('Get off the vehicle'), value = 'vehicles'})
			else
				table.insert(elements, {label = ('Getting in the vehicle'), value = 'vehicles'})
			end
			
			if ordre then
				table.insert(elements, {label = ('Give orders'), value = 'orders'})
			end

			table.insert(elements, {label = 'Dismiss', value = 'dismiss'})

		else
			table.insert(elements, {label = ('To bring the animal'), value = 'come_animal'})
		end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'eden_animal',
		{
			title	 = 'Manage animal',
			align	 = 'top-left',
			elements = elements,

		},

		function(data, menu)
			
			if data.current.value == 'dismiss' and come == 1 then
				come = 0
				DeletePed(ped)
				menu.close()
			end
			
			if data.current.value == 'come_animal' and come == 0 then

				ESX.TriggerServerCallback('eden_animal:animalname', function(data)
						print("You tried getting a " .. data)
					if (data == "dog") then
						model = GetHashKey('a_c_rottweiler')
						come = 1
						ordre = true
						openchien()
					elseif (data == "cat") then
						model = GetHashKey('a_c_cat_01')
						come = 1
						ordre = true
						openchien()
					elseif (data == "wolf") then
						model = GetHashKey('a_c_coyote')
						come = 1
						ordre = true
						openchien()
					elseif (data == "rabbit") then
						model = GetHashKey('a_c_rabbit_01')
						come = 1
						ordre = false
						openchien()
					elseif (data == "husky") then
						model = GetHashKey('a_c_husky')
						come = 1
						openchien()
					elseif (data == "pig") then
						model = GetHashKey('a_c_pig')
						come = 1
						ordre = false
						openchien()
					elseif (data == "poodle") then
						model = GetHashKey('a_c_poodle')
						come = 1
						ordre = false
						openchien()
					elseif (data == "pug") then
						model = 1832265812
						come = 1
						ordre = true
						openchien()
					elseif (data == "retriever") then
						model = GetHashKey('a_c_retriever')
						come = 1
						ordre = true
						openchien()
					elseif (data == "shepherd") then
						model = GetHashKey('a_c_shepherd')
						come = 1
						ordre = false
						openchien()
					elseif (data == "westie") then
						model = GetHashKey('a_c_westy')
						come = 1
						ordre = false
						openchien()
					end

				end)
				menu.close()
			end
			if data.current.value == 'attached_animal' then
				if not IsPedSittingInAnyVehicle(ped) then

					if isAttached == false then
						attached()
						isAttached = true
					else
						detached()
						isAttached = false
					end
				else
					TriggerEvent('esx:showNotification', 'We do not attach an animal in a vehicle !')
				end
			end
			if data.current.value == 'orders' then
				ordres()
				menu.close()
			end

			if data.current.value == 'vehicles' then
				local coords	= GetEntityCoords(GetPlayerPed(-1))
				local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
				local coords2 = GetEntityCoords(ped)
				local distance = GetDistanceBetweenCoords(coords.x,coords.y,coords.z,coords2.x,coords2.y,coords2.z,true)
				if not isInVehicle then
					if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						if distance < 8 then
							attached ()
							Wait(200)
							TaskWarpPedIntoVehicle(ped,	 vehicle,  -2)
							isInVehicle = true
							menu.close()
						else
							TriggerEvent('esx:showNotification', 'Your pet is too far from the vehicle.')
						end
					else
						TriggerEvent('esx:showNotification', 'You must be in a vehicle !')
					end
				else
					if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						SetEntityCoords(ped,coords.x, coords.y, coords.z - 1,1,0,0,1)
						Wait(100)
						detached()
						isInVehicle = false
						menu.close()
					else
						TriggerEvent('esx:showNotification', 'You are still in your vehicle !')
					end
				end

			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

local inanimation = false
function ordres()
 ESX.TriggerServerCallback('eden_animal:animalname', function(data)
	local elements = {}

	if not inanimation then
		if (data == "dog") then
			table.insert(elements, {label = ('Seated'), value = 'Seated'})
			table.insert(elements, {label = ('Sleep'), value = 'sleep'})
		end
		if (data == "cat") then
			table.insert(elements, {label = ('Sleep'), value = 'sleep2'})
		end
		if (data == "wolf") then
			table.insert(elements, {label = ('Sleep'), value = 'sleep3'})
		end
		if (data == "pug") then
			table.insert(elements, {label = ('Seated'), value = 'seated2'})
		end
		if (data == "retriever") then
			table.insert(elements, {label = ('Seated'), value = 'seated3'})
		end
	else
		table.insert(elements, {label = ('Standing'), value = 'standing'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'eden_animal',
		{
			title	 = 'Orders animals',
			align	 = 'top-left',
			elements = elements,
		},
		function(data, menu)

			if data.current.value == 'seated' then							-- [chien ]
				RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
				while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
					Wait(0)
				end
				TaskPlayAnim( ped, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base' ,8.0, -8, -1, 1, 0, false, false, false )
				inanimation = true
				menu.close()
			end
			if data.current.value == 'sleep' then						-- [chien ]
				RequestAnimDict('creatures@rottweiler@amb@sleep_in_kennel@')
				while not HasAnimDictLoaded('creatures@rottweiler@amb@sleep_in_kennel@') do
					Wait(0)
				end
				TaskPlayAnim( ped, 'creatures@rottweiler@amb@sleep_in_kennel@', 'sleep_in_kennel' ,8.0, -8, -1, 1, 0, false, false, false )
				inanimation = true
				menu.close()
			end
			if data.current.value == 'sleep2' then						-- [chat ]
				RequestAnimDict('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
				while not HasAnimDictLoaded('creatures@cat@amb@world_cat_sleeping_ground@idle_a') do
					Wait(0)
				end
				TaskPlayAnim( ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false )
				inanimation = true
				menu.close()
			end
			if data.current.value == 'sleep3' then						-- [loup ]
				RequestAnimDict('creatures@coyote@amb@world_coyote_rest@idle_a')
				while not HasAnimDictLoaded('creatures@coyote@amb@world_coyote_rest@idle_a') do
					Wait(0)
				end
				TaskPlayAnim( ped, 'creatures@coyote@amb@world_coyote_rest@idle_a', 'idle_a' ,8.0, -8, -1, 1, 0, false, false, false )
				inanimation = true
				menu.close()
			end
			if data.current.value == 'seated2' then						-- [carlin ]
				RequestAnimDict('creatures@carlin@amb@world_dog_sitting@idle_a')
				while not HasAnimDictLoaded('creatures@carlin@amb@world_dog_sitting@idle_a') do
					Wait(0)
				end
				TaskPlayAnim( ped, 'creatures@carlin@amb@world_dog_sitting@idle_a', 'idle_b' ,8.0, -8, -1, 1, 0, false, false, false )
				inanimation = true
				menu.close()
			end
			if data.current.value == 'seated3' then						-- [retriever ]
				RequestAnimDict('creatures@retriever@amb@world_dog_sitting@idle_a')
				while not HasAnimDictLoaded('creatures@retriever@amb@world_dog_sitting@idle_a') do
					Wait(0)
				end
				TaskPlayAnim( ped, 'creatures@retriever@amb@world_dog_sitting@idle_a', 'idle_c' ,8.0, -8, -1, 1, 0, false, false, false )
				inanimation = true
				menu.close()
			end

			if data.current.value == 'standing' then
				ClearPedTasks(ped)
				inanimation = false
				menu.close()
			end


		end,
		function(data, menu)
			menu.close()
		end
	)
	end)
end


function attached ()
	local playerPed = GetPlayerPed(-1)
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 10.0)
	SetPedNeverLeavesGroup(ped, false)
	SetEntityAsMissionEntity(ped, false,true)
	FreezeEntityPosition(ped, true)
end
function detached ()
	local playerPed = GetPlayerPed(-1)
	local GroupHandle = GetPlayerGroup(PlayerId())
	SetGroupSeparationRange(GroupHandle, 999999.9)
	SetPedNeverLeavesGroup(ped, true)
	SetEntityAsMissionEntity(ped, true,true)
	SetPedAsGroupMember(ped, GroupHandle)
	FreezeEntityPosition(ped, false)
end

function openchien ()
	local playerPed = GetPlayerPed(-1)
	local LastPosition = GetEntityCoords(GetPlayerPed(-1))
	local GroupHandle = GetPlayerGroup(PlayerId())
	RequestAnimDict('rcmnigel1c')
	while not HasAnimDictLoaded('rcmnigel1c') do
		Wait(0)
	end
	TaskPlayAnim( GetPlayerPed(-1), 'rcmnigel1c', 'hailing_whistle_waive_a' ,8.0, -8, -1, 120, 0, false, false, false )
	SetTimeout(1000, function() -- 5 secondes
		RequestModel( model )
		while ( not HasModelLoaded( model ) ) do
			Citizen.Wait( 1 )
		end
		ped = CreatePed(28, model, LastPosition.x, LastPosition.y, LastPosition.z - 1, 1.0, true)
		--print("Spawned ped# " .. ped .. " model# " .. model .. " " .. LastPosition.x .. " " .. LastPosition.y)
		if ped > 0 then
			SetPedAsGroupLeader(playerPed, GroupHandle)
			SetPedAsGroupMember(ped, GroupHandle)
			SetPedNeverLeavesGroup(ped, true)
			SetGroupFormationSpacing(GroupHandle,0.5,0.0,0.0)
			--SetEntityInvincible(ped, true)
			SetPedCanBeTargetted(ped, false)
			SetEntityAsMissionEntity(ped, true,true)
			SetPedFleeAttributes(ped,0,0)
		else
			come = 0
		end
	end)
end

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(0, Keys['F10']) and not IsControlPressed(0, 45) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'eden_animal') and (GetGameTimer() - GUI.Time) > 150 then
			OpenAnimal()
			GUI.Time = GetGameTimer()
		end
	end
end)

-- Animal Shop
local spawnpoint = {
{x = 562.19805908203,y = 2741.3090820313,z = 41.868915557861 },
}

--BLIP
Citizen.CreateThread(function()
	for i = 1 , #spawnpoint, 1 do
		local blip = AddBlipForCoord(spawnpoint[i].x,spawnpoint[i].y,spawnpoint[i].z)
		SetBlipSprite (blip, 463)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 63)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Pet Shop")
		EndTextCommandSetBlipName(blip)
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(0)
		for i = 1 , #spawnpoint ,1 do
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			if GetDistanceBetweenCoords(coord, spawnpoint[i].x,spawnpoint[i].y,spawnpoint[i].z, false) < 5 then
				DisplayHelpText("Press on ~INPUT_CONTEXT~ to access the pet shop.")
				if IsControlJustPressed(0, Keys['E'])  then
					buy_animal()
				end
			end
		end
	end
end)

--function
function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function buy_animal()
		local value = value
		local price = price
		local elements = {}

		table.insert(elements, {label = 'Dog - <span style="color:green;">$15000</span>',								value = "dog",	price = 15000})
		table.insert(elements, {label = 'Cat - <span style="color:green;">$15000</span>',								value = "cat", price = 15000})
		table.insert(elements, {label = 'Wolf - <span style="color:green;">$15000</span>',								value = "wolf", price = 15000})
		table.insert(elements, {label = 'Rabbit - <span style="color:green;">$15000</span>',								value = "rabbit",	price = 15000})
		table.insert(elements, {label = 'Husky - <span style="color:green;">$15000</span>',									value = "husky", price = 15000})
		table.insert(elements, {label = 'Pig - <span style="color:green;">$15000</span>',								value = "pig", price = 15000})
		table.insert(elements, {label = 'Poodle - <span style="color:green;">$15000</span>',								value = "poodle", price = 15000})
		table.insert(elements, {label = 'Pug - <span style="color:green;">$15000</span>',								value = "pug", price = 15000})
		table.insert(elements, {label = 'Retriever - <span style="color:green;">$15000</span>',									value = "retriever", price = 15000})
		table.insert(elements, {label = 'German shepherd - <span style="color:green;">$15000</span>',								value = "shepherd", price = 15000})
		table.insert(elements, {label = 'Westie - <span style="color:green;">$15000</span>',								value = "westie", price = 15000})

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'eden_animal',
		{
			title	 = 'Pet Shop',
			align	 = 'top-left',
			elements = elements
		},
		function(data, menu)
			TriggerServerEvent('eden_animal:takeanimal', data.current.value, data.current.price)

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end)
end


