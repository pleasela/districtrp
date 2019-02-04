--[[ Layout



	["Name"]={name="Name",
	currentMoney=500, -- starting money
	maxMoney=5000, -- maximum money the store can hold
	moneyRengerationRate=100, -- how much money is gained Per Minute
	takesMoneyToBankOnMax=true, -- If the place transfers money to bank every 30 minutes
	isBank=false, -- is the place a bank
	bankToDeliverToo="Legion Flecca Bank Vault", -- what bank to deliver to if the takesMoenyToBank is true
	},

]]

local watchList = {}

local nationUnderCooldown = false
local nationCooldownTime = 2700
local nationCooldownTimer = 0

local nationAttemptUnderCooldown = false
local nationAttemptCooldownTime = 1500
local nationAttemptCooldownTimer = 0

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

robbableSpots = {
	["Little Seoul 24/7 Register #1"]={name="Little Seoul 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},

	["Little Seoul 24/7 Register #2"]={name="Little Seoul 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},

	["Little Seoul 24/7 Safe"]={name="Little Seoul 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},

	["Algonquin 24/7 Register"]={name="Algonquin 24/7 Register",
	currentMoney=10000,
	maxMoney=10000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	bankToDeliverToo="Route 68 Flecca Bank Vault",
	},

	["Mirror Park 24/7 Register #1"]={name="Mirror Park 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	bankToDeliverToo="East Hawick Flecca Bank Vault",
	},
	["Mirror Park 24/7 Register #2"]={name="Mirror Park 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="East Hawick Flecca Bank Vault",
	},
	["Mirror Park 24/7 Safe"]={name="Mirror Park 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="East Hawick Flecca Bank Vault",
	},

	["Downtown Vinewood 24/7 Register #1"]={name="Downtown Vinewood 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Pacific Standard Bank Vault",
	},
	["Downtown Vinewood 24/7 Register #2"]={name="Downtown Vinewood 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Pacific Standard Bank Vault",
	},
	["Downtown Vinewood 24/7 Safe"]={name="Downtown Vinewood 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Pacific Standard Bank Vault",
	},

	["Rockford Dr 24/7 Register #1"]={name="Rockford Dr 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Grean Ocean Hwy Flecca Bank Vault",
	},
	["Rockford Dr 24/7 Register #2"]={name="Rockford Dr 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Grean Ocean Hwy Flecca Bank Vault",
	},
	["Rockford Dr 24/7 Safe"]={name="Rockford Dr 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Grean Ocean Hwy Flecca Bank Vault",
	},

	["South Senora Fwy 24/7 Register #1"]={name="South Senora Fwy 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Route 68 Flecca Bank Vault",
	},
	["South Senora Fwy 24/7 Register #2"]={name="South Senora Fwy 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Route 68 Flecca Bank Vault",
	},
	["South Senora Fwy 24/7 Safe"]={name="South Senora Fwy 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Route 68 Flecca Bank Vault",
	},

	["North Senora Fwy 24/7 Register #1"]={name="North Senora Fwy 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Blaine County Savings Vault",
	},
	["North Senora Fwy 24/7 Register #2"]={name="North Senora Fwy 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Blaine County Savings Vault",
	},
	["North Senora Fwy 24/7 Safe"]={name="North Senora Fwy 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Blaine County Savings Vault",
	},

	["Route 68 24/7 Register #1"]={name="Route 68 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Grean Ocean ",
	},
	["Route 68 24/7 Register #2"]={name="Route 68 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Grean Ocean ",
	},
	["Route 68 24/7 Safe"]={name="Route 68 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Grean Ocean ",
	},

	["Innocence Blvd 24/7 Register #1"]={name="Innocence Blvd 24/7 Register #1",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},
	["Innocence Blvd 24/7 Register #2"]={name="Innocence Blvd 24/7 Register #2",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},
	-- ["Innocence Blvd 24/7 Register #2"]={name="Innocence Blvd 24/7 Register #2",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=10,
	-- timerLeft=0,
	-- bankToDeliverToo="Legion Flecca Bank Vault",
	-- },
	["Innocence Blvd 24/7 Safe"]={name="Innocence Blvd 24/7 Safe",
	currentMoney=2000,
	maxMoney=25000,
	moneyRengerationRate=350, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},


	--CLUBS

	-- ["Bahama Mamas Cash Register #1"]={name="Bahama Mamas Cash Register #1",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="West Hawick Flecca Bank Vault",
	-- },
	-- ["Bahama Mamas Cash Register #2"]={name="Bahama Mamas Cash Register #2",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="West Hawick Flecca Bank Vault",
	-- },
	-- ["Bahama Mamas Cash Register #3"]={name="Bahama Mamas Cash Register #3",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="West Hawick Flecca Bank Vault",
	-- },
	-- ["Bahama Mamas Cash Register #4"]={name="Bahama Mamas Cash Register #4",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="West Hawick Flecca Bank Vault",
	-- },
	-- ["Bahama Mamas Cash Register #5"]={name="Bahama Mamas Cash Register #5",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="West Hawick Flecca Bank Vault",
	-- },
	-- ["Bahama Mamas Cash Register #6"]={name="Bahama Mamas Cash Register #6",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="West Hawick Flecca Bank Vault",
	-- },

	-- ["Tequilala Register"]={name="Tequilala Register",
	-- currentMoney=500,
	-- maxMoney=5000,
	-- moneyRengerationRate=100, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="Pacific Standard Bank Vault",
	-- },
	-- ["Tequilala Safe"]={name="Tequilala Safe",
	-- currentMoney=3000,
	-- maxMoney=15000,
	-- moneyRengerationRate=250, -- Per Minute
	-- takesMoneyToBankOnMax=true,
	-- isBank=false,
	-- underCooldown=false,
	-- cooldownTime=14400,
	-- timerLeft=0,
	-- bankToDeliverToo="Pacific Standard Bank Vault",
	-- },









--- LIQUIOR STORES



	["Prosperity Liquor Store Register"]={name="Prosperity Liquor Store Register",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=200, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="West Hawick Flecca Bank Vault",
	},
	["Prosperity Liquor Store Safe"]={name="Prosperity Liquor Store Safe",
	currentMoney=2000,
	maxMoney=30000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="West Hawick Flecca Bank Vault",
	},

	["El Rancho Blvd Liquor Register"]={name="El Rancho Blvd Liquor Store Register",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=200, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},

	["El Rancho Blvd Liquor Store Safe"]={name="El Rancho Blvd Liquor Store Safe",
	currentMoney=2000,
	maxMoney=30000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Legion Flecca Bank Vault",
	},

	["Great Ocean Hwy Liquor Store Register"]={name="Great Ocean Hwy Liquor Store Register",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=200, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Great Owean Hwy Flecca Bank Vault",
	},
	["Great Ocean Hwy Liquor Store Safe"]={name="Great Ocean Hwy Liquor Store Safe",
	currentMoney=2000,
	maxMoney=30000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Great Owean Hwy Flecca Bank Vault",
	},

	["Route 68 Liquor Store Register"]={name="Route 68 Liquor Store Register",
	currentMoney=500,
	maxMoney=5000,
	moneyRengerationRate=200, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Route 68 Flecca Bank Vault",
	},
	["Route 68 Liquior Store Safe"]={name="Route 68 Liquior Store Safe",
	currentMoney=2000,
	maxMoney=30000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=true,
	isBank=false,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="Route 68 Flecca Bank Vault",
	},







-- bank booths

	["Pacific Standard Bank Booth #1"]={name="Pacific Standard Bank Booth #1",
	currentMoney=250,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Pacific Standard Bank Booth #2"]={name="Pacific Standard Bank Booth #2",
	currentMoney=250,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Pacific Standard Bank Booth #3"]={name="Pacific Standard Bank Booth #3",
	currentMoney=250,
	maxMoney=5000,
	moneyRengerationRate=100, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=14400,
	timerLeft=0,
	bankToDeliverToo="None",
	},






	-- BANKS



	["East Hawick Flecca Bank Vault"]={name="East Hawick Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["East Hawick Flecca Bank Vault"]={name="East Hawick Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Route 68 Flecca Bank Vault"]={name="Route 68 Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Hawick Flecca Bank Vault"]={name="Hawick Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["West Hawick Flecca Bank Vault"]={name="West Hawick Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Legion Flecca Bank Vault"]={name="Legion Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Great Ocean Hwy Flecca Bank Vault"]={name="Great Ocean Hwy Flecca Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Pacific Standard Bank Vault"]={name="Pacific Standard Bank Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},

	["Blaine County Savings Vault"]={name="Blaine County Savings Vault",
	currentMoney=10000,
	maxMoney=200000,
	moneyRengerationRate=400, -- Per Minute
	takesMoneyToBankOnMax=false,
	isBank=true,
	underCooldown=false,
	cooldownTime=43200,
	timerLeft=0,
	bankToDeliverToo="None",
	},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		for name,spot in pairs(robbableSpots) do
			if(spot.currentMoney<spot.maxMoney)then
				spot.currentMoney = spot.currentMoney + spot.moneyRengerationRate
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1800000)
		for name,spot in pairs(robbableSpots)do
			if(spot.isBank==false)then
				local aFourth = spot.currentMoney/4
				local randomAmount = math.random(aFourth,aFourth*3)
				spot.currentMoney = spot.currentMoney-randomAmount
				robbableSpots[spot.bankToDeliverToo].currentMoney=robbableSpots[spot.bankToDeliverToo].currentMoney+randomAmount
				if(robbableSpots[spot.bankToDeliverToo].currentMoney>robbableSpots[spot.bankToDeliverToo].maxMoney)then
					robbableSpots[spot.bankToDeliverToo].currentMoney=robbableSpots[spot.bankToDeliverToo].maxMoney
				end
			end
		end
	end
end)

function table.removeKey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

RegisterServerEvent("robberies:robberyOver")
AddEventHandler("robberies:robberyOver", function(name) 	
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('black_money', robbableSpots[name].currentMoney)
	robbableSpots[name].currentMoney=0

	-- table.insert(watchList, {
 --      playerName   = xPlayer.name,
 --      cooldownTime = 10,
 --      timerLeft = 0,
 --    })

 --    watchList[xPlayer.name] = {
 --      playerName   = xPlayer.name,
 --      cooldownTime = 10800,
 --      timerLeft = 0,
 --    }

	-- local spotBeingRobbed = robbableSpots[name]
	-- spotBeingRobbed.underCooldown=true
	-- local cooldownTimer = spotBeingRobbed.cooldownTime

	-- local playerJustRobbed = watchList[xPlayer.name]
	-- local playerCooldownTimer = playerJustRobbed.cooldownTime

	-- Citizen.CreateThread(function()
	-- 	while cooldownTimer > 0 do
	-- 		cooldownTimer = cooldownTimer - 1
	-- 		spotBeingRobbed.timerLeft = cooldownTimer
	-- 		if (cooldownTimer == 1) then
	-- 			spotBeingRobbed.underCooldown = false
	-- 		end
	-- 		Citizen.Wait(1000)
	-- 	end
	-- end)
	-- Citizen.CreateThread(function()
	-- 	while playerCooldownTimer > 0 do
	-- 		playerCooldownTimer = playerCooldownTimer - 1
	-- 		playerJustRobbed.timerLeft = playerCooldownTimer
	-- 		if (playerCooldownTimer == 1) then
	-- 			table.removeKey(watchList, xPlayer.name)
	-- 		end
	-- 		Citizen.Wait(1000)
	-- 	end
	-- end)

	nationUnderCooldown = true
	local cooldownTimer = nationCooldownTime
	Citizen.CreateThread(function()
		while cooldownTimer > 0 do
			cooldownTimer = cooldownTimer - 1
			nationCooldownTimer = cooldownTimer
			if (cooldownTimer == 1) then
				nationUnderCooldown = false
			end
			Citizen.Wait(1000)
		end
	end)
end)

RegisterServerEvent("robberies:robberyAttemptOver")
AddEventHandler("robberies:robberyAttemptOver", function(name) 	
	nationAttemptUnderCooldown = true
	local cooldownTimer = nationAttemptCooldownTime
	Citizen.CreateThread(function()
		while cooldownTimer > 0 do
			cooldownTimer = cooldownTimer - 1
			nationAttemptCooldownTimer = cooldownTimer
			if (cooldownTimer == 1) then
				nationAttemptUnderCooldown = false
			end
			Citizen.Wait(1000)
		end
	end)
end)

RegisterServerEvent("robberies:syncSpots")
AddEventHandler("robberies:syncSpots", function(spots)
	TriggerClientEvent("robberies:syncSpotsClient", -1, spots)
end)

RegisterServerEvent("robberies:policeCheck")
AddEventHandler("robberies:policeCheck", function(spotName)
	local xPlayers = ESX.GetPlayers()
	local PoliceConnected = 0
	local PlayerConnected = 0

	local xPlayerUser = ESX.GetPlayerFromId(source)
	if (xPlayerUser.job.name == 'police') then
		TriggerEvent("robberies:policeCannotRobNotification", source)
	else
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			PlayerConnected = PlayerConnected + 1

			if xPlayer.job.name == 'police' then
				PoliceConnected = PoliceConnected + 1
			end	
		end

		-- local alreadySentOnce = false
		-- if not watchList[xPlayerUser.name] then
		-- 	for name,spot in pairs(robbableSpots) do
		-- 		spotBeingRobbed = robbableSpots[spotName]
		-- 		if (alreadySentOnce == false) then
		-- 			TriggerClientEvent("robberies:StartRobbery", source, PoliceConnected, spotBeingRobbed.underCooldown)
		-- 			alreadySentOnce = true
		-- 		end
		-- 	end
		-- else
		-- 	local playerJustRobbed = watchList[xPlayerUser.name]
		-- 	local playerJustRobbedTimerLeft = playerJustRobbed.timerLeft
		-- 	TriggerEvent("robberies:playerJustRobbedCooldown", source, playerJustRobbedTimerLeft)
		-- end

		if (nationUnderCooldown == true) then
			TriggerEvent("robberies:underNationCooldownNotification", source, nationCooldownTimer)
		elseif (nationAttemptUnderCooldown == true) then
			TriggerEvent("robberies:underNationAttemptCooldownNotification", source, nationAttemptCooldownTimer)
		else
			TriggerClientEvent("robberies:StartRobbery", source, PoliceConnected)
		end

	end
end)

-- OL
RegisterServerEvent('robberies:robberyStartedNotification')
AddEventHandler('robberies:robberyStartedNotification', function(robberySpotName)
	TriggerClientEvent("outlawNotify", -1, "~r~10-90~w~: A silent alarm has been triggered at ~r~" ..robberySpotName)
end)

RegisterServerEvent('robberies:robberyEndedNotification')
AddEventHandler('robberies:robberyEndedNotification', function(robberySpotName)
	TriggerClientEvent("outlawNotify", -1, "~r~10-90~w~: Somebody was seen fleeing the area at ~r~" ..robberySpotName)
end)

RegisterServerEvent('robberies:robberyAttemptEndedNotification')
AddEventHandler('robberies:robberyAttemptEndedNotification', function(robberySpotName)
	TriggerClientEvent("outlawNotify", -1, "~r~10-90~w~: Somebody was seen fleeing the area without any noticable extra items at ~r~" ..robberySpotName)
end)

RegisterServerEvent('robberies:notEnoughCopsNotification')
AddEventHandler('robberies:notEnoughCopsNotification', function(copsNeeded)
	TriggerClientEvent("pNotify:SetQueueMax", source, "robnotify", 1)
	TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Robbing this place is not allowed until " ..copsNeeded.. " policemen are in town",
            type = "error",
            queue = "robnotify",
            timeout = 3000,
            layout = "Centerleft"
        	})
	-- TriggerClientEvent("robberies:notify", "Robbing this place is not allowed until ~b~" ..copsNeeded.. " ~w~policemen are in town")
end)

-- RegisterServerEvent('robberies:playerJustRobbedCooldown')
-- AddEventHandler('robberies:playerJustRobbedCooldown', function(_source, playerJustRobbedTimerLeft)
-- 	local playerJustRobbedTimerLeftMins = playerJustRobbedTimerLeft/60
-- 	local playerJustRobbedTimerLeftMins = math.floor(playerJustRobbedTimerLeftMins+0.5)
-- 	TriggerClientEvent("pNotify:SetQueueMax", _source, "justrobbed", 1)
-- 	TriggerClientEvent("pNotify:SendNotification", _source, {
--             text = "You have just robbed a place and the police are on high alert, you cannot rob this spot for " ..playerJustRobbedTimerLeftMins.. " minutes.",
--             type = "error",
--             queue = "justrobbed",
--             timeout = 3000,
--             layout = "Centerleft"
--         	})
-- 	-- TriggerClientEvent("robberies:notify", "Robbing this place is not allowed until ~b~" ..copsNeeded.. " ~w~policemen are in town")
-- end)

RegisterNetEvent('robberies:policeCannotRobNotification')
AddEventHandler('robberies:policeCannotRobNotification', function(_source)
	TriggerClientEvent("pNotify:SetQueueMax", _source, "pcnrn", 1)
	TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "You cannot rob this place as a LEO",
            type = "error",
            queue = "pcnrn",
            timeout = 3000,
            layout = "Centerleft"
        	})
	-- TriggerClientEvent("robberies:notify", "Robbing this place is not allowed until ~b~" ..copsNeeded.. " ~w~policemen are in town")
end)

