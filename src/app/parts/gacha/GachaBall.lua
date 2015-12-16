local GachaBall = class("GachaBall", cc.Sprite)

GachaBall.DENSITY = 10
GachaBall.RESTIUTION = 0
GachaBall.FRICTION = 0.4
GachaBall.MASS = 10
GachaBall._state = 0
GachaBall._frame = nil
GachaBall._image = nil
GachaBall.scalePer = 1.6 --元の値
GachaBall.circleSize = 80 --元の値
GachaBall.BOOM = 5

function GachaBall:ctor()
end

function GachaBall:create(type)
	local ball = GachaBall.new()
	ball:init(type)
	return ball
end

function GachaBall:init(type)
	self._image = cc.Sprite:create()
	WidgetLoader:setSpriteImage(self._image, GameConst.BALL_PNG[type])
	self._image:setAnchorPoint(cc.p(0.5,0.5))
	self:setAnchorPoint(cc.p(0.5,0.5))
	self:addChild(self._image)
	self:setScale(self.scalePer)
	self._frame = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	self._frame:setDynamic(true) --重力干渉を受けるか
	self._frame:setRotationEnable(true)
	self._frame:setMoment(800) --モーメント(大きいほど回転しにくい)
	self._frame:setMass(self.MASS) --重さ
	self._frame:setCategoryBitmask(1)
	self._frame:setCollisionBitmask(0x01)
	self._frame:setContactTestBitmask(2)
	self:setPhysicsBody(self._frame)
end
return GachaBall