local char = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")
---------------------------------------------------
local SPRITE_OFFSET = Vector(1000, 1000)
local PLAYER_MOVESPEED = 0
local PLAYER_POSITION = Vector(160, 280)
local DAMAGE_MULTIPLIER = .65
local STARTING_ITEMS = {CollectibleType.COLLECTIBLE_HAEMOLACRIA}
---------------------------------------------------
local PRE_RED_ROOM = 108
local CHAR_RED_ROOM = 94
local FAKE_SPRITESHEET = "gfx/characters/costumes/character_gray.png"
local FAKE_VECTOR = Vector(440, 280)
local PLAYER_SLOTVARIANT = 14
---------------------------------------------------
local game = global.game
local level = game:GetLevel()
local ItemConfig = Isaac.GetItemConfig()
---------------------------------------------------
--- HANDLE TAINTED UNLOCK AND STUFF
local function SpawnCharSlot()
	for _, t in pairs({Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER), Isaac.FindByType(EntityType.ENTITY_PICKUP)}) do
		for _, v in pairs(t) do
			v:Remove() 
		end
	end

	for _, v in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT, PLAYER_SLOTVARIANT)) do
		local sprite = v:GetSprite()
		sprite:ReplaceSpritesheet(0, FAKE_SPRITESHEET)	
		sprite:LoadGraphics()
		return
	end
	
	local grayFake = Isaac.Spawn(EntityType.ENTITY_SLOT, PLAYER_SLOTVARIANT, 0, FAKE_VECTOR, Vector(0,0), nil):GetSprite()
	grayFake:ReplaceSpritesheet(0, FAKE_SPRITESHEET)	
	grayFake:LoadGraphics()

end
--- HANDLE PLAYER WITHOUT UNLOCK
local function AdjustPlayerAndRoom(player)
	player:GetSprite().Offset = SPRITE_OFFSET
	player.MoveSpeed = PLAYER_MOVESPEED
	player.Position = PLAYER_POSITION
	player.FireDelay = math.huge


	game:GetRoom():GetDoor(DoorSlot.RIGHT0):GetSprite().Scale = Vector(0,0)
end
--
local function GoToDarkCloset(player, returning)
	if not returning then 
		for i = 1, 10 do player:UsePill(PillEffect.PILLEFFECT_SMALLER, PillColor.PILL_NULL, UseFlag.USE_NOANNOUNCER) end
		player:EvaluateItems()

		--ooOOO super cool stuff!!
		Isaac.ExecuteCommand("stage 13")
		level:MakeRedRoomDoor(PRE_RED_ROOM, 0)
		level:ChangeRoom(CHAR_RED_ROOM)
	
		SpawnCharSlot()
	end

	AdjustPlayerAndRoom(player)
	game:GetHUD():SetVisible()
end
--- HANDLE GAME START
function char:PostGameStarted(returning)
	local player = game:GetPlayer(0)
	if saveman.save.unlocks.gray or player:GetPlayerType() ~= enums.players.gray then return end
	GoToDarkCloset(player, returning) 
end
--- HANDLE PLAYER INIT
function char:PostPlayerInit(player)
    if player:GetPlayerType() ~= enums.players.gray then return end
	saveman:Load()
    if not saveman.save.unlocks.gray and functions:GetPlayerId(player) ~= 0 then player:ChangePlayerType(enums.players.red) return end

    local CustomeId = Isaac.GetCostumeIdByPath("gfx/characters/character_gray_head.anm2")
    player:AddNullCostume(CustomeId)
	print(STARTING_ITEMS[1])

    for _, v in pairs(STARTING_ITEMS) do
        if not player:HasCollectible(v) then    
            player:AddCollectible(v)
            player:RemoveCostume(ItemConfig:GetCollectible(v))
        end
    end
end
--- HANDLE CACHE EVALUATION
function char:EvaluateCache(player, cache)
	if cache ~= CacheFlag.CACHE_DAMAGE or player:GetPlayerType() ~= enums.players.gray then return end
	player.Damage = player.Damage * DAMAGE_MULTIPLIER
end
--- HANDLE SPAWNING PLAYER SLOT
function char:PostNewRoom()
	if level:GetStage() ~= LevelStage.STAGE8 
	or level:GetCurrentRoomIndex() ~= CHAR_RED_ROOM 
	or saveman.save.unlocks.gray
	or not functions:red_exists() then return end	

	SpawnCharSlot()
end
--- HANDLE PLAYER UNLOCK
function char:PrePlayerCollision(player, collider)
	if saveman.save.unlocks.gray or collider.Type ~= EntityType.ENTITY_SLOT then return end
	if collider.Variant ~= PLAYER_SLOTVARIANT or player:GetPlayerType() ~= enums.players.red then return end
	saveman.save.unlocks.gray = true
	saveman:Save()
	--TODO: Add callback to wait for the slot's animation to finish.
end

---------------------------------------------------
return char
