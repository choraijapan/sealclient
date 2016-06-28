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
--Targets.scalePer = 0.9 --元の値
--Targets.circleSize = 48 --元の値
--Targets.scalePer = 1 --元の値
Targets.scalePer = 0.65 --元の値
Targets.circleSize = 56 --元の値

--Targets.scalePer = 0.65
--Targets.circleSize = 49
--Targets.scalePer = 0.6 --元の値
--Targets.circleSize = 48 --元の値

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
--	self:setTag(kind)
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
end

function Targets:reOrder(order)
	self:getParent():reorderChild(self,order)
end

function Targets:brokenBullet()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false and self:getType() ~= 1 then
		self:broken()
	end
end

--------------------------------------------------------------------------------
-- 連打ボールを爆発条件
--[[
Targets.touchBoomXCount = 0
function Targets:brokenBoomX()
	self.touchBoomXCount = self.touchBoomXCount + 1

	local action1 = cc.ScaleTo:create(0.3,1 + self.touchBoomXCount/20)
	self:runAction(cc.Sequence:create(action1))

	if self.touchBoomXCount == 10 then
		self:broken()
		self.touchBoomXCount = 0
		return true
	else
		return false
	end
end
]]--

function Targets:brokenBoomX()
	self:broken()
	return true
end



function Targets:broken()

	--	print("#######"..self:getTag())
	--	local particle = GameUtils:createParticle(GameConst.PARTICLE_BROKEN[self:getTag()],nil)
	--	local particle = cc.ParticleSystemQuad:create(GameConst.PARTICLE.Targets_BROKEN)
	--	particle:setPosition(cc.p(0,0))
	--	particle:setScale(0.2)
	--	particle:setAutoRemoveOnFinish(true)
	--	particle:setPosition(cc.p(self:getPositionX(),self:getPositionY()))

	--	self:stopAllActions()
	--	self:removeFromParent()

	local function actionEnd()
		--		self:getParent():addChild(particle,999)
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
function Targets:onEnter()
end

function Targets:addTargetsHint()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false and self:getName() ~= "touched" then
		self:setName("big")
		--		self._image:setScale(1.2)
		--		self._image:setColor(cc.c3b(123,123,123))
		--		self._image:setBlendFunc(gl.DST_COLOR,gl.SRC_COLOR)
		self:addGlowEffect(self._image,60,1,1)
	end
end

function Targets:addGlowEffect(sprite, opacity, scale,order)
	--	local pos = cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
	--	local glowSprite = cc.Sprite:create("battle/Targets_white.png")
	--	--	glowSprite:setColor(ccColor3B)
	--	glowSprite:setPosition(pos)
	--	glowSprite:setRotation(sprite:getRotation())
	--	glowSprite:setOpacity(opacity)
	--	--	glowSprite:setBlendFunc(gl.SRC_ALPHA,gl.ONE)
	--	glowSprite:setScale(scale)
	--	sprite:addChild(glowSprite, order)
	--	self._image:setColor(cc.c3b(1, 1,1))
	--	local tex = self:createStroke(self._image, 20, cc.c3b(111, 255,111),255)
	--	self:addChild(tex, self._image:getLocalZOrder() - 1)
	--	self:addChild(tex, 111)
	self:setGrayNode(self._image, true)

end

function Targets:addBallTouchEffect()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false then
		self:setName("big")
		cc.SimpleAudioEngine:getInstance():playEffect(GameConst.SOUND.PUZZLE_TOUCH)
		local action1 = cc.ScaleTo:create(0.1,1.5)
		local action2 = cc.ScaleTo:create(0.1,1.2)
		self._image:runAction(cc.Sequence:create(action1,action2))
		self:getParent():reorderChild(self,2)
		self:addGlowEffect(self._image,255,1.05,-1)
	end
end

function Targets:removeAllEffect()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false then
		self:setName("normal")
		self:removeTargetsTouchEffect()
	end
end

function Targets:removeSingleEffect()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false then
		self:setName("touched")
		self:removeTargetsTouchEffect()
	end
end

function Targets:removeTargetsTouchEffect()
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false then
		self._image:stopAllActions()
		self._image:setScale(1)
		self:setGrayNode(self._image, false)
		self._image:removeAllChildren()
		self:getParent():reorderChild(self,1)
	end
end

function Targets:addPuzzleNumber(num)
	if GameUtils:inTable(GameConst.BOOM.KINDS,self:getName()) == false then
		local puzzleNumber = ccui.TextAtlas:create()
		puzzleNumber:setProperty(num, GameConst.FONT.NUMBER, 17, 22, "0")
		puzzleNumber:setScale(1.5)
		puzzleNumber:setTag(GameConst.PUZZLEOBJTAG.T_Number)
		puzzleNumber:setPosition(cc.p(self:getPositionX(),self:getPositionY() + 100))
		self:getParent():addChild(puzzleNumber,1111)
		self:getParent():reorderChild(puzzleNumber,11111)
		GameUtils:addNumberEffect(puzzleNumber)
	end
end
function Targets:removePuzzleNumber()
	if self:getParent():getChildByTag(GameConst.PUZZLEOBJTAG.T_Number) ~= nil then
		self:getParent():removeChildByTag(GameConst.PUZZLEOBJTAG.T_Number)
	end
end

function Targets:addBoom(num)
	if num > 5 then
