-------------------------------------------------------------------------------
-- ScheduleManager
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
ScheduleManager = class("ScheduleManager")


-- update node every frame
function ScheduleManager:scheduleUpdate(node,callBack, priority)
	if priority == nil then
		priority = 1
	end
	node:scheduleUpdateWithPriorityLua(function(dt) callBack(node,dt) end, priority)
end

-- unscheduleUpdate
function ScheduleManager:unscheduleUpdate(node)
	node:unscheduleUpdate()
end

-- updateWithDelay
function ScheduleManager:updateWithDelay(node, callBack, delay)
	schedule(node,function() callBack(node) end, delay)
end

-- update once
function ScheduleManager:once(node, callBack, delay)
	performWithDelay(node,function() callBack(node) end,delay)
end

-- stopAllActions
function ScheduleManager:stopAllActions(node)
	node:stopAllActions()
end



