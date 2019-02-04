Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = true
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale = 'en'

Config.MafiaStations = {

  Mafia = {

    Blip = {
--      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL',     price = 30000 },
      { name = 'WEAPON_ASSAULTSMG',       price = 1125000 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 1500000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 600000 },
      { name = 'WEAPON_STUNGUN',          price = 50000 },
      { name = 'WEAPON_FLASHLIGHT',       price = 800 },
      { name = 'WEAPON_STICKYBOMB',       price = 200000 },
      { name = 'WEAPON_GRENADE',          price = 180000 },
      { name = 'WEAPON_BZGAS',            price = 120000 },
      { name = 'WEAPON_SMOKEGRENADE',     price = 100000 },
      { name = 'WEAPON_APPISTOL',         price = 70000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 1100000 },
    },

	  AuthorizedVehicles = {
		  { name = 'schafter3',  label = 'Véhicule Civil' },
		  { name = 'sandking',   label = '4X4' },
		  { name = 'mule3',      label = 'Camion de Transport' },
		  { name = 'guardian',   label = 'Grand 4x4' },
		  { name = 'burrito3',   label = 'Fourgonnette' },
		  { name = 'mesa',       label = 'Tout-Terrain' },
	  },

    Cloakrooms = {
      { x = 564.4046, y = -3126.838, z = 17.7686 },
    },

    Armories = {
      { x = 563.2125, y = -3121.073, z = 17.76863 },
    },

    Vehicles = {
      {
        Spawner    = { x = 491.9314, y = -3049.182, z = 5.11084 },
        SpawnPoint = { x = 491.9314, y = -3049.182, z = 5.11084 },
        Heading    = 0.22770504653454,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 9020.312, y = 9535.667, z = 9173.627 },
        SpawnPoint = { x = 9993.40, y = 9525.56, z = 9177.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 476.4188, y = -3047.67, z = 5.094548 },
    },

    BossActions = {
      { x = 575.0113, y = -3126.784, z = 18.76859 }
    },

  },

}