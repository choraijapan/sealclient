
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

local resourceVersionApi = require("app.network.api.reource.ResourceVersionApi")

local testTable = require("app.data.master.TestTable")

local userApi = require("app.network.api.UserApi")









-- onEnter
function DebugScene:onEnter()
	
	local function callback(res)
		print("#########"..dumpTable(res))
	end
	
	userApi:test(callback)
	
--	local a = nil
--	--a = testTable:insert(record)
--	testTable:deleteById(29)
--	testTable:deleteById(103)
--	testTable:deleteById(104)
--
--	a = testTable:find()
--	a = testTable:findAll()
--
--	local i = {
--		id = 29,
--		content = "c 29"
--	}
--	a = testTable:insert(i)
--	a = testTable:find()
--	a = testTable:findAll()
--
--    
--    local recoreds = {}
--    local i1 = {
--        id = "103",
--        content = "c 103"
--    }
--	local i2 = {
--		id = "104",
--		content = "c 104"
--	}
--	
--	recoreds[1] = i1
--	recoreds[2] = i2
--    
--	testTable:batchInsert(recoreds)
--    
--    
--	local updateQueyr = {
--		content = "test3"
--	}
--
--	testTable:update(updateQueyr, " id = 29")
--	--baseApi:request(nil)
--	
--	-- test createDir
--	local is = GameFileUtils:isDirectoryExist(GameFileUtils:getDownloadPath())
--	if is == false then
--		GameFileUtils:createDirectory(GameFileUtils:getDownloadPath())
--	else
--		GameFileUtils:removeDirectory(GameFileUtils:getDownloadPath())
--	end
--	resourceVersionApi:updateVersionFile()

--	local debugTable = require("src.app.scene.debug.DebugTable")
--	debugTable:init()
--	self:TestResVerUpdate()
--	cc.AssetsManager:new("http://192.168.33.10/app/dl/res/Default/Button_Disable.png.zip",
--		"https://raw.github.com/samuele3hu/AssetsManagerTest/master/version",
--		res_download_path)
--	self:AseetsDownload()
end


-- onExit
function DebugScene:TestResVerUpdate()
	local resVerTable = require("app.data.user.ResourceVerTable")
	resourceVersionApi:updateVersionFile(function(res)
		for key, var in pairs(res) do
			local record = resVerTable:find(string.format("WHERE path = '%s' AND file = '%s'",var[1], var[2]))
			if record == nil then
				local insert = {
					path  = var[1],
					file  = var[2],
					checksum = var[3],
					update_flg = 1
				}
				resVerTable:insert(insert)
			elseif record.checksum ~= var.checksum then

				local update = {
					checksum = var.checksum,
					update_flg = 1,
				}
				resVerTable:updateById(update,record.id)
			end
		end
	end)
end


-- onExit
function DebugScene:AseetsDownload()
	local assetsManager       = nil

	local resVerTable = require("app.data.user.ResourceVerTable")
	
	local res_download_path = GameFileUtils:getDownloadPath()
	GameFileUtils:createDirectory(res_download_path)
	
	local function onError(errorCode)
		assetsManager:release()
		if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
		elseif errorCode == cc.ASSETSMANAGER_NETWORK then
		end
	end

	local function onProgress( percent )
	   if (percent <= 0) then
			percent = 0
	   end
	   DebugLog:debug(percent)
	end

	local function onSuccess()
	
		DebugLog:debug("downloading ok")
		local re = resVerTable:find("WHERE update_flg = 1 ")
		if not re then
		  assetsManager:release()
		end
		
	end

	local function getAssetsManager()
		if nil == assetsManager then
			assetsManager = cc.AssetsManager:new("http://192.168.33.10/static/download",
			    cc.FileUtils:getInstance():getWritablePath().."user/user.db",
				res_download_path)
			assetsManager:retain()
			assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
			assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
			assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
			assetsManager:setConnectionTimeout(3)
		end

		return assetsManager
	end
	
	getAssetsManager():update()
	
end


-- onExit
function DebugScene:onExit()

end

return DebugScene