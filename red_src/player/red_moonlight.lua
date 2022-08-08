local func = {}
---------------------------------------------------
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
local functions = require("red_src.core.functions")
local saveman = require("red_src.core.saveman")
---------------------------------------------------
local RED_MOONLIGHT_SPRITESHEET = "gfx/effect.redlight.anm2"
local RED_ROOM_FLAGS = 1024
---------------------------------------------------
local RED_MOONLIGHT_VECTOR = Vector(320, 320)
local MOONLIGHT_VARIANT = 1
local RED_PLAYERTYPE = enums.players.red
---------------------------------------------------
local game = global.game
---------------------------------------------------
--- HANDLE ENTERING RED/ULTRA SECRET
local function changeSeen(bool)
	for _, value in pairs(functions:GetPlayers()) do
		value:GetData().seenRedMoonlight = bool
	end
end
--
function func:PostNewRoom()
	local roomDesc, room = game:GetLevel():GetCurrentRoomDesc(), game:GetRoom()
	local roomFlags, roomType = roomDesc.Flags, roomDesc.Data.Type

	changeSeen(false)	

	if roomType ~= RoomType.ROOM_ULTRASECRET and roomFlags < RED_ROOM_FLAGS or not functions:red_exists() then return end
	if roomType ~= RoomType.ROOM_SECRET and roomType ~= RoomType.ROOM_ULTRASECRET then return end

	for _, v in pairs(functions:GetPlayers()) do
		local id = functions:GetPlayerId(v)
		saveman.save.data["sawMoonlight" .. id] = v:GetEffects():GetNullEffectNum(NullItemID.ID_LUNA)
	end

	if not room:IsFirstVisit() then
		for _, v in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, MOONLIGHT_VARIANT)) do
			v:GetSprite():Load(RED_MOONLIGHT_SPRITESHEET, true)
			changeSeen(true)
		end
		
		return
	end

	
	local moonlight = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, MOONLIGHT_VARIANT, RED_MOONLIGHT_VECTOR, Vector(0,0), nil)
	
	moonlight:GetSprite():Load(RED_MOONLIGHT_SPRITESHEET, true)

	changeSeen(true)
end
---
function func:EvaluateCache(player, cache)
	if cache ~= CacheFlag.CACHE_FIREDELAY 
	or player:GetPlayerType() ~= RED_PLAYERTYPE
	or not player:GetEffects():HasNullEffect(NullItemID.ID_LUNA) then return end

	local id = functions:GetPlayerId(player)
	if saveman.save.data["sawMoonlight" .. id] == player:GetEffects():GetNullEffectNum(NullItemID.ID_LUNA) then return end

	player:TryRemoveNullCostume(NullItemID.ID_LUNA)
	
	if not player:GetData().seenRedMoonlight then return end
	
	player:AddSoulHearts(-1)
	player:AddBoneHearts(1)
	
	--[[
	local red_curse = Sprite() --fix on quit and reload
	red_curse:Load("gfx/005.100_collectible.anm2", true)
	red_curse:ReplaceSpritesheet(1, "gfx/items/collectibles/null.red_curse.png")
	red_curse:LoadGraphics()
	
	red_curse:Play("PlayerPickup")
	player:AnimatePickup(red_curse)
	]]

	player:AnimateSad() --does a glitch when you leave and rejoin in a room while also having luna

	changeSeen(false)
end
---------------------------------------------------
return func
