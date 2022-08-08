local item = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
---------------------------------------------------
local COLLECTIBLE = enums.collectibles.lil_melissa
local ITEM_CONFIG = Isaac.GetItemConfig():GetCollectible(COLLECTIBLE)
local FAMILIAR = enums.familiars.lil_melissa
local TEAR_FLAGS = {[true] = TearFlags.TEAR_MIDAS, [false] = TearFlags.TEAR_LIGHT_FROM_HEAVEN} --rng
local FIRE_COOLDOWN = {[true] = 30, [false] = 35} --true if forgotten lullaby 
---------------------------------------------------
local TEAR_HEIGHT = -20
local VELOCITY_MODIFIER = .7
local MIDAS_COLOR = Color(1, 1, .6, .8, 1, .6)
---------------------------------------------------
local DIRECTION_TO_VECTOR = {
	[Direction.LEFT]	= Vector(-1, 0),
	[Direction.UP]		= Vector(0, -1),
	[Direction.RIGHT]	= Vector(1, 0),
	[Direction.DOWN]	= Vector(0, 1)
}
---------------------------------------------------
--- HANDLE FAMILIAR INIT
function item:FamiliarInit(familiar)
	if familiar.Variant ~= FAMILIAR then return end

	familiar:PlayFloatAnim(Direction.DOWN)
	familiar:AddToFollowers()
end
--- HANDLE FAMILIAR UPDATE
function item:FamiliarUpdate(familiar)
	if familiar.Variant ~= FAMILIAR then return end
	familiar.FireCooldown = familiar.FireCooldown - 1

	familiar:FollowParent()

	local player = familiar.Player
	local fireDirection = player:GetFireDirection()
	local moveDirection = player:GetMovementDirection()
	
	local lookDirection =	(fireDirection ~= Direction.NO_DIRECTION and fireDirection) or 
				(movementDirection ~= Direction.NO_DIRECTION and movementDirection) or Direction.DOWN

	local fireCooldown = FIRE_COOLDOWN[player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY)]
	
	if familiar.FireCooldown <= fireCooldown - 10 then 
		familiar:PlayFloatAnim(lookDirection) 
	end 
	
	if familiar.FireCooldown > 0 or fireDirection == Direction.NO_DIRECTION then return end

	familiar:PlayShootAnim(fireDirection)
	local tear = familiar:FireProjectile(DIRECTION_TO_VECTOR[fireDirection])
	
	tear.Velocity = tear.Velocity * VELOCITY_MODIFIER
	tear.Height = TEAR_HEIGHT

	local RNG = player:GetCollectibleRNG(COLLECTIBLE)
	local tearFlag = TEAR_FLAGS[RNG:RandomInt(10) > 8]

	tear:AddTearFlags(tearFlag)
	familiar.FireCooldown = fireCooldown

	if tearFlag == TEAR_FLAGS[false] then return end
	tear:GetSprite().Color = MIDAS_COLOR
end
--- GIVE FAMILIARS TO PLAYER
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
