local enums = require("red_src.core.enums")

return {
	[enums.collectibles.pathos] = "{{ArrowUp}} All tears fired by the player will be doubled #{{ArrowDown}} -25% Fire Rate down #{{ArrowDown}} Enemy tears have a small chance to be doubled",
	[enums.collectibles.trance] = "{{ArrowUp}} +0.2 Damage up #{{ArrowDown}} -0.2 Shot Speed down #{{Charm}} {{Bait}} Close enemies have a chance to become charmed or baited",
	[enums.collectibles.dementia] = "{{Warning}} All pickups disappear when leaving a room #{{ArrowUp}} Lost pickups give certain stat boosts: #{{Coin}} +.05 Luck #{{Bomb}} +.05 Damage #{{Key}} +.05 Range/Shot Speed #{{Trinket}} +10% Devil & Angel deal (for the floor) #{{Collectible}} -1 Fire Delay/+1 Damage #Pickup rarity increases the strength of the boost",
	[enums.collectibles.entropy] = "Any quality 0 or 1 items will turn into {{Collectible721}}TMTRAINER items",
	[enums.collectibles.extus] = "",
	[enums.collectibles.zenith] = "{{ArrowUp}} {{ArrowUp}} +2 Damage up (Unaffected by damage multipliers) #{{Warning}} Tears that come out of the players' right eye will become rock tears that revolve around him",


}


