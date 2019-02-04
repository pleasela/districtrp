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

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0

local trafficOverride = true
local trafficLevel = 0.3

local activeCops = {}
local activeBlips = {}

ESX                             = nil
GUI.Time                        = 0

local EMS_POL = {police=true,ambulance=true}
local EMS_POL_AIR = {police=true,ambulance=true,airlines=true}
local restrictedCarList = {
  --Vehicles Restricted to Ambulance and Police
  UNMARKEDTAHOE=EMS_POL, SFUM1=EMS_POL, SFUM2=EMS_POL, SFBC1=EMS_POL, SFBC2=EMS_POL, SFBC3=EMS_POL, SFBC4=EMS_POL, STATEP=EMS_POL, STATEP2=EMS_POL, statep4=EMS_POL,
  FBI=EMS_POL, FBI2=EMS_POL, POLICE=EMS_POL, POLICE2=EMS_POL, POLICE5=EMS_POL, POLICE6=EMS_POL, POLICE4=EMS_POL, POLICE3=EMS_POL, POLICE7=EMS_POL, POLICEB=EMS_POL, P1200RT=EMS_POL, POLICET=EMS_POL, POLMAV=EMS_POL, RIOT=EMS_POL, RIOT2=EMS_POL, FIRETRUK=EMS_POL, AMBULAN=EMS_POL,
  RHINO=EMS_POL, INSURGENT=EMS_POL, APC=EMS_POL, so1=EMS_POL, so2=EMS_POL, so3=EMS_POL, so4=EMS_POL, so5=EMS_POL, so6=EMS_POL, SHERIFF=EMS_POL, SHERIFF2=EMS_POL, SHERIFF3=EMS_POL,
  LADDERTRUK=EMS_POL, RESCUE=EMS_POL, ENGINE=EMS_POL,
  --Vehicles Restricted to Airlines + Ambulance + Police
  CARGOBOB=EMS_POL_AIR, HYDRA=EMS_POL_AIR, LAZER=EMS_POL_AIR, BUZZARD=EMS_POL_AIR, SAVAGE=EMS_POL_AIR, BLIMP=EMS_POL_AIR, BESRA=EMS_POL_AIR, MAVERICK=EMS_POL_AIR, ANNIHL=EMS_POL_AIR, AKULA=EMS_POL_AIR,
  DODO=EMS_POL_AIR, FROGGER=EMS_POL_AIR, TITAN=EMS_POL_AIR, CARGOPL=EMS_POL_AIR, CUBAN=EMS_POL_AIR, SHAMAL=EMS_POL_AIR, SKYLIFT=EMS_POL_AIR, JET=EMS_POL_AIR, VOLATUS=EMS_POL_AIR, HUNTER=EMS_POL_AIR,
  MILJET=EMS_POL_AIR, SWIFT=EMS_POL_AIR, SWIFT2=EMS_POL_AIR, SVOLITO=EMS_POL_AIR, SVOLITO2=EMS_POL_AIR, LUXOR=EMS_POL_AIR, DUSTER=EMS_POL_AIR, NIMBUS=EMS_POL_AIR, VELUM=EMS_POL_AIR, MAMMATUS=EMS_POL_AIR, MH60T=EMS_POL_AIR, VALKYRIE=EMS_POL_AIR,
}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  PlayerData = ESX.PlayerData
  ESX.TriggerServerCallback('esx_policejob:refreshJob', function(job)
  PlayerData.job = job
  end)

  ESX.TriggerServerCallback('esx_policejob:getTraffic', function(tOver, tLevel)
  trafficOverride = tOver
  trafficLevel = tLevel
  end)

end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2.0,
    modBrakes       = 4.0,
    modTransmission = 3.0,
    modSuspension   = 4.0,
    modTurbo        = true,
    modArmor        = 5.0,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenCloakroomMenu()

  local elements = {
    --{ label = _U('citizen_wear'), value = 'citizen_wear' }
  }


--SWAT
 if PlayerData.job.extra == 'police' then
  table.insert(elements, {label = "Go On Duty", value = 'go_on_duty'})
 else
  table.insert(elements, { label = _U('citizen_wear'), value = 'citizen_wear' })
  -- table.insert(elements, {label = "Choose Attire", value = 'choose_attire'})
 end

 if PlayerData.job.grade_name == 'SWAT' then
  table.insert(elements, {label = 'Police Outfit', value = 'police_wear'})
  -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
  table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
  --   table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
  end


