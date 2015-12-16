-------------------------------------------------------------------------------
-- core boot
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------
--
DebugLog = class("cclog")
DebugLog.TAG = {
	NETWORK = "network"
}

function DebugLog:debug(tag,fmt,...)
	if DEBUG == 0 then return end
	if fmt == nil then
		printLog("DEBUG",tag,...)
	else 
		printLog(tag,fmt,...)
	end
end

-- clean all src/app lua file
function  DebugLog:info(fmt,...)
	printInfo(fmt,...)
end

function  DebugLog:error(fmt,...)
	printError(fmt,...)
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
	DebugLog:error(tostring(msg))
end

