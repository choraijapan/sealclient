-------------------------------------------------------------------------------
-- TouchManager
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
TouchManager = class("TouchManager")

--------------------------------------------------------------------------------
-- @function
-- #pressed
function TouchManager:pressed(node, callBack, param)
	local function localCallBack(sender,event)
		callBack(sender,event, param)
	end
	node:setTouchEnabled(true)
	node:addTouchEventListener(localCallBack)
end

--------------------------------------------------------------------------------
-- @function
-- #pressedDown
function TouchManager:pressedDown(node, callBack)
	local function localCallBack(sender,event)
		if eventType == ccui.TouchEventType.ended then
			callBack(sender,event)
		end
	end
	node:setTouchEnabled(true)
	node:addTouchEventListener(localCallBack)
end

--------------------------------------------------------------------------------
-- @function return one touch
-- #touchOneByOne
function TouchManager:touchOneByOne(node, callBack)
	local function onTouch(touch, event)
		callBack(touch,event)
		return true
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouch, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouch, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouch, cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(onTouch, cc.Handler.EVENT_TOUCH_CANCELLED )
	local eventDispatcher = node:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener,node)

end

--------------------------------------------------------------------------------
-- @function return mutiple touch
-- #touchOneByOne
function TouchManager:touchAllAtOnce(node, callBack)
	local function onTouches(touches, event)
		callBack(touches,event)
		return true
	end

	local listener = cc.EventListenerTouchAllAtOnce:create()    
	listener:registerScriptHandler(onTouches,cc.Handler.EVENT_TOUCHES_BEGAN )
	listener:registerScriptHandler(onTouches,cc.Handler.EVENT_TOUCHES_MOVED )
	listener:registerScriptHandler(onTouches,cc.Handler.EVENT_TOUCHES_ENDED )
	listener:registerScriptHandler(onTouches,cc.Handler.EVENT_TOUCHES_CANCELLED )

	local eventDispatcher = node:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end