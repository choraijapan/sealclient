local GachaBall = require("app/parts/gacha/GachaBall")
local GachaAnimationLayer = require("app/layer/gacha/GachaAnimationLayer")
local CardLayer = class("CardLayer", cc.Layer)
CardLayer.wall = nil
local MAX_BULLET = 15

--------------------------------------------------------------------------------
-- UI
local CCUI_CSB = "layer/card/CardBaseLayer.csb"
local CCUI_BackButton = nil
local CCUI_GachaButton = nil
--------------------------------------------------------------------------------
-- ctor
function CardLayer:ctor()
end
--------------------------------------------------------------------------------
-- create
function CardLayer:create()
	local layer = CardLayer.new()
	layer:init()
	return layer
end
--------------------------------------------------------------------------------
-- init
function CardLayer:init()
	local CCUI_CardLayer = WidgetLoader:loadCsbFile(CCUI_CSB)
	self:addChild(CCUI_CardLayer,0)
	
	CCUI_BackButton = WidgetObj:searchWidgetByName(CCUI_CardLayer,"BackButton",WidgetConst.OBJ_TYPE.Button)

	TouchManager:pressedDown(CCUI_BackButton,
		function()
			self:removeFromParent()
		end)
end

function CardLayer:drawGacha()
	local layer = GachaAnimationLayer:create()
	self:addChild(layer,1)
end
return CardLayer