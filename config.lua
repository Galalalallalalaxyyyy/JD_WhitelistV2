Config = {}

-- To add Vehicles/Weapons/Components/Peds you just have to make a new line in the correct sub Config.
-- It needs 3 values.

-- The first value is the hash key of the object. I'm using the GetHashKey to get it the hash from spawn names.

-- The second value is the ace permission needed to have access to this Item.

-- The third value (Only for vehicles) is if the vehicle needs to be deleded or not. 
-- 1 = The vehicle will be deleted. 
-- 0 = The vehcile won't delete but you will be ejected out of the diver seat.

Config.Vehicles = {
	--{GetHashKey("apc"), "police","0"},
	--{GetHashKey("apc"), "police","1"},
}

Config.Weapons = {
	--{GetHashKey("WEAPON_PISTOL"), "police"},
	--{GetHashKey("WEAPON_PISTOL_MK2"), "jd.none"},
}

Config.WeaponComponents = {
	--{GetHashKey("COMPONENT_AT_PI_SUPP_02"), "police"},
	--{GetHashKey("COMPONENT_AT_PI_FLSH"), "jd.none"},
}

Config.Peds = {
	--{GetHashKey("mp_m_freemode_01"), "police"},
	--{GetHashKey("player_one"), "jd.none"},
}