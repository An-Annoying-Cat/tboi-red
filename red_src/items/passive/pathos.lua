local item = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.pathos 
local PROJ_PROC_CHANCE = 100
local TEAR_PROC_CHANCE = 75
local FIRE_DELAY_MUL = 1
---------------------------------------------------
local debounce_tear, debounce_projectile
local POSITION_ADDITION = {
	[Direction.UP] = Vector(8, 0),
	[Direction.DOWN] = Vector(8, 0),
	[Direction.LEFT] = Vector(0, 8),
	[Direction.RIGHT] = Vector(0, 8),
}
---------------------------------------------------
--- STAT UPDATER
function item:EvaluateCache(player, cache)
	if cache ~= CacheFlag.CACHE_FIREDELAY or not player:HasCollectible(COLLECTIBLE) then return end

	player.MaxFireDelay = player.MaxFireDelay * FIRE_DELAY_MUL	
end
--- TEAR DOUBLER
function item:PostFireTear(tear)
	if debounce_tear then debounce_tear = false return end
	 
	local player = tear.SpawnerEntity:ToPlayer()
	local RNG = player:GetCollectibleRNG(COLLECTIBLE)

	if not player or not player:HasCollectible(COLLECTIBLE) or RNG:RandomInt(100) + 1 > TEAR_PROC_CHANCE then return end

	debounce_tear = true

	local newTear = player:FireTear(player.Position, tear.Velocity)
	local fireDirection = player:GetFireDirection()

	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then return end

	tear.Position = newTear.Position + POSITION_ADDITION[fireDirection]
	newTear.Position = newTear.Position - POSITION_ADDITION[fireDirection]
end	
--- PROJECTILE HANDLER
local function GetHashTable()
	local hashTable = {}

	for _, v in pairs(Isaac.GetRoomEntities()) do
		hashTable[tostring(GetPtrHash(v))] = v
	end

	return hashTable
end
--
local function FindSecondProjectile(hashTable) --check for new projectiles
	local secondProjectile

	for _, v in pairs(Isaac.GetRoomEntities()) do
		secondProjectile = secondProjectile or not hashTable[tostring(GetPtrHash(v))] and v.Type == 9 and v
	end
	
	return secondProjectile
end
--
function item:PostProjectileInit(projectile)
	if debounce_projectile then debounce_projectile = false return end

	local player = functions:GetFirstPlayerWithCollectible(COLLECTIBLE)
	local projectileSpawner = projectile.SpawnerEntity and projectile.SpawnerEntity:ToNPC()

	if not player or not projectileSpawner then return end
	
	local RNG = player:GetCollectibleRNG(COLLECTIBLE)
	local spawnerEntity = projectile.SpawnerEntity:ToNPC()

	if not spawnerEntity or spawnerEntity:IsBoss() or RNG:RandomInt(100) + 1 > PROJ_PROC_CHANCE then return end 
	local hashTable = GetHashTable()

	debounce_projectile = true

	spawnerEntity:FireProjectiles(spawnerEntity.Position, projectile.Velocity, 0, ProjectileParams())
	local newProjectile = FindSecondProjectile(hashTable)

end 
---------------------------------------------------
return item
