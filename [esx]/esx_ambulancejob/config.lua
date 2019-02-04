Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 50, g = 200, b = 50 }
Config.BuildingColor                = { r = 152, g = 0, b = 152 }
Config.DeleterColor                = { r = 200, g = 50, b = 50 }
Config.PharmacyColor                = { r = 50, g = 50, b = 200 }
Config.SpawnerColor                = { r = 200, g = 200, b = 50 }

local second = 1000
local minute = 60 * second

-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 0.8 * minute

-- How much time before a menu opens to ask the player if he wants to respawn at hospital now
-- The player is not obliged to select YES, but he will be auto respawn
-- at the end of RespawnDelayAfterRPDeath just above.
Config.RespawnToHospitalMenuTimer   = false
Config.MenuRespawnToHospitalDelay   = 3.5 * minute

Config.EnablePlayerManagement       = true
Config.EnableSocietyOwnedVehicles   = false

Config.NoPenaltyWithoutEMS = true
Config.CountEMSTimer = 5 * second

Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = true
Config.RemoveItemsAfterRPDeath      = true

-- Will display a timer that shows RespawnDelayAfterRPDeath time remaining
Config.ShowDeathTimer               = true

-- The player can have a fine (on bank account)
Config.RespawnFine                  = false
Config.RespawnFineAmount            = 2500

Config.Locale = 'en'

Config.Blip = {
  Pos     = { x = 307.76, y = -1433.47, z = 28.97 },
  Sprite  = 61,
  Display = 4,
  Scale   = 1.2,
  Colour  = 2,
}

Config.HelicopterSpawner = {
  SpawnPoint  = { x = 313.33, y = -1465.2, z = 45.5 },
  Heading     = 0.0
}

--Size = { x = 1.5, y = 1.5, z = 0.4 }
Config.CloakRooms = { -- CLOAKROOM
	--Davis
	{x = 305.7, y = -1456.45, z = 29.0},
	--Capital Medical
	{x = 1147.21, y = -1523.86, z = 33.7},
	--Paleto Bay
	{x = -242.21, y = 6325.89, z = 31.42},
	--Sandy Shores
	{x = 1836.29, y = 3671.13, z = 33.27},
	--Matrix MC
	{x = -498.83, y = -342.91, z = 33.37},
	
	--Pillbox Lower
	{x = 355.95, y = -596.48, z = 27.69},
	--Pillbox Upper
	{x = 299.94, y = -573.64, z = 42.18},
}

Config.VehicleSpawners = {
	--Davis
	{x = 318.9, y = -1449.8, z = 28.75, heading = 228.4},
	--Capital Medical
	{x = 1150.4, y = -1495.77, z = 33.7, heading = 359.0},
	--Paleto Bay
	{x = -242.27, y = 6336.83, z = 31.42, heading = 44.6},
	--Sandy Shores
	{x = 1842.4, y = 3667.1, z = 32.68, heading = 217.9},
	--Matrix MC
	{x = -478.2, y = -338.48, z = 33.37, heading = 172.11},
	
	--Pillbox Lower
	{x = 364.94, y = -590.71, z = 27.69, heading = 160.2},
	--Pillbox Upper
	{x = 291.18, y = -588.58, z = 42.18, heading = 336.6},
	
	--~~FIRE~~--
	--Davis
	{x = 208.09, y = -1654.9, z = 28.8, heading = 319.37},
	--Capital
	{x = 1204.92, y = -1475.3, z = 33.86, heading = 360.0},
	--Rockford Hills
	{x = -625.15, y = -75.31, z = 39.54, heading = 354.64},
	--Sandy
	{x = 1695.35, y = 3589.39, z = 34.62, heading = 205.96},
	--Paleto
	{x = -370.7, y = 6128.38, z = 30.44, heading = 40.91},
}
  
