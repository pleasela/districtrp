--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 09/05/2017
-- Time: 09:55
-- To change this template use File | Settings | File Templates.
--




local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Vehicle Menu",
    menu_subtitle = "Categories",
    color_r = 127,
    color_g = 200,
    color_b = 255,
}

--Save previous car we locked
local savedCar = nil

------------------------------------------------------------------------------------------------------------------------

-- Base du menu
function PersonnalMenu()
    options.menu_subtitle = "CATEGORIES"
    ClearMenu()
    if IsPedInAnyVehicle(GetPlayerPed(-1)) or savedCar then
      Menu.addButton("Speed limiter", "speedo", nil)
      Menu.addButton("Doors", "doors", nil)
      Menu.addButton("Lock","toggleDoorLocks",nil)
      Menu.addButton("Engine", "motor", nil)
      Menu.addButton("Neons", "NeonSubMenu", nil)
    end
    Menu.addButton("Close", "CloseMenu", nil)
end

function motor()
    options.menu_subtitle = "CATEGORIES"
    ClearMenu()
    Menu.addButton("Turn On", "motorOn", nil)
    Menu.addButton("Turn Off", "motorOff", nil)
	  Menu.addButton("Back", "PersonnalMenu", nil)
end

function doors()
    options.menu_subtitle = "CATEGORIES"
    ClearMenu()
    Menu.addButton("All doors", "all", nil)
    Menu.addButton("Hood", "capot", nil)
    Menu.addButton("Trunk", "coffre", nil)
    Menu.addButton("Front doors", "avant", nil)
    Menu.addButton("Back doors", "arriere", nil)
	  Menu.addButton("Back", "PersonnalMenu", nil)
end

function avant()
    options.menu_subtitle = "DOORS"
    ClearMenu()
    Menu.addButton("Front left", "avantgauche", nil)
    Menu.addButton("Front right", "avantdroite", nil)
	  Menu.addButton("Back", "doors", nil)
end

function arriere()
    options.menu_subtitle = "DOORS"
    ClearMenu()
    Menu.addButton("Back left", "arrieregauche", nil)
    Menu.addButton("Back right", "arrieredroite", nil)
	  Menu.addButton("Back", "doors", nil)
end

function NeonSubMenu()
    options.menu_subtitle = "NEONS"
    ClearMenu()
    Menu.addButton("All", "NeonAll", nil)
    Menu.addButton("Front", "NeonFront", nil)
    Menu.addButton("Left", "NeonLeft", nil)
    Menu.addButton("Right", "NeonRight", nil)
    Menu.addButton("Rear", "NeonRear", nil)
    Menu.addButton("Back", "PersonnalMenu", nil)
end

local function neonToggleWhich(which,forced,on)
	local isOn = IsVehicleNeonLightEnabled(savedCar,which)
	if forced then
		SetVehicleNeonLightEnabled(savedCar, which, on)
	else
		SetVehicleNeonLightEnabled(savedCar, which, (not isOn))
	end
end
local function neonToggle(which, turnOn)
	if getVehicleOrSaved() then
		--In a vehicle! We can proceed
		neonToggleWhich(which, false, turnOn)
   end
end

function NeonAll()
	if getVehicleOrSaved() then
		local turnOn = not IsVehicleNeonLightEnabled(savedCar,0)
		neonToggleWhich(0, true, turnOn)
		neonToggleWhich(1, true, turnOn)
		neonToggleWhich(2, true, turnOn)
		neonToggleWhich(3, true, turnOn)
		local r,g,b = 0, 0, 0
		GetVehicleNeonLightsColour(savedCar,r,g,b)
		print("Color detected: " .. r .. " " .. g .. " " .. b)
	end
end

function NeonLeft()
	neonToggle(0)
end
function NeonRight()
	neonToggle(1)
end
function NeonFront()
	neonToggle(2)
end
function NeonRear()
	neonToggle(3)
end

function speedo()
    options.menu_subtitle = "LIMITER"
    ClearMenu()
    Menu.addButton("Off", "limiter", 0)
    Menu.addButton("35 ~g~Mp/h", "limiter", "35.0")
    Menu.addButton("45 ~g~Mp/h", "limiter", "45.0")
    Menu.addButton("55 ~g~Mp/h", "limiter", "55.0")
    Menu.addButton("65 ~g~Mp/h", "limiter", "65.0")
    Menu.addButton("75 ~g~Mp/h", "limiter", "75.0")
    Menu.addButton("85 ~g~Mp/h", "limiter", "85.0")
    Menu.addButton("110 ~g~Mp/h", "limiter", "110.0")
    Menu.addButton("Back", "PersonnalMenu", nil)
end

function CloseMenu()
    Menu.hidden = not Menu.hidden
end

------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
function drawTxt(options)
    SetTextFont(options.font)
    SetTextProportional(0)
    SetTextScale(options.scale, options.scale)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(0)
    SetTextEntry('STRING')
    AddTextComponentString(options.text)
    DrawRect(options.xBox,options.y,options.width,options.height,0,0,0,150)
    DrawText(options.x - options.width/2 + 0.005, options.y - options.height/2 + 0.0028)
