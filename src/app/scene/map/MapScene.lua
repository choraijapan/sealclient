-------------------------------------------------------------------------------
-- @date 2015/12/7
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local MapScene = class("MapScene",StandardScene)

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
			SceneManager:changeScene('app/scene/puzzle/PuzzleScene',nil)
		end)
end

-- onExit
function MapScene:onExit()

end

return MapScene