if PlayerData.job.grade_name == 'SWAT Captain' then
  table.insert(elements, {label = 'Police Outfit', value = 'police_wear'})
  -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
  --   table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
  --   table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
  --   table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  end

 if PlayerData.job.grade_name == 'Lead Detective' then
 	-- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    table.insert(elements, {label = _U('sergeant_wear'), value = 'sergeant_wear'})
    -- table.insert(elements, {label = _U('detective_uniform'), value = 'detective_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  end

  if PlayerData.job.grade_name == 'Detective III' then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('detective_uniform'), value = 'detective_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  end

  if PlayerData.job.grade_name == 'Detective II' then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('detective_uniform'), value = 'detective_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  end
  if PlayerData.job.grade_name == 'Detective I' then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('detective_uniform'), value = 'detective_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  end
  


--STATE POLICE ----------------------------------------------------------------------------------------


if PlayerData.job.grade_name =="Cadet" then
   table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
   -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
  end
  if PlayerData.job.grade_name =="State Transport" then
   table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
   -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
  end
if PlayerData.job.grade_name == "Trooper I" then
 table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
 -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
 -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
  end
if PlayerData.job.grade_name ==  "Trooper II" then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
  end

  if PlayerData.job.grade_name ==  "Trooper III" then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
    -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
  end

  if PlayerData.job.grade_name == 'Air Chief' then
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
    table.insert(elements, {label = _U('sergeant_wear'), value = 'sergeant_wear'})
    table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
    -- table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
    -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
    -- table.insert(elements, {label = _U('pilot_uniform'), value = 'pilot_uniform'})
  end

  if PlayerData.job.grade_name == 'Air Trooper' then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
    -- table.insert(elements, {label = _U('pilot_uniform'), value = 'pilot_uniform'})
  end

if PlayerData.job.grade_name == "State Sergeant" then
    table.insert(elements, {label = _U('police_wear'), value = 'sergeant_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
    table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
    -- table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
    -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
    -- table.insert(elements, {label = _U('pilot_uniform'), value = 'pilot_uniform'})
  end
if PlayerData.job.grade_name == "State Lieutenant" then
  -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
  -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
  -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  table.insert(elements, {label = _U('lieutenant_wear'), value = 'lieutenant_wear'})
  table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
  -- table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
  -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
  -- table.insert(elements, {label = _U('pilot_uniform'), value = 'pilot_uniform'})
  end
if PlayerData.job.grade_name == "State Captain" then
  -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
  -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
  -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  table.insert(elements, {label = _U('sergeant_wear'), value = 'sergeant_wear'})
  table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
  -- table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
  -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
  -- table.insert(elements, {label = _U('pilot_uniform'), value = 'pilot_uniform'})
end

if PlayerData.job.grade_name == "Deputy" then
    table.insert(elements, {label = _U('sergeant_wear'), value = 'sergeant_wear'})
    -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
  end

if PlayerData.job.grade_name == 'Sheriff' then
    -- table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
    -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
  end

 if PlayerData.job.grade_name == 'Major' then
    table.insert(elements, {label = _U('police_wear'), value = 'commandant_wear'})
    -- table.insert(elements, {label = _U('police_uniform'), value = 'police_uniform'})
    -- table.insert(elements, {label = _U('windbreaker_uniform'), value = 'windbreaker_uniform'})
    -- table.insert(elements, {label = _U('motorcycle_uniform'), value = 'motorcycle_uniform'})
    -- table.insert(elements, {label = _U('k9_uniform'), value = 'k9_uniform'})
    table.insert(elements, {label = _U('swat_wear'), value = 'commandant_wear_freemode'})
    -- table.insert(elements, {label = _U('swat_uniform'), value = 'swat_uniform'})
    -- table.insert(elements, {label = _U('pilot_uniform'), value = 'pilot_uniform'})
  end


  if Config.EnableNonFreemodePeds then
    table.insert(elements, {label = _U('sheriff_wear'), value = 'sheriff_wear_freemode'})
    table.insert(elements, {label = _U('lieutenant_wear'), value = 'lieutenant_wear_freemode'})
    table.insert(elements, {label = _U('commandant_wear'), value = 'commandant_wear_freemode'})
  end

  if PlayerData.job.extra ~= 'police' then
    table.insert(elements, {label = _U('veste_wear'), value = 'veste_wear'})
    table.insert(elements, {label = _U('regular_wear'), value = 'regular_vest'})
    -- table.insert(elements, {label = 'Police Formal Hat', value = 'formal_hat'})
    table.insert(elements, {label = _U('gilet_wear'), value = 'gilet_wear'})
  end


  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
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
      TriggerServerEvent("esx_policejob:goOffDuty")
        end)
      end

    if data.current.value == 'go_on_duty' then
      TriggerServerEvent("esx_policejob:goOnDuty")
    end

      if data.current.value == 'cadet_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          if skin.sex == 0 then
      SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)--Gants
      --SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 2, 0)--Gants
      SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 2)  --Bag
      SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--Chaussure
      SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque
      SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 0, 0)--Grade
      SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 0)--Veste
            SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)           --Oreillete
            SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)           --Montre

        --    ClearPedProp(GetPlayerPed(-1),  0)  -- Helmet
          else
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
          end
        end)
      end

      if data.current.value == 'police_wear' then
        setUniform('police_wear', playerPed)
      end

      if data.current.value == 'police_uniform' then
        setOutfit(Config.Outfits['LSPD Uniform (Short Sleeve)'], playerPed)
      end

      if data.current.value == 'detective_uniform' then
        setOutfit(Config.Outfits['LSPD Detective (Vest)'], playerPed)
      end

      if data.current.value == 'windbreaker_uniform' then
        setOutfit(Config.Outfits['LSPD Windbreaker'], playerPed)
      end

      if data.current.value == 'motorcycle_uniform' then
        setOutfit(Config.Outfits['LSPD Motorcycle Uniform'], playerPed)
      end

      if data.current.value == 'k9_uniform' then
        setOutfit(Config.Outfits['LSPD K-9 Uniform'], playerPed)
      end

      if data.current.value == 'pilot_uniform' then
        setOutfit(Config.Outfits['LSPD Pilot Uniform'], playerPed)
      end

      if data.current.value == 'swat_uniform' then
        setOutfit(Config.Outfits['LSPD SWAT Uniform'], playerPed)
      end

      if data.current.value == 'sergeant_wear' then --Ajout de tenue par grades
        setUniform('sergeant_wear', playerPed)
      end

      if data.current.value == 'lieutenant_wear' then --Ajout de tenue par grades
        setUniform('lieutenant_wear', playerPed)
      end

      if data.current.value == 'commandant_wear' then
        setUniform('commandant_wear', playerPed)
      end

