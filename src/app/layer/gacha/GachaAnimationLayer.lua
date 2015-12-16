local GachaAnimationLayer = class("GachaAnimationLayer", cc.Layer)

GachaAnimationLayer.wall = nil
GachaAnimationLayer.cards = {
	card1 = nil,
	card2 = nil,
	card3 = nil,
	card4 = nil,
	card5 = nil,
	card6 = nil
}

local MAX_BULLET = 15

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
	self:init()
	return self
end
--------------------------------------------------------------------------------
-- init
function GachaAnimationLayer:init()
	CCUI_GachaAnimationLayer = WidgetLoader:loadCsbFile(CCUI_CSB)
	self:addChild(CCUI_GachaAnimationLayer,1)
	
	CCUI_ResultPanel = WidgetObj:searchWidgetByName(CCUI_GachaLayer,"ResutlPanel",WidgetConst.OBJ_TYPE.Panel)
	TouchManager:pressedDown(CCUI_ResultPanel,
		function()
			self:removeSelf()
		end)
end

return GachaAnimationLayer