Config                            = {}
Config.DrawDistance               = 100.0
Config.nameJob                    = "eboueur"
Config.nameJobLabel               = "Little Pricks"
Config.platePrefix                = "EBOU"
Config.Locale = 'en'

Config.Blip = {
    Sprite = 318,
    Color = 52
}

Config.Vehicles = {
	Truck = {
		Spawner = 1,
		Label = 'Camion',
		Hash = "trash",
		Livery = 0,
		Trailer = "none",
	}
}

Config.Zones = {

  Cloakroom = {
    Pos     = {x = -429.079, y = -1728.0515, z = 18.7838},
    Size    = {x = 1.5, y = 1.5, z = 0.6},
    Color   = {r = 11, g = 203, b = 159},
    Type    = 1,
	BlipSprite = 318,
	BlipColor = 52,
	BlipName = Config.nameJobLabel.." : Vestiaire",
	hint = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au vestiaire',
  },

  VehicleSpawner = {
	Pos   = {x = -424.1206, y = -1698.0678, z = 18.0759},
	Size  = {x = 1.5, y = 1.5, z = 0.6},
	Color = {r = 11, g = 203, b = 159},
	Type  = 1,
	BlipSprite = 318,
	BlipColor = 52,
	BlipName = Config.nameJobLabel.." : Véhicule",
	hint = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage',
  },

  VehicleSpawnPoint = {
	Pos   = {x = -425.6056, y = -1688.4176, z = 18.0290},
	Size  = {x = 3.0, y = 3.0, z = 1.0},
	Type  = -1,
	Heading = 160.0,
  },

  VehicleDeleter = {
	Pos   = {x = -468.0126, y = -1689.6763, z = 17.9377},
	Size  = {x = 3.0, y = 3.0, z = 0.9},
	Color = {r = 255, g = 0, b = 0},
	Type  = 1,
	BlipSprite = 318,
	BlipColor = 52,
	BlipName = Config.nameJobLabel.." : Retour Véhicule",
	hint = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule',
  },

  Vente = {
	Pos   = {x = -529.9580, y = -1714.5396, z = 18.2570},
	Size  = {x = 10.0, y = 10.0, z = 0.8},
	Color = {r = 11, g = 203, b = 159},
	Type  = 1,
	BlipSprite = 318,
	BlipColor = 52,
	BlipName = Config.nameJobLabel.." : Déchetterie",
		
	ItemTime = 10,
	ItemDb_name = "poubelle",
	ItemName = "poubelle",
	ItemMax = 100,
	ItemAdd = 1,
	ItemRemove = 1,
	ItemRequires = "poubelle",
	ItemRequires_name = "Poubelle",
	ItemDrop = 100,
	ItemPrice  = 50,
	hint = 'Appuyez sur ~INPUT_CONTEXT~ pour décharger les poubelles',
  },

}

