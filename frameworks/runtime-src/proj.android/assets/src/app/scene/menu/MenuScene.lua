
-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local MenuScene = class("MenuScene",StandardScene)

local CONST_MENU_SETTINGS = {
	Sample_01 = 'app/scene/puzzle/PuzzleScene',
	Sample_02 = 'app/scene/map/MapScene',
	Sample_03 = nil,
	Sample_04 = nil,
	Sample_05 = nil,
	Sample_06 = nil,
	Sample_07 = nil,
	Sample_08 = nil,
	Sample_09 = nil,
	Sample_10 = nil,
	Sample_11 = nil,
	Sample_12 = nil,
	Sample_13 = nil,
	Sample_14 = nil,
	Sample_15 = nil,
}

-- init
function MenuScene:init(...)
	self.m = {}
end

-- onEnter
function MenuScene:onEnter()
	--	SceneManager:changeScene(CONST_MENU_SETTINGS.Sample_03,nil)

	self.m.menuNode = WidgetLoader:loadCsbFile("scene/MenuScene.csb")
	self.scene:addChild(self.m.menuNode)

	for key, var in pairs(CONST_MENU_SETTINGS) do
		local button = WidgetObj:searchWidgetByName(self.m.menuNode,buttonNm,WidgetConst.OBJ_TYPE.Button)
		self:clickButton(key, var)
	end
end

function MenuScene:clickButton(buttonNm,scenePath)
	local button = WidgetObj:searchWidgetByName(self.m.menuNode,buttonNm,WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(button,
		function()
			SceneManager:changeScene(scenePath,nil) 
		end)
end

-- onExit
function MenuScene:onExit()

end

return MenuScene