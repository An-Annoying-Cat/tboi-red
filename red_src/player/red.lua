local char = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")
---------------------------------------------------
local PLAYER_TYPE = enums.players.red
local ILLEGAL_COLLECTIBLE = CollectibleType.COLLECTIBLE_RED_KEY
local POCKET_COLLECTIBLE = enums.collectibles.reds_key
local UNLOCKABLE_TRINKET = TrinketType.TRINKET_CRYSTAL_KEY
local TRINKET_SAVE = "crystal_key_start"
---------------------------------------------------
local game = global.game
local level = game:GetLevel()
---------------------------------------------------
--- HANDLE GIVING ITEMS
function char:PostPeffectUpdate(player)	
	if player:GetPlayerType() ~= PLAYER_TYPE then return end
	
	local savedata = saveman.save.data

	if player:HasCollectible(ILLEGAL_COLLECTIBLE) and player:HasCollectible(POCKET_COLLECTIBLE) then 
		savedata.redsKeyCharge = player:GetActiveCharge(ActiveSlot.SLOT_POCKET)
		return 
	end
	
	local backdrop = game:GetRoom():GetBackdropType()
	if (backdrop == BackdropType.MINES_SHAFT or backdrop == BackdropType.ASHPIT_SHAFT) and level:GetStage() == LevelStage.STAGE2_2 then return end
	
	if not player:HasCollectible(POCKET_COLLECTIBLE) then
		player:SetPocketActiveItem(POCKET_COLLECTIBLE)
		player:SetActiveCharge(savedata.redsKeyCharge or 3, ActiveSlot.SLOT_POCKET)
	end

	local playerPosition = player.Position

	player:RemoveCollectible(ILLEGAL_COLLECTIBLE) --glowing hourglass shenanigans
	player:AddCollectible(ILLEGAL_COLLECTIBLE, 0, false, 3) 
	--putting it at 4 doesn't allow the player to fire
	
	player:SetActiveCharge(3, ActiveSlot.SLOT_POCKET)


	level:UpdateVisibility()

	if not saveman.save.unlocks[TRINKET_SAVE] or player:HasTrinket(UNLOCKABLE_TRINKET) then return end
	player:AddTrinket(UNLOCKABLE_TRINKET)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false)
end
--- HANDLE RANDOM ASS THING I CAN BARELY RECREATE
function char:PostNewRoom()
	for _, player in pairs(functions:GetPlayers()) do
		if player:GetPlayerType() == PLAYER_TYPE then player:StopExtraAnimation() end
	end
end
-- HANDLE TEAR FIRING
function char:PostTearInit(tear)
	local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
	if not player or player:GetPlayerType() ~= PLAYER_TYPE then return end

	if tear.Variant ~= TearVariant.BLUE then return end
	tear:ChangeVariant(TearVariant.BLOOD)
end
---------------------------------------------------
return char
