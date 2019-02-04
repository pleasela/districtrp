DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/495397604381818900/kCCUQTsqPKTRTA4jW-qbYZaPxi9OIcrIDPgs_TJs8c7ISFgLr4pe0bB7XkG-wCpubZOb'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/495397648178741248/DgIb2wevay-1yMdc4Ccxoul-MatiVwolnV2wIDt-hdw1B3GWQU6FOW8p6BHzpoCIHIFU'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/495397604381818900/kCCUQTsqPKTRTA4jW-qbYZaPxi9OIcrIDPgs_TJs8c7ISFgLr4pe0bB7XkG-wCpubZOb'

SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png'

UserAvatar = 'https://i.imgur.com/KIcqSYs.png'

SystemName = 'FiveM To Discord'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/car', 'https://discordapp.com/api/webhooks/465257908918026240/PbccJ4YFqzfSZb5d1tT4GFQPVWIFk0pSJ43HKPTAkNczkO77yjaIHe845HNYciRrEj3E'},
					  {'/giveitem', 'https://discordapp.com/api/webhooks/465257908918026240/PbccJ4YFqzfSZb5d1tT4GFQPVWIFk0pSJ43HKPTAkNczkO77yjaIHe845HNYciRrEj3E'},
					  {'/giveweapon', 'https://discordapp.com/api/webhooks/465257908918026240/PbccJ4YFqzfSZb5d1tT4GFQPVWIFk0pSJ43HKPTAkNczkO77yjaIHe845HNYciRrEj3E'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

