local https = require('https')
local discordia = require('discordia')
local ffi = require("ffi")
opus = ffi.load("opus")
sodium = ffi.load("sodium")
require('class')
require('intent')
local dobtlog = owo
local client = discordia.Client {
	--dateTime = "%Y-%m-%d T:%H:%M:%S",
	logFile = "lolprobot files/egirl.log",
	cacheAllMembers = true,
}
discordia.extensions()
client:on('ready', function()
	-- client.user is the path for your bot
	print('Logged in as '.. client.user.username)
	client:setGame(io.open("lolprobot files/egirl_msgs/status.txt"):read())--Smashing DoorMat's dick
end)

function trim(s)
	if type(s) == "string" then
		return (s:gsub("^%s*(.-)%s*$", "%1"))
	end
end

function split(s)
	local chunks = {}
	for substring in s:gmatch("%S+") do
	   table.insert(chunks, substring)
	end
	print(table.concat(chunks, ","))
	return chunks
end

client:on('messageCreate', function(message)
	local prefix = '!'
	local song_list = {"c", "m", "d", "o", "h", "y", "op", "owo", "uwu", "why"}
	--if message.author.id == "873989176490623066" then
		--return
	--end
	function player(song)
		coroutine.wrap(function()
			if message.member ~= nil then
				local channel = client:getChannel(message.member.voiceChannel)
				if channel ~= nil then
					local connection = channel:join()
					if connection ~= nil then
						connection = channel:join()
					end
					connection:playFFmpeg('lolprobot files/egirl_msgs/'..song..'.mp3')
				end
			end
		end)()
	end
	for i=1,#song_list do
		if message.content == song_list[i] then
			message:delete()
			player(song_list[i])
		end
	end
	if message.content == "b" then
		message:delete()
		message.channel:send("*blushes*")
	elseif message.content == "k" then
		message:delete()
		message.channel:send("okie")
		player("k")
	elseif message.content == "s" then
		message:delete()
		message.channel:send("*cries in code*")
	elseif message.content == "<@!856669192958902293> i love you ❤️" or message.content == "<@856669192958902293> i love you ❤️" then
		player("gottem")
		message.channel:send("I was only made <t:1624341451:R>!")
	elseif message.content == prefix.."play hentai" then
		player("hentai")
	elseif message.content:sub(1,3) == prefix.."dm" then
		message:delete()
		local dm_id = split(trim(message.content:sub(4,string.len(message.content))))
		local dm_message = ""
		--dm_id = {"701824288340180993", "e"}
		if dm_id[1] == nil then
			return
		else
			if dm_id ~= nil then
				dm_message  = dm_id[2]
				for i=3,#dm_id do
					dm_message = dm_message.." "..dm_id[i]
				end
				if dm_message ~= nil then
					client:getUser(dm_id[1]):send(dm_message)
				end
			end
		end
		message.author:send(dm_message)
		message.author:send("Sent dm to <@"..dm_id[1]..">")
	elseif message.content:sub(1,3) == prefix.."sa" then
		message:delete()
		local _message = trim(message.content:sub(4,string.len(message.content)))
		message.channel:send(_message)
	elseif message.content:sub(1,3) == prefix.."ss" then
		message:delete()
		--if message.author.id == "873989176490623066" then
			--message.channel:send("!ss")
		--end
		local stat_change = io.open("lolprobot files/egirl_msgs/status.txt", "w")
		stat_change:write(message.content:sub(4,string.len(message.content)))
		stat_change:close()
		client:setGame(trim(message.content:sub(4,string.len(message.content))))
	elseif message.content == "Will you marry me?" then
		message.channel:send("No Way.")
	elseif message.content == "Sudo will you marry me?" then
		local sudoers_file = {[701824288340180993] = true, [502999470611365893] = true}
		if sudoers_file[tonumber(message.author.id)] == true then			
			message.channel:send("https://cdn.discordapp.com/attachments/792555177794207765/881411852855291934/Screenshot_2021-08-28_223504_2.png")
		else
			message.channel:send("Error: User is not in Sudoer's file.\nThis incident will be reported.")
		end
	elseif message.content:sub(1,1) == "'" then
		local file_learn_str = trim(message.content:sub(2,string.len(message.content)))
		--"a1d0b100-a8b7-4ff0-96e4-90009c41c31f"
		local num_list = io.open("lolprobot files/egirl_msgs/list.txt", "r")
		local added = num_list:read()
		num_list:close()
		local num_list = io.open("lolprobot files/egirl_msgs/list.txt", "w")
		local file_learn = io.open("lolprobot files/egirl_msgs/"..tostring(added + 1)..".txt", "w")
		num_list:write(added + 1)
		file_learn:write(file_learn_str)
		file_learn:close()
		num_list:close()
		message.channel:send("String Logged.")
	elseif message.content:sub(1,4) == "join" then
		if message.member ~= nil then
			local channel = client:getChannel(message.member.voiceChannel)
			if channel ~= nil and connection ~= channel:join() then
				connection = channel:join()
			end
		end
	elseif message.content == "hello" then
		message:delete()
		player("hi")
	else
		local intent = str_intent(message.content)
	end
	if message.content or message.reply then
		print("[CHAT]: #"..message.channel.name.." "..message.content.." "..message.author.username.."#"..message.author.discriminator.." id:"..message.author.id)
	end
end)

client:run("Bot "..io.open("lolprobot files/egirl_token.txt"):read())