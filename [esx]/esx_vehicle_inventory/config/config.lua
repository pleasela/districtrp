--Truck
Config	=	{}

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 0



-- If true, ignore rest of file
Config.WeightSqlBased = false

-- I Prefer to edit weight on the config.lua and I have switched Config.WeightSqlBased to false:

Config.localWeight = {
	bread = 125,
	water = 330,
	wood = 500,
	cutted_wood = 500,
	packaged_plank = 500,
	WEAPON_COMBATPISTOL = 1000, -- poid poir une munnition
	black_money = 1, -- poids pour un argent
	weed = 121000,
    weed_pooch = 122000,
	meth = 121000,
	meth_pooch = 122000,
    coke = 121000,
    coke_pooch = 122000,
	opium = 121000,
	opium_pooch = 122000,
	petrol = 165,
}

Config.VehicleLimit = {
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 70000, --SUV
    [3] = 25000, --Coupes
    [4] = 30000, --Muscle
    [5] = 10000, --Sports Classics
    [6] = 5000, --Sports
    [7] = 5000, --Super
    [8] = 5000, --Motorcycles
    [9] = 90000, --Off-road
    [10] = 120000, --Industrial
    [11] = 70000, --Utility
    [12] = 100000, --Vans
    [13] = 0, --Cycles
    [14] = 5000, --Boats
    [15] = 20000, --Helicopters
    [16] = 0, --Planes
    [17] = 40000, --Service
    [18] = 100000, --Emergency
    [19] = 0, --Military
    [20] = 120000, --Commercial
    [21] = 0, --Trains
}