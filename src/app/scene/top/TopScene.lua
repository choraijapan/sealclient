-------------------------------------------------------------------------------
-- @date 2015/12/9
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local TopScene = class("TopScene",StandardScene)
local GachaLayer = require("app.layer.gacha.GachaLayer")
local CardLayer = require("app.layer.card.CardLayer")

local m_UserName = ""
local m_UserGold = 1
local m_UserGem = 1
local m_UserLevel = 1
local m_UserExp = 1
local m_UserBattlePt = 1
local m_UserBattlePtMax = 1

local CCUI_Label_UserName = nil
local CCUI_Label_UserGold = nil
local CCUI_Label_UserGem = nil
local CCUI_Label_UserLevel = nil
local CCUI_Label_UserExp = nil
local CCUI_Label_UserBattlePt = nil

-- init
function TopScene:init(...)
	self.m = {}
end

-- onEnter
function TopScene:onEnter()
	self.m.csb = WidgetLoader:loadCsbFile("scene/TopScene.csb")
	self.scene:addChild(self.m.csb)

	local CCUI_Node_Header = WidgetObj:searchWidgetByName(self.m.csb,"node_Header",WidgetConst.OBJ_TYPE.Node)
	CCUI_Label_UserName = WidgetObj:searchWidgetByName(self.m.csb,"label_UserName",WidgetConst.OBJ_TYPE.Label)
	CCUI_Label_UserGold = WidgetObj:searchWidgetByName(self.m.csb,"label_UserGold",WidgetConst.OBJ_TYPE.Label)
	CCUI_Label_UserGem = WidgetObj:searchWidgetByName(self.m.csb,"label_UserGem",WidgetConst.OBJ_TYPE.Label)
	CCUI_Label_UserLevel = WidgetObj:searchWidgetByName(self.m.csb,"label_UserLevel",WidgetConst.OBJ_TYPE.Label)
	CCUI_Label_UserExp = WidgetObj:searchWidgetByName(self.m.csb,"label_UserExp",WidgetConst.OBJ_TYPE.Label)
	CCUI_Label_UserBattlePt = WidgetObj:searchWidgetByName(self.m.csb,"label_UserBattlePt",WidgetConst.OBJ_TYPE.Label)
	
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
	-------------------------------------
	--通信
	local userApi = require("app.network.api.UserApi")
	local function callback(res)
		
		local data = res["user_datas"]
		m_UserName = "Server?"
		m_UserGold = data["gold"]
		m_UserGem = "Server?"
		m_UserLevel = data["level"]
		m_UserBattlePt = data["battle_pt"]
		m_UserBattlePtMax = data["max_battle_pt"]
		
		-------------------------------------
		--通信結果を設定する
		CCUI_Label_UserName:setString(m_UserName)
		CCUI_Label_UserGold:setString(m_UserGold)
		CCUI_Label_UserGem:setString(m_UserGem)
		CCUI_Label_UserLevel:setString(m_UserLevel)
		CCUI_Label_UserExp:setString(m_UserExp)
		CCUI_Label_UserBattlePt:setString(m_UserBattlePt)
	end
	userApi:Request(callback)

	
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