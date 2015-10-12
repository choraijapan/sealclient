
local Ball = class("Ball", cc.Sprite)

Ball.MOVING = 0
Ball.BROKEN = 1

Ball._state = 0
Ball._type = 0
Ball._frame = nil
Ball._image = nil

--Ball.size = 0  -- いらない。
Ball.scalePer = 0.7          -- TODO 这个要弄成可变的！！
Ball.circleSize = 42
--Ball.scalePer = 0.5 -- TODO 这个要弄成可变的！！

--Ball.type = {
--    [1] = "donat_1.png",
--    [2] = "donat_2.png",
--    [3] = "donat_3.png",
--    [4] = "donat_4.png",
--    [5] = "cat_1.png",
--}

Ball.type = {
	[1] = "battle/1.png",  
	[2] = "battle/2.png",      
	[3] = "battle/3.png",      --DEFDOWN
	[4] = "battle/4.png",  --FREEZE
	[5] = "battle/5.png", 
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
    
    self._image = cc.Sprite:create()
    WidgetLoader:setSpriteImage(self._image, self.type[type])
    self:addChild(self._image)
--    local size = self._image:getContentSize()
--    if type == 2 then
--        self.scalePer = 0.4
--    else
--        self.scalePer= 0.25
--    end
    self:setScale(self.scalePer)
--    self.size = (size.width/2) * self.scalePer
--    self.size = self.circleSize
    --1、density（密度）2、restiution（弹性）3、friction（摩擦力）
    self._frame = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(1, 0, 0.5))
    
    self._frame:setDynamic(true)
    self._frame:setRotationEnable(true)
    --    pBall:setMoment(PHYSICS_INFINITY) --モーメント(大きいほど回転しにくい)
    self._frame:setMass(1) --重さ
    self:setPhysicsBody(self._frame)
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

--function Ball:addBallTouchEffect()
--    local copySelf = cc.Sprite:create()
--    WidgetLoader:setSpriteImage(copySelf, self.type[self._type])
--    copySelf:setScale(self.scalePer + 0.1)
--    copySelf:setAnchorPoint(cc.p(0.5, 0.5))
--    copySelf:setPosition(self:getPosition())
--    copySelf:setTag(1)
--    self:getParent():addChild(copySelf,10)
--end
function Ball:addBallTouchEffect()
    self._image:setScale(1.2)
    self:getParent():reorderChild(self,2)
end

function Ball:removeBallTouchEffect()
    self._image:setScale(1)
    self:getParent():reorderChild(self,1)
end

function Ball:getType()
    return self._type
end

return Ball