--		local boomId = math.random(1,4)
		local boomId = self._kind
		self:setName("TARGET")
		self:setTag(GameConst.BOOM[boomId].tag)
		WidgetLoader:setSpriteImage(self._image, GameConst.BOOM[boomId].image)

		local particle = GameUtils:createParticle(GameConst.PARTICLE.BOOM,nil)
		particle:setAutoRemoveOnFinish(true)
		particle:setPosition(cc.p(0,0))
		self:addChild(particle,1111)

		self:getParent():reorderChild(self,3)
--		self._image:setScale(1.4)
		self:setScale(1.2)
	end
end

function Targets:getType()
	return self._type
end

function Targets:getKind()
	return self._kind
end

function Targets:addBoomCard(num)
	print("##########=type "..self._type)
	if self._type == 1 then
--		local boomId = math.random(1,4)
		local boomId = 4 --TODO
		self:setName(GameConst.BOOM[boomId].name)
		self:setTag(GameConst.BOOM[boomId].tag)
		WidgetLoader:setSpriteImage(self._image,GameConst.BOOM[1].image)

		local particle = GameUtils:createParticle(GameConst.PARTICLE.BOOM,nil)
		particle:setAutoRemoveOnFinish(true)
		particle:setPosition(cc.p(0,0))
		self:addChild(particle,1111)

		self:getParent():reorderChild(self,3)
		self._image:setScale(1.2)
	end
end

function Targets:changeToBoomCard(cardId, num)
	self:setName("boom_9999")
	self:setTag(9999)
	WidgetLoader:setSpriteImage(self._image, GameConst.BOOM[1].image)

	local particle = GameUtils:createParticle(GameConst.PARTICLE.BOOM,nil)
	particle:setAutoRemoveOnFinish(true)
	particle:setPosition(cc.p(0,0))
	self:addChild(particle,1111)

	self:getParent():reorderChild(self,3)
	self._image:setScale(0.9)
end

--function Targets:createStroke(sprite, size, color, opacity)
--	local rt = cc.RenderTexture:create(
--		sprite:getTexture():getContentSize().width + size * 2,
--		sprite:getTexture():getContentSize().height + size * 2
--	)
--	local originalPos = cc.p(sprite:getPositionX(),sprite:getPositionY())
--	local originalColor = sprite:getColor()
--	local originalOpacity = sprite:getOpacity()
--	local originalVisibility = sprite:isVisible()
--	sprite:setColor(color)
--	sprite:setOpacity(opacity)
--	sprite:setVisible(true)
--	local originalBlend = sprite:getBlendFunc()
--	local bf = {gl.SRC_ALPHA, gl.ONE}
--	sprite:setBlendFunc(bf)
--	local bottomLeft = cc.p(
--		sprite:getTexture():getContentSize().width * sprite:getAnchorPoint().x + size,
--		sprite:getTexture():getContentSize().height * sprite:getAnchorPoint().y + size)
--	local positionOffset= cc.p(
--		-sprite:getTexture():getContentSize().width / 2,
--		-sprite:getTexture():getContentSize().height / 2)
--	local position = cc.pSub(originalPos, positionOffset)
--	rt:begin()
--	for i = 0, 360, 15 do
--		sprite:setPosition(
--			cc.p(bottomLeft.x + math.sin(math.rad(i))*size, bottomLeft.y + math.cos(math.rad(i))*size)
--		)
--		sprite:visit()
--	end
--	rt:endToLua()
--	sprite:setPosition(originalPos)
--	sprite:setColor(originalColor)
--	sprite:setBlendFunc(originalBlend)
--	sprite:setVisible(originalVisibility)
--	sprite:setOpacity(originalOpacity)
--	--	rt:setPosition(position)
--	return rt
--end
function Targets:setGrayNode(node, flag)
	local cache = cc.GLProgramCache:getInstance()
	local name, shader = nil, nil

	if flag then
		name = "MQ_ShaderPositionTextureGray"
		shader = cache:getGLProgram(name)

		if not shader then
			shader = cc.GLProgram:createWithByteArrays(
				-- vertex shader
				[[
            attribute vec4 a_position;
            attribute vec2 a_texCoord;
            attribute vec4 a_color;
 
            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;
 
            void main()
            {
                gl_Position = CC_PMatrix * a_position;
                v_fragmentColor = a_color;
                v_texCoord = a_texCoord;
            }
            ]],
				-- fragment shader
				[[
            varying vec2 v_texCoord;
            varying vec4 v_fragmentColor;
 
            void main()
            {
                vec4 v_orColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
                float gray = dot(v_orColor.rgb, vec3(1, 0.587, 0.114));
                gl_FragColor = vec4(v_orColor.r*1.1, v_orColor.g*1.9, v_orColor.b*1.9, v_orColor.a);
            }
            ]]
			)
			cache:addGLProgram(shader, name)
		end
	else
		name = "ShaderPositionTextureColor_noMVP"
		shader = cache:getGLProgram(name)
	end
	local errno = gl.getError()
	if errno ~= 0 then print("gl error:", errno) end

	local list = {}
	table.insert(list, node)
	for i, v in ipairs(list) do
		v:setGLProgram(shader)
		v:getGLProgram()
	end
end
-----------------------------------------------------------------------------
-- スキル関連
-----------------------------------------------------------------------------



return Targets