local cjson = require("cjson")
local DataManager = class("DataManager")

function DataManager:getData(name)
	return GameUtils:tableFromJson(name)
end

return DataManager
