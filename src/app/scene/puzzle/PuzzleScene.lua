-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------
require("app.scene.puzzle.Global")

local PhysicsScene = require('core.base.scene.PhysicsScene')
local ScenePuzzle = class("ScenePuzzle",PhysicsScene)

local gravity = cc.p(0, -98)
local speed = 5.0


-- init
function ScenePuzzle:init(...)
    self.scene:getPhysicsWorld():setGravity(gravity)
    self.scene:getPhysicsWorld():setSpeed(speed)
    
    --self.scene:getPhysicsWorld():setAutoStep(false)
    require('app.scene.puzzle.layer.GameLayer')

    local gameCardNode = WidgetLoader:loadCsbFile('parts/game/GameCardNode.csb')
    gameCardNode:setPosition(cc.p(0,cc.Director:getInstance():getWinSize().height/2 + 40))
    gameCardNode:setName("GameCardNode")

    self.scene:addChild(GameLayer:create(),1)
    self.scene:addChild(gameCardNode,2)

    local deck1 = WidgetObj:searchWidgetByName(gameCardNode,"Sprite_1","cc.Sprite")
    --deck1:setScale(1.5)

end

-- onEnter
function ScenePuzzle:onEnter()
    local test = 1
end

function ScenePuzzle:update(dt,node)
--self.scene:getPhysicsWorld():setp(0.05)
end

-- onExit
function ScenePuzzle:onExit()

end

return ScenePuzzle

