local Ball = class("Ball", cc.Sprite)

Ball.DENSITY = 10
Ball.RESTIUTION = 0
Ball.FRICTION = 0.4
Ball.MASS = 10

Ball._state = 0
Ball._frame = nil
Ball._image = nil
Ball.scalePer = 0.9 --元の値
Ball.circleSize = 48 --元の値
--Ball.scalePer = 0.65
--Ball.circleSize = 49
--Ball.scalePer = 0.6 --元の値
--Ball.circleSize = 48 --元の値

Ball.vertexes = {
	[1] = {cc.p(41*Ball.scalePer,22*Ball.scalePer),cc.p(59*Ball.scalePer,-20*Ball.scalePer),cc.p(45*Ball.scalePer,-44*Ball.scalePer),cc.p(-41*Ball.scalePer,-51*Ball.scalePer),cc.p(-59*Ball.scalePer,-26*Ball.scalePer),cc.p(-43*Ball.scalePer,23*Ball.scalePer),cc.p(-27*Ball.scalePer,50*Ball.scalePer),cc.p(-1*Ball.scalePer,63*Ball.scalePer)},
	[2] = { cc.p(-60*Ball.scalePer,3*Ball.scalePer),
		cc.p(-31*Ball.scalePer,47*Ball.scalePer),
		cc.p(-3*Ball.scalePer,63*Ball.scalePer),
		cc.p(40*Ball.scalePer,47*Ball.scalePer),
		cc.p(64*Ball.scalePer,7*Ball.scalePer),
		cc.p(53*Ball.scalePer,-42*Ball.scalePer),
		cc.p(15*Ball.scalePer,-64*Ball.scalePer),
		cc.p(-36*Ball.scalePer,-58*Ball.scalePer)},
	[3] =   {cc.p( -15*Ball.scalePer, 61*Ball.scalePer ),
		cc.p( 32 *Ball.scalePer, 52*Ball.scalePer ),
		cc.p( 59 *Ball.scalePer, 10*Ball.scalePer ),
		cc.p( 50 *Ball.scalePer,-34*Ball.scalePer ),
		cc.p( 16 *Ball.scalePer,-55*Ball.scalePer ),
		cc.p( -9 *Ball.scalePer,-63*Ball.scalePer ),
		cc.p( -42*Ball.scalePer,-46*Ball.scalePer ),
		cc.p( -57*Ball.scalePer, 27*Ball.scalePer )},
	[4] = { cc.p(-60*Ball.scalePer,3*Ball.scalePer),
		cc.p(-31*Ball.scalePer,47*Ball.scalePer),
		cc.p(-3*Ball.scalePer,63*Ball.scalePer),
		cc.p(40*Ball.scalePer,47*Ball.scalePer),
		cc.p(64*Ball.scalePer,7*Ball.scalePer),
		cc.p(53*Ball.scalePer,-42*Ball.scalePer),
		cc.p(15*Ball.scalePer,-64*Ball.scalePer),
		cc.p(-36*Ball.scalePer,-58*Ball.scalePer)},
	[5] =  {cc.p( -15*Ball.scalePer, 61*Ball.scalePer ),
		cc.p( 32 *Ball.scalePer, 52*Ball.scalePer ),
		cc.p( 59 *Ball.scalePer, 10*Ball.scalePer ),
		cc.p( 50 *Ball.scalePer,-34*Ball.scalePer ),
		cc.p( 16 *Ball.scalePer,-55*Ball.scalePer ),
		cc.p( -9 *Ball.scalePer,-63*Ball.scalePer ),
		cc.p( -42*Ball.scalePer,-46*Ball.scalePer ),
		cc.p( -57*Ball.scalePer, 27*Ball.scalePer )}
}

Ball.BOOM = 5

function Ball:ctor()
end

function Ball:create(type)
	local ball = Ball.new()
	ball:init(type)
	return ball
end

