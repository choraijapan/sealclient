local UserApi = class("UserApi",Game.BaseApi)

function UserApi:test(callback)
	--NetworkManager:request("mypage/index.msgpack",param, baseCallback)

	self:request("mypage",nil,
		function (success,res)
			callback(res)
		end
	)
end

return UserApi
