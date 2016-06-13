--------------------------------------------------------------------------------
-- ConfirmLayer
local ConfirmLayer = class("ConfirmLayer",cc.Layer)
--------------------------------------------------------------------------------
-- const変数
local TAG = "ConfirmLayer:"
local CSBFILE = "layer/puzzle/ConfirmLayer.csb"
--------------------------------------------------------------------------------
-- メンバ変数
--------------------------------------------------------------------------------
-- UI変数
--------------------------------------------------------------------------------
-- constructor
function ConfirmLayer:ctor()
end
--------------------------------------------------------------------------------
-- create
function ConfirmLayer:create()
	local CCUI_CSB = WidgetLoader:loadCsbFile(CSBFILE)
	local layer = ConfirmLayer.new()
	layer:addChild(CCUI_CSB)
	
	local button = WidgetObj:searchWidgetByName(CCUI_CSB,"MySelfButton",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(button,
		function()
			SceneManager:changeScene('app/scene/puzzle/PuzzleScene',nil)
		end)
	
	local close = WidgetObj:searchWidgetByName(CCUI_CSB,"CloseButton",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(close,
		function()
			layer:removeFromParent()
		end)
	return layer
end

return ConfirmLayer












