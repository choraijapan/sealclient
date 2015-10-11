
local Ball = class("Ball", cc.Sprite)

Ball.MOVING = 0
Ball.BROKEN = 1

Ball._state = 0
Ball._type = 0

Ball.size = 0
Ball.scalePer = 0.35 * 2          -- TODO 这个要弄成可变的！！
Ball.circleSize = 22 * 2
--Ball.scalePer = 0.5 -- TODO 这个要弄成可变的！！

--Ball.type = {
--    [1] = "donat_1.png",
--    [2] = "donat_2.png",
--    [3] = "donat_3.png",
--    [4] = "donat_4.png",
--    [5] = "cat_1.png",
--}

Ball.type = {
	[1] = "battle/ball_adore.png",  
	[2] = "battle/ball_hell.png",      
	[3] = "battle/ball_boom.png",      --DEFDOWN
	[4] = "battle/ball_cold.png",  --FREEZE
	[5] = "battle/ball_boss.png", 
}

function Ball:ctor()
  local test = 1
end

function Ball:create(type)
    local ball = Ball.new()
    ball:init(type)
    return ball
end

function Ball:init(type)
  	self:enableNodeEvents()
    local _tagColor = {
        [1] = cc.c3b(152,255,50),
        [2] = cc.c3b(92,78,29),
        [3] = cc.c3b(245,100,0),
        [4] = cc.c3b(10,126,254),
        [5] = cc.c3b(255,255,255),
    }
--    self:setColor(_tagColor[type])
    
    self._type = type
	WidgetLoader:setSpriteImage(self, self.type[type])
    local size = self:getContentSize()
--    if type == 2 then
--        self.scalePer = 0.4
--    else
--        self.scalePer= 0.25
--    end
    self:setScale(self.scalePer)
    self.size = (size.width/2) * self.scalePer
    local pBall = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(1, 0, 0.4))
    pBall:setDynamic(true)
    pBall:setRotationEnable(true)
    --    pBall:setMoment(PHYSICS_INFINITY) --モーメント(大きいほど回転しにくい)
    pBall:setMass(1.0) --重さ
    self:setPhysicsBody(pBall)
end


function Ball:brokenBullet()
    self:stopAllActions()
    local remove = cc.RemoveSelf:create()
    self:runAction(remove)
    self._state = self.BROKEN
end

function Ball:getPosition()
    local pos = {}
    pos.x = self:getPositionX()
    pos.y = self:getPositionY()
    return pos
end

function Ball:getState()
    return self._state
end

function Ball:onEnter()

end

function Ball:getType()
    return self._type
end

return Ball

