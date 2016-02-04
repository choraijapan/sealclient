WebSocketManager = class("WebSocketManager")
local msgPack = require("msgpackcpp")

WebSocketManager.wsSendBinary = nil
WebSocketManager.onConnectCallBack = nil
WebSocketManager.onMessageCallBack = nil
WebSocketManager.onCloseCallBack = nil
WebSocketManager.onErrorCallBack = nil

function WebSocketManager:reset()
	WebSocketManager.wsSendBinary = nil
	WebSocketManager.onConnectCallBack = nil
	WebSocketManager.onMessageCallBack = nil
	WebSocketManager.onCloseCallBack = nil
	WebSocketManager.onErrorCallBack = nil
end


WebSocketManager.onConnect = function(data)
    if WebSocketManager.onConnectCallBack ~= nil then
	   WebSocketManager.onConnectCallBack(data)
	end
end

local function utf8_from(t)
	local bytearr = {}
	for _, v in ipairs(t) do
		local utf8byte = v < 0 and (0xff + v + 1) or v
		table.insert(bytearr, string.char(utf8byte))
	end
	return table.concat(bytearr)
end


WebSocketManager.onMessage = function(data)
    if WebSocketManager.onMessageCallBack ~= nil then
		--local testdata = utf8_from(data)d
		WebSocketManager.onMessageCallBack(msgPack.unpack(data))
	end
end

WebSocketManager.onClose = function(data)
    if WebSocketManager.onCloseCallBack ~= nil then
        WebSocketManager.onCloseCallBack(data)
    end
	WebSocketManager:reset()
end

WebSocketManager.onError = function(data)
    if WebSocketManager.onErrorCallBack ~= nil then
	   WebSocketManager.onErrorCallBack(data)
	end
end

function WebSocketManager:connect(url,param, onConnect,onMessage,onClose,onError)
	WebSocketManager.onConnectCallBack = onConnect
	WebSocketManager.onMessageCallBack = onMessage
	WebSocketManager.onCloseCallBack = onClose
	WebSocketManager.onErrorCallBack = onError
    
    
	self.wsSendBinary = cc.WebSocket:createByAProtocol(url,"echo-protocol")
	self.wsSendBinary:registerScriptHandler(self.onConnect,cc.WEBSOCKET_OPEN)
	self.wsSendBinary:registerScriptHandler(self.onMessage,cc.WEBSOCKET_MESSAGE)
	self.wsSendBinary:registerScriptHandler(self.onClose,cc.WEBSOCKET_CLOSE)
	self.wsSendBinary:registerScriptHandler(self.onError,cc.WEBSOCKET_ERROR)
end

function WebSocketManager:emit(data,callback)
	local testData = msgPack.pack(data)
	self.wsSendBinary:sendString(testData)
end

function WebSocketManager:disconnect(callback)
end

-- cc.WEBSOCKET_STATE_CONNECTING 
-- cc.WEBSOCKET_STATE_OPEN 
-- cc.WEBSOCKET_STATE_CLOSING
-- cc.WEBSOCKET_STATE_CLOSED
function WebSocketManager:getStatus()
	return wsSendBinary:getReadyState()
end
