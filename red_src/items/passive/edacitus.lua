local mod = RegisterMod("Red", 1)
local game = Game()

local EdId = Isaac.GetItemIdByName("Edacitus")
local killed_shits_2137 = 0
local player = Isaac.GetPlayer(0)

local ItemBonus = {
	HUNGER = 0.25
}

function mod:counterReset()
	if game:GetFrameCount() == 1 then
		killed_shits_2137 = 0
	end
end

function mod:onCache(player, hearts)
local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EdId) then
		if game:GetFrameCount() % 940 == 0 then --2100 frames = 35 seconds, 1840 frames = 30 seconds
			ranNum = math.random(1,2) --NotSpooky is going to change it 
			if ranNum == 1 then 
				if player:GetHearts() > 0 then
				player:AddHearts(-1)
				elseif player:GetHearts() == 0 then
				player:AddSoulHearts(-1)
				end
			end
			if player:GetHearts() == 0 and player:GetSoulHearts() == 0 and player:GetBlackHearts() == 0 then
				player:Die()
			--player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 0) --doesn't eat devil deal chance 
			end
		end
	end
end

function mod:CheckEnemyDied(hitEntity, amount, damageFlag, source, countDown, cacheFlag)
local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EdId) then
		if hitEntity:IsActiveEnemy() and hitEntity.HitPoints - amount <= 0 then
			killed_shits_2137 = killed_shits_2137 + 1
		end
		if (killed_shits_2137 >= 30) then
			killed_shits_2137 = 0;
			player.Damage = player.Damage + ItemBonus.HUNGER
			if player:GetHearts() ~= 0 then
				player:AddHearts(1)
			end
			if player:GetHearts() == 0 then
				player:AddSoulHearts(1)
			end
		end
	end
end	

function mod:onCache2(player, cacheFlag)
	if player:HasCollectible(EdId) then
		if (killed_shits_2137 >= 30) then
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				if player:HasCollectible(EdId) then
					player.Damage = player.Damage + ItemBonus.SULFUR
				end
			end
		end
	end
end


--damage cache
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
--damage your ass >=]
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onCache)
--enemies death 
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CheckEnemyDied)