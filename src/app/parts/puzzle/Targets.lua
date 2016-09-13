local Targets = class("Targets", cc.Sprite)

Targets.DENSITY = 10
Targets.RESTIUTION = 0
Targets.FRICTION = 0.4
Targets.MASS = 10 --重さ
Targets.MOMENT = 1200 -- モーメント(大きいほど回転しにくい)

Targets._state = 0
Targets._frame = nil
Targets._image = nil
Targets._type = nil
Targets._kind = nil
Targets.scalePer = 0.65 --元の値
Targets.circleSize = 56 --元の値

Targets.BOOM = 5
Targets.BOOM10 = 6

function Targets:ctor()
end

function Targets:create(type,kind)
	local Targets = Targets.new()
	Targets:init(type,kind)
	return Targets
end

function Targets:init(kind)
	self:enableNodeEvents()
	self._kind = kind
	self:setTag(123)
	self._image = cc.Sprite:create()
	WidgetLoader:setSpriteImage(self._image,GameConst.TARGETS_PNG[1].image)
	
	self._image:setAnchorPoint(cc.p(0.5,0.5))
	self:setAnchorPoint(cc.p(0.5,0.5))
	self:addChild(self._image)
	self:setScale(self.scalePer)
	if self._type == 1 then
		self.circleSize = self.circleSize * 1.5
	end
	--1、density（密度）2、restiution（弹性）3、friction（摩擦力）
	self._frame = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	self._frame:setDynamic(false) --重力干渉を受けるか
--	self._frame:setRotationEnable(true)
--	self._frame:setMoment(self.MOMENT) --モーメント(大きいほど回転しにくい)
--	self._frame:setMass(self.MASS) --重さ
	self._frame:setCategoryBitmask(1)
	self._frame:setCollisionBitmask(0x01)
	self._frame:setContactTestBitmask(2)
	self:setPhysicsBody(self._frame)
	self._frame:setTag(GameConst.PUZZLEOBJTAG.T_TARGET)
end

function Targets:reOrder(order)
	self:getParent():reorderChild(self,order)
end

function Targets:brokenBullet()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false and self:getType() ~= 1 then
		self:broken()
	end
end

function Targets:broken()
	local function actionEnd()
		self:getParent():reorderChild(self,3)
	end

	local action1 = cc.CallFunc:create(actionEnd)
	local action2 = cc.RemoveSelf:create()
	local action = cc.Spawn:create(action1,action2)
	self:runAction(action)
end

function Targets:makeShake()
	local act1 = cc.RotateBy:create(0.1, 36)
	local act2 = cc.MoveBy:create(0.1, cc.p(0,30))
	local seq  = cc.Spawn:create(act1,act2)
	local rep = cc.Repeat:create(seq:clone(), 10)
	self:runAction(seq)
end

function Targets:getPosition()
	local pos = {}
	pos.x = self:getPositionX()
	pos.y = self:getPositionY()
	return pos
end

function Targets:getState()
	return self._state
end

function Targets:getType()
	return self._type
end

function Targets:getKind()
	return self._kind
end

return Targets