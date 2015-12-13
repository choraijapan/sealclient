
-------------------------------------------------------------------------------
-- core TestScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require('core.base.scene.StandardScene')
local DebugScene = class("DebugScene",StandardScene)


--require("lsqlite3")
---- local db = sqlite3.open_memory()
--local db = sqlite3.open(cc.FileUtils:getInstance():getWritablePath().."/test.db")
--db:exec[[
--  CREATE TABLE test (
--    id        INTEGER PRIMARY KEY,
--    content   VARCHAR
--  );
--]]
--
--local insert_stmt = assert( db:prepare("INSERT INTO test VALUES (NULL, ?)") )
--
--local function insert(data)
--  insert_stmt:bind_values(data)
--  insert_stmt:step()
--  insert_stmt:reset()
--end
--
--local select_stmt = assert( db:prepare("SELECT * FROM test") )
--
--local function select()
--  for row in select_stmt:nrows() do
--      print(row.id, row.content)
--  end
--end
--
--insert("Hello World")
--print("First:")
--select()
--
--insert("Hello Lua")
--print("Second:")
--select()
--
--insert("Hello Sqlite3")
--print("Third:")
--select()

-- init
function DebugScene:init(...)
	self.m = {}
end

local testTable = require("app.data.master.TestTable")
-- onEnter
function DebugScene:onEnter()
	local a = nil
	--a = testTable:insert(record)
	testTable:deleteById(29)
	testTable:deleteById(103)
	testTable:deleteById(104)

	a = testTable:find()
	a = testTable:findAll()

	local i = {
		id = 29,
		content = "c 29"
	}
	a = testTable:insert(i)
	a = testTable:find()
	a = testTable:findAll()

    
    local recoreds = {}
    local i1 = {
        id = "103",
        content = "c 103"
    }
	local i2 = {
		id = "104",
		content = "c 104"
	}
	
	recoreds[1] = i1
	recoreds[2] = i2
    
	testTable:batchInsert(recoreds)
    
    
	local updateQueyr = {
		content = "test3"
	}

	testTable:update(updateQueyr, " id = 29")
end

-- onExit
function DebugScene:onExit()

end

return DebugScene