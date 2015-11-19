local PuzzleResultLayer = require("app.layer.puzzle.PuzzleResultLayer")
local PuzzleCardNode = require("app.parts.puzzle.PuzzleCardNode").new()
local Ball = require("app.parts.puzzle.Ball")
local DrawLine = require("app.parts.puzzle.DrawLine")
local BossSprite = require("app.parts.puzzle.BossSprite")

PuzzleLayer = class("PuzzleLayer", cc.Layer)
PuzzleLayer.stateGamePlaying = 0
PuzzleLayer.stateGameOver = 1
PuzzleLayer.resultWin = 1
PuzzleLayer.resultLost = 0
PuzzleLayer.gameState = nil
PuzzleLayer.gameTime = nil                --

PuzzleLayer.boss = nil                    -- boss

PuzzleLayer.wall = nil
PuzzleLayer.puzzleCardNode = nil
PuzzleLayer.cards = {
	card1 = nil,
	card2 = nil,
	card3 = nil,
	card4 = nil,
	card5 = nil,
	card6 = nil
}

local TYPES = 5

local offside = nil

local MAX_BULLET = 45
local _time = 0
local _tag = nil
local _bulletVicts = nil
local _fingerPosition = nil
local _bullets = {}
local _bullets2 = {}
local tempBullets = {}
local touchIdx = 1
local touchIdx2 = 1
local curTouchBall = nil
local lastTouchBall = nil

local startBall = nil
local curBall = nil

local ferver = 0
local isFerverTime = false
local ferverBar = nil
local ferverEffect = nil

--各Layerの表示順番
local ZOrder = {
	Z_BallBg = 0,
	Z_Ball = 1,
	Z_Line = 2,
	--	Z_BossBg = 10,
	Z_BossBg = 0,
	Z_Boss = 11,
	Z_Deck = 20,
	Z_FerverBar = 30,
	Z_Dialog = 999,
}
--------------------------------------------------------------------------------
-- ctor
function PuzzleLayer:ctor()
	offside = AppConst.WIN_SIZE.height/2 + 25
end
--------------------------------------------------------------------------------
-- create
function PuzzleLayer:create()
	local layer = PuzzleLayer.new()
	layer:init()
	return layer
end
--------------------------------------------------------------------------------
-- create
local function isTableContains(tb,obj)
	for _,v in pairs(tb) do
		if v == obj then
			return true
		end
	end
	return false
end
--------------------------------------------------------------------------------
-- init
function PuzzleLayer:init()
	--    self:loadingMusic() -- 背景音乐
	self:addBG()        -- 初始化背景
	--    self:moveBG()       -- 背景移动
	--    self:addBtn()       -- 游戏暂停按钮

	self:initGameState()                -- 初始化游戏数据状态
	self:addCards()             -- 初期化（自分）

	self:addBossSprite()
	self:addPuzzle()

	self:addSchedule()  -- 更新
	self:addTouch()     -- 触摸

	self:addFerverBar()

	_bulletVicts = {}
	_fingerPosition = nil
end
--------------------------------------------------------------------------------
-- addPuzzle
function PuzzleLayer:addPuzzle()
	local vec =
		{
			cc.p(AppConst.VISIBLE_SIZE.width-1,AppConst.VISIBLE_SIZE.height-1),
			cc.p(1, AppConst.VISIBLE_SIZE.height-1),
			cc.p(1, 100),
			cc.p(AppConst.VISIBLE_SIZE.width/3, 50),
			cc.p(AppConst.VISIBLE_SIZE.width*2/3, 50),
			cc.p(AppConst.VISIBLE_SIZE.width-1, 100),
			cc.p(AppConst.VISIBLE_SIZE.width-1, AppConst.VISIBLE_SIZE.height-1)
		}

	self.wall = cc.Node:create()
	local edge = cc.PhysicsBody:createEdgeChain(vec,cc.PhysicsMaterial(0,0,0.8))
	self.wall:setPhysicsBody(edge)
	self.wall:setPosition(cc.p(0,30))
	self:addChild(self.wall)
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:addBalls()
	local typeId = math.random(1,TYPES)
	local ball = Ball:create(typeId)

	local randomX = math.random(AppConst.WIN_SIZE.width/2 - 20,AppConst.WIN_SIZE.width/2 + 20)
	--	local randomY = math.random(AppConst.WIN_SIZE.height*2/3 ,AppConst.WIN_SIZE.height*3/4)
	local randomY = AppConst.WIN_SIZE.height*1/2 + 60
	ball:setPosition(randomX, randomY)
	ball:setRotation(math.random(1,360))
	local pBall = ball:getPhysicsBody()
	pBall:setTag(GameConst.PUZZLEOBJTAG.T_Bullet)
	self:addChild(ball,ZOrder.Z_Ball,typeId+2)