-----------------------------------------------------------Need swat gear to work-------------------------------------
      if data.current.value == 'swat_wear' then
         if skin.sex == 0 then
          local model = GetHashKey("s_m_y_swat_01")


          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_m_y_swat_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          setUniform('swat_wear_freemode', playerPed)
          end
      end

      if data.current.value == 'choose_attire' then
        OpenChooseUniformsMenu()
      end


      if data.current.value == 'veste_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
          SetPedComponentVariation(GetPlayerPed(-1), 9, 10, 1, 2)--Gilet
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'regular_vest' then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 100)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
          end)
      end

      if data.current.value == 'formal_hat' then
          setUniform('formal_hat', playerPed)
      end

      if data.current.value == 'gilet_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
          SetPedComponentVariation(GetPlayerPed(-1), 9, 14, 1, 2)--Sans Gilet
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'sheriff_wear_freemode' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then

          local model = GetHashKey("she6")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("she6")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'commandant_wear_freemode' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("s_m_y_swat_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          setUniform('swat_wear_freemode', playerPed)
      else
          local model = GetHashKey("s_m_y_swat_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          setUniform('swat_wear_freemode', playerPed)
          end

        end)
      end


      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(station)
    local elements = {
      {label = 'Armory', value = 'get_weapon'},
      {label = 'Pull Items',  value = 'get_stock'},
      {label = 'Store Items',  value = 'put_stock'},
      {label = 'Pull Confiscated Items', value = 'get_confiscated'},
      {label = 'Store Confiscated Items', value = 'put_confiscated'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)

    if data.current.value == 'get_weapon' then
      local elements = {}
      for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
        local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
        table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
      end

      ESX.UI.Menu.CloseAll()

      ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}

      end)
    end

        if data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
          OpenGetStocksMenu()
        end

        if data.current.value == 'put_confiscated' then
          OpenPutConfiscatedItemsMenu()
        end

        if data.current.value == 'get_confiscated' then
          OpenGetConfiscatedItemsMenu()
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )

end

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job == 'bullet_wear' then
        SetPedArmour(playerPed, 100)
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job == 'bullet_wear' then
        SetPedArmour(playerPed, 100)
      end
    end

  end)
end

