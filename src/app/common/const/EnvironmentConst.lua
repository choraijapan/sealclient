-------------------------------------------------------------------------------
-- @date 2015/10/14
-- @author chorai
-------------------------------------------------------------------------------
--local masterPath = ""
--if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
--	masterPath = "master"
--elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
--	masterPath = "master"
--else
--	masterPath = "res/masterMac"
--end

EnvironmentConst = {
	--cc.XMLHTTPREQUEST_RESPONSE_MSGPACK
	--cc.XMLHTTPREQUEST_RESPONSE_JSON
	HTTP_DATA_TYPE = cc.XMLHTTPREQUEST_RESPONSE_MSGPACK,
	--	HTTP_SERVER_URL = "http://192.168.33.10/",
	HTTP_SERVER_URL = "http://crown.eglass.jp/",

	DOWNLOAD_ASSETS_PATH_IOS = cc.FileUtils:getInstance():getWritablePath().."../Library/".."Download/",
	DOWNLOAD_ASSETS_PATH_ANDROID = cc.FileUtils:getInstance():getWritablePath().."../Download/",

	DB = {
		PATH = cc.FileUtils:getInstance():getWritablePath(),
		TYPE_MASTER = 'res/masterMac',
		TYPE_USER   = 'user',
	}
}

