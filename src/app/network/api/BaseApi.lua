
    
local BaseApi = class("BaseApi")

function BaseApi:request(param, callback)
	
	--response
	local function baseCallback(success, res)
	
	    -- 共通処理 エラーなど
		if (success) then
        
		else

		end
        if (callback ~= nil) then
		  callback(success,res)
		end
    end


	local param = {}
	local url = "http://www.baidu.com/"
	NetworkManager:request("mypage/index.msgpack",param, baseCallback)
--	
--	local data1 = {
--	   a = 1,
--	   b = "お破y路Fだfdさfdさfdさfdさfdさ"
--	}
--	
--	local tbl = { a=123, b="any", c={"ta","bl","e",1,2,3} }
--	local packed = msgPack.pack(data1)
--	local unpacked_table = msgPack.unpack(packed)
	
end


return BaseApi