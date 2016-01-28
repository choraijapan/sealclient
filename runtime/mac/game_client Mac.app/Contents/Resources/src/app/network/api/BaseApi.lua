
    
local BaseApi = class("BaseApi")

BaseApi.request_type = "POST"

function BaseApi:request(api, param, callback)
	
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


	if param == nil then
		param = {} 
	end
	NetworkManager:request(api,self.request_type,param, baseCallback)
end


return BaseApi