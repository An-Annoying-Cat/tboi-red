local pickup = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
---------------------------------------------------
local PICKUP_VARIANT = enums.pickups.red_chest
local OPENED_PICKUP_VARIANT = enums.pickups.red_chest_opened
local MULTIPLIER = 1.5
local RED_DOOR_NUM = 2 
local POOF_VARIANT = 1 
local POSSIBLE_PICKUPS = {Card.CARD_CRACKED_KEY,} --enums.cards.cheat_card, enums.cards.soul_of_red}
local MAX_EXTRA_CHEST_PICKUPS = 3
local MIN_CHEST_PICKUPS = 2
---------------------------------------------------
local MAX_DOOR_CREATE_ATTEMPTS = 50
local DOOR_TO_INDEX = {
	[DoorSlot.LEFT0] = -1,
	[DoorSlot.UP0] = -13,
	[DoorSlot.RIGHT0] = 1,
	[DoorSlot.DOWN0] = 13,
}
local APPEAR_ANIMATION = "Appear"
local ItemConfig = Isaac.GetItemConfig()
local RED_KEY_MAX_CHARGE = ItemConfig:GetCollectible(CollectibleType.COLLECTIBLE_RED_KEY).MaxCharges
local REDS_KEY_MAX_CHARGE = ItemConfig:GetCollectible(enums.collectibles.reds_key).MaxCharges
local MAP_DIMENSIONS = 13
local MAX_SPAWN_VELOCITY = 10
local MIN_SPAWN_VELOCITY = -10
local PICKUP_FRAME_DELAY = 5 
local SOUL_VARIANT = 1
local TARGET_SUBTYPE = 21
local DISTANCE_FOR_SFX = 600 
local MAX_RANDOM_DIST = 300
local OPEN_CHEST_SOUNDS = {SoundEffect.SOUND_UNLOCK00, SoundEffect.SOUND_CHEST_OPEN, SoundEffect.SOUND_BLACK_POOF}
local DROP_SOUND = SoundEffect.SOUND_CHEST_DROP
---------------------------------------------------
local game, sfx = global.game, global.sfxman
local level = game:GetLevel()
local preventRemove
---------------------------------------------------
local a = 0 
---------------------------------------------------
--- HANDLE PLAYING UNLOCK SOUND
function pickup:PostEffectUpdate(effect)
	if effect.Variant ~= EffectVariant.ENEMY_SOUL or effect.SubType ~= SOUL_VARIANT then return end
	
	local target = effect.Target
 	if not target 
	or target.Type ~= EntityType.ENTITY_EFFECT 
	or target.Variant ~= EffectVariant.ENEMY_SOUL 
	or target.SubType ~= TARGET_SUBTYPE  then return end


	local center = game:GetRoom():GetCenterPos()

	local RNG = effect:GetDropRNG()
	if center:Distance(effect.Position) <= DISTANCE_FOR_SFX + RNG:RandomInt(MAX_RANDOM_DIST) then return end

	sfx:Play(SoundEffect.SOUND_UNLOCK00)
	effect:Remove()
	target:Remove()
end
---  HANDLE PICKUP COLLISION
local function GetValidDoorSlots(roomDesc) --from dms with xalum 5/5/22
	local indexes = {} --indexi?
	for _, v in pairs(DoorSlot) do
		table.insert(indexes, roomDesc.Data.Doors & (1 << v) > 0 and v or nil)
	end

	return indexes
end
--
function pickup:PostPickupInit(pickup)
	if pickup.Variant == PICKUP_VARIANT and pickup:GetSprite():GetAnimation() == APPEAR_ANIMATION then
		sfx:Play(DROP_SOUND)
	elseif pickup.Variant == OPENED_PICKUP_VARIANT and not preventRemove then 
		pickup:Remove()
	end
