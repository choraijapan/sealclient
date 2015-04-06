-------------------------------------------------------------------------------
-- core boot
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local TestScene = class("GameScene",StandardScene)

-- init
function TestScene:init(...)
	printInfo("init")
end

-- onEnter
function TestScene:onEnter()
	local sprite_bug = cc.Sprite:create("BugAnt.png")
	self.scene:addChild(sprite_bug)
	sprite_bug:setPosition(cc.p(50,200));
	sprite_bug:runAction(cc.MoveTo:create(1,cc.p(100,300)))
	printInfo("onEnter")
	
	local testNode = WidgetLoader:loadCsbFile("MainScene.csb")
	local image = WidgetObj:searchWidgetByName(testNode,"Image_1",WidgetConst.OBJ_TYPE.Image)
	local btn = WidgetObj:searchWidgetByName(testNode,"Button_1","ccui.Button")
	
	image:setColor(cc.c3b(255,0,0))
	self.scene:addChild(testNode)
	
	TouchManager:pressed(image,function(sender,event) cclog(event) end)
	
	TouchManager:touchAllAtOnce(self.scene,function(sender,event) cclog(event:getEventCode()) end)
	
	ScheduleManager:scheduleUpdate(self.scene,function(node) cclog("test") end, 1)
	
end


-- onExit
function TestScene:onExit()
	CacheUtils:removeLoadedAppLua(CleanUpList.TYPE_SCENE)
	printInfo("onExit")
end


return TestScene
