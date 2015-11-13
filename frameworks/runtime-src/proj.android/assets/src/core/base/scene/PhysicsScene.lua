-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

--------------------------------
-- @module PhysicsScene
local BaseScene = require("core.base.scene.BaseScene")
local PhysicsScene = class("PhysicsScene", BaseScene.new(GameSysConst.SCENE_TYPE.PHYSICS))


-- constructor
function PhysicsScene:createScene(scene_type)
	self.scene = cc.Scene:createWithPhysics()
	local mainLayer = cc.Layer:create()
	self.scene:addChild(mainLayer,1)
	self.mainLayer = mainLayer
end


return PhysicsScene
