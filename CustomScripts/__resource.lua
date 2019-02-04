-- server scripts
server_scripts{ 
  '@mysql-async/lib/MySQL.lua',
  "deletepoliceweapons-server.lua",
  "deathmessages-server.lua",
  "dispatch-server.lua",
  "getplayerbyid-server.lua"
}

-- client scripts
client_scripts{
  "crouch-client.lua",
  "pointfinger-client.lua",
  "handsup-client.lua",
  "stopwanted-client.lua",
  "deletepoliceweapons-client.lua",
  "deathmessages-client.lua",
  "missiontext-client.lua",
  "getplayerbyid-client.lua"
 }