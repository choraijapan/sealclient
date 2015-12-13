local TestTable = class("TestTable", Game.BaseDb)

TestTable.path = cc.FileUtils:getInstance():getWritablePath()
TestTable.db_name = "test.db"
TestTable.table_name = "test"
TestTable.col_def = {
    id = "int",
	content = "string",    
}

function TestTable:test()

end

return TestTable