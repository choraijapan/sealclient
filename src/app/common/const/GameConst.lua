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
--	LIGHT 	= 4,
	DARK 	= 4
}

GameConst.BALL_PNG = {
	[1] = "images/puzzle/block/b_water.png",
	[2] = "images/puzzle/block/b_fire.png",
	[3] = "images/puzzle/block/b_tree.png",
--	[4] = "images/puzzle/block/b_light.png",
	[4] = "images/puzzle/block/b_dark.png",
	["BOOM"] = "images/puzzle/block/ball_dark.png"
}

GameConst.CARD_FRAME_PNG = {
	[1] = "images/common/monster_thum_blue.png",
	[2] = "images/common/monster_thum_red.png",
	[3] = "images/common/monster_thum_green.png",
	[4] = "images/common/monster_thum_yellow.png",
--	[5] = "images/common/monster_thum_blue_red.png" --TODO 仮素材もないです
}

GameConst.ATTRIBUTE_EFFECT = {
	[1] 	= "images/puzzle/effect/particle/block_effect.plist",
	[2] 	= "images/puzzle/effect/particle/block_effect.plist",
	[3] 	= "images/puzzle/effect/particle/block_effect.plist",
	[4] 	= "images/puzzle/effect/particle/block_effect.plist",
	[5] 	= "images/puzzle/effect/particle/block_effect.plist", --TODO
}

GameConst.EFFECT_PNG = {
	[1] 	= "images/puzzle/effect/particle/particle_4star.png",
	[2] 	= "images/puzzle/effect/particle/particle_4star.png",
	[3] 	= "images/puzzle/effect/particle/leaf.png",
	[4] 	= "images/puzzle/effect/particle/particle_4star.png",
	[5] 	= "images/puzzle/effect/particle/particle_4star.png", --TODO
}

GameConst.CSB = {
	["ResultScene"] = "scene/puzzle/ResultScene.csb"
}

GameConst.FONT = {
	NUMBER = "images/font/labelatlas.png",
	NUMBER_YELLOW = "images/font/number_quest_medium_yellow.png",
	NUMBER_FWHITE = "images/font/number_quest_floor_white.png",
	NUMBER_MBLUE = "images/font/number_quest_medium_blue.png",
	NUMBER_MGREEN = "images/font/number_quest_medium_green.png",
	NUMBER_MHEAL = "images/font/number_quest_medium_kaihuku.png",
	NUMBER_MRED = "images/font/number_quest_medium_red.png",
	NUMBER_MGRAY = "images/font/number_quest_medium_white_gray.png",
	NUMBER_MWHITE = "images/font/number_quest_medium_white.png",
	NUMBER_MYELLOW = "images/font/number_quest_medium_yellow.png",
	NUMBER_SGREEN = "images/font/number_quest_small_green.png",
	NUMBER_SWHITE = "images/font/number_quest_small_white.png",
	NUMBER_XPWHITE = "images/font/number_quest_xlarge_purewhite.png",
	NUMBER_XBLUE = "images/font/number_quest_xxlarge_blue.png",
	NUMBER_XXGREEN = "images/font/number_quest_xxlarge_green.png",
	NUMBER_XXRED = "images/font/number_quest_xxlarge_red.png",
	NUMBER_XXYELLOW = "images/font/number_quest_xxlarge_yellow.png"
}

GameConst.PARTICLE = {
	[1]            = "images/puzzle/effect/particle/thumbnail_skill_water.plist",
	[2]            = "images/puzzle/effect/particle/thumbnail_skill_fire.plist",
	[3]            = "images/puzzle/effect/particle/thumbnail_skill_forest.plist",
	[4]            = "images/puzzle/effect/particle/thumbnail_skill_thunder.plist",
	[5]            = "images/puzzle/effect/particle/block_effect.plist", --TODO
	
	SKILL_1         = "images/puzzle/effect/particle/fireWall.plist", -- TODO cardのスキルエフェクト
	
	SNOW           = "images/puzzle/effect/particle/particle_snow.plist",
	BALL_BROKEN    = "images/puzzle/effect/particle/puzzle.plist",
	FERVER         = "images/puzzle/effect/particle/fireWall.plist",
	BOOM           = "images/puzzle/effect/particle/particle_boom.plist",
	HEAL           = "images/puzzle/effect/particle/gauge_bar_heal.plist",

	
	ATK_FIRE       = "images/puzzle/effect/particle/firebig_aura.plist",
	ATK_FOREST     = "images/puzzle/effect/particle/forestbig_aura.plist",
	ATK_THUNDER    = "images/puzzle/effect/particle/thunderbig_aura.plist",
	ATK_WATER      = "images/puzzle/effect/particle/waterbig_aura.plist",
	ATK_FIRE_2     = "images/puzzle/effect/particle/block_change_fire.plist",
	ATK_SHINE      = "images/puzzle/effect/particle/active_skill_energy_shine_big.plist",
	ATK_SWORD      = "images/puzzle/effect/particle/weapon_sword_hit_back.plist"
}

GameConst.PARTICLE_PNG = {
	[1]     = "images/puzzle/effect/particle/particle_4star.png",
	[2]     = "images/puzzle/effect/particle/particle_4star.png",
	[3]     = "images/puzzle/effect/particle/leaf.png",
	[4]     = "images/puzzle/effect/particle/particle_4star.png",
	[5]     = "images/puzzle/effect/particle/particle_4star.png", --TODO
	SNOW    = "images/puzzle/effect/particle/particle_snow.png",
	STAR4    = "images/puzzle/effect/particle/particle_4star.png",
}

GameConst.PUZZLE_PNG = {
	FERVER_BAR     = "images/puzzle/ui/bar_ferver.png",
	BOSS_HP_BAR    = "images/puzzle/ui/gauge_green.png",
	BOSS_HP_BG     = "images/puzzle/ui/boss_gauge_green.png",
	
	LEFT_TIME      = "images/puzzle/text/text_turn.png",
}

GameConst.CardType = {
	ATK = 1,
	DEF = 2,
	HEAL = 3,
	CONTROL = 4,
	REMOVE = 5
}

GameConst.DEBUFF = {
	ATK = 1,
	FREEZE = 2,
	DEFDOWN = 3,
}

GameConst.PUZZLEOBJTAG = {
	T_Bullet = 100,
	T_Dialog = 200,
	T_Line = 300,
	T_Number = 400
}

GameConst.ZOrder = {
	Z_BallBg = 0,
	Z_Ball = 1,
	Z_Line = 2,
	Z_BossBg = 0,
	Z_Boss = 11,
	Z_Deck = 20,
	Z_FerverBar = 30,
	Z_Combol = 30,
	Z_EffectAtkBoss = 30,
	Z_Dialog = 999,
	Z_Dark = 1000,
}


GameConst.PUZZLE_SCENE_TAG = 500