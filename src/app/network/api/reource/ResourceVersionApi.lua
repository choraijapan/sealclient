

local ResourceVersionApi = class("ResourceVersionApi",Game.BaseApi)

function ResourceVersionApi:updateVersionFile(callback)
	--NetworkManager:request("mypage/index.msgpack",param, baseCallback)

	self.super:request("static/download/assets_download_list.pack",nil,
		function (success,res)
			callback(res)
		end
	)
end

return ResourceVersionApi
