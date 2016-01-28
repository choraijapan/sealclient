local GachaAnimationLayer = class("GachaAnimationLayer", cc.Layer)
--------------------------------------------------------------------------------
-- UI
local CCUI_CSB = "layer/gacha/GachaAnimationLayer.csb"
local CCUI_GachaAnimationLayer = nil
local CCUI_ResultPanel = nil
--------------------------------------------------------------------------------
-- ctor
function GachaAnimationLayer:ctor()
end
--------------------------------------------------------------------------------
-- create
function GachaAnimationLayer:create()
	local layer = GachaAnimationLayer.new()
	layer:init()
	return layer
end
--------------------------------------------------------------------------------
-- init
function GachaAnimationLayer:init()
	CCUI_GachaAnimationLayer = WidgetLoader:loadCsbFile(CCUI_CSB)
	self:addChild(CCUI_GachaAnimationLayer)
	
	local tl = WidgetLoader:loadCsbAnimation(CCUI_CSB)
	self:runAction(tl)
--	tl:gotoFrameAndPlay(0,false)
	tl:play("gacha",false)
	
	CCUI_ResultPanel = WidgetObj:searchWidgetByName(CCUI_GachaAnimationLayer,"ResultPanel",WidgetConst.OBJ_TYPE.Panel)
	TouchManager:pressedDown(CCUI_ResultPanel,
		function()
			self:removeSelf()
		end)
end

return GachaAnimationLayer