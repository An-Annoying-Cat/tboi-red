local item = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local saveman = require("red_src.core.saveman")
local red_room_load = require("red_src.player.red_room_load")
local update_doors = require("red_src.player.red_update_doors")
local saveman = require("red_src.core.saveman")
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.reds_key
local BOSS_ROOM_CHANCE = 20
local SPECIAL_ROOM_BIRTHRIGHT_CHANCE = 30
---------------------------------------------------
local RED_ROOM_FLAG = 1023
local SPECIAL_ROOMS = {"treasure", "shop", "library", "sacrifice"}
---------------------------------------------------
local NAME_TO_TYPE = {
	["treasure"] = RoomType.ROOM_TREASURE,
	["shop"] = RoomType.ROOM_SHOP,
	["library"] = RoomType.ROOM_LIBRARY,
	["sacrifice"] = RoomType.ROOM_SACRIFICE,
}
local ITEM_FUNCTIONS 
---------------------------------------------------
local game, sfx = global.game, global.sfxman
local level = game:GetLevel()
local doors, usingRedsKey = {} 
---------------------------------------------------
--- HANDLE ITEM USE
local function UpdateDoor(door, animation, targetRoomType)
	local sprite = door:GetSprite()
	local animation = animation or sprite:GetAnimation()

	door:SetRoomTypes(door.CurrentRoomType, targetRoomType or door.TargetRoomType)

	sprite:Play(animation)
end
--
local function TryForBirthright(player, RNG, room, newRoom, newDoor)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) 
	or player:GetPlayerType() ~= enums.players.red 
	or room:GetType() == RoomType.ROOM_ULTRASECRET
	or RNG:RandomInt(100) + 1 >= SPECIAL_ROOM_BIRTHRIGHT_CHANCE then return end

	local data = saveman.save.data
	if data.secondUltrasecret then
		local chosenRoomType = SPECIAL_ROOMS[RNG:RandomInt(#SPECIAL_ROOMS) + 1]

		newRoom.Data = red_room_load[chosenRoomType][RNG:RandomInt(#red_room_load[chosenRoomType]) + 1]
		level:UpdateVisibility()
		UpdateDoor(newDoor, nil, NAME_TO_TYPE[chosenRoomType])
	else
		newRoom.Flags = 0
		newRoom.Data = red_room_load.ultrasecret[RNG:RandomInt(#red_room_load.ultrasecret) + 1]

		data.secondUltrasecret = true

		level:UpdateVisibility()
		UpdateDoor(newDoor, nil, RoomType.ROOM_ULTRASECRET)
	end
end
--- HANDLE SPECIAL STUFF
local function GetDoors()
	item.doors = {}
	local room = game:GetRoom()

	for i = 0, 7 do
		item.doors[i] = room:GetDoor(i) or {}
	end
end

item.PostNewRoom = GetDoors
--
local function DoSpecialMechanics(RNG, player)
	local room = game:GetRoom()	
 
	local newDoor
	for i = 0, 7 do 
		newDoor = newDoor or (item.doors[i].Slot ~= (room:GetDoor(i) or {}).Slot) and room:GetDoor(i)
	end

	if not newDoor then return {Discharge = false} end
	item.doors[newDoor.Slot] = newDoor
	
	local newRoom = level:GetRoomByIdx(newDoor.TargetRoomIndex)
	if newRoom.Data.Type ~= RoomType.ROOM_DEFAULT or level:GetStage() == LevelStage.STAGE8 then return true end


	if RNG:RandomInt(100) + 1 >= BOSS_ROOM_CHANCE then
		TryForBirthright(player, RNG, room, newRoom, newDoor) 
		return true 
	end

	newRoom.Data = red_room_load.boss[RNG:RandomInt(#red_room_load.boss) + 1]

	update_doors:EvaluateDoors(newDoor.TargetRoomIndex)
	level:UpdateVisibility()
	
	return true
end
--- HANDLE ITEM USAGE
local function HandleRedsKey(RNG, player)
	usingRedsKey = true

	player:UseActiveItem(CollectibleType.COLLECTIBLE_RED_KEY, false)
	usingRedsKey = false

	return DoSpecialMechanics(RNG, player)
end
--
local function HandleRedKey(RNG, player)
	if usingRedsKey or player:GetPlayerType() ~= enums.players.red then return true end

	DoSpecialMechanics(RNG, player)
	return true
end
--
function item:UseItem(collectible, RNG, player)
	if not ITEM_FUNCTIONS[collectible] then return end 
	return ITEM_FUNCTIONS[collectible](RNG, player)	
end
--- HANDLE NEW LEVEL
function item:PostNewLevel()
	saveman.save.data.secondUltrasecret = false
end
---------------------------------------------------
ITEM_FUNCTIONS = {
	[COLLECTIBLE] = HandleRedsKey,
	[CollectibleType.COLLECTIBLE_RED_KEY] = HandleRedKey
}

return item
