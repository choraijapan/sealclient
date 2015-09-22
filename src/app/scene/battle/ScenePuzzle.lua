-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

require("app.scene.battle.Global")

local PhysicsScene = require('core.base.scene.PhysicsScene')
local ScenePuzzle = class("GameScene",PhysicsScene)

local gravity = cc.p(0, -98)
local speed = 3.0


-- init
function ScenePuzzle:init(...)
	self.scene:getPhysicsWorld():setGravity(gravity)
	self.scene:getPhysicsWorld():setSpeed(speed)
	require('app.scene.battle.layer.GameLayer')
	self.scene:addChild(GameLayer:create())
end

-- onEnter
function ScenePuzzle:onEnter()
 local test = 1
end

function ScenePuzzle:update(dt,node)
	
end

-- onExit
function ScenePuzzle:onExit()

end

return ScenePuzzle
