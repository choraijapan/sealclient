NetworkManager = class("NetworkManager")
local msgPack = require("msgpackcpp")

function NetworkManager:request(url,data)

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_MSGPACK
	xhr:open("POST", url)

	local function onResponse()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			local response   = xhr.response
			local test = 1
		else
			-- error
			DebugLog.error("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
		end
	end

	xhr:registerScriptHandler(onResponse)
	xhr:send(msgPack.pack(data))

	--	local xhr = cc.XMLHttpRequest:new()
	--	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	--	xhr:open("POST", "http://www.baidu.com/")
	--	local function onReadyStateChange()
	--		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	--			print(xhr.response)
	--		else
	--			print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
	--		end
	--	end
	--	xhr:registerScriptHandler(onReadyStateChange)
	--	xhr:send("aaa")

end
