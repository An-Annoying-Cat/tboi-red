local item = {}
---------------------------------------------------
local global = require("red_src.core.global")
local enums = require("red_src.core.enums")
local saveman = require("red_src.core.saveman")
local functions = require("red_src.core.functions")
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.zenith
local DAMAGE_BOOST = 2
local TEAR_FLAGS = TearFlags.TEAR_ORBIT | TearFlags.TEAR_ROCK | TearFlags.TEAR_SPECTRAL
local TEAR_VARIANTS = TearVariant.ROCK
---------------------------------------------------
local FALLING_SPEED = -10
local VELOCITY_MODIFIER = -1
local POSITION_MODIFIER = Vector(0, -10)
local game = global.game
---------------------------------------------------
--- STAT UPDATER
function item:EvaluateCache(player, cache)
	if not player:HasCollectible(COLLECTIBLE) or cache ~= CacheFlag.CACHE_DAMAGE then return end
	
	player.Damage = player.Damage + DAMAGE_BOOST
end
--- TEAR HANDLER
function item:PostFireTear(tear)
	local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
	if not player then return end

	saveman.save.data.zenith = saveman.save.data.zenith or {}
	local save = saveman.save.data.zenith

	local saveIndex = "tearIndex" .. functions:GetPlayerId(player)
	save[saveIndex] = tear.TearIndex ~= 2^32 and tear.TearIndex or save[saveIndex]

	local data = player:GetData()
	local fireDirection = player:GetFireDirection()

	if not player:HasCollectible(COLLECTIBLE)
	or tear.TearIndex == 2^32 
	or tear.TearIndex % 2 ~= (0 and data.ZenithRight and fireDirection ~= Direction.UP and fireDirection ~= Direction.RIGHT or 1)
	--special cases
	or 	tear.Variant == TearVariant.BOBS_HEAD
	or	tear.Variant == TearVariant.CHAOS_CARD
	or	tear.Variant == TearVariant.KEY
	or	tear.Variant == TearVariant.KEY_BLOOD
	or	tear.Variant == TearVariant.ERASER
	or	tear.Variant == TearVariant.SWORD_BEAM
	or	tear.Variant == TearVariant.TECH_SWORD_BEAM
	then return end


	tear:AddTearFlags(TEAR_FLAGS)
	tear:ChangeVariant(TEAR_VARIANTS)

	tear.FallingSpeed = FALLING_SPEED
	tear.Velocity = tear.Velocity * VELOCITY_MODIFIER
	tear.Position = player.Position + POSITION_MODIFIER
end
--- PLAYER HANDLER
function item:PostPlayerInit(player)
	local tearindex = saveman.save.data["tearindex" .. functions:GetPlayerId(player)]

	player:GetData().ZenithRight = tearindex and tearindex % 2 == 1 --how does this work
end
---------------------------------------------------
return item 