end
--
function pickup:PrePickupCollision(pickup, collider)
	local player = collider:ToPlayer()
	if not player or pickup.Variant ~= PICKUP_VARIANT then return end	
	local KEY_SLOTS = {} --1 is red key, 2 is red's key
	for i, c in pairs({CollectibleType.COLLECTIBLE_RED_KEY, enums.collectibles.reds_key}) do
		for _, v in pairs(ActiveSlot) do
			KEY_SLOTS[i] = KEY_SLOTS[i] or player:GetActiveItem(v) == c and v
		end 
	end
	
	local hasChargedRedKey = KEY_SLOTS[1] and player:GetActiveCharge(KEY_SLOTS[1]) >= RED_KEY_MAX_CHARGE
	local hasChargedRedsKey = KEY_SLOTS[2] and player:GetActiveCharge(KEY_SLOTS[2]) >= REDS_KEY_MAX_CHARGE

	local openedDoors = (hasChargedRedKey
			  or hasChargedRedsKey
			  or player:GetCard(0) == Card.CARD_CRACKED_KEY) and RED_DOOR_NUM * MULTIPLIER
			  or player:GetNumKeys() > 0 and RED_DOOR_NUM

	local sprite = pickup:GetSprite()
	if not openedDoors or sprite:GetAnimation() ~= "Idle" then return end

	local createdIndex = {}
	local RNG = pickup:GetDropRNG()

	a = 0 --attempts 
	for i = 1, openedDoors do
		::try_spawn_again::

		a = a + 1
		if a == 50 then goto continue end

		local selectedRoom = level:GetRoomByIdx(level:GetRandomRoomIndex(false, RNG:RandomInt(2^31) + 1))
	
		
		if selectedRoom.Data.Shape >= RoomShape.ROOMSHAPE_1x2 
		or ((a < 25 and selectedRoom.Data.Type ~= RoomType.ROOM_DEFAULT) or (a >= 25 and true))
		then goto try_spawn_again end --i am not dealing with this

		local doorSlots = GetValidDoorSlots(selectedRoom)
		for _, v in pairs(doorSlots) do
			if level:MakeRedRoomDoor(selectedRoom.SafeGridIndex, v) then 
				table.insert(createdIndex, selectedRoom.SafeGridIndex + DOOR_TO_INDEX[v]) 				
				goto stop_loop_cycle
			end 
		end

		goto try_spawn_again
		::stop_loop_cycle::
	end

	::continue::

	local currentIndex = level:GetCurrentRoomIndex()
	local currentY = math.ceil(currentIndex/MAP_DIMENSIONS)
	local currentX = currentIndex - currentY*MAP_DIMENSIONS
	
	local xModifier = currentX ~= 0 and 1 or -1  

	for _, v in pairs(createdIndex) do
		local createdY = math.ceil(v/MAP_DIMENSIONS)
		local createdX = v - createdY*MAP_DIMENSIONS

		local x, y = createdX - currentX, createdY - currentY

		local targetEntity = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_SOUL, TARGET_SUBTYPE, game:GetRoom():GetCenterPos() + Vector(x*2^10*xModifier, y*2^10), Vector(0,0), nil)
		targetEntity.SpriteOffset = Vector(10000, 10000)

		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_SOUL, SOUL_VARIANT, pickup.Position, Vector(MIN_SPAWN_VELOCITY + RNG:RandomInt(MAX_SPAWN_VELOCITY - MIN_SPAWN_VELOCITY), MIN_SPAWN_VELOCITY + RNG:RandomInt(MAX_SPAWN_VELOCITY - MIN_SPAWN_VELOCITY)), nil).Target = targetEntity
	end

	local pickupNum = RNG:RandomInt(MAX_EXTRA_CHEST_PICKUPS) + MIN_CHEST_PICKUPS
	for i = 1, pickupNum do
		local card = POSSIBLE_PICKUPS[RNG:RandomInt(#POSSIBLE_PICKUPS) + 1]
		local newPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, pickup.Position, Vector(MIN_SPAWN_VELOCITY + RNG:RandomInt(MAX_SPAWN_VELOCITY - MIN_SPAWN_VELOCITY), MIN_SPAWN_VELOCITY + RNG:RandomInt(MAX_SPAWN_VELOCITY - MIN_SPAWN_VELOCITY)), nil)
		newPickup:GetSprite():SetFrame(-RNG:RandomInt(PICKUP_FRAME_DELAY))
	end

	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, POOF_VARIANT, pickup.Position, Vector(0,0), nil)

	preventRemove = true
	pickup:Morph(EntityType.ENTITY_PICKUP, OPENED_PICKUP_VARIANT, 0)
	preventRemove = false

	for _, v in pairs(OPEN_CHEST_SOUNDS) do
		sfx:Play(v)
	end

	if player:GetCard(0) == Card.CARD_CRACKED_KEY then 
		player:SetCard(0, 0) 
		return true 
	end
	
	if hasChargedRedKey then
		player:DischargeActiveItem(KEY_SLOTS[1])
		return true
	end

	if hasChargedRedsKey then
		player:DischargeActiveItem(KEY_SLOTS[2])
		return true
	end
	

	player:AddKeys(-1)

	return true
end
---------------------------------------------------
return pickup