-- RegisterServerEvent('robberies:underCooldownNotification')
-- AddEventHandler('robberies:underCooldownNotification', function(spotBeingRobbedName)
-- 	local cooldownTimerDuration = robbableSpots[spotBeingRobbedName].timerLeft/60
-- 	local cooldownTimerInMinutes = math.floor(cooldownTimerDuration+0.5)
-- 	TriggerClientEvent("pNotify:SetQueueMax", source, "robcooldownnotify", 2)
-- 	TriggerClientEvent("pNotify:SendNotification", source, {
--             text = "Extremely tight security measures are active due to a recent robbery, deactivating in " ..cooldownTimerInMinutes.. " minutes. You cannot rob this place right now.",
--             type = "error",
--             queue = "robcooldownnotify",
--             timeout = 3000,
--             layout = "Centerleft"
--         	})
-- end)

RegisterServerEvent('robberies:underNationCooldownNotification')
AddEventHandler('robberies:underNationCooldownNotification', function(_source, nationCooldownTimerLeft)
	local cooldownTimerDuration = nationCooldownTimerLeft/60
	local cooldownTimerInMinutes = math.floor(cooldownTimerDuration+0.5)
	TriggerClientEvent("pNotify:SetQueueMax", _source, "robncooldownnotify", 2)
	TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "Statewide extreme anti-robbery security measures are active due to a recent robbery for another " ..cooldownTimerInMinutes.. " minutes.",
            type = "error",
            queue = "robncooldownnotify",
            timeout = 3000,
            layout = "Centerleft"
        	})
end)

RegisterServerEvent('robberies:underNationAttemptCooldownNotification')
AddEventHandler('robberies:underNationAttemptCooldownNotification', function(_source, nationCooldownTimerLeft)
	local cooldownTimerDuration = nationCooldownTimerLeft/60
	local cooldownTimerInMinutes = math.floor(cooldownTimerDuration+0.5)
	TriggerClientEvent("pNotify:SetQueueMax", _source, "robnacooldownnotify", 2)
	TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "The city is on high alert and active surveillance from a recent attempted robbery for another " ..cooldownTimerInMinutes.. " minutes.",
            type = "error",
            queue = "robnacooldownnotify",
            timeout = 3000,
            layout = "Centerleft"
        	})
end)

RegisterServerEvent('robberies:robberyPlacePos')
AddEventHandler('robberies:robberyPlacePos', function(tx, ty, tz)
	TriggerClientEvent('robberies:robberyPlace', -1, tx, ty, tz)
end)