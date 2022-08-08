--NOTE: 100000% spaghetti code incoming
local func = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
---------------------------------------------------
local BOSS_ROOM_IDS = {5140, 2030, 3310, 1040, 3280, 4030, 5220, 1101, 1106}
local TEMPLATE_ROOM_IDS = {0}
local LOADED_ROOM_ID = -3

local ROOMS_TO_LOAD = {
	{"boss", BOSS_ROOM_IDS}, 
	{"ultrasecret", ULTRASECRET_ROOM_IDS},
	{"treasure", TREASURE_ROOM_IDS},
	{"shop", SHOP_ROOM_IDS},
	{"sacrifice", SACRIFICE_ROOM_IDS},
	{"library", LIBRARY_ROOM_IDS},
}
---------------------------------------------------
local PLAYER_ACTIVELESS_SPRITE = "gfx/player.start.anm2"
local PLAYER_RED_ACTIVE_SPRITE = "gfx/player.red.anm2"
local PLAYER_REGULAR_SPRITE = "gfx/001.000_Player.anm2"
local PLAYERTYPE_RED = enums.players.red
local COLLECTIBLE_GLOWING_HOURGLASS = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
local NEAR_ROOM_IDX = {1, -1, 13, -13}
---------------------------------------------------
local mod, loading
local game, sfx = global.game, global.sfxman
local level = game:GetLevel()
---------------------------------------------------
--- HANDLE GAME STARTING
function func:PostGameStarted()
	if func[ROOMS_TO_LOAD[#ROOMS_TO_LOAD][1]]
	or not functions:red_exists()
	or level:GetStage() == LevelStage.STAGE8 then return end

	local player = game:GetPlayer(0)
	
	func.boss, func.ultrasecret = {}, {}

	for _, v in pairs(ROOMS_TO_LOAD) do
		local roomTypeName = v[1]
		local roomIds = v[2] or TEMPLATE_ROOM_IDS

		print(roomTypeName)
		func[roomTypeName] = {}

		for _, v in pairs(roomIds) do 
			Isaac.ExecuteCommand("goto s."  .. roomTypeName .. "." .. v)
			local roomData = level:GetRoomByIdx(LOADED_ROOM_ID).Data
			player:UseActiveItem(COLLECTIBLE_GLOWING_HOURGLASS)
	
			table.insert(func[roomTypeName], roomData)
		end
	end


	sfx:Stop(SoundEffect.SOUND_HELL_PORTAL2)

	loading = true
	
	local sprite = player:GetSprite()
	sprite:Load(PLAYER_ACTIVELESS_SPRITE, true)

	mod:AddCallback(ModCallbacks.MC_POST_RENDER, func.PostRender)
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, func.UseItem) --oh no! things are getting messy!
end
--- HANDLE STOPPING ANIM
function func:PostRender()
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, func.PostRender)
end
--- HANDLE CHANGING SPRITESHEET WHEN PLAYER USES AN ITEM
function func:UseItem(item, rng, player)
	local sprite = player:GetSprite()

	if sprite:GetFilename() ~= PLAYER_ACTIVELESS_SPRITE then return end
	sprite:Load(PLAYER_RED_ACTIVE_SPRITE, true)
end
---
function func:PostNewRoom()
	local player = game:GetPlayer(0)	
	local sprite = player:GetSprite()

	if sprite:GetFilename() ~= PLAYER_ACTIVELESS_SPRITE then return end
	if loading then loading = false return end
	
	sprite:Load(PLAYER_REGULAR_SPRITE, true)
	player:ChangePlayerType(PLAYERTYPE_RED)
end
---
function func:init(_mod)
	mod = _mod
end
---------------------------------------------------
return func
