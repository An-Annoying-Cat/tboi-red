local saveman = { save = {data = {}, unlocks = {}} }

local SAVE_TEMPLATE = {
	data = {},
	unlocks = {}
}

local mod
local json = require("json")

function saveman:Load(returning)
	local data = mod:LoadData()
	saveman.save = data ~= "" and json.decode(data) or SAVE_TEMPLATE

	if not returning then saveman.save.data = {} end
end

function saveman:Save()
	mod:SaveData(json.encode(saveman.save))
end

function saveman:init(_mod)
	mod = _mod
end

saveman.PostGameStarted = saveman.Load

saveman.PostNewLevel = saveman.Save
saveman.PreGameExit = saveman.Save


return saveman
