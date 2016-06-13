-------------------------------------------------------------------------------
-- core boot
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------
--
CacheUtils = class("CacheData")

function CacheUtils:removeAllResource()
	cc.SpriteFrameCache:getInstance():removeSpriteFrames()
	cc.Director:getInstance():getTextureCache():removeAllTextures()
	cc.Director:getInstance():getRunningScene():getEventDispatcher():removeAllEventListeners()
	ccs.SceneReader:destroyInstance()
	ccs.ActionManagerEx:destroyInstance()
	ccs.GUIReader:destroyInstance()
	ccs.ArmatureDataManager:destroyInstance()
end


function CacheUtils:removeAllAppScript()
	local loadedLuaFile = package.loaded
	for k, v in pairs(loadedLuaFile) do
		local findPath =  string.find(k, "app")
		if findPath ~= nil then
			package.loaded[k] = nil
		end
	end
end

function CacheUtils:removeAllAppExcludeCommon()
	local excludeList = CleanUpList.LIST[CleanUpList.TYPE_GLOBAL]
	local loadedLuaFile = package.loaded
	for k, v in pairs(loadedLuaFile) do
		local findPath =  string.find(k, "app")
		for ck, cv in pairs(excludeList) do
			local findPath =  string.find(ck, cv)
			if findPath == nil then
				package.loaded[k] = nil
			end
		end
		
	end
end

-- clean all src/app lua file
function  CacheUtils:removeAllAppLua(excludeGlobal)
	if (excludeGlobal) then
	   self:removeAllAppExcludeCommon()
	else 
		self:removeAllApp()
	end
end


-- clean loded lua file by type
function  CacheUtils:removeLoadedAppLua(type)
	local clean_list = CleanUpList.LIST[type]
	local loadedLuaFile = package.loaded
	for k, v in pairs(loadedLuaFile) do
		for ck, cv in pairs(clean_list) do
			local findPath =  string.find(k, cv)
			if findPath ~= nil then
			--	DebugLog:debug(k)
				package.loaded[k] = nil
			end
		end
	end
end




