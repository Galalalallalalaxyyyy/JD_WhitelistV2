local vehAllowedToUse = false
local gunAllowedToUse = false
local gunCompAllowedToUse = false
local pedAllowedToUse = false
local delveh = 0

RegisterNetEvent("returnIsVehAllowed")
AddEventHandler("returnIsVehAllowed", function(isAllowed)
    vehAllowedToUse = isAllowed
end)

RegisterNetEvent("returnIsGunAllowed")
AddEventHandler("returnIsGunAllowed", function(isAllowed)
    gunAllowedToUse = isAllowed
end)

RegisterNetEvent("returnIsGunCompAllowed")
AddEventHandler("returnIsGunCompAllowed", function(isAllowed)
    gunCompAllowedToUse = isAllowed
end)

RegisterNetEvent("returnIsPedAllowed")
AddEventHandler("returnIsPedAllowed", function(isAllowed)
    pedAllowedToUse = isAllowed
end)

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
		local iPed = GetPlayerPed(-1)
		Citizen.Wait(0)
		if IsPedInAnyVehicle(iPed, false) then
			veh = GetVehiclePedIsUsing(iPed)
			VehHash = GetEntityModel(veh)
		end
		
		if DoesEntityExist(veh) then
			if lockedVehicle(VehHash) ~= 0 then
				local AcePerm = lockedVehicle(VehHash)
				TriggerServerEvent("getIsVehAllowed", AcePerm)
				Citizen.Wait(500)
				if GetPedInVehicleSeat(veh, -1) == iPed then
					if not vehAllowedToUse then
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
		local iPed = GetPlayerPed(-1)
		Citizen.Wait(0)
		local gun = GetSelectedPedWeapon(iPed)
		if gun ~= GetHashKey("WEAPON_UNARMED") then
			if lockedWeapons(gun) ~= 0 then
				local AcePerm = lockedWeapons(gun)
				TriggerServerEvent("getIsGunAllowed", AcePerm)
				Citizen.Wait(500)
				if not gunAllowedToUse then
					RemoveWeaponFromPed(iPed, gun)
					ShowInfo("You ~r~don't ~w~have permission to use this Weapon")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local iPed = GetPlayerPed(-1)
		Citizen.Wait(0)
		local gun = GetSelectedPedWeapon(iPed)
		if gun ~= GetHashKey("WEAPON_UNARMED") then
			if checkComps(gun) ~= nil then
				local comp = checkComps(gun)
				local AcePerm = lockedWeaponComps(comp)
				--print(AcePerm)
				TriggerServerEvent("getIsGunCompAllowed", AcePerm)
				Citizen.Wait(500)
				if not gunCompAllowedToUse then
					RemoveWeaponComponentFromPed(iPed, gun, comp)
					ShowInfo("You ~r~don't ~w~have permission to use this weapon component")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local iPed = GetPlayerPed(-1)
		local model = GetEntityModel(iPed)
		Citizen.Wait(0)
		if checkPed(model) ~= 0 then
			local AcePerm = checkPed(model)
			TriggerServerEvent("getIsPedAllowed", AcePerm)
			Citizen.Wait(500)
			if not pedAllowedToUse then
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
	local iPed = GetPlayerPed(-1)
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