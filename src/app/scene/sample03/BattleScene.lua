-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

require('app.scene.sample03.data.BattleData')

local StandardScene = require('core.base.scene.StandardScene')
local BattleScene = class("GameScene",StandardScene)

local heros = {
}

-- init
function BattleScene:init(...)
	self.battle_manager = nil
	self.battle_main_node = nil
	BattleData.battleChara = {}
	BattleData.targetPos = {}
end

-- onEnter
function BattleScene:onEnter()
	local battle_manager = require('app/scene/sample03/managers/BattleManager')
	local MainNode = WidgetLoader:loadCsbFile("scene/BattleSample/battle.csb")
	self.mainLayer:addChild(MainNode)
	battle_manager:init(MainNode)
	battle_manager:createHeros()
	battle_manager:createBoss()
	battle_manager:createTargetPos()
	battle_manager:start()
end

function BattleScene:update(dt,node)
	
end

function BattleScene:calculateSpeed(dt)
	
end

-- onExit
function BattleScene:pull(touch,event)
	
end

-- onExit
function BattleScene:onExit()

end

return BattleScene
