local Ball = class("Ball", cc.Sprite)

Ball.MOVING = 0
Ball.BROKEN = 1

Ball._state = 0
Ball._type = 0
Ball._frame = nil
Ball._image = nil
Ball.scalePer = 0.7
Ball.circleSize = 45
--Ball.scalePer = 0.5

Ball.type = {
	[1] = "battle/ball_water.png",
	[2] = "battle/ball_fire.png",
	[3] = "battle/ball_tree.png",
	[4] = "battle/ball_light.png",
	[5] = "battle/ball_dark.png",
}

function Ball:ctor()
end

function Ball:create(type)
	local ball = Ball.new()
	ball:init(type)
	return ball
end

function Ball:init(type)
	self:enableNodeEvents()
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
--	self._frame = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(1, 0, 0.5))
--	local vertexes = {cc.p(44,-3),cc.p(25,-40),cc.p(-22,-41),cc.p(-42,-3),cc.p(-22,36),cc.p(25,37)}
	local vertexes = {cc.p(27,39),cc.p(47,-1),cc.p(29,-40),cc.p(-25,-40),cc.p(-45,-2),cc.p(-25,40)}
	self._frame = cc.PhysicsBody:createPolygon(vertexes, cc.PhysicsMaterial(10, 0, 0.5))
	self._frame:setDynamic(true) --重力干渉を受けるか
	self._frame:setRotationEnable(true)
	--	self._frame:setMoment(PHYSICS_INFINITY) --モーメント(大きいほど回転しにくい)
--	self._frame:setMass(1) --重さ
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

function Ball:addBallTouchEffect()
	local action1 = cc.ScaleTo:create(0.1,1.6)
	local action2 = cc.ScaleTo:create(0.1,1.3)
	self._image:runAction(cc.Sequence:create(action1,action2))
	self:getParent():reorderChild(self,2)
	
end

function Ball:removeBallTouchEffect()
	self._image:stopAllActions()
	self._image:setScale(1)
	self:getParent():reorderChild(self,1)
end

function Ball:getType()
	return self._type
end

return Ball

