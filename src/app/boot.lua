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
	cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 960, 2)

	SceneManager:changeScene("src/app/scene/menu/MenuScene",nil)

	-- add resource searchPath
	--    cc.FileUtils:getInstance():addSearchPath("res")
	--create scene
	--  local scene = require("app.scene.GameScene")
	--  local gameScene = scene.new(GameSysConst.SCENE_TYPE.STANDARD)
	--  scene:initialize()
	--  --    gameScene:playBgMusic()
	--
	--  if cc.Director:getInstance():getRunningScene() then
	--    cc.Director:getInstance():replaceScene(gameScene)
	--  else
	--    cc.Director:getInstance():runWithScene(gameScene)
	--  end
end

return Application
