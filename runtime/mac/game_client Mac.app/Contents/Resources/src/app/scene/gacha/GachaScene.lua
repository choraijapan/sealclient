-------------------------------------------------------------------------------
-- GachaScene
-- @date 2015/12/14
-------------------------------------------------------------------------------
local PhysicsScene = require('core.base.scene.PhysicsScene')
local GachaLayer = require("app/layer/gacha/GachaLayer").new()
local GachaScene = class("GachaScene",PhysicsScene)
local gravity = cc.p(0, -98)
local speed = 0.0

-- init
function GachaScene:init(...)
	self.scene:getPhysicsWorld():setGravity(gravity)
	self.scene:getPhysicsWorld():setAutoStep(false)
	self.scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL) --Debug用
	self.scene:addChild(GachaLayer:create(),1)
	local function update(dt)
		for var=0, 3 do
			self.scene:getPhysicsWorld():step(dt/1)
		end
	end
	self.scene:scheduleUpdateWithPriorityLua(update,0)
	self.scene:setTag(GameConst.PUZZLE_SCENE_TAG)
end

-- onEnter
function GachaScene:onEnter()
end

-- onExit
function GachaScene:onExit()

end

return GachaScene
