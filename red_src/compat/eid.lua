if not EID then return end
local enums = require("red_src.core.enums")
local descs = require("red_src.compat.descriptions")

EID:addCollectible(enums.collectibles.pathos, descs[enums.collectibles.pathos])
EID:addCollectible(enums.collectibles.trance, descs[enums.collectibles.trance])
EID:addCollectible(enums.collectibles.dementia, descs[enums.collectibles.dementia])
EID:addCollectible(enums.collectibles.entropy, descs[enums.collectibles.entropy])
EID:addCollectible(enums.collectibles.extus, descs[enums.collectibles.extus])
EID:addCollectible(enums.collectibles.zenith, descs[enums.collectibles.zenith])
