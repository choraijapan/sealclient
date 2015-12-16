
    
local BaseApi = class("BaseApi")

function BaseApi:request(data)
    local data = {}
	local url = "http://www.baidu.com/"
	NetworkManager:request("http://www.baidu.com/",data)
	NetworkManager:request("http://www.yahoo.co.jp/",data)
	NetworkManager:request("http://www.rakuten.co.jp/",data)
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