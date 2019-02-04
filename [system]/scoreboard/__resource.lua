description 'Scoreboard'

-- temporary!
ui_page 'html/scoreboard.html'

client_scripts {
  '@es_extended/locale.lua',
	'scoreboard.lua'
}

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
	'server.lua'
}


files {
    'html/scoreboard.html',
    'html/style.css',
    'html/reset.css',
    'html/bg.png',
    'html/newlogo.png',
    'html/listener.js',
    'html/res/mpm.ttf',
    'html/res/mpb.ttf',
}