end
--------------------------------------------------------------------------------
--播放音乐
function PuzzleLayer:loadingMusic()
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:addFooter()

end
--------------------------------------------------------------------------------
--
function PuzzleLayer:addBG()
	local puzzleLayer = WidgetLoader:loadCsbFile("scene/puzzle/PuzzleScene.csb")
	self.bg1 = WidgetObj:searchWidgetByName(puzzleLayer,"Bg1","cc.Sprite")
	self.bg2 = WidgetObj:searchWidgetByName(puzzleLayer,"Bg2","cc.Sprite")
	self:addChild(puzzleLayer,ZOrder.Z_BossBg)
	self:moveBG()
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:moveBG()
	local height = self.bg1:getContentSize().height
	local function updateBG()
		self.bg1:setPositionY(self.bg1:getPositionY() - 1)
		self.bg2:setPositionY(self.bg1:getPositionY() + height)
		if self.bg1:getPositionY() <= -height + 180 then -- TODO 素材是960， 屏幕不一定大小
			self.bg1, self.bg2 = self.bg2, self.bg1
			self.bg2:setPositionY(AppConst.VISIBLE_SIZE.height)
		end
	end
	schedule(self, updateBG, 0)
end

--------------------------------------------------------------------------------
--
function PuzzleLayer:addBtn()
	local function PauseGame()
		self:PauseGame()
	end
	local pause = cc.MenuItemImage:create("battle/pause.png", "battle/pause.png")
	pause:setAnchorPoint(cc.p(1, 0))
	pause:setPosition(cc.p(AppConst.VISIBLE_SIZE.width, 0))
	pause:registerScriptTapHandler(PauseGame)

	local menu = cc.Menu:create(pause)
	menu:setPosition(cc.p(0, 0))
	--    self:addChild(menu, 1, 10)
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:addSchedule()

	local function update(dt)
		self:update(dt)
	end
	self:scheduleUpdateWithPriorityLua(update,0)

	-- 更新UI
	local function updateGame()
		self:updateGame()
	end
	schedule(self, updateGame, 0)

	-- 更新时间
	local function updateTime()
		self:updateTime()
	end
	schedule(self, updateTime, 1)
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:addTouch()
	local function onTouchBegan(touch, event)
		print("################# touch began")
		touchIdx = 1
		touchIdx2 = 1
		local idx = 1
		local location = touch:getLocation()
		local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
		local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()

		if GameUtils.TouchFlag then
			return
		end

		for _, obj in ipairs(arr) do
			if bit.band(obj:getBody():getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
				if _tag ~= nil and _tag ~= obj:getBody():getNode():getTag() then

					return false
				else
					if  obj:getBody():getNode():getName() == "boom" then
						print("#################### BOOM Touched")
						local boomAround = self:getAroundBalls(all,obj:getBody():getNode())
						for _, obj2 in ipairs(boomAround) do
							obj2:getNode():brokenBullet()

							local data = {
								action = "atkBoss",
								type = obj2:getNode():getType(),
								count = 1,
								startPos = obj2:getNode():getPosition()
							}
							self.puzzleCardNode:ballToCard(data)

						end
						self:setFerverPt(#boomAround)
						obj:getBody():getNode():broken()
						startBall = nil
						_bullets = {}
						_bullets2 = {}
						self.curTouchBall = nil
						break;
					else
						GameUtils.TouchFlag = true
						startBall = obj:getBody():getNode()
						_tag = obj:getBody():getNode():getTag()
						self.curTouchBall = obj:getBody():getNode()
						if next(_bullets) == nil then
							_bullets[touchIdx] = obj:getBody():getNode()
						end
						self.curTouchBall:addPuzzleNumber(1)
						self.curTouchBall:addBallTouchEffect()
					end
					break;
				end
			end
		end
		if startBall ~= nil then
			for _, obj in ipairs(all) do
				if startBall:getTag() == obj:getNode():getTag() then
					_bullets2[touchIdx2] = obj:getNode()
					touchIdx2 = touchIdx2 + 1
				end
			end
		end

		return true
	end
	local function onTouchMoved(touch, event)
		GameUtils.TouchFlag = true
		self.curTouchBall = nil
		local location = touch:getLocation()
		local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
		for _, obj in ipairs(arr) do
			if bit.band(obj:getBody():getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
				if obj:getBody():getNode():getTag() == _tag then
					self.curTouchBall = obj:getBody():getNode()
					break
				else
					self.curTouchBall = nil
				end
			end
		end
		if self.curTouchBall ~= nil and self.curTouchBall:getState() == Ball.MOVING then
			if next(_bullets) == nil then
				_bullets[touchIdx] = self.curTouchBall
			elseif isTableContains(_bullets,self.curTouchBall) == false then
				local p1 = _bullets[#_bullets]:getPosition()
				local p2 = self.curTouchBall:getPosition()
				local distance = cc.pGetDistance(p1,p2)
				if distance < 2 * math.sqrt(3) * self.curTouchBall.circleSize  then
					DebugLog:debug("####### touchIdx"..touchIdx)
					touchIdx = touchIdx + 1
					_bullets[touchIdx] = self.curTouchBall
					if touchIdx > 1 then
						_bullets[touchIdx-1]:removeSingleEffect()
						_bullets[touchIdx-1]:removePuzzleNumber()
					end
					if next(_bullets) ~= nil then
						_bullets[touchIdx]:addBallTouchEffect()
						_bullets[touchIdx]:addPuzzleNumber(touchIdx)
					end
				end
			else
				local obj1 = _bullets[#_bullets]
				local obj2 = _bullets[#_bullets-1]
				if self.curTouchBall == obj2 then
					touchIdx = touchIdx - 1
					obj1:removeAllEffect()
					obj2:addBallTouchEffect()
					table.remove(_bullets,#_bullets)
				end
			end
		else
		end

		if #_bullets < 2 then
			_fingerPosition = location
		else
			_fingerPosition = nil
		end
	end


	local function onTouchEnded(touch, event)
		GameUtils.TouchFlag = false
		startBall = nil
		curBall = nil
		_tag = nil
		local location = touch:getLocation()
		local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
		for _, obj in ipairs(arr) do
			if obj:getBody():getTag() == GameConst.PUZZLEOBJTAG.T_Bullet then
				obj:getBody():getNode():removeAllEffect()
			end
		end

		if self.curTouchBall ~= nil then
			self.curTouchBall:removeAllEffect()
		end

		for key, var in ipairs(_bullets) do
			var:removeAllEffect()
		end
		if next(_bullets) ~= nil then
			local type = 1
			local lastPos = nil
			for key, var in ipairs(_bullets) do
				if var:getState() == Ball.MOVING then
					if  #_bullets > 2 then
						if  #_bullets == key then
							_bullets[#_bullets]:addBoom(#_bullets)
						end

						type = var:getType()
						lastPos = var:getPosition()

						var:removeAllEffect()
						var:brokenBullet()
					end
				end
			end
			if  #_bullets > 2 then
				local data = {
					action = "atkBoss",
					type = type,
					count = #_bullets,
					startPos = lastPos,
					atkBossEffect = "effect/card_atk_001.plist" --TODO parameter
				}
				self.puzzleCardNode:ballToCard(data)

				self:setFerverPt(#_bullets)
			end
		else

		end

		local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
		for _, obj in ipairs(all) do
			if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
				obj:getNode():removeAllEffect()
				obj:getNode():removePuzzleNumber()
			end
		end

		_bullets = {}
		_bullets2 = {}
	end
	local dispatcher = self:getEventDispatcher()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


--------------------------------------------------------------------------------
-- add energy
function PuzzleLayer:setFerverPt(count)
	local point = count * 1.5

	if isFerverTime == false then
		ferver = ferver + point
		if ferver > 100 then
			isFerverTime = true

			ferverEffect = cc.ParticleSystemQuad:create("effect/fireWall.plist")
			ferverEffect:setAutoRemoveOnFinish(true)
			ferverEffect:setPosition(cc.p(0,0))
			ferverEffect:setScale(4)
			ferverEffect:setAnchorPoint(cc.p(0, 0))
			ferverEffect:setDuration(15)
			local to = cc.ProgressTo:create(15, 0)
			ferverBar:runAction(cc.RepeatForever:create(to))
			self:addChild(ferverEffect,0)

		else
			local to = cc.ProgressTo:create(0.5, ferver)
			ferverBar:runAction(cc.RepeatForever:create(to))
		end
	end
end

------------------------------------
--   addFerverBar
function PuzzleLayer:addFerverBar()
	ferverBar = cc.ProgressTimer:create(cc.Sprite:create("images/Common/bar_ferver.png"))
	ferverBar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	ferverBar:setAnchorPoint(cc.p(0,0))
	ferverBar:setMidpoint(cc.p(0, 0))
	ferverBar:setBarChangeRate(cc.p(1, 0))
	ferverBar:setPosition(cc.p(124, 23.5))
	ferverBar:setScale(2)
	self:addChild(ferverBar,ZOrder.Z_FerverBar)
end
--------------------------------------------------------------------------------
--
-- 初始化游戏数据状态
function PuzzleLayer:initGameState()
	-- 游戏状态
	self.gameState = self.stateGamePlaying
	-- 游戏时间
	self.gameTime = 0
end
--------------------------------------------------------------------------------
--
-- cardsを追加する
function PuzzleLayer:addCards()
	self.puzzleCardNode = PuzzleCardNode:create()
	self:addChild(self.puzzleCardNode, ZOrder.Z_Deck)
end
--------------------------------------------------------------------------------
--
-- BOSSをinitする
function PuzzleLayer:addBossSprite()
	self.boss = BossSprite:create()
	self:addChild(self.boss,ZOrder.Z_Boss)
end
--------------------------------------------------------------------------------
--
-- 更新时间
function PuzzleLayer:updateTime()
	if self.gameState == self.stateGamePlaying then
		self.gameTime = self.gameTime + 1
	end
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:update(dt)
	_time = _time + 1
	local all = {}
	if cc.Director:getInstance():getRunningScene():getPhysicsWorld() ~= nil then
		all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	end

	if MAX_BULLET >= #all then
		self:addBalls()
	end

	self:DrawLineRemove()

	if GameUtils.TouchFlag == false then
		curBall = nil
		_tag = nil
		_bullets = {}
		_bullets2 = {}
	else
		if next(_bullets) ~= nil then
			for key, var in ipairs(_bullets) do
				table.insert(_bulletVicts, var:getPosition())
			end
		end
		local node = DrawLine:create(_bulletVicts)
		self:addChild(node,ZOrder.Z_Line,GameConst.PUZZLEOBJTAG.T_Line)
		_bulletVicts = {}
	end

	if isFerverTime then
		if ferverBar:getPercentage() == 0 then
			isFerverTime = false
			ferver = 0
		end
	end
	self:checkPuzzleHint()
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:getAroundBalls(all,curBall)
	local aroundBalls = {}
	local index = 1
	if curBall ~= nil and all ~= nil then
		local p1 = curBall:getPosition()
		for _, obj in ipairs(all) do
			if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0  then
				local p2 = obj:getPosition()
				local distance = cc.pGetDistance(p1,p2)
				if isTableContains(all,aroundBalls[index]) == false then
					if distance < 2 * math.sqrt(3) * curBall.circleSize  then
						if obj ~= curBall then
							aroundBalls[index] = obj
							index = index + 1
						end
					end
				end
			end
		end
	end
	return aroundBalls
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:checkPuzzleHint()
	local function setBallsHintOn(balls,curBall)
		if curBall:getName() ~= "big" then
			local aroundBalls = {}
			local index = 1
			if curBall ~= nil and balls ~= nil then
				local p1 = curBall:getPosition()
				for _, obj in ipairs(balls) do
					local p2 = obj:getPosition()
					local distance = cc.pGetDistance(p1,p2)
					if distance < 2 * math.sqrt(3) * curBall.circleSize  then
						if obj:getName() == "big" then
							curBall:addBallHint()
						end
					end
				end
			end
		end
	end

	if next(_bullets2) ~= nil then
		for _, obj in ipairs(_bullets2) do
			setBallsHintOn(_bullets2,obj)
		end
	end
end
--------------------------------------------------------------------------------
-- 更新游戏
function PuzzleLayer:updateGame()
	if self.gameState == self.stateGamePlaying then
		self:checkGameOver()
		self:updateUI()
	end
end
--------------------------------------------------------------------------------
-- 游戏结束 or 使用道具
function PuzzleLayer:checkGameOver()
	if self.boss == nil then
		return
	end
	--You Win
	if  self.boss:isActive() == false then
		self.gameState = self.stateGameOver
		self:gameResult(true)
	end
	--You Lost
	if self.puzzleCardNode:isAllDead() then
		self:gameResult(false)
	end
end
--------------------------------------------------------------------------------
-- 刷新界面
function PuzzleLayer:updateUI()
end
--------------------------------------------------------------------------------
-- 游戏暂停
function PuzzleLayer:PauseGame()
	cc.Director:getInstance():pause()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
	cc.SimpleAudioEngine:getInstance():pauseAllEffects()
	--  local pauseLayer = PauseLayer:create() -- TODO add pause layer
	--  self:addChild(pauseLayer, 9999)
end

--------------------------------------------------------------------------------
-- 游戏继续
function PuzzleLayer:resumeGame()
	cc.Director:getInstance():resume()
	cc.SimpleAudioEngine:getInstance():resumeMusic()
	cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end
--------------------------------------------------------------------------------
-- 游戏结束
function PuzzleLayer:gameResult(isWin)
	local scene = PuzzleResultLayer:createScene(isWin)
	local tt = cc.TransitionCrossFade:create(1.0, scene)
	cc.Director:getInstance():replaceScene(tt)
end
--------------------------------------------------------------------------------
--
function PuzzleLayer:DrawLineRemove()
	local nodes = self:getChildren()
	for key, var in ipairs(nodes) do
		if var:getTag() == GameConst.PUZZLEOBJTAG.T_Line then
			local line = var
			line:remove()
			break
		end
	end
end
