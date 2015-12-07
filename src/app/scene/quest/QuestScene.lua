
-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local QuestScene = class("QuestScene",StandardScene)

local CONST_MAP_SETTINGS = {
	world_map = 'parts/map/World.csb',
}

-- init
function QuestScene:init(...)
	self.m = {}
end

-- onEnter
function QuestScene:onEnter()


--	ScheduleManager:scheduleUpdate(self.m.worldMap,callBack,0)
--
	self.m.worldMap = WidgetLoader:loadCsbFile(CONST_MAP_SETTINGS.world_map)
	self.mainLayer:addChild(self.m.worldMap)
	
--	
	local tl = WidgetLoader:loadCsbAnimation(CONST_MAP_SETTINGS.world_map)
	
	self.m.worldMap:runAction(tl)
	tl:gotoFrameAndPlay(0,true)
--	
	TouchManager:touchAllAtOnce(self.mainLayer,function(touch,event) DebugLog:debug(event:getEventCode()) end)
--


--	
--	
--	TouchManager:touchAllAtOnce(self.mainLayer,
--		function(touch,event)
--			DebugLog:debug(event:getEventCode());
--		end
--	
--	)
	
--	--	SceneManager:changeScene(CONST_MENU_SETTINGS.Sample_03,nil)
--
--	self.m.menuNode = WidgetLoader:loadCsbFile("scene/MenuScene.csb")
--	self.scene:addChild(self.m.menuNode)
--
--	for key, var in pairs(CONST_MENU_SETTINGS) do
--		local button = WidgetObj:searchWidgetByName(self.m.menuNode,buttonNm,WidgetConst.OBJ_TYPE.Button)
--		self:clickButton(key, var)
--	end
end

function QuestScene:update() 
	
	
end

function test() 
	local MultiTouchLayer = class("MultiTouchLayer",function()
		return cc.Layer:create()
	end)
	function MultiTouchLayer:ctor()
		self.visibleSize = cc.Director:getInstance():getVisibleSize()
		self.origin = cc.Director:getInstance():getVisibleOrigin()
		self.schedulerID = nil
	end
	function MultiTouchLayer.create()
		local layer = MultiTouchLayer.new()
		-- handing touch events
		local touchBeginPoint = nil
		local function onTouchesBegan(touches, event)
			for i,v in ipairs(touches) do 
				print("x"..":"..v:getLocation().x)
				print("y"..":"..v:getLocation().y) 
			end
			return true
		end
		local listener = cc.EventListenerTouchAllAtOnce:create()
		listener:registerScriptHandler(onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN )
		local eventDispatcher = layer:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
		local function onNodeEvent(event)
			if "exit" == event then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
			end
		end
		layer:registerScriptHandler(onNodeEvent)
		return layer

	end

	return MultiTouchLayer
end


function QuestScene:clickButton(buttonNm,scenePath)
--	local button = WidgetObj:searchWidgetByName(self.m.menuNode,buttonNm,WidgetConst.OBJ_TYPE.Button)
--	TouchManager:pressedDown(button,
--		function()
--			SceneManager:changeScene(scenePath,nil) 
--		end)
end

-- onExit
function QuestScene:onExit()

end

return QuestScene