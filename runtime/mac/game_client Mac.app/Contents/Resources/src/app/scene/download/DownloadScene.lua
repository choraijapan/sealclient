-------------------------------------------------------------------------------
-- @date 2015/12/9
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local DownloadScene = class("DownloadScene",StandardScene)

-- init
function DownloadScene:init(...)
	self.m = {}
end

-- onEnter
function DownloadScene:onEnter()
	self.m.csb = WidgetLoader:loadCsbFile("scene/DownloadScene.csb")
	self.scene:addChild(self.m.csb)

	local CCUI_LoadingBar = WidgetObj:searchWidgetByName(self.m.csb,"LoadingBar",WidgetConst.OBJ_TYPE.ProgressBar)
	
	local percent = 0
	CCUI_LoadingBar:setPercent(percent)
	local function updateTime()
		if percent < 100 then
			
			percent = percent + 1
			
			if percent == 3 then
				percent = 38
			end
			
			if percent == 40 then
				percent = 66
			end
			
			if percent == 70 then
				percent = 87
			end
			
			if percent == 90 then
				percent = 97
			end
			
			CCUI_LoadingBar:setPercent(percent)
		else
			CCUI_LoadingBar:setPercent(100)
			SceneManager:changeScene("app/scene/top/TopScene", nil)
		end
		
	end
	schedule(CCUI_LoadingBar, updateTime, 1)
end

-- onExit
function DownloadScene:onExit()

end

return DownloadScene