-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require("core.base.scene.StandardScene")
local TestScene = class("GameScene",StandardScene)

-- init
function TestScene:init(...)
  cclog("init")
end

-- onEnter
function TestScene:onEnter()
  cclog("onEnter")
end

-- onExit
function TestScene:onExit()
  cclog("onExit")
end


return TestScene
