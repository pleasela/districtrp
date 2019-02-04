Config = {}
Config.DrawDistance = 100.0
Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = true
Config.RequiredCops = 1
Config.RequiredThieves = 1
Config.CooldownOnStealingCar = 45 * 60
Config.AmountOfTimeBlipWillFollowStolenCar = 5*60 
Config.EnableCitizenInteraction = true -- Handcuff and search
Config.EnableVehicleInteraction = true -- Pick car lock


Config.Zones = {

  SellCar = {
    Pos   = {x = -82.039, y = 363.687, z = 111.684},
    Size  = {x = 3.5, y = 3.5, z = 2.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },

  CarthiefOptions = {
    Pos   = {x = -43.039, y = 309.687, z = 111.684},
    Size  = {x = 2.0, y = 2.0, z = 1.0},
    Color = {r = 0, g = 204, b = 0},
    Type  = 1
  },

  StealCarPosition1 = {
    Pos   = {x = -168.000, y = 916.000, z = 234.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1
  },

  StealCarPosition2 = {
    Pos   = {x = -708.000, y = 643.000, z = 154.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1
  },

  StealCarPosition3 = {
    Pos   = {x = -95.000, y = -869.000, z = 25.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1
  },

  StealCarPosition4 = {
    Pos   = {x = 950.000, y = -517.000, z = 59.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1
  },

  StealCheapCarPosition = {
    Pos   = {x = 33.000, y = 6596.000, z = 31.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1
  },

  DropOffPoint = {
    Pos   = {x = 1118.000, y = -3134.000, z = 6.200},
    Size  = {x = 0.0, y = 0.0, z = 0.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1
  },

  DropOffPointCheapCar = {
    Pos   = {x = 136.000, y = -1050.000, z = 28.200},
    Size  = {x = 3.5, y = 3.5, z = 2.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },

}

Config.Cars = {
  {
    Pos   = {x = -169.200, y = 932.200, z = 234.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1,
    Car   = 'reaper',
    CarName = 'Pegassi Reaper',
    Heading = 310.0,
    Value = 129000
  },
  {
    Pos   = {x = -721.200, y = 647.200, z = 154.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1,
    Car   = 't20',
    CarName = 'Progen T20',
    Heading = 345.0,
    Value = 129000
  },
  {
    Pos   = {x = -110.200, y = -878.200, z = 29.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1,
    Car   = 'infernus',
    WheelType = 5,
    CarName = 'Lamborghini',
    Heading = 168.0,
    Value = 149000
  },
  {
    Pos   = {x = 953.200, y = -508.200, z = 61.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1,
    Car   = 'stingergt',
    CarName = 'Classic Truffade Z-Type',
    Heading = 31.0,
    Value = 135900
  },
  {
    Pos   = {x = 33.200, y = 6609.200, z = 33.200},
    Size  = {x = 2.5, y = 2.5, z = 1.0},
    Color = {r = 204, g = 25, b = 25},
    Type  = 1,
    Car   = 'verlierer2',
    CarName = 'Verlier 2',
    Heading = 220.0,
    Value = 5900
  }
}

-- MENU
Config.STRING_VEHICLE_INTERACTION = 'Vehicle Interaction'
Config.STRING_CITIZEN_INTERACTION = 'Citizen Interaction'
Config.STRING_CARTHIEF_MENU_TITLE = 'Car Thief'
Config.STRING_SEARCH = 'Search'
Config.STRING_HANDCUFF = 'Handcuff'
Config.STRING_PICK_LOCK = 'Pick Lock'
Config.STRING_CARTHIEF_INVENTORY = 'Carthief Inventory'
Config.STRING_AMOUNT = 'Amount'
Config.STRING_INVALID_QUANTITY = 'Invalid Quantity'
Config.STRING_STORE_WEAPON = 'Store Weapon'
Config.STRING_RETRIEVE_WEAPON = 'Retrieve Weapon'
Config.STRING_WITHDRAW_ITEM = 'Withdraw Item'
Config.STRING_STORE_ITEM = 'Store Item'
Config.STRING_CONFISCATE_DIRTY_MONEY = 'Confiscate dirty money'
Config.STRING_CONFISCATE = 'Confiscate'
Config.STRING_HAVE_WITHDRAWN = 'have withdrawn '
Config.STRING_ADDED = 'added '

-- MESSAGES
Config.STRING_NO_PLAYERS_NEARBY = 'No players nearby'
Config.STRING_VEHICLE_UNLOCKED = 'Vehicle unlocked'
Config.STRING_SELL_VEHICLE_MSG = 'Press E to sell vehicle'
Config.STRING_STEAL_VEHICLE_MSG = 'Press E to steal a vehicle'
Config.STRING_ACCESS_INVENTORY_MSG = 'Press E to access inventory'
Config.STRING_DELIVER_CAR = 'Deliver the car at the mark!'
Config.STRING_NO_HEAT = 'This car has no heat!'
Config.STRING_LOSE_HEAT = 'Lose the heat!'
Config.STRING_POLICE_MSG_P1 = 'VEHICLE THEFT IN PROGRESS - VEHICLES LAST SEEN POINT MARKED ON YOUR MAP - VEHICLE STOLEN IS A '
Config.STRING_POLICE_MSG_P2 = ' - WITH PLATE NUMBER '
Config.STRING_SIT_CAR = 'You must sit in a car'
Config.STRING_WRONG_VEHICLE = 'Wrong vehicle'
Config.STRING_INSUFF_POLICE = 'Not enough police and/or car buyers online'
Config.STRING_COOLDOWN_P1 = 'You need to wait '
Config.STRING_COOLDOWN_P2 = ' seconds'
Config.STRING_SOLD_CAR_VALUE = 'You sold the car for $'