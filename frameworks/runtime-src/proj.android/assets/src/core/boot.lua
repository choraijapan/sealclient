-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

-- load cocos2dx lua api
require("cocos.init")
require("core.common.include.Global")

-- main
local function main()

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or
		(cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
		(cc.PLATFORM_OS_MAC == targetPlatform) then
	end

	local application = require("app.boot")
	application:main()

end


xpcall(main, __G__TRACKBACK__)
