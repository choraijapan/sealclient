

local ResourceVersionApi = class("ResourceVersionApi",Game.BaseApi)

ResourceVersionApi.request_type = "GET"

function ResourceVersionApi:updateVersionFile(callback)
	--NetworkManager:request("mypage/index.msgpack",param, baseCallback)

	self:request("static/download/assets_download_list.pack",nil,
		function (success,res)
			callback(res)
		end
	)
end

return ResourceVersionApi
