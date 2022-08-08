local item = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.lil_warlock
local ITEM_CONFIG = Isaac.GetItemConfig():GetCollectible(COLLECTIBLE)
local FAMILIAR = enums.familiars.lil_warlock
local TEAR_VARIANT = TearVariant.MYSTERIOUS
local TEAR_FLAGS = TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP | TearFlags.TEAR_JACOBS
local BFFS_FLAGS = {[true] = TearFlags.TEAR_QUADSPLIT, [false] = TearFlags.TEAR_NORMAL} --true if BFFs
local FIRE_COOLDOWN = {[true] = 14, [false] = 20} --true if forgotten lullaby
---------------------------------------------------
local TEAR_SCALE = 1.2
local TEAR_STOP_FIRE_ANIM_NUM = 10
---------------------------------------------------
local DIRECTION_TO_VECTOR = {
	[Direction.LEFT]	= Vector(-1, 0),
	[Direction.UP]		= Vector(0, -1),
	[Direction.RIGHT]	= Vector(1, 0),
	[Direction.DOWN]	= Vector(0, 1)
}
---------------------------------------------------
function item:FamiliarInit(familiar)
	if familiar.Variant ~= FAMILIAR then return end

	familiar:PlayFloatAnim(Direction.DOWN)
	familiar:AddToFollowers()
end

function item:FamiliarUpdate(familiar)
	if familiar.Variant ~= FAMILIAR then return end
	familiar.FireCooldown = familiar.FireCooldown - 1

	familiar:FollowParent()

	local player = familiar.Player
	local fireDirection = player:GetFireDirection()
	local movementDirection = player:GetMovementDirection()

	local lookDirection =	(fireDirection ~= Direction.NO_DIRECTION and fireDirection) or 
				(movementDirection ~= Direction.NO_DIRECTION and movementDirection) or Direction.DOWN

	local fireCooldown = FIRE_COOLDOWN[player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY)]
	
	if familiar.FireCooldown <= fireCooldown - TEAR_STOP_FIRE_ANIM_NUM then 
		familiar:PlayFloatAnim(lookDirection) 
	end

	if familiar.FireCooldown > 0 or fireDirection == Direction.NO_DIRECTION then return end

	familiar:PlayShootAnim(fireDirection)
	local tear = familiar:FireProjectile(DIRECTION_TO_VECTOR[fireDirection])

	local tearFlags = TEAR_FLAGS | BFFS_FLAGS[player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS)]
	tear:AddTearFlags(tearFlags)

	tear:ChangeVariant(TEAR_VARIANT)
	tear.Scale = TEAR_SCALE

	familiar.FireCooldown = fireCooldown
end

function item:EvaluateCache(player, cache)
	if cache ~= CacheFlag.CACHE_FAMILIARS then return end

	local boxUses =  player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
	local itemNum = player:GetCollectibleNum(COLLECTIBLE)
	local itemRNG = player:GetCollectibleRNG(COLLECTIBLE)

	local familiarNum = (itemNum > 0) and (itemNum + boxUses) or 0

	player:CheckFamiliar(FAMILIAR, familiarNum, itemRNG, ITEM_CONFIG)
end
---------------------------------------------------
return item