function setOutfit(outfit, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    local ped = PlayerPedId()

    if skin.sex == 0 then
      RequestModel(outfit.male.ped)

      while not HasModelLoaded(outfit.male.ped) do
          Wait(0)
      end

      if GetEntityModel(ped) ~= GetHashKey(outfit.male.ped) then
          SetPlayerModel(PlayerId(), outfit.male.ped)
      end

      ped = PlayerPedId()

      for _, comp in ipairs(outfit.male.components) do
         SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
      end

      for _, comp in ipairs(outfit.male.props) do
          if comp[2] == 0 then
              ClearPedProp(ped, comp[1])
          else
              SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
          end
      end
    else
      RequestModel(outfit.female.ped)

      while not HasModelLoaded(outfit.female.ped) do
          Wait(0)
      end

      if GetEntityModel(ped) ~= GetHashKey(outfit.female.ped) then
          SetPlayerModel(PlayerId(), outfit.female.ped)
      end

      ped = PlayerPedId()

      for _, comp in ipairs(outfit.female.components) do
         SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
      end

      for _, comp in ipairs(outfit.female.props) do
          if comp[2] == 0 then
              ClearPedProp(ped, comp[1])
          else
              SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
          end
      end
    end

  end)
end

function cleanPlayer(playerPed)
  SetPedArmour(playerPed, 0)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function OpenChooseUniformsMenu()

  local elements = {}

  table.insert(elements, {label = 'Police Outfit', value = 'police_wear'})
  table.insert(elements, {label = 'Cadet Outfit', value = 'cadet_wear'})
  table.insert(elements, {label = 'Sergeant Outfit', value = 'sergeant_wear'})
  table.insert(elements, {label = 'Commandant Outfit', value = 'commandant_wear'})
  table.insert(elements, {label = 'Lieutenant Outfit', value = 'lieutenant_wear'})
  table.insert(elements, {label = 'SWAT Outfit', value = 'swat_wear_freemode'})
  table.insert(elements, {label = 'State Trooper Outfit', value = 'statetrooper_wear_freemode'})
  table.insert(elements, {label = 'Sheriff Outfit', value = 'sheriff_wear_freemode'})
  -- table.insert(elements, {label = 'Bullet Wear', value = 'bullet_wear'}) -- Bulletproof vest
  table.insert(elements, {label = 'Shiny Reflective Vest', value = 'gilet_wear'})
  table.insert(elements, {label = 'Police Formal Hat', value = 'formal_hat'})

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'choose_uniform',
    {
      title    = _U('choose_uniform_menu'),
      align    = 'bottom-right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      local playerPed = GetPlayerPed(-1)

      cleanPlayer(playerPed)

      if
        data.current.value == 'cadet_wear' or
        data.current.value == 'police_wear' or
        data.current.value == 'sergeant_wear' or
        data.current.value == 'lieutenant_wear' or
        data.current.value == 'commandant_wear' or
        data.current.value == 'bullet_wear' or
        data.current.value == 'gilet_wear' or
        data.current.value == 'formal_hat'
      then
        setUniform(data.current.value, playerPed)
      end

      if data.current.value == 'sheriff_wear_freemode' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then

          local model = GetHashKey("s_m_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_f_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end


      if data.current.value == 'statetrooper_wear_freemode' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("s_m_y_hwaycop_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
        else
          local model = GetHashKey("s_m_y_hwaycop_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'swat_wear_freemode' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("s_m_y_swat_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          setUniform('swat_wear_freemode', playerPed)
        else
          local model = GetHashKey("s_m_y_swat_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          setUniform('swat_wear_freemode', playerPed)
          end

        end)
      end

    end,
    function(data, menu)
      menu.close()
    end
    )
end

-- Car listings

-- This table has the display names for vehicles
local vehicle_labels = {
  police4 = 'Marked Taurus',
  police6 = 'K9 Tahoe',
  police5 = 'Marked Explorer',
  police2 = 'Marked Charger',
  police = 'Marked Impala',
  police3 = 'Marked Explorer Older',
  police7 = 'Marked Crown Vic',
  riot = 'Riot',
  riot2 = 'Riot 2',
  fbi = 'Unmarked Charger',
  fbi2 = 'Unmarked Tahoe',
  unmarkedtahoe = 'Unmarked Tahoe 2',
  XLS2 = 'XLS',
  predator = 'Police Boat',
  schafter5 = 'Schafter',
  lguard = 'Life Guard SUV',
  seashark2 = 'Police Jet Ski',
   polmav = 'Police Maverick',
   policeb = 'Police Motorcycle',
   p1200rt = 'Police Bike',
}

-- This table has the actual models a job grade can spawn
local job_vehicles = {

  ['SWAT'] = {
    'police7', 'police4',  'police2', 'police5', 'riot', 'predator', 'policeb', 'p1200rt',
  },

  ['SWAT Captain'] = {
    'schafter5', 'XLS2', 'police5', 'riot', 'police7', 'police2', 'fbi2', 'police4', 'fbi', 'seashark2', 'lguard', 'predator', 'policeb', 'p1200rt',
  },

  ['Lead Detective'] = {
    'police2',  'police5', 'police7', 'fbi', 'fbi2', 'unmarkedtahoe', 'riot', 'Predator', 'p1200rt',
  },

  ['Detective III'] = {
    'police2',  'police5', 'police7', 'fbi', 'fbi2', 'unmarkedtahoe', 'riot', 'Predator', 'p1200rt',
  },

  ['Detective II'] = {
    'police2', 'police5', 'police7', 'fbi', 'fbi2','unmarkedtahoe', 'riot', 'Predator', 'p1200rt',
  },

  ['Detective I'] = {
    'police2', 'police5', 'police7', 'fbi', 'fbi2', 'unmarkedtahoe', 'riot', 'Predator', 'p1200rt',
  },

  ['Cadet'] = {
     'police', 'police7',
  },

  ['Trooper I'] = {
    'police','police2', 'police5', 'police7', 'p1200rt',
  },

  ['Trooper II'] = {
    'police','police2', 'police4', 'police5', 'police7', 'p1200rt',
  },

  ['Trooper III'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7', 'predator', 'policeb', 'p1200rt',
  },

  ['State Sergeant'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7', 'polmav', 'police7', 'fbi', 'riot', 'predator', 'policeb', 'p1200rt',
  },

  ['State Lieutenant'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7', 'polmav', 'fbi', 'fbi2', 'unmarkedtahoe', 'riot', 'riot2', 'predator', 'policeb', 'p1200rt',
  },

  ['State Captain'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7', 'fbi',  'polmav', 'fbi2', 'unmarkedtahoe', 'riot', 'riot2', 'predator', 'policeb', 'p1200rt',
  },

  ['Air Chief'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7', 'polmav', 'policeb', 'p1200rt', 'fbi', 'unmarkedtahoe',
  },

  ['Air Trooper'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7', 'polmav', 'policeb', 'p1200rt',
  },



['Sheriff'] = {
    'police2', 'police5', 'police6', 'polmav', 'police7', 'fbi', 'riot', 'predator', 'policeb',
  },

['Deputy'] = {
    'police2', 'police5', 'police6', 'polmav', 'police7', 'fbi', 'riot', 'predator', 'policeb',
  },

  ['Major'] = {
    'police','police2', 'police4', 'police5', 'police6', 'police7',  'polmav', 'fbi', 'fbi2', 'unmarkedtahoe', 'riot', 'riot2', 'predator', 'policeb', 'p1200rt',
  },
}

function OpenVehicleSpawnerMenu(station, partNum, veh)

  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'bottom-right',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
            local playerPed = GetPlayerPed(-1)
            TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'police')

  else
  --Regular vehicle spawns
  local elements = {}

  for k,v in ipairs(job_vehicles[PlayerData.job.grade_name] or {}) do
    table.insert(elements, { label = (vehicle_labels[v] or v), value = v})
  end

  if veh then
    elements = {{label = "Delete Vehicle",  value = 'delete_vehicle'}}
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

    if model == 'delete_vehicle' then
      ESX.Game.DeleteVehicle(veh)
      return
    end

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle2)
              SetVehicleMaxMods(vehicle2)
              SetVehicleNumberPlateText(vehicle2, 'LSPDX' .. ESX.GetRandomString(3))
              TaskWarpPedIntoVehicle(playerPed,  vehicle2,  -1)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle2)
                  SetVehicleMaxMods(vehicle2)
                  SetVehicleNumberPlateText(vehicle2, 'LSPDX' .. ESX.GetRandomString(3))
                  TaskWarpPedIntoVehicle(playerPed,  vehicle2,  -1)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'police')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum, vehicle = veh}

      end
    )

  end

