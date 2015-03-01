-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require("core.main.base.scene.StandardScene")
local TestScene = class("GameScene",StandardScene)

-- init
function TestScene:init(...)
  cclog("init")
end

-- onEnter
function TestScene:onEnter()
  local sprite_bug = cc.Sprite:create("BugAnt.png")
  self.scene:addChild(sprite_bug)
  sprite_bug:setPosition(cc.p(150,200));
  cclog("onEnter")
end


-- onExit
function TestScene:onExit()
  CacheUtils:removeLoadedAppLua(CleanUpList.TYPE_SCENE)
  cclog("onExit")
end


return TestScene
