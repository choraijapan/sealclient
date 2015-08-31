
GameScene = class("GameScene", function()
    return cc.Scene:createWithPhysics()
end)


function GameScene:createScene()
    local scene = GameScene.new()
    scene:getPhysicsWorld():setGravity(cc.p(0, -98))
    scene:getPhysicsWorld():setSpeed(3.0)
--    scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    local gameLayer = GameLayer:create()
    scene:addChild(gameLayer)
    
    return scene
end