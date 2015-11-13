-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local MapScene = class("MapScene",StandardScene)



local count = 13
-- init
function MapScene:init(...)
	DebugLog:debug(count)
	self.m = {}
end


-- onEnter
function MapScene:onEnter()
--	SceneManager:changeScene(CONST_MENU_SETTINGS.Sample_03,nil)
	local worldMapParts = require("app.parts.WorldMapParts")
	local partsWorldMap = worldMapParts.new()
	self.scene:addChild(partsWorldMap)
end

-- onExit
function MapScene:onExit()

end

return MapScene


