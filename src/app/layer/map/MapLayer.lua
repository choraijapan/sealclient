local GachaBall = require("app/parts/gacha/GachaBall")
local GachaAnimationLayer = require("app/layer/gacha/GachaAnimationLayer")
local ConfirmLayer = require("app.parts.puzzle.ConfirmLayer")
local MapLayer = class("MapLayer", cc.Layer)

--------------------------------------------------------------------------------
-- UI
local CCUI_CSB = "layer/map/MapLayer.csb"
local CCUI_MapLayer = nil
--------------------------------------------------------------------------------
-- ctor
function MapLayer:ctor()
	self:setTag(GameConst.LAYERID.MAP)
end
--------------------------------------------------------------------------------
-- create
function MapLayer:create()
	local layer = MapLayer.new()
	layer:init()
	return layer
end
--------------------------------------------------------------------------------
-- init
function MapLayer:init()
	CCUI_MapLayer = WidgetLoader:loadCsbFile(CCUI_CSB)
	self:addChild(CCUI_MapLayer,0)
	local CCUI_EventButton = WidgetObj:searchWidgetByName(CCUI_MapLayer,"BtnEvent_1",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(CCUI_EventButton,
		function()
			print("####### Event 1 ######")
			local layer = ConfirmLayer:create()
			self:addChild(layer)
		end)

end

return MapLayer