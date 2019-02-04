--[[--------------------------------------------------------------------------
	
	* Mello Trainer
	* (C) Michael Goodwin 2017
	* http://github.com/thestonedturtle/mellotrainer/releases
	
	* This menu used the Scorpion Trainer as a framework to build off of.
	* https://github.com/pongo1231/ScorpionTrainer
	* (C) Emre Cürgül 2017
	 
	* A lot of useful functionality has been converted from the lambda menu.
	* https://lambda.menu
	* (C) Oui 2017
	
	* Additional Contributors:
	* WolfKnight (https://forum.fivem.net/u/WolfKnight)
	
--------------------------------------------------------------------------]]--




-- Format: {string, x, y, z, scenery_required*, scenery_to_remove*, isLoaded!}
-- * = Table ! = Boolean

local locations = {}

locations.safeHouses = {
	{ "Michael's Safehouse", -827.138, 176.368, 70.4999 },
	{ "Franklin's Safehouse", -18.0355, -1456.94, 30.4548 },
	{ "Franklin's Safehouse 2", 10.8766, 545.654, 175.419 },
	{ "Trevor's Safehouse", 1982.13, 3829.44, 32.3662 },
	{ "Trevor's Safehouse 2", -1157.05, -1512.73, 4.2127 },
	{ "Trevor's Safehouse 3", 91.1407, -1280.65, 29.1353 },
	{ "Michael's Safehouse Inside", -813.603, 179.474, 72.1548 },
	{ "Franklin's Safehouse Inside", -14.3803, -1438.51, 31.1073 },
	{ "Franklin's Safehouse 2 Inside", 7.11903, 536.615, 176.028 },
	{ "Trevor's Safehouse Inside", 1972.61, 3817.04, 33.4278 },
	{ "Trevor's Safehouse 2 Inside", -1151.77, -1518.14, 10.6327 },
	{ "Trevor's Safehouse 3 Inside", 96.1536, -1290.73, 29.2664 }
}

locations.landmarks = {
	{ "Airport Entrance", -1034.6, -2733.6, 13.8 },
	{ "Airport Field", -1336.0, -3044.0, 13.9 },
	{ "Altruist Cult Camp", -1170.841, 4926.646, 224.295 },
	{ "Calafia Train Bridge", -517.869, 4425.284, 89.795 },
	{ "Cargo Ship", 899.678, -2882.191, 19.013 },
	{ "Chumash", -3192.6, 1100.0, 20.2 },
	{ "Chumash Historic Family Pier", -3426.683, 967.738, 8.347 },
	{ "Del Perro Pier", -1850.127, -1231.751, 13.017 },
	{ "Devin Weston's House", -2639.872, 1866.812, 160.135 },
	{ "El Burro Heights", 1384.0, -2057.1, 52.0 },
	{ "Elysian Island", 338.2, -2715.9, 38.5 },
	{ "Far North San Andreas", 24.775, 7644.102, 19.055 },
	{ "Ferris Wheel", -1670.7, -1125.0, 13.0 },
	{ "Fort Zancudo", -2047.4, 3132.1, 32.8 },
	{ "Fort Zancudo ATC Entrance", -2344.373, 3267.498, 32.811 },
	{ "Fort Zancudo ATC Top Floor", -2358.132, 3249.754, 101.451 },
	{ "God's Thumb", -1006.402, 6272.383, 1.503 },
	{ "Hippy Camp", 2476.712, 3789.645, 41.226 },
	{ "Jetsam", 760.4, -2943.2, 5.8 },
	{ "Jolene Cranley-Evans Ghost", 3059.620, 5564.246, 197.091 },
	{ "Kortz Center", -2243.810, 264.048, 174.615 },
	{ "Main LS Customs", -365.425, -131.809, 37.873 },
	{ "Marlowe Vineyards", -1868.971, 2095.674, 139.115 },
	{ "McKenzie Airfield", 2121.7, 4796.3, 41.1 },
	{ "Merryweather Dock", 486.417, -3339.692, 6.070 },
	{ "Mineshaft", -595.342, 2086.008, 131.412 },
	{ "Mt. Chiliad", 425.4, 5614.3, 766.5 },
	{ "Mt. Chiliad Summit", 450.718, 5566.614, 806.183 },
	{ "NOOSE Headquarters", 2535.243, -383.799, 92.993 },
	{ "Pacific Standard Bank", 235.046, 216.434, 106.287 },
	{ "Paleto Bay Pier", -275.522, 6635.835, 7.425 },
	{ "Playboy Mansion", -1475.234, 167.088, 55.841 },
	{ "Police Station", 436.491, -982.172, 30.699 },
	{ "Quarry", 2954.196, 2783.410, 41.004 },
	{ "Sandy Shores Airfield", 1747.0, 3273.7, 41.1 },
	{ "Satellite Dishes", 2062.123, 2942.055, 47.431 },
	{ "Sisyphus Theater Stage", 686.245, 577.950, 130.461 },
	{ "Trevor's Meth Lab", 1391.773, 3608.716, 38.942 },
	{ "Weed Farm", 2208.777, 5578.235, 53.735 },
	{ "Wind Farm", 2354.0, 1830.3, 101.1 }
}

locations.high = {
	{ "Airplane Graveyard Airplane Tail ", 2395.096, 3049.616, 60.053 },
	{ "FIB Building Roof", 150.126, -754.591, 262.865 },
	{ "Galileo Observatory Roof", -438.804, 1076.097, 352.411 },
	{ "IAA Building Roof", 134.085, -637.859, 262.851 },
	{ "Maze Bank Arena Roof", -324.300, -1968.545, 67.002 },
	{ "Maze Bank Roof", -75.015, -818.215, 326.176 },
	{ "Palmer-Taylor Power Station Chimney", 2732.931, 1577.540, 83.671 },
	{ "Rebel Radio", 736.153, 2583.143, 79.634 },
	{ "Sandy Shores Building Site Crane", 1051.209, 2280.452, 89.727 },
	{ "Satellite Dish Antenna", 2034.988, 2953.105, 74.602 },
	{ "Stab City", 126.975, 3714.419, 46.827 },
	{ "Very High Up", -129.964, 8130.873, 6705.307 },
	{ "Windmill Top", 2026.677, 1842.684, 133.313 }
}

locations.underwater = {
	{ "Dead Sea Monster", -3373.726, 504.714, -24.656 },
	{ "Humane Labs Tunnel", 3619.749, 2742.740, 28.690 },
	{ "Sunken Body", -3161.078, 3001.998, -37.974 },
	{ "Sunken Cargo Ship", 3199.748, -379.018, -22.500 },
	{ "Sunken Plane", -942.350, 6608.752, -20.912 },
	{ "Underwater Hatch", 4273.950, 2975.714, -170.746 },
	{ "Underwater UFO", 762.426, 7380.371, -111.377 },
	{ "Underwater WW2 Tank", 4201.633, 3643.821, -39.016 },
}

locations.interiors = {
	{ "10 Car Garage Back Room", 223.193, -967.322, -99.000 },
	{ "10 Car Garage Bay", 228.135, -995.350, -99.000 },
	{ "Ammunation Gun Range", 22.153, -1072.854, 29.797 },
	{ "Ammunation Office", 12.494, -1110.130, 29.797 },
	{ "Bahama Mamas West", -1387.08, -588.4, 30.3195 },
	{ "Blaine County Savings Bank", -109.299, 6464.035, 31.627 },
	{ "Clucking Bell Farms Warehouse", -70.0624, 6263.53, 31.0909, { "CS1_02_cf_onmission1", "CS1_02_cf_onmission2", "CS1_02_cf_onmission3", "CS1_02_cf_onmission4" }, { "CS1_02_cf_offmission" }, false },
	{ "Control Office", 1080.97, -1976.0, 31.4721 },
	{ "Devin's Garage", 482.027, -1317.96, 29.2021 },
	{ "Eclipse Apartment 5", -762.762, 322.634, 175.401 },
	{ "Eclipse Apartment 9", -790.673, 334.468, 158.599 },
	{ "Eclipse Apartment 31", -762.762, 322.634, 221.855 },
	{ "Eclipse Apartment 40", -790.673, 334.468, 206.218 },
	{ "FIB Building Burnt", 159.553, -738.851, 246.152 },
	{ "FIB Building Floor 47", 134.573, -766.486, 234.152 },
	{ "FIB Building Floor 49", 134.635, -765.831, 242.152 },
	{ "FIB Building Lobby", 110.4, -744.2, 45.7,  { "FIBlobby" }, { "FIBlobbyfake" } },
	{ "FIB Building Top Floor", 135.733, -749.216, 258.152 },
	{ "Garment Factory", 717.397, -965.572, 30.3955 },
	{ "Hospital (Destroyed)", 302.651, -586.293, 43.3129, { "RC12B_Destroyed", "RC12B_HospitalInterior" }, { "RC12B_Default", "RC12B_Fixed" }, false },
	{ "Humane Labs Lower Level", 3525.495, 3705.301, 20.992 },
	{ "Humane Labs Upper Level", 3618.52, 3755.76, 28.6901 },
	{ "IAA Office", 117.220, -620.938, 206.047 },
	{ "Ice Planet Jewelery", 243.516, 364.099, 105.738 },
	{ "Janitor's Apartment", -110.721, -8.22095, 70.5197 },
	{ "Jewel Store", -630.07, -236.332, 38.0571, { "post_hiest_unload" }, { "jewel2ake", "bh1_16_refurb" }, false },
	{ "Lester's House", 1273.898, -1719.304, 54.771 },
	{ "Life Invader Office", -1049.13, -231.779, 39.0144,  { "facelobby" }, { "facelobbyfake" }, false },
	{ "Maze Bank Arena", -254.918, -2019.75, 30.1456 },
	{ "Morgue", 275.446, -1361.11, 24.5378,  { "Coroner_Int_on" }, {}, false },
	{ "O'Neil Farm", 2454.78, 4971.92, 46.8103,  { "farm", "farm_props", "farmint" }, { "farm_burnt", "farm_burnt_props", "farmint_cap" }, false },
	{ "Pacific Standard Bank Vault", 255.851, 217.030, 101.683 },
	{ "Paleto Bay Sheriff", -446.135, 6012.91, 31.7164 },
	{ "Raven Slaughterhouse", 967.357, -2184.71, 30.0613 },
	{ "Rogers Salvage & Scrap", -609.962, -1612.49, 27.0105 },
	{ "Sandy Shores Sheriff", 1853.18, 3686.63, 34.2671 },
	{ "Simeon's Dealership", -56.4951, -1095.8, 26.4224 },
	{ "Split Sides West Comedy Club", -564.261, 278.232, 83.1364 },
	{ "Strip Club DJ Booth", 126.135, -1278.583, 29.270 },
	{ "Torture Warehouse", 136.514, -2203.15, 7.30914 },
}


local IPLS = {}
IPLS.carrier = {
	"hei_carrier",
	"hei_carrier_DistantLights",
	"hei_Carrier_int1",
	"hei_Carrier_int2",
	"hei_Carrier_int3",
	"hei_Carrier_int4",
	"hei_Carrier_int5",
	"hei_Carrier_int6",
	"hei_carrier_LODLights"
}

IPLS.heistyacht = {
	"hei_yacht_heist",
	"hei_yacht_heist_Bar",
	"hei_yacht_heist_Bedrm",
	"hei_yacht_heist_Bridge",
	"hei_yacht_heist_DistantLights",
	"hei_yacht_heist_enginrm",
	"hei_yacht_heist_LODLights",
	"hei_yacht_heist_Lounge"
}

IPLS.north_yankton = {
	"plg_01",
	"prologue01",
	"prologue01_lod",
	"prologue01c",
	"prologue01c_lod",
	"prologue01d",
	"prologue01d_lod",
	"prologue01e",
	"prologue01e_lod",
	"prologue01",
	"prologue01_lod",
	"prologue01g",
	"prologue01h",
	"prologue01h_lod",
	"prologue01i",
	"prologue01i_lod",
	"prologue01j",
	"prologue01j_lod",
	"prologue01k",
	"prologue01k_lod",
	"prologue01z",
	"prologue01z_lod",
	"plg_02",
	"prologue02",
	"prologue02_lod",
	"plg_03",
	"prologue03",
	"prologue03_lod",
	"prologue03b",
	"prologue03b_lod",
	-- the commented code disables the 'Prologue' grave and
	-- enables the 'Bury the Hatchet' grave
	--"prologue03_grv_cov",
	--"prologue03_grv_cov_lod",
	"prologue03_grv_dug",
	"prologue03_grv_dug_lod",
	--"prologue03_grv_fun",
	"prologue_grv_torch",
	"plg_04",
	"prologue04",
	"prologue04_lod",
	"prologue04b",
	"prologue04b_lod",
	"prologue04_cover",
	"des_protree_end",
	"des_protree_start",
	"des_protree_start_lod",
	"plg_05",
	"prologue05",
	"prologue05_lod",
	"prologue05b",
	"prologue05b_lod",
	"plg_06",
	"prologue06",
	"prologue06_lod",
	"prologue06b",
	"prologue06b_lod",
	"prologue06_int",
	"prologue06_int_lod",
	"prologue06_pannel",
	"prologue06_pannel_lod",
	--"prologue_m2_door",
	--"prologue_m2_door_lod",
	"plg_occl_00",
	"prologue_occl",
	"plg_rd",
	"prologuerd",
	"prologuerdb",
	"prologuerd_lod"
}

IPLS.bunker = {
"gr_grdlc_interior_placement_interior_0_grdlc_int_01_milo_",
"gr_grdlc_interior_placement_interior_1_grdlc_int_02_milo_",
}

IPLS.lab = {
"sm_smugdlc_interior_placement",
"sm_smugdlc_interior_placement_interior_0_smugdlc_int_01_milo_",
"xm_x17dlc_int_placement",
"xm_x17dlc_int_placement_interior_0_x17dlc_int_base_ent_milo_",
"xm_x17dlc_int_placement_interior_10_x17dlc_int_tun_straight_milo_",
"xm_x17dlc_int_placement_interior_11_x17dlc_int_tun_slope_flat_milo_",
"xm_x17dlc_int_placement_interior_12_x17dlc_int_tun_flat_slope_milo_",
"xm_x17dlc_int_placement_interior_13_x17dlc_int_tun_30d_r_milo_",
"xm_x17dlc_int_placement_interior_14_x17dlc_int_tun_30d_l_milo_",
"xm_x17dlc_int_placement_interior_15_x17dlc_int_tun_straight_milo_",
"xm_x17dlc_int_placement_interior_16_x17dlc_int_tun_straight_milo_",
"xm_x17dlc_int_placement_interior_17_x17dlc_int_tun_slope_flat_milo_",
"xm_x17dlc_int_placement_interior_18_x17dlc_int_tun_slope_flat_milo_",
"xm_x17dlc_int_placement_interior_19_x17dlc_int_tun_flat_slope_milo_",
"xm_x17dlc_int_placement_interior_1_x17dlc_int_base_loop_milo_",
"xm_x17dlc_int_placement_interior_20_x17dlc_int_tun_flat_slope_milo_",
"xm_x17dlc_int_placement_interior_21_x17dlc_int_tun_30d_r_milo_",
"xm_x17dlc_int_placement_interior_22_x17dlc_int_tun_30d_r_milo_",
"xm_x17dlc_int_placement_interior_23_x17dlc_int_tun_30d_r_milo_",
"xm_x17dlc_int_placement_interior_24_x17dlc_int_tun_30d_r_milo_",
"xm_x17dlc_int_placement_interior_25_x17dlc_int_tun_30d_l_milo_",
"xm_x17dlc_int_placement_interior_26_x17dlc_int_tun_30d_l_milo_",
"xm_x17dlc_int_placement_interior_27_x17dlc_int_tun_30d_l_milo_",
"xm_x17dlc_int_placement_interior_28_x17dlc_int_tun_30d_l_milo_",
"xm_x17dlc_int_placement_interior_29_x17dlc_int_tun_30d_l_milo_",
"xm_x17dlc_int_placement_interior_2_x17dlc_int_bse_tun_milo_",
"xm_x17dlc_int_placement_interior_30_v_apart_midspaz_milo_",
"xm_x17dlc_int_placement_interior_31_v_studio_lo_milo_",
"xm_x17dlc_int_placement_interior_32_v_garagem_milo_",
"xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_",
"xm_x17dlc_int_placement_interior_34_x17dlc_int_lab_milo_",
"xm_x17dlc_int_placement_interior_35_x17dlc_int_tun_entry_milo_",
"xm_x17dlc_int_placement_interior_3_x17dlc_int_base_milo_",
"xm_x17dlc_int_placement_interior_4_x17dlc_int_facility_milo_",
"xm_x17dlc_int_placement_interior_5_x17dlc_int_facility2_milo_",
"xm_x17dlc_int_placement_interior_6_x17dlc_int_silo_01_milo_",
"xm_x17dlc_int_placement_interior_7_x17dlc_int_silo_02_milo_",
"xm_x17dlc_int_placement_interior_8_x17dlc_int_sub_milo_",
"xm_x17dlc_int_placement_interior_9_x17dlc_int_01_milo_",
"xm_x17dlc_int_placement_strm_0",
"xm_bunkerentrance_door",
"xm_hatch_closed",
"xm_hatches_terrain",
"xm_hatches_terrain_lod",
"xm_mpchristmasadditions",
"xm_siloentranceclosed_x17",
}

IPLS.ImpExp = {
"imp_dt1_02_cargarage_a",
"imp_dt1_02_cargarage_b",
"imp_dt1_02_cargarage_c",
"imp_dt1_02_modgarage",
"imp_dt1_11_cargarage_a",
"imp_dt1_11_cargarage_b",
"imp_dt1_11_cargarage_c",
"imp_dt1_11_modgarage",
"imp_impexp_interior_placement",
"imp_impexp_interior_placement_interior_0_impexp_int_01_milo_",
"imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_",
"imp_impexp_interior_placement_interior_2_imptexp_mod_int_01_milo_",
"imp_impexp_interior_placement_interior_3_impexp_int_02_milo_",
"imp_sm_13_cargarage_a",
"imp_sm_13_cargarage_b",
"imp_sm_13_cargarage_c",
"imp_sm_13_modgarage",
"imp_sm_15_cargarage_a",
"imp_sm_15_cargarage_b",
"imp_sm_15_cargarage_c",
"imp_sm_15_modgarage",
}

locations.reqscen = {
	{ "Carrier", 3069.330, -4632.4, 15.043 },
	{ "Bunker", 888.430, -3206.1, -99.243, IPLS.bunker , {}, false },
	{ "ImportExport", -98.21, -853.1, 40.243, IPLS.ImpExp , {}, false },
	{ "Lab test", 244.0, 6163.1, -159.0, IPLS.lab , {}, false },
	{ "Fort Zancudo UFO", -2052.000, 3237.000, 1456.973, { "ufo", "ufo_lod", "ufo_eye" }, {}, false },
	--{ "Heist Yacht", -2043.974, -1031.582, 11.981, IPLS.heistyacht, {}, false },
	{ "North Yankton", 3360.19, -4849.67, 111.8, IPLS.north_yankton, {}, false },
	{ "North Yankton Bank", 5309.519, -5212.375, 83.522, IPLS.north_yankton, {}, false },
	{ "SS Bulker (Intact)", -163.749, -2377.94, 9.3192, { "cargoship" }, { "sunkcargoship" }, false },
	{ "SS Bulker (Sunk)", -162.8918, -2365.769, 0.0, { "sunkcargoship" }, { "cargoship" }, false },
	{ "Train Crash Bridge", -532.1309, 4526.187, 88.7955, { "canyonriver01_traincrash", "railing_end" }, { "railing_start", "canyonriver01" }, false },
	{ "Yacht", -2023.661, -1038.038, 5.577 },
}

locations.broken = {
	{ "Carrier", 3069.330, -4704.220, 15.043, IPLS.carrier, {}, false },
	{ "Director Mod Trailer", -20.004, -10.889, 500.602 },
}


locations.categories = {
	["Safehouses"] = locations.safeHouses,
	["Landmarks"] = locations.landmarks,
	["Roof/High Up"] = locations.high,
	["Underwater"] = locations.underwater, 
	["Interiors"] = locations.interiors, 
	["Extra Exterior Scenery"] = locations.reqscen
}


--[[------------------------------------------------------------------------
	Teleport to location 
------------------------------------------------------------------------]]--

locations.current = nil -- Holds the current location 
locations.old = nil     -- Holds the old location

function teleportToLocation(category,index)
	locations.old = locations.current
	local destination = locations.categories[category][index]

	-- Get Entity to Teleport
	local targetPed = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = GetVehiclePedIsUsing(targetPed)
	end

	-- If it has a 5th option then it requires locations.
	if(destination[5])then
		local required = destination[5]
		local removeThese = destination[6]
		local isLoaded = destination[7]

		if(not isLoaded)then
			-- Load the IPL before teleporting them.
			drawNotification("Loading scenery...")

			-- Remove requested IPLs
			if(getTableLength(removeThese) > 0)then
				for index,value in ipairs(removeThese)do
					if(IsIplActive(value))then
						RemoveIpl(value)
					end
				end
			end

			-- Add Required IPLs
			if(getTableLength(required) > 0)then
				for index,value in ipairs(required)do
					if(IsIplActive(value) == false)then
						RequestIpl(value)
					end
				end
			end
			drawNotification("Scenery Loaded!")
			destination.isLoaded = true
		end
	end

	SetEntityCoordsNoOffset( targetPed, destination[2], destination[3], destination[4], false, false, true )



	--local coords = {}
	--coords.x = destination[2]
	--coords.y = destination[3]
	--coords.z = destination[4]

	-- TeleportToCoords(targetPed, coords)

	if(locations.old ~= nil)then
		if(locations.old[6] ~= nil)then
			drawNotification("Unloading old scenery...")
			local removeList = locations.old[6]
			local keepList = {}
			-- Don't remove needed IPLs
			if(destination[5])then
				keepList = tableSet(destination[5])
			end
			if(getTableLength(removeList) > 0)then
				for index,value in ipairs(removeList)do
					if(keepList[value] == nil and IsIplActive(value))then
						RemoveIpl(value)
					end
				end
			end
			locations.old[7] = false
			drawNotification("Scenery Unloaded")
		end
	end

	locations.current = destination
end


function createLocationJSON()
	local jsonList = {}
	local count = 0
	for key,value in pairs(locations.categories) do
		local options = {}
		-- Create the submenu for all locations under each category.
		for index,currentObj in pairs(value)do
			local curOpt = {
				["menuName"] = currentObj[1],
				["data"] = {
					["action"] = "locationteleport "..tostring(index).." "..key -- Key may contain spaces so add to end
				}
			}
			table.insert(options,curOpt)
		end

		table.insert(jsonList, {
			["menuName"] = key,
			["data"] = {
				["sub"] = count
			},
			["submenu"] = options
		})
		count = count + 1
	end

	local customJSON = "{}"

    if ( getTableLength( jsonList ) > 0 ) then
        customJSON = json.encode( jsonList, { indent = true } )
    end
 
    SendNUIMessage( {
        createmenu = true,
        menuName = "createlocationsmenu",
        menudata = customJSON
    })
end

RegisterNUICallback("createlocationsmenu", function()
	createLocationJSON()
end)



RegisterNUICallback("locationteleport", function( data, cb )
	local index = tonumber(data.data[2])
	local category = table.concat(data.data, " ", 3)

	teleportToLocation(category, index)

	if(cb)then cb("ok")end
end)