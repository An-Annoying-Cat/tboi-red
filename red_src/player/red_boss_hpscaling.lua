local func = {} --also removes champions
---------------------------------------------------
local global = require("red_src.core.global")
---------------------------------------------------
local RED_ROOM_FLAGS = 1024
local HP_SCALING_STAGE = {
	[EntityType.ENTITY_GURGLING] = LevelStage.STAGE1_1,
	[EntityType.ENTITY_LOKI] = LevelStage.STAGE3_1, --works for lokii
	[EntityType.ENTITY_GURDY] = LevelStage.STAGE2_2,
	[EntityType.ENTITY_GURDY_JR] = LevelStage.STAGE2_1,
	[EntityType.ENTITY_WAR] = LevelStage.STAGE3_1,
	[EntityType.ENTITY_HORNFEL] = LevelStage.STAGE3_2, --no
	[EntityType.ENTITY_CHUB] = LevelStage.STAGE2_1, --actually chad
	[EntityType.ENTITY_STAIN] = LevelStage.STAGE2_1,

}
---------------------------------------------------
local game = global.game
local level = game:GetLevel()
---------------------------------------------------
function func:PostNewRoom()
	local roomDesc = level:GetCurrentRoomDesc()
	if roomDesc.Data.Type ~= RoomType.ROOM_BOSS or roomDesc.Flags < RED_ROOM_FLAGS then return end

	for _, entity in pairs(Isaac.GetRoomEntities()) do --5 fps
		local entityType = entity.Type
		if entity:IsBoss() and HP_SCALING_STAGE[entityType] then
			local newBoss = Isaac.Spawn(entity.Type, 0, 0, entity.Position, entity.Velocity, entity.Parent)
			entity:Remove()

			local newHP = newBoss.MaxHitPoints - math.max(0, (HP_SCALING_STAGE[entityType] - level:GetStage()) * newBoss.MaxHitPoints/12)
			local hpDifference = newHP - newBoss.MaxHitPoints

			newBoss.HitPoints = math.floor(newBoss.HitPoints + hpDifference)
			print(newBoss.HitPoints, newBoss.HitPoints/newBoss.MaxHitPoints)

			newBoss.MaxHitPoints = newBoss.HitPoints
		end
	end

end

---------------------------------------------------
return func
