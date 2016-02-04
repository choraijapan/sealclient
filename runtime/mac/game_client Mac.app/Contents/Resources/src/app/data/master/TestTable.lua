local TestTable = class("TestTable", Game.BaseDb)

TestTable.type = EnvironmentConst.DB.TYPE_MASTER
TestTable.db_name = "test.db"
TestTable.table_name = "test"
TestTable.col_def = {
    id = "int",
	content = "string",    
}

function TestTable:test()

end

return TestTable