local TeleportFromTo = {

----------------------Blank copy----------------------
--	["Office 2"] = {
--		positionFrom = { ['x'] = , ['y'] = , ['z'] = , nom = ""},
--		positionTo = { ['x'] = , ['y'] = , ['z'] = , nom = ""},
--	},	

	["Courtroom"] = {
		positionFrom = { ['x'] = 225.338, ['y'] = -419.71, ['z'] = -118.150, nom = "Go inside the court room"},
		positionTo = { ['x'] = 238.794, ['y'] = -334.078, ['z'] = -118.760, nom = "Exit the court room"},
	},

	["Defense Hall"] = {
		positionFrom = { ['x'] = 246.438, ['y'] = -337.090, ['z'] = -118.794, nom = "Enter the defense hall"},
		positionTo = { ['x'] = 248.171, ['y'] = -337.797, ['z'] = -118.794, nom = "Exit the defense hall"},
	},
	
	["Reception"] = {
		positionFrom = { ['x'] = 233.35, ['y'] = -410.89, ['z'] = 48.11, nom = "Enter the L.A. CIty Court"},
		positionTo = { ['x'] = 236.101, ['y'] = -413.360, ['z'] = -118.150, nom = "Exit the court"},
	},
	
	["Judge Bench"] = {
		positionFrom = { ['x'] = 258.11, ['y'] = -326.28, ['z'] = -118.80, nom = "Enter the Jury bench"},
		positionTo = { ['x'] = 241.035, ['y'] = -304.235, ['z'] = -118.794, nom = "Exit the Jury bench"},
	},

	["Jail Visitation"] = {
		positionFrom = { ['x'] = 1792.49, ['y'] = 2593.84, ['z'] = 45.80, nom = "Enter the visitation"},
		positionTo = { ['x'] = 1706.62, ['y'] = 2580.96, ['z'] = -69.41, nom = "Exit the visitation"},
	},

	["Jail Entrance"] = {
		positionFrom = { ['x'] = 1699.95, ['y'] = 2574.87, ['z'] = -69.40, nom = "Enter the jail"},
		positionTo = { ['x'] = 1800.96, ['y'] = 2483.19, ['z'] = -122.70, nom = "Exit the jail"},
	},
	
	-----------------------------State Building-----------------------------------
	["Sandy Station"] = {
		positionFrom = { ['x'] = 139.1089, ['y'] = -762.7905 , ['z'] = 44.75202  , nom = "Enter the State building"},
		positionTo = { ['x'] = 2155.471, ['y'] = 2920.868, ['z'] = -62.90243, nom = "Exit the station"},
	},
	
	["Paleto Station"] = {
		positionFrom = { ['x'] = -442.352, ['y'] = 6012.365, ['z'] = 31.76, nom = "Enter the station"},
		positionTo = { ['x'] = -441.880, ['y'] = 6010.498, ['z'] = -118.761 , nom = "Exit the station"},
	},
	
	["FBI Building"] = {
		positionFrom = { ['x'] = 136.22, ['y'] = -762.22, ['z'] = 44.75, nom = "Special Operations Branch"},
		positionTo = { ['x'] = 136.39, ['y'] = -762.39, ['z'] = 241.15, nom = "Use the elevator"},
	},	
	
	["Market"] = {
		positionFrom = { ['x'] = 46.77, ['y'] = -1749.51, ['z'] = 29.64, nom = "Enter the market"},
		positionTo = { ['x'] = 64.93, ['y'] = -1742.44, ['z'] = 0.70, nom = "Exit the market"},
	},
	
	["UD Heist"] = {
		positionFrom = { ['x'] = 10.20, ['y'] = -671.30, ['z'] = 33.45, nom = "Use the elevator"},
		positionTo = { ['x'] = -0.04, ['y'] = -705.78, ['z'] = 16.13, nom = "Use the elevator"},
	},	

	["Police Garage in"] = {
		positionFrom = { ['x'] = 141.0195, ['y'] = -766.1981, ['z'] = 44.75201, nom = "Police Garage"},
		positionTo = { ['x'] =404.9515 , ['y'] =-975.2843 , ['z'] =-99.00419 , nom = "Use the elevator (no cars) "},
	},	

	["Police Garage out"] = {
		positionFrom = { ['x'] = 405.3129, ['y'] = -942.3885, ['z'] = -99.00418, nom = "Police Garage"},
		positionTo = { ['x'] =123.7953 , ['y'] =-731.4393 , ['z'] =33.13324 , nom = "Have a safe patrol! "},
	},	

	["Basement entrence"] = {
		positionFrom = { ['x'] = 65.10961, ['y'] = -749.2597, ['z'] = 31.63448, nom = "To ground floor"},
		positionTo = { ['x'] = 139.0121, ['y'] = -770.7515, ['z'] = 44.75204, nom = "To basement entrence"},
	},	
	["Interagation"] = {
		positionFrom = { ['x'] = 133.7305, ['y'] = -768.1908, ['z'] = 44.75202, nom = "Interrogation rooms"},
		positionTo = { ['x'] = 2060.702, ['y'] =2983.265 , ['z'] =-67.10127 , nom = "To Upper level"},
	},	

	["Office 2"] = {
		positionFrom = { ['x'] =121.5463 , ['y'] =-754.2021 , ['z'] =44.752 , nom = " Enter Office"},
		positionTo = { ['x'] = 122.6835, ['y'] =-752.9158 , ['z'] =44.7519 , nom = "Leave Office"},
	},	

	["Mail Room"] = {
		positionFrom = { ['x'] =141.8635 , ['y'] =-769.3264 , ['z'] =241.1521 , nom = "Enter Mail Rom"},
		positionTo = { ['x'] = 143.012, ['y'] =-769.813 , ['z'] = 241.1521 , nom = "Leave Mail Room"},
	},	

	["Major Office"] = {
		positionFrom = { ['x'] =146.6092 , ['y'] = -756.9357, ['z'] =241.1519 , nom = "Mj. Thomas McAllister"},
		positionTo = { ['x'] =145.6092 , ['y'] = -756.9357, ['z'] =-241.1519 , nom = ""},
	},	

	["Capt office"] = {
		positionFrom = { ['x'] = 151.261, ['y'] =-744.0802 , ['z'] =241.1519 , nom = "Cpt. Harold Fisher"},
		positionTo = { ['x'] =150.261, ['y'] =-744.0802 , ['z'] =241.1519 , nom = ""},
	},

	["Lead Detective"] = {
		positionFrom = { ['x'] =152.1549 , ['y'] =-738.5595 , ['z'] =241.152 , nom = "Sgt. Bobston Bruins"},
		positionTo = { ['x'] =152.1549, ['y'] =-738.5595 , ['z'] =241.1519 , nom = ""},
	},	

	["EMS Chief"] = {
		positionFrom = { ['x'] =125.0686 , ['y'] =-765.4319 , ['z'] =241.1522 , nom = "Lucifer Morningstar"},
		positionTo = { ['x'] =125.0686 , ['y'] =-765.4319 , ['z'] =241.1522 , nom = ""},
	},

	["Roof access"] = {
		positionFrom = { ['x'] = 141.7307, ['y'] =-735.4436 , ['z'] = 262.8515, nom = "Exit Roof"},
		positionTo = { ['x'] = 2034.262, ['y'] =2942.108 , ['z'] =-62.90174 , nom = "Roof Access"},
	},	
-- 	["Capt office"] = {
-- 		positionFrom = { ['x'] = 151.261, ['y'] =-744.0802 , ['z'] =241.1519 , nom = "Capt. Garrett Oakley "},
-- 		positionTo = { ['x'] =150.261, ['y'] =-744.0802 , ['z'] =241.1519 , nom = ""},
-- },	

-- ["Major office"] = {
-- 		positionFrom = { ['x'] =152.1549 , ['y'] =-738.5595 , ['z'] =241.152 , nom = "Major Chris Santos "},
-- 		positionTo = { ['x'] =152.1549, ['y'] =-738.5595 , ['z'] =241.1519 , nom = ""},
-- },	

-- ["Lead Detectice"] = {
-- 		positionFrom = { ['x'] =125.0686 , ['y'] =-765.4319 , ['z'] =241.1522 , nom = "Lt. Eric Mason"},
-- 		positionTo = { ['x'] =125.0686 , ['y'] =-765.4319 , ['z'] =241.1522 , nom = ""},
-- 	},	



	---------------------------------------------------Mamas Bar----------------------------------------------------------
	["Bahama Mamas"] = {
		positionFrom = { ['x'] = -1388.544, ['y'] =-585.4951 , ['z'] =30.21665 , nom = "Enter"},
		positionTo = { ['x'] = -1387.026, ['y'] =-588.4763 , ['z'] =30.319 , nom = " Leave"},
	},	

["Back Bar"] = {
		positionFrom = { ['x'] =-1381.258 , ['y'] =-632.3945 , ['z'] =30.81957 , nom = "Enter"},
		positionTo = { ['x'] = -1380.00, ['y'] =-631.44 , ['z'] =31.00 , nom = "Leave"},
	},	

	["Front Bar"] = {
		positionFrom = { ['x'] = -1391.708, ['y'] = -597.7766, ['z'] = 30.31957, nom = "Enter"},
		positionTo = { ['x'] = -1390.851, ['y'] =-600.1299 , ['z'] =30.31957 , nom = "Leave"},
	},	

	--["Booking room"] = {
	--	positionFrom = { ['x'] = 65.10961, ['y'] = -749.2597, ['z'] = 31.63448, nom = "To ground floor"},
	--	positionTo = { ['x'] = 402.1293, ['y'] = -1003.184, ['z'] = -99.00404, nom = "To basement entrence"},
	--},	
["Tazer tag"] = {
		positionFrom = { ['x'] = -115.9124, ['y'] = -601.7662, ['z'] = 36.28206, nom = "Enter to play tazer tag"},
		positionTo = { ['x'] = 2154.831, ['y'] = 2920.986, ['z'] =-81.075386047364 , nom = "Leave"},
	},	


	["ATC Tower"] = {
		positionFrom = { ['x'] =-985.8347 , ['y'] =-2634.862 , ['z'] =84.04646 , nom = ""},
		positionTo = { ['x'] =-983.5023 , ['y'] =-2635.8347 , ['z'] =84.01019 , nom = ""},
	},	


	["ATC "] = {
		positionFrom = { ['x'] =-966.3262 , ['y'] =-2610.123 , ['z'] =13.981 , nom = ""},
		positionTo = { ['x'] = -981.7664, ['y'] =-2631.344 , ['z'] =84.04636 , nom = ""},
	},	

	-- LA FUETA BLANCA
	["LFB"] = {
		positionFrom = { ['x'] =1394.011 , ['y'] =1141.795 , ['z'] =113.5954 , nom = "Enter house"},
		positionTo = { ['x'] = 1397.612, ['y'] =1141.644 , ['z'] = 113.3479 , nom = " Leave house"},
	},

	["LFBP"] = {
		positionFrom = { ['x'] = 1408.294 , ['y'] = 1147.277 , ['z'] = 113.3336 , nom = "Leave house"},
		positionTo = { ['x'] = 1411.664, ['y'] =1147.605 , ['z'] = 113.3342 , nom = " Enter house"},
	},

	["WZN2"] = {
		positionFrom = { ['x'] = -1048.629 , ['y'] = -238.5197 , ['z'] = 44.02 , nom = "Enter room"},
		positionTo = { ['x'] = -1046.638, ['y'] = -237.5053 , ['z'] = 44.02 , nom = "Leave room"},
	},

	["WZN2L"] = {
		positionFrom = { ['x'] = -1062.925 , ['y'] = -241.1704 , ['z'] = 44.02 , nom = "Enter room"},
		positionTo = { ['x'] = -1063.729, ['y'] = -239.3716 , ['z'] = 44.02 , nom = "Leave room"},
	},
	
	-- SENOR HOUSE
	["FRONT DOOR"] = {
		positionFrom = { ['x'] =-852.8939 , ['y'] =693.933 , ['z'] =149.0418 , nom = "Enter house"},
		positionTo = { ['x'] = -859.9323, ['y'] =691.5107 , ['z'] = 152.8587 , nom = " Leave house"},
    },
}

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing


function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Drawing.drawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function msginf(msg, duree)
    duree = duree or 500
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k, j in pairs(TeleportFromTo) do

			--msginf(k .. " " .. tostring(j.positionFrom.x), 15000)
			if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 150.0)then
				DrawMarker(1, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 255, 255, 255,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 5.0)then
					Drawing.draw3DText(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.100, j.positionFrom.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 2.0)then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Press ~r~E~w~ to ".. j.positionFrom.nom)
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(1000)
							Citizen.Wait(2000)
							SetEntityCoords(GetPlayerPed(-1), j.positionTo.x, j.positionTo.y, j.positionTo.z - 1)
							DoScreenFadeIn(1000)
						end
					end
				end
			end

			if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 150.0)then
				DrawMarker(1, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 255, 255, 255,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 5.0)then
					Drawing.draw3DText(j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.100, j.positionTo.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 2.0)then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Press ~r~E~w~ to ".. j.positionTo.nom)
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(1000)
							Citizen.Wait(2000)
							SetEntityCoords(GetPlayerPed(-1), j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1)
							DoScreenFadeIn(1000)
						end
					end
				end
			end
		end
	end
end)
