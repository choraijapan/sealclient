--require("lsqlite3")

local BaseDB = class("BaseDB")
BaseDB.type = nil
BaseDB.db_name = nil
BaseDB.table_name = nil
BaseDB.col_def = nil
BaseDB.db = nil

function BaseDB:open()
	if self.db == nil then
		local test = EnvironmentConst.DB_PATH
		local path = GameFileUtils:getDbPath(self.type)
		
		if GameFileUtils:isDirectoryExist(path) == false then
		  GameFileUtils:createDirectory(path)
		end
		self.db = sqlite3.open(path..self.db_name)
	end
end

function BaseDB:close()
	self.db:close()
	self.db = nil
end

function BaseDB:exec(query)
	self:open()
	self.db:exec(query)
end

function BaseDB:findById(id) 
	self:open()
	local query = "SELECT * FROM "..self.table_name .. " WHERE id = " .. id
	local stmt = self.db:prepare(query)
	local result = nil
	for row in stmt:nrows() do
		result = row
		break;
	end
	stmt:finalize()
	return result
end

function BaseDB:find(where)
    self:open()
	local query = "SELECT * FROM "..self.table_name
	if where ~= nil then
		query = query .. " ".. where
	end

	local stmt = self.db:prepare(query.." LIMIT 1")
	local result = nil
	for row in stmt:nrows() do
		result = row
	end
	stmt:finalize()
	return result
end

function BaseDB:findAll(where)
	self:open()
	local query = "SELECT * FROM "..self.table_name
	if where ~= nil then
		query = query .. " WHERE ".. where
	end
	local stmt =   self.db:prepare(query)
	
	local result = {}
	for row in stmt:nrows() do
		result[row.id] = row
	end
	stmt:finalize()
	return result
end

function BaseDB:findLimit(where,limit)
	self:open()
	local stmt = self.db:prepare("SELECT * FROM "..self.table_name.. " LIMIT ".. limit)
	local result = {}
	for row in stmt:nrows() do
		result[row.id] = row
	end
	stmt:finalize()
	return result
end

function BaseDB:updateById(cols, id)
	self:open()
	local query = "UPDATE "..self.table_name .. " SET "

	local totalCount = GameUtils:tablelength(cols)
	local count = 0

	for k, v in pairs(cols) do
		query = query .. k .. "='" .. v .. "'"
		count = count + 1
		if (count ~= totalCount) then
			query = query .. ","
		end
	end

	query = query .. " WHERE id = ".. id
	--DebugLog:debug(self.path)
	self:exec(query)
end

function BaseDB:update(cols, where)
	self:open()
	local query = "UPDATE "..self.table_name .. " SET "

	local totalCount = GameUtils:tablelength(cols)
	local count = 0

	for k, v in pairs(cols) do
		query = query .. k .. "='" .. v .. "'"
--		if type(v) == "string" then
--			query = query .. k .. "='" .. v .. "'"
--		else    
--			query = query .. k .. "=" .. v
--        end
		
		count = count + 1
		if (count ~= totalCount) then
			query = query .. ","
		end
    end

	if where ~= nil then
		query = query .. " WHERE ".. where
	end
	--DebugLog:debug(self.path)
	self:exec(query)
end


function BaseDB:insert(cols)
	local query = "INSERT INTO "..self.table_name.." ("

    local values = ""
	local names = ""
	local totalCount = GameUtils:tablelength(cols)
	local count = 0
	for k, v in pairs(cols) do
		names = names .."'" .. k .. "'"
		values = values .. "'" .. v .. "'"
		count = count + 1
		if (count ~= totalCount) then
			names = names .. ","
			values = values .. ","
		end
	end
	query = query .. names .. ") VALUES (" .. values .. ")"
	
	self:exec(query)
end

function BaseDB:delete(where)
	self:open()
	local query = "DELETE FROM "..self.table_name
	if where ~= nil then
		query = query .. " WHERE ".. where
	end
	self:exec(query)
end

function BaseDB:deleteById(id)
	self:open()
	local query = "DELETE FROM "..self.table_name .. " WHERE id = " .. id
	self:exec(query)
end

function BaseDB:batchInsert(records)
	self:open()
	self:exec("BEGIN IMMEDIATE TRANSACTION");
	
	for k, v in pairs(records) do
		self:insert(v)
	end
	
	self:exec("COMMIT TRANSACTION");
end

return BaseDB