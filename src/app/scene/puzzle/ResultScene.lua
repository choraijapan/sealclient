-------------------------------------------------------------------------------
-- @date 2015/11/25
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local ResultScene = class("ResultScene",StandardScene)

function ResultScene:init(...)
end

function ResultScene:create()
	local scene = cc.Scene:create()
	
	local csb = WidgetLoader:loadCsbFile(GameConst.CSB.ResultScene)
	local panelTouch = WidgetObj:searchWidgetByName(csb,"PanelTouch",WidgetConst.OBJ_TYPE.Panel)

	TouchManager:pressedDown(panelTouch,
		function()
			SceneManager:changeScene("src/app/scene/menu/MenuScene", nil)
		end)
		
	scene:addChild(csb)
	return scene
end

-- onEnter
function ResultScene:onEnter()
end

function ResultScene:onExit()

end

return ResultScene