Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 200
Config.Locale       = 'en'

Config.Trucks = {
	"faggio",
	--"packer"	
}

Config.Cloakroom = {
	CloakRoom = {
			Pos   = {x = 217.59413146973, y = -28.255523681641, z = 69.713890075684},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1
		},
}

Config.Zones = {
	VehicleSpawner = {
			Pos   = {x = 224.60891723633, y = -32.909862518311, z = 69.719039916992},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1
		},

	VehicleSpawnPoint = {
			Pos   = {x = 231.92344665527, y = -36.398815155029, z = 69.710906982422},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Type  = -1
		},
}

Config.Livraison = {
-------------------------------------------Los Santos
	-- Strawberry avenue et Davis avenue
	Delivery1LS = {
			Pos   = {x = -297.57235717773, y = 380.34313964844, z = 112.09562683105},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- a coté des flic
	Delivery2LS = {
			Pos   = {x = -408.10067749023, y = 342.2233581543, z = 108.90744018555},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- vers la plage
	Delivery3LS = {
			Pos   = {x = -476.02252197266, y = 413.123046875, z = 103.11745452881},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- studio 1
	Delivery4LS = {
			Pos   = {x = -537.06909179688, y = 476.63604736328, z = 103.18890380859},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- popular street et el rancho boulevard
	Delivery5LS = {
			Pos   = {x = -595.23425292969, y = 529.376953125, z = 107.75710296631},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	--Alta street et las lagunas boulevard
	Delivery6LS = {
			Pos   = {x = -667.71569824219, y = 473.0471496582, z = 114.09594726563},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	--Rockford Drive Noth et boulevard del perro
	Delivery7LS = {
			Pos   = {x = -678.66571044922, y = 509.53231811523, z = 113.52593231201},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	--Rockford Drive Noth et boulevard del perro
	Delivery8LS = {
			Pos   = {x = -762.47320556641, y = 432.90899658203, z = 100.05422973633},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	--New empire way (airport)
	Delivery9LS = {
			Pos   = {x = -784.01696777344, y = 458.21362304688, z = 100.17910766602},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	--Rockford drive south
	Delivery10LS = {
			Pos   = {x = -851.62915039063, y = 521.00054931641, z = 90.622337341309},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
------------------------------------------- Blaine County
	-- panorama drive
	Delivery1BC = {
			Pos   = {x = -882.40832519531, y = 518.72192382813, z = 92.428970336914},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- route 68
	Delivery2BC = {
			Pos   = {x = -1241.2220458984, y = 673.47320556641, z = 142.81929016113},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Algonquin boulevard et cholla springs avenue
	Delivery3BC = {
			Pos   = {x = -1100.2305908203, y = 795.48254394531, z = 166.68598937988},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Joshua road
	Delivery4BC = {
			Pos   = {x = -962.90844726563, y = 812.70697021484, z = 177.56622314453},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- East joshua road
	Delivery5BC = {
			Pos   = {x = -824.55249023438, y = 808.07745361328, z = 202.58702087402},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Seaview road
	Delivery6BC = {
			Pos   = {x = -659.22137451172, y = 889.07794189453, z = 229.24899291992},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Paleto boulevard
	Delivery7BC = {
			Pos   = {x = -537.77655029297, y = 820.83099365234, z = 197.5106048584},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Paleto boulevard et Procopio drive
	Delivery8BC = {
			Pos   = {x = -494.19354248047, y = 739.21990966797, z = 163.03114318848},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Marina drive et joshua road
	Delivery9BC = {
			Pos   = {x = -476.33178710938, y = 649.32000732422, z = 144.38667297363},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	-- Pyrite Avenue
	Delivery10BC = {
			Pos   = {x = -608.51910400391, y = 770.73004150391, z = 188.51007080078},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 1000
		},
	
	RetourCamion = {
			Pos   = {x = 235.91499328613, y = -40.914516448975, z = 69.721870422363},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
	
	AnnulerMission = {
			Pos   = {x = 231.03507995605, y = -41.948207855225, z = 69.65306854248},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
}
