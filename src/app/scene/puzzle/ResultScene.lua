-------------------------------------------------------------------------------
-- @date 2015/11/25
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local ResultScene = class("ResultScene",StandardScene)

function ResultScene:init(...)
end

-- onEnter
function ResultScene:onEnter()
	local scene = WidgetLoader:loadCsbFile(GameConst.CSB.ResultScene)
    
    
	local panelTouch = WidgetObj:searchWidgetByName(scene,"PanelTouch",WidgetConst.OBJ_TYPE.Panel)

	TouchManager:pressedDown(panelTouch,
		function()
			print("################## touch result #########")
		end)
end

function ResultScene:onExit()

end

return ResultScene