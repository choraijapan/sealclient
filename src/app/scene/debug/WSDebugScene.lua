
-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local WSDebugScene = class("WSDebugScene",StandardScene)
local msgPack = require("msgpackcpp")

local LABEL_STATUS_VALUE = nil
local CREATE_ROOM_NAME = nil
local JOIN_ROOM_NAME = nil
local LABEL_ROOM_NAME = nil 
local LAVEL_CONSOLE_LOG = nil
local TXT_SEND_MESSAGE = nil

-- init
function WSDebugScene:init(...)
	self.m = {}
end
local count  = 0
-- onEnter
function WSDebugScene:onEnter()
	--	SceneManager:changeScene(CONST_MENU_SETTINGS.Sample_03,nil)
	self.m.root = WidgetLoader:loadCsbFile("scene/debug/WSDebugScene.csb")
	self.scene:addChild(self.m.root)
	ScheduleManager:scheduleUpdate(self.m.root,function(dt) self:update(dt) end,0)
	
	local btn_connect = WidgetObj:getChild(self.m.root ,"btn_connect",WidgetConst.OBJ_TYPE.Button) 
	local btn_create = WidgetObj:getChild(self.m.root ,"btn_create",WidgetConst.OBJ_TYPE.Button) 
	local btn_join = WidgetObj:getChild(self.m.root ,"btn_join",WidgetConst.OBJ_TYPE.Button) 
	local btn_leave = WidgetObj:getChild(self.m.root ,"btn_leave",WidgetConst.OBJ_TYPE.Button) 
	local btn_send = WidgetObj:getChild(self.m.root ,"btn_send",WidgetConst.OBJ_TYPE.Button) 
	local btn_close = WidgetObj:getChild(self.m.root ,"btn_close",WidgetConst.OBJ_TYPE.Button) 
	local btn_home = WidgetObj:getChild(self.m.root ,"btn_home",WidgetConst.OBJ_TYPE.Button) 
	
	LABEL_STATUS_VALUE = WidgetObj:getChild(self.m.root ,"lable_value",WidgetConst.OBJ_TYPE.Label) 
	CREATE_ROOM_NAME = WidgetObj:getChild(self.m.root ,"txt_create_room",WidgetConst.OBJ_TYPE.TextField) 
	JOIN_ROOM_NAME = WidgetObj:getChild(self.m.root ,"txt_join_room",WidgetConst.OBJ_TYPE.TextField) 
	LABEL_ROOM_NAME = WidgetObj:getChild(self.m.root ,"label_room_name",WidgetConst.OBJ_TYPE.Label) 
	LAVEL_CONSOLE_LOG = WidgetObj:getChild(self.m.root ,"consolelog",WidgetConst.OBJ_TYPE.Label) 
	TXT_SEND_MESSAGE = WidgetObj:getChild(self.m.root ,"txt_send_message",WidgetConst.OBJ_TYPE.TextField) 
	
	
	MultiManager.onConnect = self.onConnect
	MultiManager.onMessage = self.onMessage
	MultiManager.onClose = self.onClose
	MultiManager.onError = self.onError
	
	TouchManager:pressedDown(btn_connect,
		function()
			local param = {
				port=8080,
				userName = 123,
			}
			MultiManager:connect(param)
		end)

	TouchManager:pressedDown(btn_create,
		function()
			local roomName = CREATE_ROOM_NAME:getString()
			MultiManager:createRoom(roomName)
		end)

	TouchManager:pressedDown(btn_join,
		function()
			local roomName = JOIN_ROOM_NAME:getString()
			MultiManager:joinRoom(roomName)
		end)

	TouchManager:pressedDown(btn_leave,
		function()
			MultiManager:leaveRoom()
		end)

	TouchManager:pressedDown(btn_send,
		function()
			local param = {}
			param.c = NetWorkConst.WS.CUST_OP_CODE.ACK
			param.v = {}
			param.v.msg = TXT_SEND_MESSAGE:getString()
			MultiManager:emit(param)
		end)

	TouchManager:pressedDown(btn_close,
		function()
			MultiManager:close()
		end)

	TouchManager:pressedDown(btn_home,
		function()
			SceneManager:changeScene("src/app/scene/menu/MenuScene", nil)
		end)
	
--
--    local param = {}
--    local function onConnect(data)
--		local msg = "test lua " ..count
--		local sent = {}
--		sent["test"] = msg
--		sent["test1"] = {
--		  a = 0,
--		  b = "尾羽よう御座います。FだsfだsfだsfだsfdさいいいいいいfdさFだsjkッッmッッbfdさfだFだsfでいい家。"
--		
--		}
--		local en = msgPack.pack(sent)
--		local de = msgPack.unpack(en)
--		WebSocketManager:emit(sent)
--    end
--	local function onMessage(data)
--	   --DebugLog:debug(data)
--	   count = count + 1
--		local msg = "test lua " ..count
--		local sent = {}
--		sent["test"] = msg
--		WebSocketManager:emit(sent)
--	end
--	local function onClose(data)
--	end
--	local function onError(data)
--	end
--	WebSocketManager:connect("ws://127.0.0.1:8080/123",param, onConnect,onMessage,onClose,onError)
end

local function updateStatus()
	--	self.m.lable_value
	local status = MultiManager:getStatus()
	local txt = ""
	if (status == cc.WEBSOCKET_STATE_CONNECTING ) then
		txt = "CONNECTING"
	elseif  (status == cc.WEBSOCKET_STATE_OPEN ) then
		txt = "OPEN"
	elseif  (status == cc.WEBSOCKET_STATE_CLOSING ) then
		txt = "CLOSING"
	elseif  (status == cc.WEBSOCKET_STATE_CLOSED ) then
		txt = "CLOSED"
	end
	LABEL_STATUS_VALUE:setString(txt)
end

-- onExit
function WSDebugScene.onConnect(data)
	local test  =  1 
	updateStatus()
end

local function dump_data( data )
	if type( data ) ~= "table" then
		return tostring(data);
	end;

	dump_table = function( t, indent )
		local str = "{\n";
		for k, v in pairs( t ) do
			if type( v ) == "table" then
				str = string.format("%s%s%s%s = %s,\n", str, indent, "\t", tostring( k ),dump_table( v, indent .. "\t" ) );
			elseif type( v ) == "string" then
				str = string.format("%s%s%s%s = %q,\n", str, indent, "\t", tostring( k ), v );
			else
				str = string.format("%s%s%s%s = %s,\n", str, indent, "\t", tostring( k ), tostring( v ) );
			end;
		end;
		str = str .. indent .. "}";
		return str;
	end;

	return dump_table( data, "" );
end

function WSDebugScene.onMessage(data)
	if data ~= nil and data.v ~= nil and type( data.v ) == "table" and  data.v.roomName ~= nil then
		LABEL_ROOM_NAME:setString(data.v.roomName)
	end
	
	LAVEL_CONSOLE_LOG:setString(dump_data(data,2));
	
	updateStatus()
end
function WSDebugScene.onClose(data)
	updateStatus()
end
function WSDebugScene.onError(data)
	updateStatus()
end


-- onExit
function WSDebugScene:update()

end

-- onExit
function WSDebugScene:onExit()

end

return WSDebugScene