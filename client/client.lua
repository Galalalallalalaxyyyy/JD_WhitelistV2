local vehAllowedToUse = false
local gunAllowedToUse = false
local gunCompAllowedToUse = false
local pedAllowedToUse = false
local delveh = 0

function lockedVehicle(veh)
	local VehHash = veh
	local Vehicles = Config.Vehicles
	for i,v in ipairs(Vehicles) do 
		if VehHash == v[1] then
			delveh = v[3]
			return v[2]
		end
	end
	return 0
end

Citizen.CreateThread(function()
	while true do
		local veh = nil
		local iPed = PlayerPedId()
		Citizen.Wait(0)
		if IsPedInAnyVehicle(iPed, false) then
			veh = GetVehiclePedIsUsing(iPed)
			VehHash = GetEntityModel(veh)
		end
		
		if DoesEntityExist(veh) then
			if lockedVehicle(VehHash) ~= 0 then
				if ESX.PlayerData.job.name ~= lockedVehicle(VehHash) then
					if GetPedInVehicleSeat(veh, -1) == iPed then
						ClearPedTasksImmediately(iPed)
						SetEntityAsMissionEntity(veh, true, true)
						ShowInfo("You ~r~don't ~w~have permission to use this vehicle")
						if delveh ~= "0" then
							DeleteVehicle(veh)
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local iPed = PlayerPedId()
		Citizen.Wait(0)
		local gun = GetSelectedPedWeapon(iPed)
		if gun ~= GetHashKey("WEAPON_UNARMED") then
			if lockedWeapons(gun) ~= 0 then
				if ESX.PlayerData.job.name ~= lockedWeapons(gun) then
					RemoveWeaponFromPed(iPed, gun)
					ShowInfo("You ~r~don't ~w~have permission to use this Weapon")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local iPed = PlayerPedId()
		Citizen.Wait(0)
		local gun = GetSelectedPedWeapon(iPed)
		if gun ~= GetHashKey("WEAPON_UNARMED") then
			if checkComps(gun) ~= nil then
				local comp = checkComps(gun)
				if ESX.PlayerData.job.name ~= lockedWeaponComps(comp) then
					RemoveWeaponComponentFromPed(iPed, gun, comp)
					ShowInfo("You ~r~don't ~w~have permission to use this weapon component")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local iPed = PlayerPedId()
		local model = GetEntityModel(iPed)
		Citizen.Wait(0)
		if checkPed(model) ~= 0 then
			if ESX.PlayerData.job.name ~= checkPed(model) then
				print("not Allowed")
				SetPlayerModel(PlayerId(), GetHashKey("player_zero"))
				ShowInfo("You ~r~don't ~w~have permission to use this Player Model")
				
			end
		end
	end
end)

function lockedWeapons(gun)
	local Weapons = Config.Weapons
	for i,v in ipairs(Weapons) do 
		if tonumber(gun) == v[1] then 
			return v[2]
		end
	end
	return 0
end

function lockedWeaponComps(gun)
	local WeaponComps = Config.WeaponComponents
	for i,v in ipairs(WeaponComps) do
		if tonumber(gun) == v[1] then 
			return v[2]
		end
	end
	return 0
end

function checkComps(gun)
	local iPed = PlayerPedId()
	local WeaponComps = Config.WeaponComponents
	for i,v in ipairs(WeaponComps) do
		if HasPedGotWeaponComponent(iPed, gun, v[1]) then
			return v[1]
		end
	end
end

function checkPed(model)
	local Ped = Config.Peds
	for i,v in ipairs(Ped) do
		if model == v[1] then
			return v[2]
		end
	end
	return 0
end

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData = ESX.PlayerData
end)
