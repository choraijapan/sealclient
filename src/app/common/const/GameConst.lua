-------------------------------------------------------------------------------
-- @date 2015/10/14
-- @author chorai
-------------------------------------------------------------------------------
GameConst = {}
-----------------------------------------------------------------------------
-- カードの属性　1:水　2:火　3:木　4:光　5:闇　
-----------------------------------------------------------------------------
GameConst.ATTRIBUTE = {
	WATER 	= 1,
	FIRE 	= 2,
	TREE 	= 3,
	LIGHT 	= 4,
	DARK 	= 5,
}
	
GameConst.ATTRIBUTE_EFFECT = {
	[1] 	= "images/effect/block_effect.plist",
	[2] 	= "images/effect/block_effect.plist",
	[3] 	= "images/effect/block_effect.plist",
	[4] 	= "images/effect/block_effect.plist",
	[5] 	= "images/effect/block_effect.plist", --TODO
}

GameConst.EFFECT_PNG = {
	[1] 	= "images/effect/images/particle_4star.png",
	[2] 	= "images/effect/images/particle_4star.png",
	[3] 	= "images/effect/images/leaf.png",
	[4] 	= "images/effect/images/particle_4star.png",
	[5] 	= "images/effect/images/particle_4star.png", --TODO
}

GameConst.CardType = {
	ATK = 1,
	DEF = 2,
	HEAL = 3,
	CONTROL = 4
}

GameConst.DEBUFF = {
	ATK = 1,
	FREEZE = 2,
	DEFDOWN = 3,
}

GameConst.PUZZLEOBJTAG = {
	T_Bullet = 1,
	T_Bullet1 = 2,
	T_Bullet2 = 3,
	T_Bullet3 = 4,
	T_Bullet4 = 5,
	T_Bullet5 = 6,
	T_Dialog = 7,
	T_Line = 8,
}

GameConst.PUZZLE_SCENE_TAG = 500