end
function DisplayHelpText(str)
    SetTextComponentFormat('STRING')
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function notifs(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString( msg )
    DrawNotification(false, false)
end

--------------------------------------------------- NUI CALLBACKS ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function limiter(vit)
	if getVehicleOrSaved() then
		local speed = vit*0.44
		local vehicleModel = GetEntityModel(savedCar)
		local Max = GetVehicleMaxSpeed(vehicleModel)

		if (vit == 0) then
			SetEntityMaxSpeed(savedCar, Max)
			exports.pNotify:SendNotification({text = "Limiter desactived", type = "error", layout = "bottomRight", timeout = math.random(4000, 8000)})
		else
			SetEntityMaxSpeed(savedCar, speed)
			exports.pNotify:SendNotification({text = "Limiter actived", type = "success", layout = "bottomRight", timeout = math.random(4000, 8000)})
			PersonnalMenu()
		end
	end
end

function all()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 1) > 0.0 then
         SetVehicleDoorShut(savedCar, 5, false)
         SetVehicleDoorShut(savedCar, 4, false)
         SetVehicleDoorShut(savedCar, 3, false)
         SetVehicleDoorShut(savedCar, 2, false)
         SetVehicleDoorShut(savedCar, 1, false)
         SetVehicleDoorShut(savedCar, 0, false)
       else
         SetVehicleDoorOpen(savedCar, 5, false)
         SetVehicleDoorOpen(savedCar, 4, false)
         SetVehicleDoorOpen(savedCar, 3, false)
         SetVehicleDoorOpen(savedCar, 2, false)
         SetVehicleDoorOpen(savedCar, 1, false)
         SetVehicleDoorOpen(savedCar, 0, false)
         frontleft = true
      end
   end
end


--Get the current car, or the saved car
function getVehicleOrSaved()
	local playerPed = GetPlayerPed(-1)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		local playerVeh = GetVehiclePedIsIn(playerPed, false)
		savedCar = playerVeh
	end
	return savedCar and true or false
end

--Toggle Door locks
function toggleDoorLocks()
	if getVehicleOrSaved() then
		local lock = (GetVehicleDoorLockStatus(savedCar)==2) and 0 or 2
		SetVehicleDoorsLocked(savedCar, lock)
		if lock == 2 then
		  SendNotification("~s~~h~Doors ~g~Locked")
		else
		  SendNotification("~s~~h~Doors ~r~Unlocked")
		end
	end
end

function capot()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 4) > 0.0 then
         SetVehicleDoorShut(savedCar, 4, false)
       else
         SetVehicleDoorOpen(savedCar, 4, false)
         frontleft = true
      end
   end
end

function coffre()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 5) > 0.0 then
         SetVehicleDoorShut(savedCar, 5, false)
       else
         SetVehicleDoorOpen(savedCar, 5, false)
         frontleft = true
      end
   end
end

function avantgauche()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 0) > 0.0 then
         SetVehicleDoorShut(savedCar, 0, false)
       else
         SetVehicleDoorOpen(savedCar, 0, false)
         frontleft = true
      end
   end
end

function avantdroite()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 1) > 0.0 then
         SetVehicleDoorShut(savedCar, 1, false)
       else
         SetVehicleDoorOpen(savedCar, 1, false)
         frontleft = true
      end
   end
end

function arrieredroite()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 3) > 0.0 then
         SetVehicleDoorShut(savedCar, 3, false)
       else
         SetVehicleDoorOpen(savedCar, 3, false)
         frontleft = true
      end
   end
end

function arrieregauche()
	if getVehicleOrSaved() then
      if GetVehicleDoorAngleRatio(savedCar, 2) > 0.0 then
         SetVehicleDoorShut(savedCar, 2, false)
       else
         SetVehicleDoorOpen(savedCar, 2, false)
         frontleft = true
      end
   end
end

function motorOn()
	if getVehicleOrSaved() then
		SetVehicleUndriveable(savedCar,false)
		SetVehicleEngineOn(savedCar, true,true,false)
		SendNotification("~s~~h~Engine ~g~on")
   end
end

function motorOff()
	if getVehicleOrSaved() then
		SetVehicleUndriveable(savedCar,true)
		SetVehicleEngineOn(savedCar, false,true,false)
		SendNotification("~s~~h~Engine ~r~off")
   end
end

function SendNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

------------------------------------------------------------------------------------------------------------------------
function drawMenuRight(txt,x,y,selected)
  local menu = personnelmenu.menu
  SetTextFont(menu.font)
  SetTextProportional(0)
  SetTextScale(menu.scale, menu.scale)
  SetTextRightJustify(1)
  if selected then
    SetTextColour(0, 0, 0, 255)
  else
    SetTextColour(255, 255, 255, 255)
  end
  SetTextCentre(0)
  SetTextEntry("STRING")
  AddTextComponentString(txt)
  DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

--------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		--if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        if IsControlJustPressed(1, 244) then
            PersonnalMenu() -- Menu to draw
            Menu.hidden = not Menu.hidden -- Hide/Show the menu
        end
        Menu.renderGUI(options) -- Draw menu on each tick if Menu.hidden = false
        if IsEntityDead(PlayerPedId()) then
            --PlayerIsDead()
            -- prevent the death check from overloading the server
            --playerdead = true
			 else

			 end
    end
    --end
end)

local working
------------------------------------------------------------------------------------------------------------------------