function Ball:init(type)
	self:enableNodeEvents()

	self:setTag(type)

	self._image = cc.Sprite:create()
	WidgetLoader:setSpriteImage(self._image, GameConst.BALL_PNG[type])
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
	self._frame = cc.PhysicsBody:createCircle((self.circleSize), cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	--	local vertexes = {cc.p(44,-3),cc.p(25,-40),cc.p(-22,-41),cc.p(-42,-3),cc.p(-22,36),cc.p(25,37)}
	--	local vertexes = {cc.p(27,39),cc.p(47,-1),cc.p(29,-40),cc.p(-25,-40),cc.p(-45,-2),cc.p(-25,40)} --６角形
	--	local vertexes = {cc.p(-41, -43),cc.p(3, 48),cc.p(49, -44)} --5角形
	--	local vertexes = Ball.vertexes[type]
	--	self._frame = cc.PhysicsBody:createPolygon(vertexes, cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	self._frame:setDynamic(true) --重力干渉を受けるか
	self._frame:setRotationEnable(true)
	self._frame:setMoment(800) --モーメント(大きいほど回転しにくい)
	self._frame:setMass(self.MASS) --重さ
	self._frame:setCategoryBitmask(1)
	self._frame:setCollisionBitmask(0x01)
	self._frame:setContactTestBitmask(2)
	self:setPhysicsBody(self._frame)
end

function Ball:reOrder(order)
	self:getParent():reorderChild(self,order)
end

function Ball:brokenBullet()
	if self:getName() ~= "boom" then
		self:broken()
	end
end
function Ball:broken()

	print("#######"..self:getTag())
	local particle = GameUtils:createParticle(GameConst.PARTICLE_BROKEN[self:getTag()],nil)
--	local particle = cc.ParticleSystemQuad:create(GameConst.PARTICLE.BALL_BROKEN)
	particle:setPosition(cc.p(0,0))
--	particle:setScale(0.2)
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

function Ball:makeShake()
	local act1 = cc.RotateBy:create(0.1, 36)
	local act2 = cc.MoveBy:create(0.1, cc.p(0,30))
	local seq  = cc.Spawn:create(act1,act2)
	local rep = cc.Repeat:create(seq:clone(), 10)
	self:runAction(seq)
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
	if self:getName() ~= "boom" and self:getName() ~= "touched" then
		self:setName("big")
		--		self._image:setScale(1.2)
		--		self._image:setColor(cc.c3b(123,123,123))
		--		self._image:setBlendFunc(gl.DST_COLOR,gl.SRC_COLOR)
		self:addGlowEffect(self._image,60,1,1)
	end
end

function Ball:addGlowEffect(sprite, opacity, scale,order)
	--	local pos = cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
	--	local glowSprite = cc.Sprite:create("battle/ball_white.png")
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

function Ball:addBallTouchEffect()
	if self:getName() ~= "boom" then
		self:setName("big")
		cc.SimpleAudioEngine:getInstance():playEffect(GameConst.SOUND.PUZZLE_TOUCH)
		local action1 = cc.ScaleTo:create(0.1,1.5)
		local action2 = cc.ScaleTo:create(0.1,1.2)
		self._image:runAction(cc.Sequence:create(action1,action2))
		self:getParent():reorderChild(self,2)
		self:addGlowEffect(self._image,255,1.05,-1)
	end
end

function Ball:removeAllEffect()
	if self:getName() ~= "boom" then
		self:setName("normal")
		self:removeBallTouchEffect()
	end
end

function Ball:removeSingleEffect()
	if self:getName() ~= "boom" then
		self:setName("touched")
		self:removeBallTouchEffect()
	end
end

function Ball:removeBallTouchEffect()
	if self:getName() ~= "boom" then
		self._image:stopAllActions()
		self._image:setScale(1)
		self:setGrayNode(self._image, false)
		self._image:removeAllChildren()
		self:getParent():reorderChild(self,1)
	end
end

function Ball:addPuzzleNumber(num)
	if self:getName() ~= "boom" then
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
function Ball:removePuzzleNumber()
	if self:getParent():getChildByTag(GameConst.PUZZLEOBJTAG.T_Number) ~= nil then
		self:getParent():removeChildByTag(GameConst.PUZZLEOBJTAG.T_Number)
	end
end

function Ball:addBoom(num)
	if num > 6 then
		self:setName("boom")
		self:setTag(Ball.BOOM)
		--		self._image:setVisible(false)
		--		local particle = cc.ParticleSystemQuad:create("images/effect/particle_boom.plist")

		local particle = GameUtils:createParticle(GameConst.PARTICLE.BOOM,nil)

		particle:setAutoRemoveOnFinish(true)
		particle:setPosition(cc.p(0,0))
		particle:setScale(0.9)
		WidgetLoader:setSpriteImage(self._image, GameConst.BALL_PNG["BOOM"])
		self:addChild(particle,1111)
		self:getParent():reorderChild(self,3)
	end
end

--function Ball:createStroke(sprite, size, color, opacity)
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
function Ball:setGrayNode(node, flag)
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



return Ball