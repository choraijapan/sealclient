-------------------------------------------------------------------------------
-- @date 2015/12/9
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local TitleScene = class("TitleScene",StandardScene)

-- init
function TitleScene:init(...)
	self.m = {}
end

-- onEnter
function TitleScene:onEnter()
	self.m.csb = WidgetLoader:loadCsbFile("scene/TitleScene.csb")
	self.scene:addChild(self.m.csb)

	local CCUI_ButtonStart = WidgetObj:searchWidgetByName(self.m.csb,"ButtonStart",WidgetConst.OBJ_TYPE.Button)
	
	local act1 = cc.ScaleTo:create(0.5,1.1)
	local act2 = cc.ScaleTo:create(0.5,1)
	CCUI_ButtonStart:runAction(cc.RepeatForever:create(cc.Sequence:create(act1,act2)))
	TouchManager:pressedDown(CCUI_ButtonStart,
		function()
			SceneManager:changeScene("app/scene/download/DownloadScene", nil)
		end)
		
	local CCUI_PanelNotice = WidgetObj:searchWidgetByName(self.m.csb,"PanelNotice",WidgetConst.OBJ_TYPE.Panel)
	
	local function onTouchBtn()
		local action1 = cc.FadeOut:create(1)
		local action2 = cc.RemoveSelf:create()
		CCUI_PanelNotice:runAction(cc.Sequence:create(action1,action2))
	end
	TouchManager:pressedDown(CCUI_PanelNotice,onTouchBtn)
end

-- onExit
function TitleScene:onExit()

end

return TitleScene