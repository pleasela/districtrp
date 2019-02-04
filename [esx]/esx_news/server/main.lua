ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

News = {}
Likes = {}

local moneyPerLike = math.random (2550,3000)

function onEvent() Citizen.Trace('\nEvent no: ' .. eventNumber .. '\n') eventNumber = eventNumber + 1 end

-- 'SELECT * FROM news_main WHERE news_type = @one ORDER BY id DESC',
AddEventHandler('onMySQLReady', function()
	MySQL.Async.fetchAll(							
    'SELECT * FROM news_main ORDER BY id DESC',
    { 
	  ['@one'] = 'news'
	},
    function (result)								

      for i=1, #result, 1 do
        table.insert(News, result[i])
      end
	  
    end
   )
   
   MySQL.Async.fetchAll(								
    'SELECT * FROM news_likes',
    { 
	  ['@one'] = 1 -- :DD
	},
    function (result2)									

      for i=1, #result2, 1 do
        table.insert(Likes, result2[i])
      end
    end
   )
end)


ESX.RegisterServerCallback('esx_news:getNews', function (source, cb)
	cb(News)
end)

ESX.RegisterServerCallback('esx_news:getLikes', function (source, cb, id)
	local likes = {}
	for i = 1, #Likes, 1 do
		if Likes[i].news_id == id then
			table.insert(likes, Likes[i])
		end
	end
	cb(likes)
end)


RegisterServerEvent('esx_news:articlePosted')
AddEventHandler('esx_news:articlePosted', function(data, id, author, identifier)
	table.insert(News, 1, {
		id = id,
		title = data.title,
		bait_title = data.bait_title,
		content = data.content,
		author_name = author,
		author_id = identifier,
		news_type = data.type,
		imgurl = data.imgurl
	})
	--table.remove(News, #News)
end)

RegisterServerEvent('esx_news:likeArticle')
AddEventHandler('esx_news:likeArticle', function(dataTemp)
	local data = dataTemp
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(95)
	
	--TriggerClientEvent('esx:showNotification', xPlayer.source, "~w~author id " .. data.author)
	MySQL.Async.fetchAll(
	'SELECT * FROM users WHERE identifier = @identifier', 
	{
      ['@identifier'] = xPlayer.identifier
    }, 
	function(rows)
		
		local _name = "Top News"
		
		for i = 1, #rows, 1 do
			_name = rows[i].firstname .. ' ' .. rows[i].lastname
		end
		
		table.insert(Likes, {id = -1, news_id = tonumber(data.id), liker_id = xPlayer.identifier, liker_name = _name})
		
		MySQL.Async.execute(
		'INSERT INTO news_likes (news_id, author_id, liker_id, liker_name) VALUES (@nid, @aid, @lid, @name)',
		{ ['@nid'] = data.id,
		  ['@aid'] = data.author,
		  ['@lid'] = xPlayer.identifier,
		  ['@name'] = _name,
		},
		function (rows_changed)
		  TriggerClientEvent('esx:showNotification', xPlayer.source, "You liked the article!")
		end
		)
	
	end
	)
	
	MySQL.Async.execute(
    'INSERT INTO paychecks (amount, receiver) VALUES (@sum, @id)',
    { 
		['@sum'] = moneyPerLike,
		['@id'] = data.author,
	},
    function (rows)
      --notify author? 
    end
	)
	
end)


