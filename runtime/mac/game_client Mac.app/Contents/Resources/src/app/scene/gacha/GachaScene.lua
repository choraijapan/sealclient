-------------------------------------------------------------------------------
-- GachaScene
-- @date 2015/12/14
-------------------------------------------------------------------------------
local PhysicsScene = require('core.base.scene.PhysicsScene')
local GachaLayer = require("app/layer/gacha/GachaLayer")
local GachaScene = class("GachaScene",PhysicsScene)
local gravity = cc.p(0, -98)
local speed = 0.0

-- init
function GachaScene:init(...)
	self.scene:addChild(GachaLayer:create(),1)
end

-- onEnter
function GachaScene:onEnter()
end

-- onExit
function GachaScene:onExit()

end

return GachaScene
