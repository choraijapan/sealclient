-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

local Application = class("Application")

function Application:main()

	-- initialize director
	local director = cc.Director:getInstance()

	--turn on display FPS
	director:setDisplayStats(true)

	--set FPS. the default value is 1.0/60 if you don't call this
	director:setAnimationInterval(1.0 / 60)
	cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 960, cc.ResolutionPolicy.FIXED_WIDTH)

	SceneManager:changeScene("src/app/scene/menu/MenuScene",nil)

end

return Application
