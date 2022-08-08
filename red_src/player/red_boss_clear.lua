local func = {}
---------------------------------------------------
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
---------------------------------------------------
local DELIRIUM_DOOR_TYPE = 17
local RED_ROOM_FLAG = 1023
local MAX_GRID_INDEX = 200
---------------------------------------------------
local ITEM_POSITION = Vector(320, 360)
---------------------------------------------------
local game = global.game
---------------------------------------------------
--- HANDLE CHEST IN LATER STAGES
local function CheckVoidDoor()
	for i = 1, MAX_GRID_INDEX do
		local deliriumDoor = game:GetRoom():GetGridEntity(i)

		if deliriumDoor and deliriumDoor:GetType() == DELIRIUM_DOOR_TYPE then
			game:GetRoom():RemoveGridEntity(deliriumDoor:GetGridIndex(), 0)
		end
	end
end
--
function func:PostPickupInit(pickup)
	local room = game:GetLevel():GetCurrentRoomDesc()

	if pickup.Variant ~= PickupVariant.PICKUP_BIGCHEST 
	or room.Flags < RED_ROOM_FLAG 
	or room.Data.Type ~= RoomType.ROOM_BOSS then return end
	
	pickup:Remove()
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Vector(320, 360), Vector(0,0), nil)

	functions:delay(1, CheckVoidDoor)
end
---------------------------------------------------
return func
