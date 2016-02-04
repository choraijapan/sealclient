local UserApi = class("UserApi",Game.BaseApi)

function UserApi:Request(callback)
	--NetworkManager:request("mypage/index.msgpack",param, baseCallback)

	self:request("mypage",nil,
		function (success,res)
			callback(res.values)
		end
	)
end

return UserApi
