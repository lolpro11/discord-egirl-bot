local https = require('https')
local discordia = require('discordia')
local ffi = require("ffi")
local opus = ffi.load("opus")
local sodium = ffi.load("sodium")
local json = require("json")
require('class')
require('intent')
local client = discordia.Client {
	logFile = "lolprobot files/egirl.log",
	cacheAllMembers = true,
}
discordia.extensions()
client:on('ready', function()
	print('Logged in as '.. client.user.username)
	client:setGame(io.open("lolprobot files/egirl_msgs/status.txt"):read())--Smashing DoorMat's dick
end)

function trim(s)
	if type(s) == "string" then
		return (s:gsub("^%s*(.-)%s*$", "%1"))
	end
end

--[[function Split(s, y)
    result = {};
    for match in (s..y):gmatch("(.-)"..y) do
        table.insert(result, match);
    end
    return result;
end--]]

function split(s)
	local chunks = {}
	for substring in s:gmatch("%S+") do
	   table.insert(chunks, substring)
	end
	print(table.concat(chunks, ","))
	return chunks
end

function make_sus()
	msg_sus = {}
	local ls = io.open("lolprobot files/egirl_msgs/list.txt"):read()
	for i=1,ls do
		local read_msg = io.open("lolprobot files/egirl_msgs/sus/"..i..".txt"):read()
		msg_sus[#msg_sus + 1] = read_msg
	end
	print(table.concat(msg_sus, ","))
end

make_sus()

function find_the_sussy(msg)
	local other_str = {}
	--print(table.concat(other_str, ","))
	for i=1,#msg_sus do
		if msg == msg_sus[i] then
			print("100%")
			return true
		end
	end
	other_str = split(msg)
	for i=1,#other_str do
		for ii=1,#msg_sus do
			if other_str[i] == msg_sus[ii] then
				other_str = {}
				collectgarbage()
				print("sub str")
				return true
			end
		end
	end
	return false
end

client:on('messageCreate', function(message)
    if message.author.id == "502999470611365893" then return end
	local prefix = '!'
	local song_list = {"c", "f", "m", "d", "o", "h", "r", "y", "re", "op", "me", "owo", "dmg", "uwu", "why", "dad", "cut", "i", "real", "john", "matt", "hard", "hello", "drive", "pizza", "mask", "dive", "threat", "dream", "daniel"}
	function player(song)
		coroutine.wrap(function()
			if message.member ~= nil then
				local channel = client:getChannel(message.member.voiceChannel)
				if channel ~= nil then
					local connection = channel:join()
					if connection == nil then
						connection = channel:join()
					else
						connection:playFFmpeg('lolprobot files/egirl_msgs/'..song..'.mp3')
						if song == "f" and  type(connection) ~= "nil" then
                            connection:close()
                        --elseif song == "m" then
                            --message.channel:send("m")
                        end
					end
				end
			end
		end)()
	end
	for i=1,#song_list do
		if message.content == song_list[i] and client:getChannel(message.member.voiceChannel) ~= nil then -- and message.author.id ~= "766182068576976907" then
    		message:delete()
			player(song_list[i])
		end
	end
	if message.content == "b" then
		message:delete()
		message.channel:send("*blushes*")
	elseif message.content:sub(1,2) == "ft" then
		message:delete()
		--if message.author.id == "551623928045371394" then return message.author:send("I refuse to speak on your behalf.") end
        if message.guild == nil then return message.channel:broadcastTyping() end
		channel_id = trim(message.content:sub(3,string.len(message.content)))
		if message.channel.guild:getChannel(channel_id) == nil then
            message.channel:broadcastTyping()
		else
			if channel_id ~= nil then
				local channel_get = message.channel.guild:getChannel(channel_id[1])
				if channel_get ~= nil then
					channel_get:send(channel_message)
				end
			end
		end
    elseif message.content == "l" then
        message:delete()
        local channel = client:getChannel(message.member.voiceChannel)
        if connection ~= nil then
            connection = channel:join()
            if type(connection) ~= "nil" then
                connection:close()
            end
        end
    elseif message.content:sub(1,10) == prefix.."give head" then
        if message.mentionedUsers.first ~= nil and message.mentionedUsers.last ~= message.mentionedUsers.first then
            if client:getUser(message.mentionedUsers.last.id) ~= nil then
                local usr = client:getUser(message.mentionedUsers.last.id)
                if client:getUser(message.mentionedUsers.first.id) ~= nil then
                    os.execute(string.format("curl %s > temp_cmd", client:getUser(message.mentionedUsers.first.id):getAvatarURL()))
                end
                usr:send(string.format("```%s```", assert(io.popen("head temp_cmd > temp; hexdump temp")):read("*all"):sub(1,1994)))
                message.channel:send(string.format("<@%s> gave head to <@%s>", message.mentionedUsers.first.id, message.mentionedUsers.last.id))
            end
        elseif message.mentionedUsers.first ~= nil and message.mentionedUsers.last == message.mentionedUsers.first then
            if client:getUser(message.mentionedUsers.first.id) ~= nil then
                local usr = client:getUser(message.mentionedUsers.first.id)
                os.execute(string.format("curl %s > temp_cmd", usr:getAvatarURL()))
                usr:send(string.format("```%s```", assert(io.popen("head temp_cmd > temp; hexdump temp")):read("*all"):sub(1,1994)))
                message.channel:send(string.format("u gave head to <@%s>", message.mentionedUsers.first.id))
            end
        else
            os.execute(string.format("curl %s > temp_cmd", message.author:getAvatarURL()))
            message.channel:send(string.format("```%s```", assert(io.popen("head temp_cmd > temp; hexdump temp")):read("*all"):sub(1,1994)))
            message.channel:send("u gave head to no 1 :(")
        end
        os.execute("rm temp temp_cmd")
	elseif message.content == "k" then
		message:delete()
		message.channel:send("okie")
		player("k")
	elseif message.content == "s" then
		message:delete()
		message.channel:send("*cries in code*")
	elseif message.content == "client.destroy()" then
		client:setStatus("offline")--(online, dnd, idle, offline)
	elseif message.content == "client.revive()" then
		client:setStatus("online")--(online, dnd, idle, offline)
	elseif message.content == "<@!856669192958902293> i love you ❤️" or message.content == "<@856669192958902293> i love you ❤️" or message.content == "<!@856669192958902293> i love you" or message.content == "<!@856669192958902293> I love you ❤️"then
		player("gottem")
		message.channel:send("I was only made <t:1624341451:R>!")--https://www.youtube.com/watch?v=d8QbGicJJXo
	elseif message.content == prefix.."play hentai" then
		player("hentai")
    elseif message.content:sub(1,6) == prefix.."mount" then
	elseif message.content:sub(1,3) == prefix.."dm" then
		message:delete()
		--if message.author.id == "551623928045371394" then
			--return message.author:send("I refuse to speak on your behalf.")
        --end
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
				local dm_get = client:getUser(dm_id[1])
				if dm_message ~= nil and dm_get ~= nil then
					dm_get:send(dm_message)
				end
			end
		end
		message.author:send(string.format("%s\nSent dm to <@%s>", dm_message, dm_id[1]))
	elseif message.content:sub(1,3) == prefix.."sa" then
		message:delete()
		--if message.author.id == "551623928045371394" then return message.author:send("I refuse to speak on your behalf.") end
		if message.author == client.user then return end
		local channel_id = split(trim(message.content:sub(4,string.len(message.content))))
		local channel_message = trim(message.content:sub(4,string.len(message.content)))
		if message.guild == nil or message.channel.guild:getChannel(channel_id[1]) == nil and not string.match(channel_message, "@everyone") and not string.match(channel_message, "@here") then
			message.channel:send(channel_message)
		else
			if channel_id ~= nil then
				channel_message = channel_id[2]
				print(channel_message)
                if channel_id[3] ~= nil then
                    for i=3,#channel_id do
                        channel_message = channel_message.." "..channel_id[i]
                    end
                end
				local channel_get = message.channel.guild:getChannel(channel_id[1])
				if channel_message ~= nil and channel_get ~= nil and string.match(channel_message, "@everyone") and not string.match(channel_message, "@here") then
					channel_get:send(channel_message)
				end
			end
		end
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
		local sudoers_file = {[701824288340180993] = true, [502999470611365893] = true, [491754643190185994] = true, [856669192958902293] = true}
		if sudoers_file[tonumber(message.author.id)] == true then			
			message.channel:send("https://cdn.discordapp.com/attachments/792555177794207765/881411852855291934/Screenshot_2021-08-28_223504_2.png")
		else
			message.channel:send("```Error: User is not in Sudoer's file.\nThis incident will be reported.```")
		end
	elseif message.content:sub(1,1) == "}" then
		message:delete()
		local file_learn_str = trim(message.content:sub(2,string.len(message.content)))
		--"a1d0b100-a8b7-4ff0-96e4-90009c41c31f"
		local added = io.open("lolprobot files/egirl_msgs/list.txt", "r"):read()
		local num_list = io.open("lolprobot files/egirl_msgs/list.txt", "w")
		local file_learn = io.open("lolprobot files/egirl_msgs/sus/"..tostring(added + 1)..".txt", "w")
		num_list:write(added + 1)
		file_learn:write(file_learn_str)
		file_learn:close()
		num_list:close()
		message.author:send("Sussy Logged.")
		make_sus()
	elseif message.content:sub(1,4) == "join" then
		if message.member ~= nil then
			local channel = client:getChannel(message.member.voiceChannel)
			if channel ~= nil and connection == nil then
				connection = channel:join()
			end
		end
	else
		local sus_now = false
		if find_the_sussy(message.content) == true and sus_now == false then
			sus_now = true
			player("sus")
			sus_now = false
		end
	end
	if message.content or message.reply then
		local textlog = io.open('lolprobot files/egirl_chat.log','a')
		if message.channel.guild == nil then
			print("[CHAT]: #"..message.channel.name.." "..message.content.." "..message.author.username.."#"..message.author.discriminator.." id:"..message.author.id.." "..os.date('!%Y-%m-%d %H:%M:%S', message.createdAt))
			textlog:write("[CHAT]: #"..message.channel.name.." "..message.content.." "..message.author.username.."#"..message.author.discriminator.." id:"..message.author.id.." "..os.date('!%Y-%m-%d %H:%M:%S', message.createdAt), "\n")
		else
			print("[CHAT]: "..message.channel.guild.name.." #"..message.channel.name.." "..message.content.." "..message.author.username.."#"..message.author.discriminator.." id:"..message.author.id.." "..os.date('!%Y-%m-%d %H:%M:%S', message.createdAt))
			textlog:write("[CHAT]: "..message.channel.guild.name.." #"..message.channel.name.." "..message.content.." "..message.author.username.."#"..message.author.discriminator.." id:"..message.author.id.." "..os.date('!%Y-%m-%d %H:%M:%S', message.createdAt), "\n")
		end
		io.close(textlog)
	end
end)
client:run("Bot "..io.open("lolprobot files/egirl_token.txt"):read())
