local functions = {}
local enums = require("red_src.core.enums")
local global = require("red_src.core.global")
---------------------------------------------------
local game = global.game
local mod

local time
local queued_functions = {}
----------------------------
---- GET PLAYERS
function functions:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end
--- GET FIRST PLAYER WITH ITEM
function functions:GetFirstPlayerWithCollectible(collectible)
	local selectedPlayer

	for _, v in pairs(functions:GetPlayers()) do
		selectedPlayer = selectedPlayer or v:HasCollectible(collectible) and v:ToPlayer()
	end

	return selectedPlayer
end
functions.item_exists = functions.GetFirstPlayerWithCollectible

--- GET FIRST PLAYER WITH TRINKET 
function functions:GetFirstPlayerWithTrinket(trinket)
	local selectedPlayer 

	for _, v in pairs(functions:GetPlayers()) do
		selectedPlayer = selectedPlayer or v:HasTrinket(trinket) and v:ToPlayer()
	end

	return selectedPlayer
end

--- GET FIRST PLAYER WITH PLAYER TYPE
function functions:GetFirstPlayerWithPlayerType(playerType)
	playerType = playerType or enums.players.red 

	local playerWithType
	for _, v in pairs(functions:GetPlayers()) do
		playerWithType = playerWithType or v:GetPlayerType() == playerType and v:ToPlayer()
	end

	return playerWithType
end

functions.red_exists = functions.GetFirstPlayerWithPlayerType 
--- GET PLAYER ID 
function functions:GetPlayerId(player)
	local hash = GetPtrHash(player)

	for i = 0, game:GetNumPlayers() - 1 do
		if GetPtrHash(Isaac.GetPlayer(i)) == hash then return i end
	end
end

--- GET FIRST PLAYER WITH TRINK

--[[ Could you repeat that?
local function Repeat()
	time = time + 1
	print('a')
	func()

	if time >= num then
		mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, Repeat)
	end
end

function functions:Repeat(_num, _func)
	num, func, time = _num, _func, 0

	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Repeat)
end
]]
local function delay()
	time = time + 1 or 1

	for i, v in pairs(queued_functions) do
		if v[1] >= time then
			v[2]()
			queued_functions[i] = nil	
		end
	end
	
	if #functions == 0 then
		time = nil
		mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, delay)
	end
end
--- DELAY 
function functions:delay(frames, func)
	table.insert(queued_functions, {frames, func})
	
	if not time then
		time = 0
		mod:AddCallback(ModCallbacks.MC_POST_UPDATE, delay)
	end	
end
--- HANDLE INIT
function functions:init(_mod)
	mod = _mod
end
---------------------------------------------------
return functions
