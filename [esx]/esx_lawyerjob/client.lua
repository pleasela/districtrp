local takeJob = {x=-406.355,y=1086.247,z=327.705}
local bossUI = {x=-422.862,y=1073.85,z=327.692}

ESX                             = nil
local PlayerData 				= nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Lawyer',
		number     = 'laywerjob',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAA3QAAAN0BcFOiBwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAARoSURBVFiF7Zd/aFVlGMc/z3vPvfvldNPmnEbUyoUUQUVumJqDCaXYsrnb8ge2Zvnjj/4JzJxwJxJaUUQgDpoRFCZHmjpDxGg0HFjSHzENHa7wV/4cabft3uu955y3P+7uZXc7pzsHsX964IX3vO/zfL/f53nP+573iNaaiTQ1oeyAMe7INinFporTD1aSZ+/jw0tnxgMzvgq0yuvY/A4c4uL0dzlfeppND38+HigZ/Q6I4sKigGdE149zicU6AR8A385NIcEjtzbyxINfeMZeXBQnFHKGD42qwMm24G6tB6Lg0UoKu9Lkw00LJAr2YEnUremERPf3/7R7ZFiGgAPBoO/a5aL6qxeLrwC9ri1yd8Azw6hYXnG9t/xX+vr99cFgMEN8xkuoKqYucRymnfy+vH3FjtY6V5Jj8h7CVtc5iZ1iXeezblP7g7XfAC/PkfgS4Eiac7iTFr1uqLvs6+Y3Sl1JcviEnBxn9LgFUyJNbiHNK2tLBZYBiE5zZApob15fBrJ06NHvF2Otq4BVq0p44XlF2QxQCpSGskF4KwFbHp/tFhJIsFaDH0BgaXNdXdkoAY7QCPgQDgKI0q7ZYMtiJhfC4hpY2QAfObA1Dx7IgYTV6BaihaYh8oMafAEjkfZLChARkCYA7fNtBrq1pqJ924aFo+GkJt1VCgwZxmTNG+m9/ZXahUAF0A1sBtBamkRE0gIObNtQjVAO0lUf2t2nRfYmlWeuF1QboJ9zrQyAFZvOhercEemvS2av94bMw30CXUB5S/2y6rQAIUkkotsA8nyOCYQ1suLQ9saiNFh0ViVQ6CnAcYR8/2vp7JcvLwK9AggTwyRJ1pYhbMerL71dMm3SLjSJG/0D72jtJACmFResDPiNBdFofH9/ONqywzzcS2xNCE1LBumNc5kicgt/YEZnde38Zx69Lz+vJd8faEjY1ombA+F9AKKUf2bhlPcB//WBv7cYtq13XrsRNkieCZ+mcPr/HEx1GwzkCNCLpoZsZsWfAjBEP307Mthwm0GABSALALSj+eOvO0PFYKdC656soMrqgeAkoGoMAiYzWFOqHcmKq6FHgXRk8ev71ck/SySwiDF9vjUMssmY9dBZgb5/95UOBYFdgJdaS9CNpmnaiGQvfzrKftE0TVuLNAKWh1ePcSe2S4VMMx69y3w0rUAEQECDPiVKV4bMju6kWD12AXZ8DkD7iZ+7RUklok8Bqe9+BKTVJm++eeZMPOM+EAwGfY85sdnkWldDXx0Npycia8oQrrqSjdwFKSsofpKS47+kHpdUVU3OV9ZMdX/5edM07dS4y4XExWKrV6Ply3sSkFvUyozvNmaDHtuVzLmH9U+ZnVg8FjfPChz9+M0K29JTAebVxTuUosTN7+a5yx7IyunuLF4PYPi4tHbngeNubp7bStt8ICK1ACfbczwzOPub32tKQfgzgPzcnOtAmYfTxNr/AiZcgPfZ7rAH4Vg2gKJJBS63pkzzKZ/nb9vYDqL/0CZ8Cf4BrBmoU1KcpzcAAAAASUVORK5CYII='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer

  
  Citizen.CreateThread(function()
  	while true do
  		Citizen.Wait(0)

  		if(PlayerData.job ~= nil and PlayerData.job.name == "avocat") then
  			DrawMarker(1,takeJob.x,takeJob.y,takeJob.z-1,0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)

  			if(GetDistanceBetweenCoords(takeJob.x,takeJob.y,takeJob.z,  GetEntityCoords(GetPlayerPed(-1)), true) < 3) then 
  				Info("Press ~g~E~w~ to open your locker.")
  				if(IsControlJustPressed(1, 38)) then
  					openTakeService()
  				end
  			end
  		end
  	end
  end)

  if(PlayerData.job.grade_name == "boss" and PlayerData.job.name == "avocat") then
  	createSocietyMenu(bossUI.x,bossUI.y,bossUI.z,"avocat", "Advokat")
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)




