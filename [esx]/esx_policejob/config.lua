Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true
Config.MaxInService               = -1
Config.Locale = 'en'
--enableOtherCopsBlips = true,

Config.PoliceStations = {

  LSPD = {
	Blips = {
		Blip = {
		  Pos     = { x = 425.130, y = -979.558, z = 30.711 },
		  Sprite  = 60,
		  Display = 4,
		  Scale   = 1.2,
		  Colour  = 29,
		},
		 Blip2 = {
		  Pos     = { x = -1063.964, y = -846.264, z = 5.042164 },
		  Sprite  = 60,
		  Display = 4,
		  Scale   = 1.2,
		  Colour  = 29,
		},

		 Blip3 = {
		  Pos     = { x = 535.3461, y = -33.24132, z = 70.64235 },
		  Sprite  = 60,
		  Display = 4,
		  Scale   = 1.2,
		  Colour  = 29,
		},
		 Blip4 = {
		  Pos     = { x = 378.7132, y =-1610.294 , z =29.29195  },
		  Sprite  = 60,
		  Display = 4,
		  Scale   = 1.2,
		  Colour  = 29,
		},
		 Blip5 = {
		  Pos     = { x =-1189.957 , y =-1806.324 , z =2.908575  },
		  Sprite  = 60,
		  Display = 4,
		  Scale   = 1.2,
		  Colour  = 29,
		},
       Blip6 = {
      Pos     = { x =112.6559 , y =-749.5986 , z =45.75159  },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },
	},

    AuthorizedWeapons = {
      { name = 'WEAPON_NIGHTSTICK',       price = 125 },
      { name = 'WEAPON_COMBATPISTOL',     price = 2500 },
      { name = 'WEAPON_HEAVYPISTOL',      price = 2500 },
      { name = 'WEAPON_CARBINERIFLE',     price = 7500 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 2000 },
      { name = 'WEAPON_STUNGUN',          price = 250 },
      { name = 'WEAPON_FLARE',          price = 250 },
      { name = 'WEAPON_FLASHLIGHT',       price = 100 },
      { name = 'WEAPON_FIREEXTINGUISHER', price = 350 },
      { name = 'WEAPON_SMG',              price = 500 },
      { name = 'WEAPON_BZGAS',            price = 200 },
      {	name = 'WEAPON_HEAVYSNIPER',      price = 200 },
      { name = 'WEAPON_PISTOL_MK2',       price = 200 },
	},

    AuthorizedVehicles = {
      { name = 'police',  label = 'Patrol vehicle 1' },
      { name = 'police2', label = 'Patrol vehicle 2' },
      { name = 'police3', label = 'Patrol vehicle 3' },
      { name = 'police4', label = 'Patrol Vehicle 4' },
      { name = 'policeb', label = 'Bike' },
      { name = 'p1200rt', label = 'Police Bike' },
      { name = 'policet', label = 'Transport Van' },
    },

    Cloakrooms = {
      { x = 456.850, y = -991.306, z = 29.750 },

      --hanger---
       { x = -1237.873, y =-3381.932 , z =12.94016  },
      
	--Vispucci Blvd
        { x = -1057.367, y =-841.2279 , z =4.042201  },
	--Meteor st sub
       { x = 534.3065, y =-22.54304 , z = 69.62951 },
	--Sandy Shores
      { x = 1857.74, y = 3688.0, z = 33.3 },
	--innocence blvd
       { x = 370.3672, y =-1608.784 , z =28.29195 },
	--Paleto Station
      { x = -448.6, y = 6017.8, z = 30.8 },
      --bay City Boat Launch
       { x = -1189.957 , y =-1806.324 , z =2.908575 },
         { x = 2063.918 , y = 2933.058 , z =-62.90179 },
    },

    Armories = {
      { x = 452.3714, y =-980.0177 , z = 29.68958 },
--state building
         { x = 2071.958, y =2933.825 , z = -62.90179 },

	--Sandy Shores
      { x = 1849.4, y = 3689.15, z = 33.3 },
	--Paleto Station
      { x = -447.8, y = 6008.8, z = 30.8 },
--firing range
        { x = 18.27839, y = -1100.742, z = 28.79703 },
    },
--bay city boat launch
    Vehicles = {

      {        
        Spawner    = { x =-1197.91 , y =-1807.72 , z =2.908329  },
        SpawnPoint = { x =-1278.459 , y =-1822.163 , z =-1.5709134  },
        Heading    = 90.0,
      },


 {        
        Spawner    = { x = 454.69, y = -1017.4, z = 27.430 },
        SpawnPoint = { x = 438.42, y = -1018.3, z = 27.757 },
        Heading    = 90.0,
      },


	--Meteor st police subdivison

 {        
        Spawner    = { x = 530.6137, y = -24.52353, z = 69.62953 },
        SpawnPoint = { x = 534.1624, y = -36.32261, z = 70.65076 },
        Heading    = 35,
      },



--pelato Helipad
 {        
        Spawner    = { x = -466.9169, y =5994.564 , z =30.2698  },
        SpawnPoint = { x = -471.7448, y =5984.73 , z =29.33671  },
        Heading    = 35,
      },




--FBI Building
       {        
        Spawner    = { x = 404.5887, y = -962.0422, z = -100.00419 },
        SpawnPoint = { x = 123.4614, y = -729.5911, z = 32.13324 },
        Heading    = 75,
      },


       {        
        Spawner    = { x = -1072.721, y =-853.8751 , z =3.868867  },
        SpawnPoint = { x = -1068.497, y = -858.3759, z =4.867543  },
        Heading    = 35,
      },

	--Sandy Shores
      {   
        Spawner  = { x = 1858.07, y = 3676.0, z = 32.65 },
        SpawnPoint = { x = 1851.5, y = 3672.4, z = 32.65 },     
        Heading    = 208.0,
      },

      {   
        Spawner  = { x = 377.3385, y =-1631.015 , z =28.0832  },
        SpawnPoint = { x =384.1173 , y =-1622.626 , z =29.29195  },     
        Heading    = 208.0,
      },

	--Paleto Station
      {   
        Spawner  = { x = -465.8, y = 6020.2, z = 30.6 },
        SpawnPoint = { x = -470.23, y = 6033.1, z = 30.6 },     
        Heading    = 222.0,
      },

     },
  
    Helicopters = {
      {
        Spawner    = { x = 128.1844, y =-732.078 , z =262.8448  },
        SpawnPoint = { x = 123.1603, y = -74.6059, z = 262.846 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      --{ x = 462.74, y = -1014.4, z = 27.065 },
      --{ x = 462.40, y = -1019.7, z = 27.104 },
      --Sandy Shores
     -- { x = 1868.0, y = 3697.0, z = 32.75 },
      --Paleto Station
      --{ x = -476.5, y = 6022.4, z = 30.6 },
    },

  

 BossActions = {
      { x = 451.9745, y =-973.6496 , z =30.1896  }
    },

  },

}

Config.Uniforms = {
    
  cadet_wear = {
    male = {
        ['tshirt_1'] = 59,  ['tshirt_2'] = 1,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 41,
        ['pants_1'] = 25,   ['pants_2'] = 0,
        ['shoes_1'] = 25,   ['shoes_2'] = 0,
        ['helmet_1'] = 46,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    },
    female = {
        ['tshirt_1'] = 36,  ['tshirt_2'] = 1,
        ['torso_1'] = 48,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 44,
        ['pants_1'] = 34,   ['pants_2'] = 0,
        ['shoes_1'] = 27,   ['shoes_2'] = 0,
        ['helmet_1'] = 45,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    }
  },
  police_wear = {
    male = {
        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 41,
        ['pants_1'] = 25,   ['pants_2'] = 2,
        ['shoes_1'] = 25,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    },
    female = {
        ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
        ['torso_1'] = 48,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 44,
        ['pants_1'] = 34,   ['pants_2'] = 0,
        ['shoes_1'] = 27,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    }
  },
  sergeant_wear = {
    male = {
        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 8,   ['decals_2'] = 1,
        ['arms'] = 41,
        ['pants_1'] = 25,   ['pants_2'] = 2,
        ['shoes_1'] = 25,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    },
    female = {
        ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
        ['torso_1'] = 48,   ['torso_2'] = 0,
        ['decals_1'] = 7,   ['decals_2'] = 1,
        ['arms'] = 44,
        ['pants_1'] = 34,   ['pants_2'] = 0,
        ['shoes_1'] = 27,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    }
  },
  lieutenant_wear = {
    male = {
        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 8,   ['decals_2'] = 2,
        ['arms'] = 41,
        ['pants_1'] = 25,   ['pants_2'] = 2,
        ['shoes_1'] = 25,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    },
    female = {
        ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
        ['torso_1'] = 48,   ['torso_2'] = 0,
        ['decals_1'] = 7,   ['decals_2'] = 2,
        ['arms'] = 44,
        ['pants_1'] = 34,   ['pants_2'] = 0,
        ['shoes_1'] = 27,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    }
  },
  commandant_wear = {
    male = {
        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 8,   ['decals_2'] = 3,
        ['arms'] = 41,
        ['pants_1'] = 25,   ['pants_2'] = 2,
        ['shoes_1'] = 25,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    },
    female = {
        ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
        ['torso_1'] = 48,   ['torso_2'] = 0,
        ['decals_1'] = 7,   ['decals_2'] = 3,
        ['arms'] = 44,
        ['pants_1'] = 34,   ['pants_2'] = 0,
        ['shoes_1'] = 27,   ['shoes_2'] = 0,
        ['helmet_1'] = -1,  ['helmet_2'] = 0,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 2,     ['ears_2'] = 0
    }
  },

  bullet_wear = {
    male = {
        ['bproof_1'] = 11,  ['bproof_2'] = 1
    },
    female = {
        ['bproof_1'] = 13,  ['bproof_2'] = 1
    }
  },
  gilet_wear = {
    male = {
        ['tshirt_1'] = 59,  ['tshirt_2'] = 1
    },
    female = {
        ['tshirt_1'] = 36,  ['tshirt_2'] = 1
    }
  },
  format_hat = {
    male = {
        ['helmet_1'] = 46,  ['helmet_2'] = 0,
    },
    female = {
        ['helmet_1'] = 45,  ['helmet_2'] = 0,
    }
  },
  formal_hat = {
    male = {
        ['helmet_1'] = 46,  ['helmet_2'] = 0,
    },
    female = {
        ['helmet_1'] = 45,  ['helmet_2'] = 0,
    }
  },
  swat_wear_freemode = {
    male = {
        ['helmet_1'] = 0,  ['helmet_2'] = 0,
    },
    female = {
        ['helmet_1'] = 0,  ['helmet_2'] = 0,
    }
  }

}

Config.Outfits = {
      ['LSPD Detective (Vest)'] = {
        male = {
          category = 'LSPD',
          ped = 'mp_m_freemode_01',
          props = {
              { 0, 0, 0 },
              { 1, 7, 1 },
              { 2, 0, 0 },
              { 3, 0, 0 },
          },
          components = {
              { 1, 1, 1 },
              { 3, 5, 1 },
              { 4, 11, 5 },
              { 5, 1, 1 },
              { 6, 11, 1 },
              { 7, 7, 1 },
              { 8, 42, 2 },
              { 9, 25, 1 },
              { 10, 1, 1 },
              { 11, 4, 1 },
          },
        },
        female = {
          category = 'LSPD',
          ped = 'mp_m_freemode_01',
          props = {
              { 0, 0, 0 },
              { 1, 7, 1 },
              { 2, 0, 0 },
              { 3, 0, 0 },
          },
          components = {
              { 1, 1, 1 },
              { 3, 5, 1 },
              { 4, 11, 5 },
              { 5, 1, 1 },
              { 6, 11, 1 },
              { 7, 7, 1 },
              { 8, 42, 2 },
              { 9, 25, 1 },
              { 10, 1, 1 },
              { 11, 4, 1 },
          },
        }
    },
    ['LSPD Uniform (Short Sleeve)'] = {
      male = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 0, 0 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 4, 1 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 1, 1 },
            { 4, 36, 1 },
            { 5, 49, 1 },
            { 6, 52, 1 },
            { 7, 9, 1 },
            { 8, 59, 1 },
            { 9, 14, 1 },
            { 10, 1, 1 },
            { 11, 150, 1 },
        },
      },
      female = {
        category = 'LSPD',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 0, 0 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 15, 1 },
            { 4, 35, 1 },
            { 5, 49, 1 },
            { 6, 53, 1 },
            { 7, 9, 1 },
            { 8, 36, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },
            { 11, 147, 1 },
        },
      }
        
    },
    ['LSPD Windbreaker'] = {
      male = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 0, 0 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 13, 1 },
            { 4, 11, 5 },
            { 5, 49, 1 },
            { 6, 11, 1 },
            { 7, 7, 1 },
            { 8, 12, 1 },
            { 9, 21, 2 },
            { 10, 1, 1 },
            { 11, 36, 2 },
        },
      },
      female = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 0, 0 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 13, 1 },
            { 4, 11, 5 },
            { 5, 49, 1 },
            { 6, 11, 1 },
            { 7, 7, 1 },
            { 8, 12, 1 },
            { 9, 21, 2 },
            { 10, 1, 1 },
            { 11, 36, 2 },
        },
      }
        
    },
    ['LSPD Motorcycle Uniform'] = {
      male = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 18, 2 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 23, 1 },
            { 4, 33, 2 },
            { 5, 49, 1 },
            { 6, 31, 1 },
            { 7, 9, 1 },
            { 8, 58, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },
            { 11, 53, 1 },
        },
      },
      female = {
        category = 'LSPD',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 18, 2 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 15, 1 },
            { 4, 32, 2 },
            { 5, 49, 1 },
            { 6, 10, 1 },
            { 7, 9, 1 },
            { 8, 35, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },
            { 11, 37, 1 },
        },
      }
    },
    ['LSPD K-9 Uniform'] = {
      male = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 11, 7 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 1, 1 },
            { 4, 53, 2 },
            { 5, 49, 1 },
            { 6, 25, 1 },
            { 7, 2, 1 },
            { 8, 38, 1 },
            { 9, 15, 1 },
            { 10, 9, 1 },
            { 11, 103, 1 },
        },
      },
      female = {
        category = 'LSPD',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 0, 0 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 15, 1 },
            { 4, 55, 2 },
            { 5, 49, 1 },
            { 6, 26, 1 },
            { 7, 2, 1 },
            { 8, 3, 1 },
            { 9, 1, 1 },
            { 10, 8, 1 },
            { 11, 94, 1 },
        },
      }
    },
    ['LSPD Pilot Uniform'] = {
      male = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 80, 2 },
            { 1, 1, 1 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 17, 1 },
            { 4, 39, 3 },
            { 5, 49, 1 },
            { 6, 25, 1 },
            { 7, 9, 1 },
            { 8, 68, 1 },
            { 9, 1, 1 },
            { 10, 16, 1 },
            { 11, 66, 3 },
        },
      },
      female = {
        category = 'LSPD',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 79, 2 },
            { 1, 14, 1 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 18, 1 },
            { 4, 39, 3 },
            { 5, 49, 1 },
            { 6, 25, 1 },
            { 7, 9, 1 },
            { 8, 50, 1 },
            { 9, 1, 1 },
            { 10, 15, 1 },
            { 11, 60, 3 },
        },
      }
    },
    ['LSPD SWAT Uniform'] = {
      male = {
        category = 'LSPD',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 76, 1 },
            { 1, 0, 0 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 53, 1 },
            { 3, 97, 1 },
            { 4, 32, 1 },
            { 5, 49, 1 },
            { 6, 26, 1 },
            { 7, 111, 1 },
            { 8, 16, 1 },
            { 9, 16, 1 },
            { 10, 4, 1 },
            { 11, 50, 1 },
        },
      },
      female = {
        category = 'LSPD',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 75, 1 },
            { 1, 26, 1 },
            { 2, 0, 0 },
            { 3, 0, 0 },
        },
        components = {
            { 1, 1, 1 },
            { 3, 112, 1 },
            { 4, 31, 1 },
            { 5, 49, 1 },
            { 6, 26, 1 },
            { 7, 82, 1 },
            { 8, 16, 1 },
            { 9, 18, 1 },
            { 10, 12, 1 },
            { 11, 43, 1 },
        },
      }
    },
}






















