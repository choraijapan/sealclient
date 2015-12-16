local GachaBall = require("app/parts/gacha/GachaBall")
local GachaAnimationLayer = require("app/layer/gacha/GachaAnimationLayer")
local GachaLayer = class("GachaLayer", cc.Layer)
GachaLayer.wall = nil
local MAX_BULLET = 15

--------------------------------------------------------------------------------
-- UI
local CCUI_CSB = "layer/gacha/GachaLayer.csb"
local CCUI_GachaLayer = nil
local CCUI_FirstPanel = nil
local CCUI_BackButton = nil
local CCUI_DrawButton = nil
local CCUI_Bg1 = nil
local CCUI_Bg2 = nil
--------------------------------------------------------------------------------
-- ctor
function GachaLayer:ctor()
end
--------------------------------------------------------------------------------
-- create
function GachaLayer:create()
	self:setName("GACHA_LAYER")
	self:init()
	return self
end
--------------------------------------------------------------------------------
-- init
function GachaLayer:init()
	CCUI_GachaLayer = WidgetLoader:loadCsbFile(CCUI_CSB)
	self:addChild(CCUI_GachaLayer,GameConst.ZOrder.Z_BossBg)

	CCUI_FirstPanel = WidgetObj:searchWidgetByName(CCUI_GachaLayer,"FirstPanel",WidgetConst.OBJ_TYPE.Panel)
	CCUI_BackButton = WidgetObj:searchWidgetByName(CCUI_GachaLayer,"BackButton",WidgetConst.OBJ_TYPE.Button)
	CCUI_DrawButton = WidgetObj:searchWidgetByName(CCUI_GachaLayer,"DrawButton",WidgetConst.OBJ_TYPE.Button)

	TouchManager:pressedDown(CCUI_BackButton,
		function()
			self:removeSelf()
		end)
		

	TouchManager:pressedDown(CCUI_DrawButton,
		function()
			CCUI_FirstPanel:setVisible(false)
			self:drawGacha()
--			self:addBalls()
		end)
	self:addPuzzle()
end

function GachaLayer:drawGacha()
	local layer = GachaAnimationLayer:create()
	
	
	
	
	self:addChild(layer,1)
end
--------------------------------------------------------------------------------
-- addPuzzle
function GachaLayer:addPuzzle()
	local vec =
		{
			cc.p(AppConst.VISIBLE_SIZE.width-1,AppConst.VISIBLE_SIZE.height+100),
			cc.p(1, AppConst.VISIBLE_SIZE.height+100),
			cc.p(1, 50),
			cc.p(AppConst.VISIBLE_SIZE.width/3, 0),
			cc.p(AppConst.VISIBLE_SIZE.width*2/3, 0),
			cc.p(AppConst.VISIBLE_SIZE.width-1, 50),
			cc.p(AppConst.VISIBLE_SIZE.width-1, AppConst.VISIBLE_SIZE.height+100)
		}

	self.wall = cc.Node:create()
--	local edge = cc.PhysicsBody:createEdgeChain(vec,cc.PhysicsMaterial(0,0,0.8),15)
	local edge = cc.PhysicsBody:createCircle(500, cc.PhysicsMaterial(0,0,0.8))
	edge:setDynamic(false) --重力干渉を受けるか
	self.wall:setPhysicsBody(edge)
	self.wall:setPosition(cc.p(AppConst.VISIBLE_SIZE.width/2,AppConst.VISIBLE_SIZE.height/2))
	self:addChild(self.wall)
end
--------------------------------------------------------------------------------
--
function GachaLayer:addBalls()
	local typeId = math.random(1,GameUtils:tablelength(GameConst.ATTRIBUTE))
	local ball = GachaBall:create(typeId)

	local randomX = math.random(AppConst.WIN_SIZE.width/2 - 20,AppConst.WIN_SIZE.width/2 + 20)
	local randomY = math.random(AppConst.WIN_SIZE.height*2/3 ,AppConst.WIN_SIZE.height*3/4)

	ball:setPosition(randomX, randomY)
	ball:setRotation(math.random(1,360))
	local pBall = ball:getPhysicsBody()
	pBall:setTag(GameConst.PUZZLEOBJTAG.T_Bullet)
	self:addChild(ball,GameConst.ZOrder.Z_Ball)
end
--------------------------------------------------------------------------------
--
function GachaLayer:addSchedule()

	local function update(dt)
		self:update(dt)
	end
	self:scheduleUpdateWithPriorityLua(update,0)
end
--------------------------------------------------------------------------------
--
function GachaLayer:addTouch()
	local function onTouchBegan(touch, event)
		return true
	end
	local function onTouchMoved(touch, event)
	end
	local function onTouchEnded(touch, event)
	end
	local dispatcher = self:getEventDispatcher()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end
--------------------------------------------------------------------------------
function GachaLayer:update(dt)
	local all = {}
	if cc.Director:getInstance():getRunningScene():getPhysicsWorld() ~= nil then
		all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	end

	if MAX_BULLET >= #all then
		self:addBalls()
	end
end
return GachaLayer