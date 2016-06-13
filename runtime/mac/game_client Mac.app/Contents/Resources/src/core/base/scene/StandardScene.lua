-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------


local BaseScene = require("core.base.scene.BaseScene")
local StandardScene = class("StandardScene", BaseScene.new(GameSysConst.SCENE_TYPE.STANDARD))
-- constructor
function StandardScene:createScene(scene_type)
	self.scene = cc.Scene:create()
	local mainLayer = cc.Layer:create()
	self.scene:addChild(mainLayer,LayerConst.LAYER_LIST.MAIN_LAYER.ZORDER, LayerConst.LAYER_LIST.MAIN_LAYER.TAG)
	self.mainLayer = mainLayer
end

return StandardScene

