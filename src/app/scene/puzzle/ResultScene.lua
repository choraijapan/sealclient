-------------------------------------------------------------------------------
-- @date 2015/11/25
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local ResultScene = class("ResultScene",StandardScene)

function ResultScene:init(...)
end

-- onEnter
function ResultScene:onEnter()
	local csb = WidgetLoader:loadCsbFile(GameConst.CSB.ResultScene)
	local panelTouch = WidgetObj:searchWidgetByName(csb,"PanelTouch",WidgetConst.OBJ_TYPE.Panel)

	TouchManager:pressedDown(panelTouch,
		function()
			SceneManager:changeScene("src/app/scene/menu/MenuScene", "WIN")
		end)

	self.scene:addChild(csb)
end

function ResultScene:onExit()

end

return ResultScene