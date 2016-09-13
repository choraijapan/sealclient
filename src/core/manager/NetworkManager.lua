NetworkManager = class("NetworkManager")

--local cjson = require("cjson")
--local msgPack = require("msgpackcpp")

function NetworkManager:request(api,type,param,callback)
	if EnvironmentConst.HTTP_DATA_TYPE == cc.XMLHTTPREQUEST_RESPONSE_MSGPACK then
	   self:request_msgpack(api,type,param,callback)
	end
	
	if EnvironmentConst.HTTP_DATA_TYPE == cc.XMLHTTPREQUEST_RESPONSE_JSON then
		self:request_json(api,type,param,callback)
	end
end


function NetworkManager:request_msgpack(api,type,param,callback)

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_MSGPACK

	xhr:open(type, EnvironmentConst.HTTP_SERVER_URL..api)

	local function onResponse()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			callback(true, xhr.response)
		else
			local error ={
				readyState = xhr.readyState,
				status = xhr.readyState,
			}
			callback(false,error)
		end
	end

	xhr:registerScriptHandler(onResponse)
	xhr:send(msgPack.pack(param))
end


function NetworkManager:request_json(api,type,param,callback)

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON

	xhr:open(type, EnvironmentConst.HTTP_SERVER_URL..api)

	local function onResponse()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			callback(true, cjson.decode(xhr.response))
		else
			local error ={
				readyState = xhr.readyState,
				status = xhr.readyState,
			}
			callback(false,error)
		end
	end

	xhr:registerScriptHandler(onResponse)
	xhr:send(cjson.encode(param))
end

