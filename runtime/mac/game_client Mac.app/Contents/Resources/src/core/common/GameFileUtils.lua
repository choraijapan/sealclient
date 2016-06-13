-------------------------------------------------------------------------------
-- core boot
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------
--
GameFileUtils = class("GameGameFileUtils")

function GameFileUtils:getDownloadPath()
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
		return EnvironmentConst.DOWNLOAD_ASSETS_PATH_IOS
	end

	if  (cc.PLATFORM_OS_ANDROID == targetPlatform) then
		return EnvironmentConst.DOWNLOAD_ASSETS_PATH_ANDROID
	end
	return nil
end

function GameFileUtils:getDbPath(type)
	return EnvironmentConst.DB.PATH ..type.."/"
end

function GameFileUtils:isDirectoryExist(path)
	return cc.FileUtils:getInstance():isDirectoryExist(path)
end

function GameFileUtils:isFileExist(path)
	return cc.FileUtils:getInstance():isFileExist(path)
end

function GameFileUtils:createDirectory(path)
	if self:isDirectoryExist(path) then
		return false;
	end
	return cc.FileUtils:getInstance():createDirectory(path)
end

function GameFileUtils:removeDirectory(path)
	if self:isDirectoryExist(path) == false then
		return false;
	end
	return cc.FileUtils:getInstance():removeDirectory(path)
end


function GameFileUtils:removeFile(path)
    return cc.FileUtils:getInstance():removeFile(path)
end



