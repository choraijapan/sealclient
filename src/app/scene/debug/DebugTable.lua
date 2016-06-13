
-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

DebugTable = class("DebugTable",Game.BaseDb)

local testDb = [[
	  CREATE TABLE test (
	    id        INTEGER PRIMARY KEY,
	    content   VARCHAR
	  );
	]]


function DebugTable:init() 

	local res_ver_table = require("app.data.user.ResourceVerTable")
	res_ver_table:open()
	res_ver_table:exec(res_ver_table.create_query)
	res_ver_table:exec(res_ver_table.idx_query)
	res_ver_table:close()
	
end




return DebugTable