local item = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local sfx = global.sfxman
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.trance
local STAT_BOOSTS = {
	[CacheFlag.CACHE_DAMAGE] = .4,
	[CacheFlag.CACHE_SHOTSPEED] = -.2,
}
local CLOSE_EFFECTS = {
	TearFlags.TEAR_BAIT, --jabaited
	TearFlags.TEAR_CHARM,
}
local ENTITY_EFFECTS = {
	EntityFlag.FLAG_CHARM ,
	EntityFlag.FLAG_BAITED,
	
}
local EFFECT_CHANCE = 5
---------------------------------------------------
local tears = {}
local PLAYER_STATS = {
	[CacheFlag.CACHE_DAMAGE] = "Damage",
	[CacheFlag.CACHE_SHOTSPEED] = "ShotSpeed",
}
---------------------------------------------------
--- STAT UPDATER
function item:EvaluateCache(player, cache)
	if not player:HasCollectible(COLLECTIBLE) or not STAT_BOOSTS[cache] then return end
	local selectedStat = PLAYER_STATS[cache]

	player[selectedStat] = player[selectedStat] + STAT_BOOSTS[cache]
end
--- HANDLE ENEMIES CLOSE RANGE
function item:PostPeffectUpdate(player)
	if not player:HasCollectible(COLLECTIBLE) then return end
	
	local RNG = player:GetCollectibleRNG(COLLECTIBLE)

	for _, v in pairs(Isaac.FindInRadius(player.Position, 135)) do 
		if RNG:RandomInt(100) + 1 <= EFFECT_CHANCE 
		and v:IsEnemy() 
		and v:IsVulnerableEnemy() --fuck you shopkeepers
		and not v:IsInvincible() 
		and not v:IsBoss() 
		and not v:HasEntityFlags(ENTITY_EFFECTS[1]) 
		and not v:HasEntityFlags(ENTITY_EFFECTS[2]) then
			
			local effectTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, v.Position, Vector(0, 0), player):ToTear()
			effectTear:GetSprite():Reset()
			effectTear.CollisionDamage = 0
			effectTear.Scale = 0
			
			tears[GetPtrHash(effectTear)] = true

			local selectedFlag = CLOSE_EFFECTS[RNG:RandomInt(#CLOSE_EFFECTS) + 1]
			effectTear:AddTearFlags(selectedFlag | TearFlags.TEAR_CHAIN)
		end
	end
end
--- HANDLE INVISIBLE TEAR
function item:PostTearUpdate(tear)
	if not tears[GetPtrHash(tear)] then return end

	tears[GetPtrHash(tear)] = nil
	sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
end
---------------------------------------------------
return item
