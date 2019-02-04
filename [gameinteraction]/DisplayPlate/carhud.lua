local showPlateHud = false

RegisterNetEvent('displayplate:show')
AddEventHandler('displayplate:show', function(show)
  showPlateHud = show
end)

-- show/hide compoent
local HUD = {
	Plate = true, 	-- only if Top is false and you want to keep Plate Number
}

-- Move the entire UI
local UI = { 
	x =  0.070 ,	-- Base Screen Coords 	+ 	 x
	y = -0.001 ,	-- Base Screen Coords 	+ 	-y
}


Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local MyPed = GetPlayerPed(-1)
		
		if(IsPedInAnyVehicle(MyPed, false))then

			local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)

			if HUD.Plate then
				if showPlateHud then
					drawTxt(UI.x + 0.61, 	UI.y + 1.385, 1.0,1.0,0.55, "~w~" .. PlateVeh, 255, 255, 255, 255)
				elseif not showPlateHud then
					drawTxt(UI.x + 0.61, 	UI.y + 1.385, 1.0,1.0,0.55, "~w~" .. PlateVeh, 255, 255, 255, 0)
				end
			end

		end		
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
