local myMod = RegisterMod("mod for ener", 1)
local game = Game()
local McId = Isaac.GetCardIdByName("MonsterCard")


function myMod:CardCallback(cardId, player)
local entities = Isaac.GetRoomEntities();
local ranNum = math.random(1, 16)
	--print(ranNum)
print(McId)
	--if ranNum == 1 then
		--Chad = Isaac.Spawn(28, 1, 0, player.Position, Vector(0, 0), nil)
		--Chad:AddCharmed(EntityRef(Player), -1, EntityFlag.FLAG_FRIENDLY_BALL, EntityFlag.FLAG_PERSISTENT) --chad, I cannot find code =[
		--Chad:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	if ranNum == 1 then
		Plum = Isaac.Spawn(EntityType.ENTITY_BABY_PLUM, 0, 0, player.Position, Vector(0, 0), nil)
		Plum:AddCharmed(EntityRef(Player), -1) 
		Plum:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 2 then
		Gurdy = Isaac.Spawn(EntityType.ENTITY_GURDY, 0, 0, player.Position, Vector(0, 0), nil)
		Gurdy:AddCharmed(EntityRef(Player), -1) 
		Gurdy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 3 then
		Gurgling = Isaac.Spawn(EntityType.ENTITY_GURGLING, 0, 0, player.Position, Vector(0, 0), nil)
		Gurgling:AddCharmed(EntityRef(Player), -1) 
		Gurgling:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 4 then
		BlightedO = Isaac.Spawn(79, 2, 0, player.Position, Vector(0, 0), nil) -- blighted twins
		BlightedO:AddCharmed(EntityRef(Player), -1) 
		BlightedO:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 5 then
		Wer = Isaac.Spawn(100, 1, 0, player.Position, Vector(0, 0), nil) -- widow but blighted
		Wer:AddCharmed(EntityRef(Player), -1) 
		Wer:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 6 then
		Gate = Isaac.Spawn(EntityType.ENTITY_GATE, 1, 0, player.Position, Vector(0, 0), nil)
		Gate:AddCharmed(EntityRef(Player), -1) 
		Gate:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 7 then
		Hob = Isaac.Spawn(EntityType.ENTITY_HORNY_BOYS, 1, 0, player.Position, Vector(0, 0), nil)
		Hob:AddCharmed(EntityRef(Player), -1) 
		Hob:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)                   
	elseif ranNum == 8 then
		War = Isaac.Spawn(EntityType.ENTITY_WAR, 0, 0, player.Position, Vector(0, 0), nil)
		War:AddCharmed(EntityRef(Player), -1) 
		War:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 9 then
		Heart = Isaac.Spawn(EntityType.ENTITY_HEART_OF_INFAMY, 1, 0, player.Position, Vector(0, 0), nil)
		Heart:AddCharmed(EntityRef(Player), -1) 
		Heart:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 10 then
		Loki = Isaac.Spawn(EntityType.ENTITY_LOKI, 0, 0, player.Position, Vector(0, 0), nil)
		Loki:AddCharmed(EntityRef(Player), -1) 
		Loki:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 11 then
		Lokii = Isaac.Spawn(EntityType.ENTITY_LOKI, 1, 0, player.Position, Vector(0, 0), nil)
		Lokii:AddCharmed(EntityRef(Player), -1) 
		Lokii:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 12 then
		Stain = Isaac.Spawn(EntityType.ENTITY_STAIN, 0, 0, player.Position, Vector(0, 0), nil)
		Stain:AddCharmed(EntityRef(Player), -1) 
		Stain:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)              --done
	elseif ranNum == 13 then
		Bloat = Isaac.Spawn(EntityType.ENTITY_PEEP, 1, 0, player.Position, Vector(0, 0), nil)
		Bloat:AddCharmed(EntityRef(Player), -1) 
		Bloat:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 14 then
		Fred = Isaac.Spawn(EntityType.ENTITY_MR_FRED, 0, 0, player.Position, Vector(0, 0), nil)
		Fred:AddCharmed(EntityRef(Player), -1) 
		Fred:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	elseif ranNum == 15 then
		Sclex = Isaac.Spawn(EntityType.ENTITY_PIN, 1, 0, player.Position, Vector(0, 0), nil)
		Sclex:AddCharmed(EntityRef(Player), -1) 
		Sclex:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
	end
end
--AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL | EntityFlag.FLAG_PERSISTENT)
--EntityFlag.FLAG_PERSISTENT - don't perish
--EntityFlag.FLAG_FRIENDLY_BALL - don't deal damage
--908.0 - baby plum
--28.1 - CHAD

myMod:AddCallback(ModCallbacks.MC_USE_CARD, myMod.CardCallback, McId)

