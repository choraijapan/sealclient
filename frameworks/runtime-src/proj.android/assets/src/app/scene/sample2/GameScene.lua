-------------------------------------------------------------------------------
-- GameScene
-- @date May 17, 2015
-- @author Masahiro Mine
-------------------------------------------------------------------------------

local PhysicsScene = require('core.base.scene.PhysicsScene')
local GameScene = class("GameScene",PhysicsScene)

local total_distance = 2048 * 4
local total_time = 4
local average_speed = 0
local rate = 2

local speed = 0
local spend_time = 0
local remain_distance = 0
local direction = 1

-- init
function GameScene:init(...)
	printInfo("init")
	self.m = {}
	speed = total_distance * rate / total_time / 60
	remain_distance = total_distance
	direction = 1
end

-- onEnter
function GameScene:onEnter()
	printInfo("onEnter3")
	local testNode = WidgetLoader:loadCsbFile("scene/sample01.csb")

	self.m.p_01 = WidgetObj:searchWidgetByName(testNode,"p_01",WidgetConst.OBJ_TYPE.Sprite)
	self.scene:addChild(testNode)
	TouchManager:touchOneByOne(self.scene,function(touch,event) self:pull(touch,event) end)
	ScheduleManager:scheduleUpdate(self.scene,function(dt) self:update(dt,self.m.p_01) end, 1)
end

function GameScene:update(dt,node)
	if (speed < 0) then
		return
	end
	cclog(speed)
	if direction == 1 and self.m.p_01:getPositionY() > 880 then
		self.m.p_01:setPositionY(880 - math.abs(speed))
		direction = -1
		return
	end

	if direction == -1 and self.m.p_01:getPositionY() < 0 then
		self.m.p_01:setPositionY(0 + math.abs(speed))
		direction = 1
		return
	end

	if direction == 1 then
		speed = math.abs(speed)
	else
		speed = -math.abs(speed)
	end
	self.m.p_01:setPositionY(self.m.p_01:getPositionY() + speed)
	self:calculateSpeed(dt)
end

function GameScene:calculateSpeed(dt)
	spend_time = spend_time  + dt
	remain_distance = remain_distance -  math.abs(speed)
	speed = remain_distance * rate / (total_time - spend_time) / 60
end

-- onExit
function GameScene:pull(touch,event)
	cclog(event:getEventCode())
	local test = touch:getStartLocation()
	cclog('startx:'..touch:getStartLocation().x)
	cclog('now:'..touch:getLocation().y)
end

-- onExit
function GameScene:onExit()

end

return GameScene
