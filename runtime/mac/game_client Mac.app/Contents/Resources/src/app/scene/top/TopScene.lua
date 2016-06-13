-------------------------------------------------------------------------------
-- @date 2015/12/9
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local TopScene = class("TopScene",StandardScene)
local GachaLayer = require("app.layer.gacha.GachaLayer")
local CardLayer = require("app.layer.card.CardLayer")

-- init
function TopScene:init(...)
	self.m = {}
end

-- onEnter
function TopScene:onEnter()
	self.m.csb = WidgetLoader:loadCsbFile("scene/TopScene.csb")
	self.scene:addChild(self.m.csb)


	local CCUI_ButtonMenu = WidgetObj:searchWidgetByName(self.m.csb,"ButtonMenu",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(CCUI_ButtonMenu,
		function()
			SceneManager:changeScene("src/app/scene/menu/MenuScene", nil)
		end)

	local CCUI_QuestPanel = WidgetObj:searchWidgetByName(self.m.csb,"QuestPanel",WidgetConst.OBJ_TYPE.Panel)
	TouchManager:pressedDown(CCUI_QuestPanel,
		function()
			SceneManager:changeScene("app/scene/map/MapScene.lua", nil)
		end)

	local CCUI_GachaButton = WidgetObj:searchWidgetByName(self.m.csb,"GachaButton",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(CCUI_GachaButton,
		function()
			self:addGachaLayer()
		end)


	local CCUI_CardsButton = WidgetObj:searchWidgetByName(self.m.csb,"CardsButton",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(CCUI_CardsButton,
		function()
			self:addCardLayer()
		end)
end

function TopScene:addGachaLayer()
	local layer = GachaLayer:create()
	self.m.csb:addChild(layer,1)
	local CCUI_HeaderNode = WidgetObj:searchWidgetByName(self.m.csb,"HeaderNode",WidgetConst.OBJ_TYPE.Node)
	self.m.csb:reorderChild(CCUI_HeaderNode,55)
end

function TopScene:addCardLayer()
	local layer = CardLayer:create()
	self.m.csb:addChild(layer,1)
	local CCUI_HeaderNode = WidgetObj:searchWidgetByName(self.m.csb,"HeaderNode",WidgetConst.OBJ_TYPE.Node)
	self.m.csb:reorderChild(CCUI_HeaderNode,55)
end


-- onExit
function TopScene:onExit()

end

return TopScene