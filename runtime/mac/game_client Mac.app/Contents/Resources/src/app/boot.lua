-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
local Application = class("Application")
DebugLog:debug(cc.FileUtils:getInstance():getWritablePath());
function Application:main()
    require("app.common.include.Global")

    -- initialize director
    local director = cc.Director:getInstance()

    --turn on display FPS
    --	director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 1136, cc.ResolutionPolicy.SHOW_ALL)
	SceneManager:changeScene("app/scene/menu/MenuScene", nil)
--    SceneManager:changeScene("src/app/scene/menu/MenuScene", nil)
    --	SceneManager:changeScene("app/scene/puzzle/PuzzleScene.lua",nil)
--	SceneManager:changeScene("src/app/scene/menu/MenuScene", nil)
--	SceneManager:changeScene("app/scene/title/TitleScene", nil)

local ttt = require("app.data.db.BaseDB")
local t = 1

end
return Application