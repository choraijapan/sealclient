-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

--------------------------------
-- @module PhysicsScene
local BaseScene = require("core.main.base.scene.BaseScene")
local PhysicsScene = class("PhysicsScene", BaseScene.new(GameSysConst.SCENE_TYPE.PHYSICS))


return PhysicsScene
