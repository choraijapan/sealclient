local Ball = class("Ball", cc.Sprite)

Ball.MOVING = 0
Ball.BROKEN = 1

Ball.DENSITY = 1
Ball.RESTIUTION = 0
Ball.FRICTION = 0.3
Ball.MASS = 1

Ball._state = 0
Ball._type = 0
Ball._frame = nil
Ball._image = nil
Ball.scalePer = 0.65
Ball.circleSize = 41
--Ball.scalePer = 0.5
Ball.TAG = {
	NUMBER = 1,
}
--Ball.type = {
--	[1] = "battle/ball_water.png",
--	[2] = "battle/ball_fire.png",
--	[3] = "battle/ball_tree.png",
--	[4] = "battle/ball_light.png",
--	[5] = "battle/ball_dark.png",
--}
Ball.type = {
	[1] = "battle/test_1.png",
	[2] = "battle/test_2.png",
	[3] = "battle/test_3.png",
	[4] = "battle/test_4.png",
	[5] = "battle/test_5.png",
}
Ball.BOOM = 100

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
	self._image:setAnchorPoint(cc.p(0.5,0.5))
	self:setAnchorPoint(cc.p(0.5,0.5))
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
	--	self._frame = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	--	local vertexes = {cc.p(44,-3),cc.p(25,-40),cc.p(-22,-41),cc.p(-42,-3),cc.p(-22,36),cc.p(25,37)}
	local vertexes = {cc.p(27,39),cc.p(47,-1),cc.p(29,-40),cc.p(-25,-40),cc.p(-45,-2),cc.p(-25,40)} --６角形
--	local vertexes = {cc.p(-41, -43),cc.p(3, 48),cc.p(49, -44)} --5角形
	self._frame = cc.PhysicsBody:createPolygon(vertexes, cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	self._frame:setDynamic(true) --重力干渉を受けるか
	self._frame:setRotationEnable(true)
	self._frame:setMoment(1000) --モーメント(大きいほど回転しにくい)
	self._frame:setMass(self.MASS) --重さ
	self:setPhysicsBody(self._frame)
end


function Ball:brokenBullet()
	if self:getName() ~= "boom" then
		self:broken()
	end
end
function Ball:broken()
	local particle = cc.ParticleSystemQuad:create("effect/puzzle.plist")
	particle:setPosition(cc.p(0,0))
	particle:setScale(0.2)
	particle:setAutoRemoveOnFinish(true)
	particle:setPosition(cc.p(self:getPositionX(),self:getPositionY()))

	--	self:stopAllActions()
	--	self:removeFromParent()

	local function actionEnd()
		self:getParent():addChild(particle,999)
		self:getParent():reorderChild(self,3)
	end

	local action1 = cc.CallFunc:create(actionEnd)
	local action2 = cc.RemoveSelf:create()
	local action = cc.Spawn:create(action1,action2)
	self:runAction(action)
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

function Ball:addBallHint()
	if self:getName() ~= "boom" then
		self:setName("big")
		--		self._image:setScale(1.2)
		--		self._image:setColor(cc.c3b(123,123,123))
		--		self._image:setBlendFunc(gl.DST_COLOR,gl.SRC_COLOR)
		self:addGlowEffect(self._image,60,1,1)
	end
end

function Ball:addGlowEffect(sprite, opacity, scale,order)
	local pos = cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
	local glowSprite = cc.Sprite:create("battle/ball_white.png")
	--	glowSprite:setColor(ccColor3B)
	glowSprite:setPosition(pos)
	glowSprite:setRotation(sprite:getRotation())
	glowSprite:setOpacity(opacity)
	--	glowSprite:setBlendFunc(gl.SRC_ALPHA,gl.ONE)
	glowSprite:setScale(scale)
	sprite:addChild(glowSprite, order)
end

function Ball:addBallTouchEffect()
	if self:getName() ~= "boom" then
		self:setName("big")
		local action1 = cc.ScaleTo:create(0.1,1.4)
		self._image:runAction(cc.Sequence:create(action1))
		self:getParent():reorderChild(self,2)
		self:addGlowEffect(self._image,255,1.05,-1)
	end
end
function Ball:removeBallTouchEffect()
	if self:getName() ~= "boom" then
		self:setName("normal")
		self._image:stopAllActions()
		self._image:setScale(1)
		self._image:removeAllChildren()
		self:getParent():reorderChild(self,1)
	end
end

function Ball:addPuzzleNumber(num)
	if self:getName() ~= "boom" then
		local puzzleNumber = ccui.TextAtlas:create()
		puzzleNumber:setProperty(num, "battle/labelatlas.png", 17, 22, "0")
		puzzleNumber:setScale(1.5)
		puzzleNumber:setTag(self.TAG.NUMBER)
		puzzleNumber:setPosition(cc.p(self:getPositionX(),self:getPositionY() + 100))
		self:getParent():addChild(puzzleNumber,1111)
		self:getParent():reorderChild(puzzleNumber,11111)
		local action1 = cc.ScaleTo:create(0.1, 4)
		if num > 5 then
			action1 = cc.ScaleTo:create(0.1, 6)
		end
		local action2 = cc.ScaleTo:create(0.1, 3)
		local action3 = cc.DelayTime:create(1.5)
		local action4 = cc.FadeOut:create(0.5)
		local action5 = cc.DelayTime:create(0.5)
		local action6 = cc.RemoveSelf:create()
		puzzleNumber:runAction(cc.Sequence:create(action1, action2,action3,action4,action5,action6))
	end
end
function Ball:removePuzzleNumber()
	if self:getParent():getChildByTag(self.TAG.NUMBER) ~= nil then
		self:getParent():removeChildByTag(self.TAG.NUMBER)
	end
end
function Ball:getType()
	return self._type
end

function Ball:addBoom(num)
	if num > 6 then
		self:setName("boom")
		self:setTag(Ball.BOOM)
		self._image:setVisible(false)
		local particle = cc.ParticleSystemQuad:create("effect/boom.plist")
		particle:setAutoRemoveOnFinish(true)
		particle:setPosition(cc.p(0,0))
		particle:setScale(2)
		self:addChild(particle,1111)
		self:getParent():reorderChild(self,3)
	end
end
return Ball
