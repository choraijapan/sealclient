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
  local sprite = cc.Sprite:create("BugAnt.png")
  self.scene:addChild(sprite)
  sprite:setPosition(cc.p(50,100));
  cclog("onEnter")

end

-- onExit
function TestScene:onExit()
  cclog("onExit")
end

return TestScene
