-------------------------------------------------------------------------------
-- @date 2015/12/7
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local MapScene = class("MapScene",StandardScene)
local ConfirmLayer = require("app.parts.puzzle.ConfirmLayer")

-- init
function MapScene:init(...)
	self.m = {}
end

-- onEnter
function MapScene:onEnter()
	self.m.menuNode = WidgetLoader:loadCsbFile("scene/MapScene.csb")
	self.scene:addChild(self.m.menuNode)

	
	local button = WidgetObj:searchWidgetByName(self.m.menuNode,"MS01",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(button,
		function()
			local layer = ConfirmLayer:create()
			self.scene:addChild(layer)
		end)
end

-- onExit
function MapScene:onExit()

end

return MapScene


