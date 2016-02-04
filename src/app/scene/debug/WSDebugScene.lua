
-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local WSDebugScene = class("WSDebugScene",StandardScene)
local msgPack = require("msgpackcpp")


-- init
function WSDebugScene:init(...)
	self.m = {}
end
local count  = 0
-- onEnter
function WSDebugScene:onEnter()
    local param = {}
    local function onConnect(data)
		local msg = "test lua " ..count
		local sent = {}
		sent["test"] = msg
		sent["test1"] = {
		  a = 0,
		  b = "尾羽よう御座います。FだsfだsfだsfだsfdさいいいいいいfdさFだsjkッッmッッbfdさfだFだsfでいい家。"
		
		}
		local en = msgPack.pack(sent)
		local de = msgPack.unpack(en)
		WebSocketManager:emit(sent)
    end
	local function onMessage(data)
	   --DebugLog:debug(data)
	   count = count + 1
		local msg = "test lua " ..count
		local sent = {}
		sent["test"] = msg
		WebSocketManager:emit(sent)
	end
	local function onClose(data)
	end
	local function onError(data)
	end
	WebSocketManager:connect("ws://127.0.0.1:8080/123",param, onConnect,onMessage,onClose,onError)
end



-- onExit
function WSDebugScene:onExit()

end

return WSDebugScene