MultiManager = class("MultiManager")

function MultiManager:connect(param)
	local userName = param.userName
	local port = param.port
	local wsUrl = string.format("%s:%d/%d",NetWorkConst.WS.URL,8080,userName)
	WebSocketManager:connect(wsUrl,param, self.onConnect,self.onMessage,self.onClose,self.onError)
end

function MultiManager:createRoom(roomName)
	MultiManager:emit(NetWorkConst.WS.MSG_CODE.CREATE_ROOM,roomName)
end

function MultiManager:joinRoom(roomName)
	MultiManager:emit(NetWorkConst.WS.MSG_CODE.JOIN_ROOM,roomName)
end

function MultiManager:leaveRoom()
	MultiManager:emit(NetWorkConst.WS.MSG_CODE.LEAVE_ROOM,nil)
end

function MultiManager:emit(code,data)
	local param = {}
	param.c = code
	param.v = data
	if (cc.WEBSOCKET_STATE_OPEN ~= self:getStatus()) then
		return
	end
	if (param.c == nil) then
		param.c = NetWorkConst.WS.MSG_CODE.MSG
	end 
	WebSocketManager:emit(param)
end

function MultiManager:close()
    WebSocketManager:close()
end

function MultiManager:getStatus()
	return WebSocketManager:getStatus()
end

MultiManager.onConnect = nil
MultiManager.onMessage = nil
MultiManager.onCreateRoom = nil
MultiManager.onJoinRoom = nil
MultiManager.onLeaveRoom = nil
MultiManager.onClose = nil
MultiManager.onError = nil
