local func = {}
---------------------------------------------------
local global = require("red_src.core.global")
---------------------------------------------------
local BOSS_ROOM_SPRITESHEET = "gfx/grid/Door_10_BossRoomDoor.anm2"
local RED_ROOM_FLAGS = 1023
---------------------------------------------------
local game = global.game
local level = game:GetLevel()
---------------------------------------------------
function func:EvaluateDoors(index)
	local room, roomDesc = game:GetRoom(), level:GetCurrentRoomDesc()

	local doors = {}
	for i = 0, 7 do table.insert(doors, room:GetDoor(i)) end

	for _, v in pairs(doors) do
		local sprite = v:GetSprite()
	
		if sprite:GetFilename() ~= BOSS_ROOM_SPRITESHEET then

			if (v.TargetRoomIndex == index 
			or v.TargetRoomType == RoomType.ROOM_BOSS
			or roomDesc.Data.Type == RoomType.ROOM_BOSS and roomDesc.Flags > RED_ROOM_FLAGS) 
			and v.TargetRoomType ~= RoomType.ROOM_ULTRASECRET then 

				v:SetRoomTypes(RoomType.ROOM_DEFAULT, RoomType.ROOM_DEFAULT)

				sprite:Load(BOSS_ROOM_SPRITESHEET, true)
				sprite:LoadGraphics()

				if sprite:GetAnimation() ~= "" then return end
			
				sprite:Play("Closed")
			end

		end
	end
end

func.PostNewRoom = func.EvaluateDoors
---------------------------------------------------
return func
