-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

local StandardScene = require(GameSysConst.SCENE_PATH.STANDARD)
local TestScene = class("GameScene",StandardScene)

-- init
function TestScene:init(...)
	printInfo("init")
end


-- onEnter
function TestScene:onEnter()
	local sprite_bug = cc.Sprite:create("BugAnt.png")
	self.scene:addChild(sprite_bug)
	sprite_bug:setPosition(cc.p(50,200));
	sprite_bug:runAction(cc.MoveTo:create(1,cc.p(100,300)))
	printInfo("onEnter")
end


-- onExit
function TestScene:onExit()
	CacheUtils:removeLoadedAppLua(CleanUpList.TYPE_SCENE)
	printInfo("onExit")
end


return TestScene