function Info(text, loop)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end






function createSocietyMenu(x,y,z,name, menuName)
Citizen.CreateThread(function()
	local menuShowed = false
	while true do
		Citizen.Wait(10)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
		DrawMarker(1,x,y,z-1,0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
		if(distance > 3 and menuShowed) then
			ESX.UI.Menu.CloseAll()
		end

		if(distance<3) then
			if(menuShowed) then
				Info("Press ~g~E~w~ to ~r~to close~w~.")
			else
				Info("Press ~g~E~w~ to ~g~to access~w~ the funds of the company.")
			end

			if(IsControlJustPressed(1, 38)) then
				menuShowed = not menuShowed

				if(menuShowed) then
					--print(name)
					renderMenu(name, menuName)
				else
					ESX.UI.Menu.CloseAll()
				end
			end
		end
	end
end)
end


function renderMenu(name, menuName)
	local _name = name
	local elements = {}
	

  	table.insert(elements, {label = 'withdraw society company', value = 'withdraw_society_money'})
  	table.insert(elements, {label = 'deposit money',        value = 'deposit_money'})
  	table.insert(elements, {label = 'wash money',        value = 'wash_money'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'realestateagent',
		{
			title    = menuName,
			align    = 'bottom-right',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'withdraw_society_money' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'withdraw_society_money_amount',
					{
						title = 'amount of withdrawal',
						align = 'bottom-right'
					},
					function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil or amount < 0 then
							ESX.ShowNotification('invalid amount')
						else
							menu.close()
							--print(_name)
							TriggerServerEvent('esx_society:withdrawMoney', _name, amount)
						end

					end,
					function(data, menu)
						menu.close()
					end
				)

			end

			if data.current.value == 'deposit_money' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'deposit_money_amount',
					{
						title = 'deposit amount',
						align = 'bottom-right'
					},
					function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil or amount < 0 then
							ESX.ShowNotification('invalid amount')
						else
							menu.close()
							TriggerServerEvent('esx_society:depositMoney', _name, amount)
						end

					end,
					function(data, menu)
						menu.close()
					end
				)

			end

			if data.current.value == 'wash_money' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'wash_money_amount',
					{
						title = 'Wash money',
						align = 'bottom-right'
					},
					function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil or amount < 0 then
							ESX.ShowNotification('invalid amount')
						else
							menu.close()
							TriggerServerEvent('esx_society:washMoney', _name, amount)
						end

					end,
					function(data, menu)
						menu.close()
					end
				)

			end

		end,
		function(data, menu)

			menu.close()
		end
	)
end





function openTakeService()

  local elements = {
    {label = "citizen wear", value = 'citizen_wear'},
    {label = "lawyer wear", value = 'avocat_wear'}
  }

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = 'Service plug',
        align    = 'bottom-right',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      --Taken from SuperCoolNinja
      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end)
      end

      if data.current.value == 'avocat_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

          
          if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
          else
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
          end
           setComponentByGrade(skin.sex)
        end)

      end


    end,
    function(data, menu)

      menu.close()

    end
  )

end