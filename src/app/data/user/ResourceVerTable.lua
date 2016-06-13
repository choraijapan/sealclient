local ResourceVerTable = class("ResourceVerTable", Game.BaseDb)

ResourceVerTable.type = EnvironmentConst.DB.TYPE_USER
ResourceVerTable.db_name = "user.db"
ResourceVerTable.table_name = "resource_ver"
ResourceVerTable.col_def = {
	path = "string",
	file = "string",
	checksum = "string",
	update_flg = "int",
}

function ResourceVerTable:update()

end


ResourceVerTable.create_query = [[
	  CREATE TABLE resource_ver (
	  	id        INTEGER PRIMARY KEY,
	    path       VARCHAR,
	    file       VARCHAR,
	    checksum   VARCHAR,
	    update_flg  INTEGER
	  );
	]]
ResourceVerTable.idx_query = [[
	  create unique index path_file on resource_ver(path,file);
	]]


return ResourceVerTable