-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
SceneManager = class("SceneManager")

--------------------------------------------------------------------------------
-- @function
-- #changeScene
function SceneManager:changeScene(scene_path, ...)
  self:clean();
  local scene_class = require(scene_path).new(...)
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


function SceneManager:clean()
  -- lua reload削除
  local loadedtable = package.loaded
  for k, v in pairs(loadedtable) do
    local findPath =  string.find(k, "scene")
    if findPath ~= nil then
      package.loaded[k] = nil
    end
  end
end
