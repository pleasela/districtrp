# FiveM-PlayerTrust
a trust system based on steam account stats for FiveM


## Configuration

Configuration is done using the "config.json" file

### APIKey
You will need to add an API Key by generating one from https://steamcommunity.com/dev/apikey, without this key, PlayerTrust will not function

### EnableVACBans
This will Enable or Disable VAC Ban checks.

### MaxVACCount
This dictates the maximum amount of VAC Bans a player can have before being declined.

### MaxDaysSinceLastBan
If the "Days Since last Ban" Count is bigger than the value here, the bans will be ignored.

### EnableAccountAgeCheck
This will Enable or Disable the Account Age check.

### MinimumAccountAge
Minimum Account Age, in Unix Time Format

### MinimumAccountAgeLabel
Minium Account Age, in English. ( to add to the reason in case of declination )

### EnableMinimumPlaytime
This will Enable or Disable the Minimum Playtime check, based on Source SDK Base 2007 Playtime.

### MinimumPlaytimeHours
The Minimum Time a Player should have played Source SDK Base 2007 for them to be able to join the server.

### EnableMinimumOwnedGames
This will Enable or Disable the Minimum Owned Games check, based on total owned games on steam.

### MinimumOwnedGames
The Minimum Games a player should own on their Steam Account to be able to join the server.

### MinimumTotalPlaytimeHours
The Minimum Amount a player should have played games on steam, takes all game playtimes and merges them into one, enter 0 to disable
