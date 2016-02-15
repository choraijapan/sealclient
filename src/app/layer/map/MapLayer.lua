local GachaBall = require("app/parts/gacha/GachaBall")
local GachaAnimationLayer = require("app/layer/gacha/GachaAnimationLayer")
local ConfirmLayer = require("app.parts.puzzle.ConfirmLayer")
local MapLayer = class("MapLayer", cc.Layer)

--------------------------------------------------------------------------------
-- UI
local CCUI_CSB = "layer/map/MapLayer.csb"
local CCUI_MapLayer = nil
--------------------------------------------------------------------------------
-- ctor
function MapLayer:ctor()
	self:setTag(GameConst.LAYERID.MAP)
end
--------------------------------------------------------------------------------
-- create
function MapLayer:create()
	local layer = MapLayer.new()
	layer:init()
	return layer
end
--------------------------------------------------------------------------------
-- init
--local firstDistance = 1
--local nextDistance = 1
local msscale = 1
function MapLayer:init()
	CCUI_MapLayer = WidgetLoader:loadCsbFile(CCUI_CSB)
	local CCUI_Map_0001 = WidgetLoader:loadCsbFile("layer/map/Map_0001.csb")
	self:addChild(CCUI_MapLayer,0)
	
--	local scrollView = WidgetObj:searchWidgetByName(CCUI_MapLayer,"ScrollView_1",WidgetConst.OBJ_TYPE.ScrollView)
--	local scrollNode = WidgetObj:searchWidgetByName(CCUI_MapLayer,"ScrollView_1",WidgetConst.OBJ_TYPE.Sprite)
	
	local scrollView = cc.ScrollView:create(AppConst.WIN_SIZE)
--	scrollView:setViewSize(cc.size(screenSize.width,screenSize.height))
--	local scrollNode = cc.Layer:create() -- 等同于display.newLayer()
	self:addChild(scrollView)
	local screenSize = AppConst.WIN_SIZE
--	local function scrollViewDidScroll()
--		print("###### scrollViewDidScroll ######")
--	end
--	local function scrollViewDidZoom()
--		print("###### scrollViewDidZoom ######")
--	end
--
	if nil ~= scrollView then
		scrollView:setContainer(CCUI_Map_0001)
		scrollView:setViewSize(cc.size(screenSize.width,screenSize.height))
		scrollView:setPosition(cc.p(0,0))
		scrollView:setScale(msscale)
		scrollView:ignoreAnchorPointForPosition(true)
		scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH )
		scrollView:setClippingToBounds(true)
		scrollView:setBounceable(false)
--		scrollView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
--		scrollView:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
	end
--	
--	local firstDistance = 0
--	local nextDistance = 0
--	local function onTouchsEvent(eventType,touchs)
--		if #touchs >= 6 then
--			if eventType=="began" then
--				firstDistance = cc.pGetDistance(cc.p(touchs[1],touchs[2]),cc.p(touchs[5],touchs[6]))
--				firstDistance = math.abs(firstDistance)
--				print("####### began"..firstDistance)
--			elseif eventType == "moved" then
--				nextDistance = cc.pGetDistance(cc.p(touchs[1],touchs[2]),cc.p(touchs[5],touchs[6]))
--				nextDistance = math.abs(nextDistance)
--				msscale = nextDistance/firstDistance * msscale
--				
--				if msscale < 1 then
--					msscale = 1
--				elseif msscale > 3 then
--					msscale = 3
--				end
--				
--				print("####### msscale"..msscale)
--				scrollView:setScale(msscale)
--				firstDistance = nextDistance
--			end
--		end
--	end
--
--	self:setTouchEnabled(true)
--	self:registerScriptTouchHandler(onTouchsEvent,true)
--
	local CCUI_EventButton = WidgetObj:searchWidgetByName(CCUI_Map_0001,"BtnEvent_1",WidgetConst.OBJ_TYPE.Button)
	TouchManager:pressedDown(CCUI_EventButton,
		function()
			print("####### Event 1 ######")
			local layer = ConfirmLayer:create()
			self:addChild(layer)
		end)

	self:transformScaleScrollView(self,scrollView)
end

function MapLayer:transformScaleScrollView(parent, scrollView)
	print("###### hello")
	local touchs = {};
	local preDistance = 0;
	local function onTouchBegan(touch, event)
		print("######## ontouchbegan")
		local touchId = touch:getId();
		local point = touch:getLocation();
		if touchs[1] == nil then
			touchs[1] = {id = touchId, point = point};
		elseif touchs[2] == nil then
			touchs[2] = {id = touchId, point = point};
			preDistance = cc.pGetDistance(touchs[1].point, touchs[2].point);
		end
		return touchs[1] and touchId == touchs[1].id or touchs[2] and touchId == touchs[2].id;
	end

	local function onTouchMoved(touch, event)
		print("######## ontouchmoved")
		local touchId = touch:getId();
		if touchId == touchs[1].id then
			touchs[1].point = touch:getLocation();
		else
			touchs[2].point = touch:getLocation();
		end

		if touchs[1] and touchs[2] then
			local distance = cc.pGetDistance(touchs[1].point, touchs[2].point);
			local diff = distance - preDistance;
			local curScale = scrollView:getScale();
			local lockPos = cc.pMidpoint(touchs[1].point, touchs[2].point);
			
			local msscale = distance/preDistance * curScale
			
			
			if msscale < 1 then
				msscale = 1
			elseif msscale > 3 then
				msscale = 3
			end
			
			scrollView:setAnchorPoint(cc.p(0.5, 0.5))
			scrollView:setScale(msscale);
			preDistance = distance;
		end
	end

	local function onTouchEnded(touch, event)
		local touchId = touch:getId();
		if touchs[1].id == touchId then
			touchs[1] = touchs[2];
		end
		touchs[2] = nil;
	end

	--    手指点击缩放.
	local listener = cc.EventListenerTouchOneByOne:create();
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN);
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED);
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED);
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_CANCELLED);
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, parent);
end

return MapLayer