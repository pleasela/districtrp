--[[--------------------------------------------------------------------------
	*
	* Mello Trainer
	* (C) Michael Goodwin 2017
	* http://github.com/thestonedturtle/mellotrainer/releases
	*
	* This menu used the Scorpion Trainer as a framework to build off of.
	* https://github.com/pongo1231/ScorpionTrainer
	* (C) Emre Cürgül 2017
	* 
	* A lot of useful functionality has been converted from the lambda menu.
	* https://lambda.menu
	* (C) Oui 2017
	*
	* Additional Contributors:
	* WolfKnight (https://forum.fivem.net/u/WolfKnight)
	*
---------------------------------------------------------------------------]]


--    _____        __            _ _    __      __        _       _     _           
--   |  __ \      / _|          | | |   \ \    / /       (_)     | |   | |          
--   | |  | | ___| |_ __ _ _   _| | |_   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___ 
--   | |  | |/ _ \  _/ _` | | | | | __|   \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
--   | |__| |  __/ || (_| | |_| | | |_     \  / (_| | |  | | (_| | |_) | |  __/\__ \
--   |_____/ \___|_| \__,_|\__,_|_|\__|     \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
--                                                                                  
--  
maxPlayers = 32;



--[[
  ______         _                   __      __        _       _     _           
 |  ____|       | |                  \ \    / /       (_)     | |   | |          
 | |__ ___  __ _| |_ _   _ _ __ ___   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___ 
 |  __/ _ \/ _` | __| | | | '__/ _ \   \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
 | | |  __/ (_| | |_| |_| | | |  __/    \  / (_| | |  | | (_| | |_) | |  __/\__ \
 |_|  \___|\__,_|\__|\__,_|_|  \___|     \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
--]]


--General Settings
featurePlayerBlips = false;
featurePlayerBlipNames = true;
featurePlayerHeadDisplay = false;
-- The above will sync by once the blip system rewrite happens
featurePlayerNotifications = false;
featureDeathNotifications = false;
featureHideMap = false;
featureHideHud = false;
featureBigHud = false;
featureMapBlips = true;
featureAreaStreetNames = false;
featureRestoreAppearance = false;
--featureRestoreWeapons = false;


--Vehicle Options
featureCloseInstantly = false;
featureSpeedometer = false;
featureSpawnInsideCar = true;
featureSpawnCarInFront = true 
featureDeleteLastVehicle = true;
featureNoFallOff = false;
featureNoDragOut = false;
featureNoHelmet = false; 
featureVehCosDamage = false;
featureVehMechDamage = false;
featureVehInvincible = false;


--Player Toggles
featureNightVision = false;
featureThermalVision = false;
featurePlayerInvincible = false;
featureKeepClean = false;
featureKeepWet = false;
featurePlayerNeverWanted = false;
featurePlayerIgnoredByPolice = false;
featurePlayerIgnoredByAll = false;
featurePlayerNoNoise = false;
featurePlayerFastSwim = false;
featurePlayerFastRun = false;
featurePlayerSuperJump = false;
featureNoRagDoll = false;
featurePlayerInvisible = false;
featurePlayerDrunk = false;
featurePlayerInfiniteStamina = true;
featurePlayerInfiniteParachutes = false;
featurePlayerInfiniteAmmo = false;
featurePlayerNoReload = false;




--Radio
featurePlayerRadio = false;
featureRadioAlwaysOff = false;


--Weather
-- TODO: The following variables are better to sync server-sided.
featureBlackout = false;
featureWeatherWind = false;
featureWeatherFreeze = false;


-- Voice
featureShowVoiceChatSpeaker = false;
featureVoiceChat = true;
-- One of the below must be true.
-- If multiple are true only the first one will apply.
featureVPAllPlayers = false;
featureVPTooClose = false;
featureVPVeryClose = true;
featureVPClose = false;
featureVPNearby = false;
featureVPDistant = false;
featureVPFar = false;
featureVPVeryFar = false;
-- One of the below must be true.
-- If multiple are true only the first one will apply.
featureChannelDefault = true;
featureChannel1 = false;
featureChannel2 = false;
featureChannel3 = false;
featureChannel4 = false;
featureChannel5 = false;



--[[---------------------------------------------
	* The below should always NOT be touched as
	* This will ensure that settings are synced
	* on player connection. Anything above here
	* is okay to toggle between true & false
-----------------------------------------------]]

Users = {}
playerWasDisconnected = true;


-- Vehicle
featureNoFallOffUpdated = true;
featureNoDragOutUpdated = true;
featureNeonLeft = nil;
featureNeonRight = nil;
featureNeonFront = nil;
featureNeonRear = nil;
featureTorqueMultiplier = 1;
featurePowerMultiplier = 1;
featureLowerForce = 0;
-- Design choice to make these not sync
featureTurboMode = false;
featureCustomTires = false;
featureBulletproofWheels = false;
featureXeonLights = false;

-- Player Toggles
featureNightVisionUpdated = true;
featureThermalVisionUpdated = true;
featurePlayerInvincibleUpdated = true;
featurePlayerNeverWantedUpdated = true;
featurePlayerIgnoredByPoliceUpdated = true;
featurePlayerIgnoredByAllUpdated = true;
featurePlayerNoNoiseUpdated = true;
featurePlayerFastSwimUpdated = true;
featurePlayerFastRunUpdated = true;
featurePlayerInvisibleUpdated = true;
featurePlayerDrunkUpdated = true;


-- Online Player
featureSpectate = false;
featureDrawRoute = false;


--    __  __               ____  _ _           
--   |  \/  |             |  _ \| (_)          
--   | \  / | __ _ _ __   | |_) | |_ _ __  ___ 
--   | |\/| |/ _` | '_ \  |  _ <| | | '_ \/ __|
--   | |  | | (_| | |_) | | |_) | | | |_) \__ \
--   |_|  |_|\__,_| .__/  |____/|_|_| .__/|___/
--                | |               | |        
--                |_|               |_|        
open1 = nil;
open2 = nil;
open3 = nil;
open4 = nil;
open5 = nil;
open6 = nil;
open7 = nil;
open8 = nil;
open9 = nil;
open10 = nil;
open11 = nil;
open12 = nil;
open13 = nil;
open14 = nil;
open15 = nil;
open16 = nil;
open17 = nil;
open18 = nil;
open19 = nil;
open20 = nil;
open21 = nil;
open22 = nil;
open23 = nil;
open24 = nil;
open25 = nil;
open26 = nil;
open27 = nil;
open28 = nil;
open29 = nil;
open30 = nil;
open31 = nil;
open32 = nil;
open33 = nil;
open34 = nil;
open35 = nil;
ponsonbys1 = nil;
ponsonbys2 = nil;
ponsonbys3 = nil;
discount1 = nil;
discount2 = nil;
discount3 = nil;
discount4 = nil;
discount5 = nil;
binco1 = nil;
binco2 = nil;
suburban1 = nil;
suburban2 = nil;
suburban3 = nil;
suburban4 = nil;
lsc1 = nil;
lsc2 = nil;
lsc3 = nil;
lsc4 = nil;
lsc5 = nil;
lsc6 = nil;
tattoo1 = nil;
tattoo2 = nil;
tattoo3 = nil;
tattoo4 = nil;
tattoo5 = nil;
tattoo6 = nil;
ammo1 = nil;
ammo2 = nil;
ammo3 = nil;
ammo4 = nil;
ammo5 = nil;
ammo6 = nil;
ammo7 = nil;
ammo8 = nil;
ammo9 = nil;
ammo10 = nil;
ammo11 = nil;
barber1 = nil;
barber2 = nil;
barber3 = nil;
barber4 = nil;
barber5 = nil;
barber6 = nil;
barber7 = nil;
store1 = nil;
store2 = nil;
store3 = nil;
store4 = nil;
store5 = nil;
store6 = nil;
store7 = nil;
store8 = nil;
store9 = nil;
store10 = nil;
store11 = nil;
store12 = nil;
policestation1 = nil;
policestation2 = nil;
policestation4 = nil;
policestation5 = nil;
policestation6 = nil;
policestation7 = nil;
policestation8 = nil;
policestation9 = nil;
policestation10 = nil;
policestation11 = nil;
bank1 = nil;
bank2 = nil;
bank3 = nil;
bank4 = nil;
bank5 = nil;
bank6 = nil;
bank7 = nil;
cablecar1 = nil;
cablecar2 = nil;
carwash1 = nil;
carwash2 = nil;
airport1 = nil;
airport2 = nil;
airport3 = nil;
stripclub = nil;
helipad = nil;
boat1 = nil;
rebel = nil;
theater1 = nil;
theater2 = nil;
theater3 = nil;
hospital1 = nil;
hospital2 = nil;
hospital3 = nil;
bar1 = nil;
bar2 = nil;
comedy = nil;
drugs = nil;
marijuana1 = nil;
marijuana2 = nil;
altruist = nil;
sub = nil;
masks = nil;
fairground = nil;
golf = nil;
tennis = nil;
darts = nil;
playboy = nil;
fib = nil;




--[[---------------------------------------------
	* Unsued Variables
-----------------------------------------------]]


--isVoiceChatRunning = true;

--blipCheck1 = nil;
--blipCheck2 = nil;

--pmodel = nil;

--drawable = {};
--dtexture = {};
--prop = {};
--ptexture = {};
--pallet = {};

-- Horizontal/Vertical Camera features.
--featureVC1 = false;
--featureVC2 = false;
--featureVC3 = false;
--featureVC4 = false;
--featureVC5 = false;
--featureVC6 = false;
--featureVC7 = false;
--featureVC8 = false;
--featureVC9 = false;
--featureVC10 = false;
--featureHC1 = false;
--featureHC2 = false;
--featureHC3 = false;
--featureHC4 = false;
--featureHC5 = false;
--featureHC6 = false;
--featureHC7 = false;
--featureHC8 = false;
--featureHC9 = false;
--featureHC10 = false;


--featurePlayerBlipCone = false;
--featureShowDeathCutscene = false;
--featureRestoreAppearance = false;
--featureRestoreWeapons = false;
--featurePlayerUnlimitedAbility = false;
--featurePlayerAttach = false;
--featureFriendly = false;
--featureHostile = false;

--featurePlayerRadioUpdated = false;
--featureRadioAlwaysOffUpdated = false;
--featureLockRadio = false;
--featureMiscLockRadio = false;
--featureVehicleDespawnable = nil;
--featurePlayerVehHeadDisplay = false;
--featurePoliceBlips = false;