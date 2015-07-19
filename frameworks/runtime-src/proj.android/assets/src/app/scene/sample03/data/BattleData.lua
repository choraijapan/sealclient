-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

BattleData = class("BattleManager")

BattleData.BATTLE_STATUS = {
	NONE = 1,
	START = 2,
	PROCESS = 3,
	END = 4

}

BattleData.targetPos = {}
BattleData.battleChara = {}
