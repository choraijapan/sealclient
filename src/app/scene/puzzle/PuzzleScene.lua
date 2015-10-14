-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------
require("app.manager.Global")

local PhysicsScene = require('core.base.scene.PhysicsScene')
local ScenePuzzle = class("ScenePuzzle",PhysicsScene)

local gravity = cc.p(0, -98)
local speed = 5.0

-- init
function ScenePuzzle:init(...)
    self.scene:getPhysicsWorld():setGravity(gravity)
    self.scene:getPhysicsWorld():setSpeed(speed)
--self.scene:getPhysicsWorld():setAutoStep(false)
    require('app.layer.puzzle.PuzzleLayer')
	self.scene:addChild(PuzzleLayer:create(),1)
end

-- onEnter
function ScenePuzzle:onEnter()
    local test = 1
end

function ScenePuzzle:update(dt,node)
--self.scene:getPhysicsWorld():setp(0.05)
end

-- onExit
function ScenePuzzle:onExit()

end

return ScenePuzzle

