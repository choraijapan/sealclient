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
	--	local sprite_bug = cc.Sprite:create("BugAnt.png")
	--	self.scene:addChild(sprite_bug)
	--	sprite_bug:setPosition(cc.p(50,200));
	--	sprite_bug:runAction(cc.MoveTo:create(1,cc.p(100,300)))
	printInfo("onEnter3")

	local testNode = WidgetLoader:loadCsbFile("scene/rpg.csb")
	
	local action = WidgetLoader:loadCsbAnimation('scene/rpg.csb')
	testNode:runAction(action)
	action:gotoFrameAndPlay(0,60,true)
--	local image = WidgetObj:searchWidgetByName(testNode,"Image_1",WidgetConst.OBJ_TYPE.Image)
--	local btn = WidgetObj:searchWidgetByName(testNode,"Button_1","ccui.Button")
	--
--	image:setColor(cc.c3b(255,0,0))
	self.scene:addChild(testNode)

--	TouchManager:pressed(image,function(sender,event) cclog(event) end)
--
--	TouchManager:touchAllAtOnce(self.scene,function(sender,event) cclog(event:getEventCode()) end)
--
--	ScheduleManager:scheduleUpdate(self.scene,function(node) cclog("test") end, 1)
--	local bg = cc.Sprite:create("images/Card/1_all.png")
--	self.scene:addChild(bg)
--	bg:setPosition(cc.p(100, 480))
--	bg:setOpacity(180)
--	self:testProgress()
end

function TestScene:testProgress()
	local layer = cc.Layer:create()
	self.scene:addChild(layer)
	local to1 = cc.ProgressTo:create(12, 100)

	local left = cc.ProgressTimer:create(cc.Sprite:create("images/Card/1_all.png"))
	left:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
	left:setPosition(cc.p(100, 480))
	left:runAction(cc.RepeatForever:create(to1))
	layer:addChild(left)
end

-- onExit
function TestScene:onExit()
	CacheUtils:removeLoadedAppLua(CleanUpList.TYPE_SCENE)
	printInfo("onExit")
end


return TestScene