Config.VehicleDeleters = {
	--Davis
	--[[{x = 295.4, y = -1440.1, z = 28.75},
	--Capital Medical
	{x = 1196.4, y = -1491.65, z = 33.7},
	--Paleto Bay
	{x = -253.41, y = 6348.5, z = 31.42},
	--Sandy Shores
	{x = 1869.22, y = 3694.5, z = 32.68},
	--Matrix MC
	{x = -467.5, y = -339.22, z = 33.37},
	
	--Pillbox
	{x = 341.41, y = -561.45, z = 27.69},]]
}

Config.Pharmacys = {
	--Davis
	{x = 307.7, y = -1433.7, z = 28.75},
	--Capital Medical
	{x = 1151.1, y = -1529.7, z = 34.25},
	--Paleto Bay
	{x = -247.66, y = 6331.38, z = 31.42},
	--Sandy Shores
	{x = 1842.37, y = 3674.7, z = 33.27},
	--Matrix MC
	{x = -498.03, y = -335.83, z = 33.37},
	
	--Pillbox Lower
	{x = 360.3, y = -585.1, z = 27.69},
	--Pillbox Upper
	{x = 298.56, y = -584.61, z = 42.18},
}

Config.Zones = {

  HospitalInteriorEntering1 = { -- ok
    Pos  = { x = 294.6, y = -1448.01, z = 28.9 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 1
  },

  HospitalInteriorInside1 = { -- ok
    Pos  = { x = 272.8, y = -1358.8, z = 23.5 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorOutside1 = { -- ok
    Pos  = { x = 295.8, y = -1446.5, z = 28.9 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorExit1 = { -- ok
    Pos  = { x = 275.7, y = -1361.5, z = 23.5 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 1
  },

  HospitalInteriorEntering2 = { -- Ascenseur aller au toit
    Pos  = { x = 247.1, y = -1371.4, z = 23.5 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 1
  },

  HospitalInteriorInside2 = { -- Toit sortie
    Pos  = { x = 333.1,  y = -1434.9, z = 45.5 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorOutside2 = { -- Ascenseur retour depuis toit
    Pos  = { x = 249.1,  y = -1369.6, z = 23.5 },
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Type = -1
  },

  HospitalInteriorExit2 = { -- Toit entrée
    Pos  = { x = 335.5, y = -1432.0, z = 45.5 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 1
  },

  ParkingDoorGoOutInside = {
    Pos  = { x = 234.56, y = -1373.77, z = 20.97 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 1
  },

  ParkingDoorGoOutOutside = {
    Pos  = { x = 320.98, y = -1478.62, z = 28.81 },
    Size = { x = 1.5, y = 1.5, z = 1.5 },
    Type = -1
  },

  ParkingDoorGoInInside = {
    Pos  = { x = 238.64, y = -1368.48, z = 23.53 },
    Size = { x = 1.5, y = 1.5, z = 1.5 },
    Type = -1
  },

  ParkingDoorGoInOutside = {
    Pos  = { x = 317.97, y = -1476.13, z = 28.97 },
    Size = { x = 1.5, y = 1.5, z = 0.4 },
    Type = 1
  },

  StairsGoTopTop = {
    Pos  = { x = 251.91, y = -1363.3, z = 38.53 },
    Size = { x = 1.5, y = 1.5, z = 1.5 },
    Type = -1
  },

  StairsGoTopBottom = {
    Pos  = { x = 237.45, y = -1373.89, z = 26.30 },
    Size = { x = 3.5, y = 3.5, z = 0.4 },
    Type = -1
  },

  StairsGoBottomTop = {
    Pos  = { x = 256.58, y = -1357.7, z = 37.30 },
    Size = { x = 3.5, y = 3.5, z = 0.4 },
    Type = -1
  },

  StairsGoBottomBottom = {
    Pos  = { x = 240.94, y = -1369.91, z = 23.53 },
    Size = { x = 1.5, y = 1.5, z = 1.5 },
    Type = -1
  },
}
