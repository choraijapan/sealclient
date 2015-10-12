
local WorldMapParts = class("WorldMapParts", cc.Node)
local missionMapPath = "samples/Map/MainScene.csb"
local comuPath = "samples/Map/DisableLayer.csb"

local freamText = "samples/Map/FreamText.csb"

local data = {
	"ようこそ。ファンタジーの世界へ！",
	"これから、案内します。",
	"コミュニケーションの案内です。\n よろしくお願いします。",
	"222 ようこそ。ファンタジーの世界へ！",
	"333 これから、案内します。",
	"444 コミュニケーションの案内です。\n よろしくお願いします。",
}

function WorldMapParts:ctor()
	self:enableNodeEvents()
	self:onUpdate(function(dt) self:update(dt) end)
	
	self.worldMap = nil
	self.pointNode = nil
	self.comuLayer = nil
	self.button = {}
	
	
	self.comuList = {}
	self.comuLayerScrollView = nil
	comuCount = 1
end
local startComuFlg = false
function WorldMapParts:onEnter()
	self.worldMap = WidgetLoader:loadCsbFile(missionMapPath)
	self.pointNode = WidgetObj:searchWidgetByName(self.worldMap,"ProjectNode_3_6",WidgetConst.OBJ_TYPE.Node)
	self:addChild(self.worldMap)
	
	local scrollView =  WidgetObj:getChild(self.worldMap,"ScrollView_2",WidgetConst.OBJ_TYPE.ScrollView)
	scrollView:jumpToBottom()	

	self.pointNode:setOpacity(0)
	local args ={time = 2}
	self.pointNode:fadeIn(args)
	-- register button
	for i = 1, 2 do
		
		self.button[i] = WidgetObj:getChild(self.pointNode,string.format("%s%02d","Sprite_Point_",i), WidgetConst.OBJ_TYPE.Button)
		
		TouchManager:pressed(self.button[i] ,function(sender,event)
			if event == ccui.TouchEventType.began then
				self.button[i]:setScale(1.2)
			elseif event == ccui.TouchEventType.ended then
				self.button[i]:setScale(1)
				performWithDelay(self.button[i],function()
					self:startComu()
				end,0.15)
			elseif event == ccui.TouchEventType.canceled then
				self.button[i]:setScale(1)
			end
		end)
	end
		
	DebugLog:debug("enter")
end

local doneFlg = false
local showTextIdx = 1
local allDoneFlg = false

local randomImage = {
	"images/Navi/left_002.png",
	"images/Navi/left_005.png",
	"images/Navi/left_04.png",
}

function WorldMapParts:startComu()
	self.comuLayer =  WidgetLoader:loadCsbFile(comuPath)
	self.comuLayerScrollView = WidgetObj:searchWidgetByName(self.comuLayer,"ScrollView",WidgetConst.OBJ_TYPE.ScrollView)
	
	self.Navi =  WidgetObj:searchWidgetByName(self.comuLayer,"Navi",WidgetConst.OBJ_TYPE.Image)
	
	self.comuLayer:setOpacity(0)
	local args ={time = 1.2}
	self.comuLayer:fadeIn(args)
	self:addChild(self.comuLayer)
	
	doneFlg = false
--	self:addTextNode(start, function(i) self:addTextNode(start + 1) end)
--	

end


local doneCount = 0
local textFreamList = {
	

}

function WorldMapParts:addTextNode(i) 
	if i > #data then
		return
	end

	if i > 0 then
		for var=1, #textFreamList do
			textFreamList[var]:setPosition(textFreamList[var]:getPositionX(),textFreamList[var]:getPositionY() - 100)
		end
	end
	
	local randomNavi = math.random(1,3)
	self.Navi:loadTexture(randomImage[randomNavi])
	
	doneFlg = true
	local textFream =  WidgetLoader:loadCsbFile(freamText)
	self.comuLayerScrollView:addChild(textFream)
	
	textFreamList[i] = textFream
	
	textFream:setPosition(cc.p(300,550))
	local image = WidgetObj:getChild(textFream,"Frame",WidgetConst.OBJ_TYPE.Image)
	local textNode = WidgetObj:getChild(image,"Text",WidgetConst.OBJ_TYPE.Label)
	textNode:setString("")

	local textLen = string.utf8len(data[i])
	local count = 1
	schedule(image,
		function()
			local text = string.utf8sub(data[i],1,count) 
			textNode:setString(text)
			count = count + 1
			if (count > textLen) then
				image:stopAllActions()
				showTextIdx = showTextIdx + 1
				doneFlg = false
				if i == #data then
					allDoneFlg = true
				end				
			end
		end
		,0.1)
end

function WorldMapParts:showText(i,len)
	local text = string.utf8sub(data[i],1,16) 
end

function WorldMapParts:update(dt)
	if self.comuLayer == nil then
		return
	end

	if allDoneFlg then
		allDoneFlg = false
		local args ={time = 1.2}
		self.comuLayer:fadeOut(args)
		performWithDelay(self.comuLayer,function() SceneManager:changeScene("app/scene/puzzle/PuzzleScene") end,1.2)
		return
	end
	
	if doneFlg == false then
		self:addTextNode(showTextIdx)
	end
		
end

function WorldMapParts:create(type)
end

function WorldMapParts:init(type)
	self:enableNodeEvents()
end

return WorldMapParts

