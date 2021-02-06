PerformHttpRequest("https://jokedevil.com/premium?id="..Config.DiscordID, function (errorCode, resultData, resultHeaders)
	if resultData == '1' then 

	RegisterServerEvent("getIsVehAllowed")
	AddEventHandler("getIsVehAllowed", function(AcePerm)
		if IsPlayerAceAllowed(source, AcePerm) then
			TriggerClientEvent("returnIsVehAllowed", source, true)
		else 
			if IsPlayerAceAllowed(source, "jd.staff") then
				TriggerClientEvent("returnIsVehAllowed", source, true)
			else 
				TriggerClientEvent("returnIsVehAllowed", source, false)
			end
		end
	end)

	RegisterServerEvent("getIsGunAllowed")
	AddEventHandler("getIsGunAllowed", function(AcePerm)
		if IsPlayerAceAllowed(source, AcePerm) then
			TriggerClientEvent("returnIsGunAllowed", source, true)
		else
			TriggerClientEvent("returnIsGunAllowed", source, false)
		end
	end)

	RegisterServerEvent("debug")
	AddEventHandler("debug", function(msg)
		print("JD_Debug: "..msg)
	end)

	RegisterServerEvent("getIsGunCompAllowed")
	AddEventHandler("getIsGunCompAllowed", function(AcePerm)
		if IsPlayerAceAllowed(source, AcePerm) then
			TriggerClientEvent("returnIsGunCompAllowed", source, true)
		else
			TriggerClientEvent("returnIsGunCompAllowed", source, false)
		end
	end)

	RegisterServerEvent("getIsPedAllowed")
	AddEventHandler("getIsPedAllowed", function(AcePerm)
		if IsPlayerAceAllowed(source, AcePerm) then
			TriggerClientEvent("returnIsPedAllowed", source, true)
		else
			TriggerClientEvent("returnIsPedAllowed", source, false)
		end
	end)

	RegisterCommand("addcar", function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, 'jd.staff') then
			if GetVehiclePedIsIn(GetPlayerPed(source)) ~= nil then
				veh = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(source)))
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "^1You need to be in the vehicle to add a player!"} })
				return
			end
			if args[1] ~= nil then
				if args[1]:find("^steam:" ) ~= nil then
					steam = args[1]
				else
					steam = ExtractIdentifiers(args[1])
				end
				targetName = GetPlayerName(args[1])
				file = io.open('JD_Perms/JD_vehPerms.cfg', 'a')
				io.output(file)
				local data = "\nadd_ace identifier."..steam.." "..veh.. " allow  #".. targetName
				io.write(data)
				io.close(file)
				ExecuteCommand("add_ace identifier."..steam.." "..veh.. " allow")
				TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Permissions updated!"} })
				--PerformHttpRequest("https://discord.com/api/webhooks/746374749365731348/24HG3m9vpGPKtxUNCBNOBmA9niD9WQRTlE7WTvUfFZhVmGUc49jV9wjAzpfumhrFS2pE", function(err, text, headers) end, 'POST', json.encode({username = "JD_Perms", content = ping, embeds = {{["color"] = 16711680, ["author"] = {["name"] = GetPlayerName(source),["icon_url"] = "https://eu.ui-avatars.com/api/?background=0D8ABC&color=fff&name="..source..""}, ["description"] = "".. rawCommand .."",["footer"] = {["text"] = "© JokeDevil.com - "..os.date("%x %X %p"),["icon_url"] = "https://www.jokedevil.com/img/logo.png",},}}}), { ['Content-Type'] = 'application/json' })
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "Please use /addcar [id]"} })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5[JD_Perms]", "^1Insuficient Premissions!"} })
		end
	end)

	function ExtractIdentifiers(src)
		local identifiers = { steam = "", ip = "", discord = "", license = "", xbl = "", live = "" }
		for i = 0, GetNumPlayerIdentifiers(src) - 1 do
			local id = GetPlayerIdentifier(src, i)
			if string.find(id, "steam") then
				identifiers.steam = id
			end
		end
		return identifiers.steam
	end
end