end

function OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'police_actions',
    {
      title    = 'Police',
      align    = 'bottom-right',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
        {label = _U('object_spawner'),      value = 'object_spawner'},
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'bottom-right',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              {label = 'GSR Test', value = 'gsr'}, 
              {label = _U('handcuff'),    value = 'handcuff'},
              {label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
              {label = 'Check Fines', value = 'check_fines'},
              {label = 'Jail', value = 'send_to_jail'},
              {label = _U('fine'),            value = 'fine'},
              {label = '>>!!Timeout!!<<', value = 'send_to_timeout'},
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'gsr' then
                if (PlayerData.job.grade >= 30 and PlayerData.job.grade < 40) or (PlayerData.job.grade >= 5 and PlayerData.job.grade <= 20) or (PlayerData.job.grade == 3) then
                  TriggerEvent('esx_guntest:checkGun', player)
                else
                  ESX.ShowNotification('Only detectives can do this')
                end
                 -- TriggerEvent('esx_guntest:checkGun', player)
                 -- OpenBodySearchMenu(player)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'check_fines' then
                OpenCheckFinesMenu(player)
              end

      if data2.current.value == 'send_to_jail' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing',
        {
          title = 'Duration in minutes'
        },
        function(data, menu)

          local amount = tonumber(data.value)

          if amount == nil or amount < 1 then
            ESX.ShowNotification('Invalid amount')
          else
            menu.close()

            --set reason to announce
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_reason',
            {
              title = 'Jail Reason'
            },
            function(data2, menu2)

              local jailReason = data2.value

              if jailReason == nil then
                ESX.ShowNotification('Set a jail reason')
              else
                menu2.close()
                --Force uncuff the player
                TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player), true, false)
                TriggerServerEvent('Jailer:jail', GetPlayerServerId(player), amount, jailReason)
              end
            end,
            function(data, menu)
              menu.close()
            end)

          end
        end,
        function(data, menu)
          menu.close()
        end)
      end

      if data2.current.value == 'send_to_timeout' then
        OpenTimeoutMenu(player)
      end

              if data2.current.value == 'fine' then
                OpenFineMenu(player)
              end

            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'bottom-right',
            elements = {
              {label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

                    end)

                  end

                end

              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('traffic_interaction'),
            align    = 'bottom-right',
            elements = {
              {label = _U('cone'),     value = 'prop_roadcone02a'},
              {label = _U('barrier'), value = 'prop_barrier_work06a'},
              {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
              {label = _U('box'),   value = 'prop_boxpile_07d'},
              {label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            },
             function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenTimeoutMenu(player)
  local elements = {
      {label = 'Confirm Timeout', value = 'confirm_timeout'},
      {label = 'Cancel', value = 'cancel_timeout'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_timeout',
    {
      title = 'Timeout Confirmation',
      align    = 'bottom-right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      if data.current.value == 'confirm_timeout' then
        TriggerServerEvent('esx_policejob:Timeout', GetPlayerServerId(player))
      end

      if data.current.value == 'cancel_timeout' then
        menu.close()
      end

    end,
    function(data, menu)
      menu.close()
    end)
end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Male'
        else
          sex = 'Female'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end

      if data.dob ~= nil then
        dobLabel = 'DOB : ' .. data.dob
      else
        dobLabel = 'DOB : Unknown'
      end

      if data.height ~= nil then
        heightLabel = 'Height : ' .. data.height
      else
        heightLabel = 'Height : Unknown'
      end

      if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Unknown'
      end

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        {label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'bottom-right',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = _U('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'bottom-right',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = _U('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Arms ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          if (itemType == 'item_weapon') then
            local targetHealth = GetEntityHealth(GetPlayerPed(player))
            print(targetHealth)
            if IsEntityDead(GetPlayerPed(player)) or (targetHealth == 0) then
              TriggerEvent('esx:showNotification', 'The person is incapacitated, please wait for the person to recover before taking weapons.')
            else
              TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
            end
          else
            TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
          end

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = _U('fine'),
      align    = 'bottom-right',
      elements = {
        {label = _U('traffic_offense'),   value = 0},
        --{label = _U('minor_offense'),     value = 1},
        {label = _U('average_offense'),   value = 2},
        {label = _U('major_offense'),     value = 3}
      },
    },
    function(data, menu)

      OpenFineCategoryMenu(player, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = _U('fine'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end

function OpenCheckFinesMenu(player)
  ESX.TriggerServerCallback('esx_billing:getFines', function(bills)

    ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #bills, 1 do
      table.insert(elements, {label = bills[i].label .. ' $' .. bills[i].amount, value = bills[i].id})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'billing_fines',
      {
        title    = 'Player Fines',
        align = 'bottom-right',
        elements = elements
      },
      function(data, menu)
        menu.close()

        local billId = data.current.value

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'bottom-right',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'bottom-right',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      local count  = 0

      for i=1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'bottom-right',
        elements = elements,
      },
      function(data, menu)

        ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
              OpenBuyWeaponsMenu(station)
            end, data.current.value)
          else
            ESX.ShowNotification(_U('not_enough_money'))
          end

        end, data.current.price)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)

    --print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('police_stock'),
    align    = 'bottom-right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity'),
      align    = 'bottom-right',
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_policejob:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
    align    = 'bottom-right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity'),
      align    = 'bottom-right',
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

-- Confiscate

function OpenGetConfiscatedItemsMenu()

  ESX.TriggerServerCallback('esx_policejob:getConfiscatedItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      print(items[i].name)
      if (items[i].type ~=nil) and (items[i].name == 'black_money') then
        table.insert(elements, {label = items[i].label .. ' [$' .. items[i].count..']', value = items[i].name})
      else
        table.insert(elements, {label = items[i].label .. ' x' .. items[i].count, value = items[i].name})
      end
      
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'confiscated_menu',
      {
        title    = _U('confiscated_inventory'),
        align    = 'bottom-right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'confiscated_menu_get_item_count',
          {
            title = _U('quantity'),
            align    = 'bottom-right',
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetConfiscatedItemsMenu()

              if (data.current.type ~=nil) and (itemName == 'black_money') then
                TriggerServerEvent('esx_policejob:getConfiscatedMoney', itemName, count)
              else
                TriggerServerEvent('esx_policejob:getConfiscatedItem', itemName, count)
              end

            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutConfiscatedItemsMenu()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

    local elements = {}

    PlayerData = ESX.GetPlayerData()
    for i=1, #PlayerData.accounts, 1 do
      if PlayerData.accounts[i].name == 'black_money' then
          table.insert(elements, {
            label     = PlayerData.accounts[i].label .. ' [$'.. math.floor(PlayerData.accounts[i].money+0.5) ..']',
            count     = PlayerData.accounts[i].money,
            value     = PlayerData.accounts[i].name,
            name      = PlayerData.accounts[i].label,
            limit     = PlayerData.accounts[i].limit,
            type    = 'item_account',
          })
      end
    end

    for i=1, #PlayerData.inventory, 1 do
      if PlayerData.inventory[i].count > 0 then
          table.insert(elements, {
            label     = PlayerData.inventory[i].label .. ' x' .. PlayerData.inventory[i].count,
            count     = PlayerData.inventory[i].count,
            value     = PlayerData.inventory[i].name,
            name      = PlayerData.inventory[i].label,
            limit     = PlayerData.inventory[i].limit,
            type    = 'item_standard',
          })
      end
    end

    -- local playerPed  = GetPlayerPed(-1)
    -- local weaponList = ESX.GetWeaponList()

    -- for i=1, #weaponList, 1 do
    --   local weaponHash = GetHashKey(weaponList[i].name)

    --   if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
    --   local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
    --   table.insert(elements, {label = weaponList[i].label .. ' [' .. ammo .. ']',name = weaponList[i].label, type = 'item_weapon', value = weaponList[i].name, count = ammo})
    --   end
    -- end

    -- for i=1, #inventory.items, 1 do
    --   local item = inventory.items[i]
    --   if item.count > 0 then
    --     table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
    --   end

    -- end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'confiscated_menu',
      {
        title    = _U('confiscated_inventory'),
        align    = 'bottom-right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'confiscated_menu_put_item_count',
          {
            title = _U('quantity'),
            align    = 'bottom-right',
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutConfiscatedItemsMenu()

              TriggerServerEvent('esx_policejob:putConfiscatedItems', itemName, count, data.current.type)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end


function updateBlips()

  --Remove existing blips
  for k, existingBlip in pairs(activeBlips) do
    RemoveBlip(existingBlip)
  end
  activeBlips = {}

  if PlayerData.job.name ~= "police" then return end

  local localIdCops = {}
  for id = 0, 31 do
    if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
      for i,c in pairs(activeCops) do
        if(i == GetPlayerServerId(id)) then
          localIdCops[id] = c
          break
        end
      end
    end
  end

  for id, c in pairs(localIdCops) do
    local ped = GetPlayerPed(id)
    local blip = GetBlipFromEntity(ped)

    if not DoesBlipExist( blip ) then

      blip = AddBlipForEntity( ped )
      SetBlipSprite( blip, 1 )
      Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
      HideNumberOnBlip( blip )
      SetBlipNameToPlayerName( blip, id )

      SetBlipScale( blip,  0.85 )
      SetBlipAlpha( blip, 200 )
      SetBlipColour(blip, 3)

      table.insert(activeBlips, blip)
    else

      blipSprite = GetBlipSprite( blip )

      HideNumberOnBlip( blip )
      if blipSprite ~= 1 then
        SetBlipSprite( blip, 1 )
        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
      end

      SetBlipNameToPlayerName( blip, id )
      SetBlipScale(blip,  0.85)
      SetBlipAlpha(blip, 200)
      SetBlipColour(blip, 3)

      table.insert(activeBlips, blip)
    end
  end
end

RegisterNetEvent('esx_policejob:copsInService')
AddEventHandler('esx_policejob:copsInService', function(array)
  activeCops = array
  updateBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
  updateBlips()
end)

RegisterNetEvent('esx_policejob:setTraffic')
AddEventHandler('esx_policejob:setTraffic', function(tOver, tLevel)
  trafficOverride = tOver
  trafficLevel = tLevel
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Police',
    number     = 'police',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}

    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed,  false) then
      local vehicle = GetVehiclePedIsIn(playerPed, false)
      if DoesEntityExist(vehicle) then
        CurrentActionData.vehicle = vehicle
      end
    end
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then

      ESX.Game.SpawnVehicle('polmav', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
      end)

    end

  end

  if part == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_object')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(force, state)
  if force then
    IsHandcuffed = state
  else
    IsHandcuffed = not IsHandcuffed
  end

  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local freeSeat = nil

      for i = 2, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end
  end

end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      for i=7, 345 do
    DisableControlAction(0, i,  true)
    end
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 249, true)
    EnableControlAction(0, 322, true)
    end
  end
end)

-- Create blips
Citizen.CreateThread(function()

for k,v in pairs(Config.PoliceStations) do
  for kk, blips in pairs(v.Blips) do
    local blip = AddBlipForCoord(blips.Pos.x, blips.Pos.y, blips.Pos.z)

    SetBlipSprite (blip, blips.Sprite)
    SetBlipDisplay(blip, blips.Display)
    SetBlipScale  (blip, blips.Scale)
    SetBlipColour (blip, blips.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)
  end
end

end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.extra == 'police') then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

    if PlayerData.job.extra == 'police' then break end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Vehicles, 1 do
          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (PlayerData.job.grade == 20 or PlayerData.job.grade == 3) then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.extra == 'police') then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end
    --Only show cloakrooms for off-duty police
    if PlayerData.job.extra == 'police' then break end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.Helicopters, 1 do

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (PlayerData.job.grade == 20 or PlayerData.job.grade == 3 ) then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()

  local trackedEntities = {
    'prop_roadcone02a',
    'prop_barrier_work06a',
    'p_ld_stinger_s',
    'prop_boxpile_07d',
    'hei_prop_cash_crate_half_full'
  }

  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end

      end

    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end

  if trafficOverride then
    SetVehicleDensityMultiplierThisFrame(trafficLevel)
  end

  --Stop non-police from driving police cars
  local veh = GetVehiclePedIsTryingToEnter(playerPed)
  if veh > 0 then
    DisablePlayerVehicleRewards(PlayerId())
      if GetSeatPedIsTryingToEnter(playerPed) == -1 then
      local modName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
      -- print("DEBUG: Entering a vehicle model: " .. modName .. " seat: " .. GetSeatPedIsTryingToEnter(playerPed))
      if (restrictedCarList[modName] and PlayerData.job ~= nil and not restrictedCarList[modName][PlayerData.job.name] and not restrictedCarList[modName][PlayerData.job.extra] ) then
        ClearPedTasks(playerPed)
        ESX.ShowNotification("You can't drive this vehicle!")
      end
    end
  end

  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.extra == 'police') and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum, CurrentActionData.vehicle)
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('police')  or
              GetEntityModel(vehicle) == GetHashKey('police2') or
              GetEntityModel(vehicle) == GetHashKey('police3') or
              GetEntityModel(vehicle) == GetHashKey('police4') or
              GetEntityModel(vehicle) == GetHashKey('policeb') or
              GetEntityModel(vehicle) == GetHashKey('policet')
            then
              TriggerServerEvent('esx_service:disableService', 'police')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end, {wash = false})

        end

        if CurrentAction == 'remove_entity' then
          print("Test Remove") -- TODO some things don't get removed?
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

    if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenPoliceActionsMenu()
      GUI.Time = GetGameTimer()
    end

  end
end)
