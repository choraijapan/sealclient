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

WebSocketManager.onMessage = function(data)
    if WebSocketManager.onMessageCallBack ~= nil then
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
	self.wsSendBinary:sendString(msgPack.pack(data))
end

function WebSocketManager:close(callback)
    self.wsSendBinary:close()
end

-- cc.WEBSOCKET_STATE_CONNECTING 
-- cc.WEBSOCKET_STATE_OPEN 
-- cc.WEBSOCKET_STATE_CLOSING
-- cc.WEBSOCKET_STATE_CLOSED
function WebSocketManager:getStatus()
	return self.wsSendBinary:getReadyState()
end
