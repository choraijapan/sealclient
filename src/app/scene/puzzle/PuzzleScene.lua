-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------
require("app.common.include.Global")
require("app.layer.puzzle.PuzzleManager")
local PhysicsScene = require('core.base.scene.PhysicsScene')
local ScenePuzzle = class("ScenePuzzle",PhysicsScene)
local gravity = cc.p(0, -120)
local speed = 5.0

-- init
function ScenePuzzle:init(...)
	self.scene:getPhysicsWorld():setGravity(gravity)
	self.scene:getPhysicsWorld():setSpeed(speed)
	self.scene:getPhysicsWorld():setAutoStep(false)
--	self.scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL) --Debug用
	require('app.layer.puzzle.PuzzleLayer')
	self.scene:addChild(PuzzleLayer:create(),1)
	local function update(dt)
		for var=0, 3 do
			self.scene:getPhysicsWorld():step(dt/1)
		end
	end
	self.scene:scheduleUpdateWithPriorityLua(update,0)
	self.scene:setTag(GameConst.PUZZLE_SCENE_TAG)
end

-- onEnter
function ScenePuzzle:onEnter()
	local test = 1
end

-- onExit
function ScenePuzzle:onExit()

end

return ScenePuzzle
