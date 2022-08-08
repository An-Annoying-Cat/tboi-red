local effect = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")
local red_room_load = require("red_src.player.red_room_load")
---------------------------------------------------
local CRACKED_KEY_CHANCE = 20
local SECOND_ULTRASECRET_CHANCE = 10
local KEY_VELOCITY = Vector(-.5, 1.5)
---------------------------------------------------
local RED_PLAYER_TYPE = enums.players.red
local BIRTHRIGHT_COLLECTIBLE = CollectibleType.COLLECTIBLE_BIRTHRIGHT
local RED_ROOM_FLAGS = 1023
local SURROUND_ROOM_INDEX = {-1, -13, 1, 13}
---------------------------------------------------
local game = global.game
local level = game:GetLevel()
---------------------------------------------------
--- HANDLE SPAWNING RED KEY
local function TrySpawnCrackedKey(player, RNG)
	if RNG:RandomInt(100) + 1 > CRACKED_KEY_CHANCE then return end

	local crackedKey = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, player.Position, KEY_VELOCITY, nil)
end
--
function effect:PreSpawnCleanAward()
	for _, v in pairs(functions:GetPlayers()) do
		if  v:GetPlayerType() == RED_PLAYER_TYPE 
		and v:HasCollectible(BIRTHRIGHT_COLLECTIBLE) then
			local RNG = v:GetCollectibleRNG(BIRTHRIGHT_COLLECTIBLE)
			TrySpawnCrackedKey(v, RNG)
		end
	end
end
--[[- HANDLE SECOND ULTRA SECRET ROOM
function effect:PostNewRoom()
	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.Data < RED_ROOM_FLAGS then print("DEATH!") return end

	local shouldContinue
	for _, v in pairs(functions:GetPlayers()) do
		shouldContinue = shouldContinue or  v:GetPlayerType() == RED_PLAYER_TYPE and v:HasCollectible(BIRTHRIGHT_COLLECTIBLE)
	end
	
	if not shouldContinue then return end
	local data = saveman.save.data

	local RNG = v:GetCollectilbeRNG(BIRTHRIGHT_COLLECTIBLE)
	if RNG:RandomInt(100) + 1 > SECOND_ULTRASECRET_CHANCE + data.ultrasecretBoost then 
		data.ultrasecretBoost = data.ultrasecretBoost + 10
		return
	end

	for i, v in pairs(SURROUND_ROOM_INDEX) do
		local gridIndex = roomDesc.GridIndex + v
		if not level:GetRoomByIdx(gridIndex).Data then
			local isSafe = true
			for _, v in pairs(SURROUND_ROOM_INDEX) do
				--HELL
				local surroundData = level:GetRoomByIdx(gridIndex + v)
				isSafe = isSafe and surroundData and surroundData.VisitedCount < 1 or not surroundData
				print(isSafe)
			end

			if isSafe and level:MakeRedRoomDoor(roomDesc.GridIndex, i - 1) then
				print("AA")
				level:GetRoomByIdx(gridIndex).Data = red_room_load.ultrasecret[RNG:RandomInt(#red_room_load.ultrasecret) + 1)
			end
		end
	end
end
--- HANDLE RESETTING SECOND ULTRASECRET BOOST
function effect:PostNewLevel()
	local data = saveman.save.data
	data.ultrasecretBoost = 0
end]] 
---------------------------------------------------
return effect
