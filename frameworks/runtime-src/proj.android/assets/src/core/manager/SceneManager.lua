-------------------------------------------------------------------------------
-- SceneManager
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
SceneManager = class("SceneManager")

--------------------------------------------------------------------------------
-- @function
-- #changeScene
function SceneManager:changeScene(scene_path, ...)
	local scene_class = require(scene_path)
	scene_class:createScene(...)
	if scene_class then
		scene_class:initialize(...)
		if cc.Director:getInstance():getRunningScene() then
			cc.Director:getInstance():replaceScene(scene_class.scene)
		else
			cc.Director:getInstance():runWithScene(scene_class.scene)
		end
	end
	CacheUtils:removeAllAppLua()
	
end