Config.Poubelle = {

    { ['x'] = -337.6367, ['y'] = -2786.992, ['z'] = 4.000239},
    { ['x'] = 1050.857,  ['y'] = -2391.396, ['z'] = 29.28452},
    { ['x'] = 1005.835,  ['y'] = -2067.349, ['z'] = 30.13629},
    { ['x'] = 957.2108,  ['y'] = -1912.296, ['z'] = 30.14571},
    { ['x'] = 770.9854,  ['y'] = -1902.144, ['z'] = 28.26986},
    { ['x'] = 969.3815,  ['y'] = -945.3486, ['z'] = 41.29815},
    { ['x'] = 776.6561,  ['y'] = -1054.236, ['z'] = 26.05088},
    { ['x'] = 787.1,     ['y'] = -1323.691, ['z'] = 25.06788},
    { ['x'] = 1089.071,  ['y'] = -449.5304, ['z'] = 64.72475},
    { ['x'] = 617.2553,  ['y'] = 70.19471,  ['z'] = 89.7544},
    { ['x'] = 560.3558,  ['y'] = 171.2989,  ['z'] = 99.2312},
    { ['x'] = 384.0609,  ['y'] = 238.476,   ['z'] = 102.0361},
    { ['x'] = 10.20545,  ['y'] = 4.926725,  ['z'] = 69.6499},
    { ['x'] = 197.3791,  ['y'] = -1092.112, ['z'] = 28.2783},
    { ['x'] = 199.9383,  ['y'] = -1296.267, ['z'] = 28.32153},
    { ['x'] = 272.633,   ['y'] = -1499.289, ['z'] = 28.2916},
    { ['x'] = 263.7913,  ['y'] = -1677.058, ['z'] = 28.30527},
    { ['x'] = 224.064,   ['y'] = -1836.624, ['z'] = 25.95535},
    { ['x'] = 161.0778,  ['y'] = -1876.63,  ['z'] = 22.9732},
    { ['x'] = 41.75639,  ['y'] = -1879.637, ['z'] = 21.21154},
    { ['x'] = -28.13282, ['y'] = -1640.856, ['z'] = 28.29198},
    { ['x'] = -171.739,  ['y'] = -1459.672, ['z'] = 30.68687},
    { ['x'] = -717.054,  ['y'] = -1171.374, ['z'] = 9.46338},
    { ['x'] = -1075.155, ['y'] = -1273.394, ['z'] = 4.829365},
    { ['x'] = -1076.804, ['y'] = -1498.936, ['z'] = 4.104791},
    { ['x'] = -1054.713, ['y'] = -1610.139, ['z'] = 3.399037},
    { ['x'] = -1264.468, ['y'] = -1374.695, ['z'] = 3.17067},
    { ['x'] = -1277.544, ['y'] = -1210.355, ['z'] = 3.724486},
    { ['x'] = -1071.163, ['y'] = -1029.759, ['z'] = 1.091357},
    { ['x'] = -1018.297, ['y'] = -1119.402, ['z'] = 1.120266},
    { ['x'] = -1622.477, ['y'] = -1081.264, ['z'] = 12.01845},
    { ['x'] = -1801.939, ['y'] = -410.1487, ['z'] = 43.5813},
    { ['x'] = -1753.204, ['y'] = -377.5302, ['z'] = 44.74607},
    { ['x'] = -964.1352, ['y'] = -185.0301, ['z'] = 36.80095},
    { ['x'] = -1481.334, ['y'] = 59.09226,  ['z'] = 52.53588},
    { ['x'] = -1629.261, ['y'] = 77.69003,  ['z'] = 60.94693},
    { ['x'] = -1892.951, ['y'] = 185.2168,  ['z'] = 81.59013},
    { ['x'] = -1466.232, ['y'] = 518.6081,  ['z'] = 116.9691},
    { ['x'] = -1298.72,  ['y'] = 627.9941,  ['z'] = 136.7925},
    { ['x'] = -1256.728, ['y'] = 653.576,   ['z'] = 139.9319},
    { ['x'] = -1177.898, ['y'] = 722.7534,  ['z'] = 150.6435},
    { ['x'] = -1111.839, ['y'] = 775.9818,  ['z'] = 161.6958},
    { ['x'] = -979.8621, ['y'] = 694.6163,  ['z'] = 155.8505},
    { ['x'] = -680.5673, ['y'] = 605.562,   ['z'] = 142.9354},
    { ['x'] = -619.3099, ['y'] = 682.4254,  ['z'] = 148.8345},
    { ['x'] = -509.0829, ['y'] = 575.6403,  ['z'] = 118.847},
    { ['x'] = -345.6455, ['y'] = 429.374,   ['z'] = 109.4156},
    { ['x'] = -194.7099, ['y'] = 419.3295,  ['z'] = 108.9558},
    { ['x'] = -215.4222, ['y'] = 276.3777,  ['z'] = 91.04716},
    { ['x'] = -468.5767, ['y'] = 272.7403,  ['z'] = 82.26152},
    { ['x'] = -343.4309, ['y'] = 103.5678,  ['z'] = 65.67259},
    { ['x'] = -287.9857, ['y'] = -95.30598, ['z'] = 46.21479},
    { ['x'] = -359.5632, ['y'] = -145.9291, ['z'] = 37.24692},
    { ['x'] = -147.5077, ['y'] = -747.1575, ['z'] = 32.89324},
    { ['x'] = -246.4445, ['y'] = -1128.171, ['z'] = 22.06822},
    { ['x'] = -294.119,  ['y'] = -1357.757, ['z'] = 30.31021},
    { ['x'] = -894.062,  ['y'] = -2750.131, ['z'] = 12.94431},
    { ['x'] = -1052.065, ['y'] = -2086.243, ['z'] = 12.34221},
    { ['x'] = -1148.458, ['y'] = -1987.686, ['z'] = 12.16035},
    { ['x'] = -589.994,  ['y'] = -1737.421, ['z'] = 21.75804},
    { ['x'] = -240.9282, ['y'] = -1473.415, ['z'] = 30.4771},
    { ['x'] = -171.5853, ['y'] = -1461.888, ['z'] = 30.79383},

}

for i=1, #Config.Poubelle, 1 do

    Config.Zones['Poubelle' .. i] = {
        Pos   = Config.Poubelle[i],
        Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 204, g = 204, b = 0},
        Type  = -1
    }

end

Config.Uniforms = {
    
  job_wear = {
    male = {
        ['tshirt_1'] = 59, ['tshirt_2'] = 1,
		['torso_1'] = 146, ['torso_2'] = 0,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 63,
		['pants_1'] = 36, ['pants_2'] = 0,
		['shoes_1'] = 25, ['shoes_2'] = 0,
		['helmet_1'] = 0, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0
    },
    female = {
        ['tshirt_1'] = 36, ['tshirt_2'] = 1,
		['torso_1'] = 49, ['torso_2'] = 0,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 83,
		['pants_1'] = 35, ['pants_2'] = 0,
		['shoes_1'] = 25, ['shoes_2'] = 0,
		['helmet_1'] = 0, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0
    }
  },
}