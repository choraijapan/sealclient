local PuzzleResultLayer = require("app.layer.puzzle.PuzzleResultLayer")
--local ResultScene = require("app.scene.puzzle.ResultScene")
--local PuzzleCardNode = require("app.parts.puzzle.PuzzleCardNode").new()

local PuzzleUILayer = require("src/app/layer/puzzle/PuzzleUILayer")
local Ball = require("app.parts.puzzle.Ball")
local Targets = require("app/parts/puzzle/Targets")
local DrawLine = require("app.parts.puzzle.DrawLine")
local BossSprite = require("app.parts.puzzle.BossSprite")
local PuzzleManager = require("app.layer.puzzle.PuzzleManager")

local PuzzleLayer = class("PuzzleLayer", cc.Layer)
PuzzleLayer.stateGamePlaying = 0
PuzzleLayer.stateGameOver = 1
PuzzleLayer.resultWin = 1
PuzzleLayer.resultLost = 0
PuzzleLayer.gameState = nil
PuzzleLayer.gameTime = nil                --

PuzzleLayer.boss = nil                    -- boss

PuzzleLayer.combolTimer = 4
PuzzleLayer.combolNumber = 0
PuzzleLayer.UI_Combol = nil

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

local offside = nil

local MAX_BULLET = 45
local _time = 0
local _curBallTag = nil
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
local ferverEffect = nil
local touchPoint = nil

local m_Score = 0

local debug = true
--------------------------------------------------------------------------------
-- UI
local CSB_PuzzleScene = "scene/puzzle/PuzzleScene.csb"
local CCUI_PuzzleScene = nil
local CCUI_PuzzleStatus = nil
local CCUI_ButtonMenu = nil
local CCUI_Bg1 = nil
local CCUI_Bg2 = nil
local CCUI_bottom_1 = nil
local CCUI_bottom_2 = nil
local CCUI_bottom_3 = nil

local Node_Score = nil
local Label_Score = nil
--------------------------------------------------------------------------------
-- ctor
function PuzzleLayer:ctor()
	offside = AppConst.WIN_SIZE.height/2 + 25
end
--------------------------------------------------------------------------------
-- create
function PuzzleLayer:create(questId)
	self:setName("PUZZLE_LAYER")
	self:init(questId)
	return self
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
function PuzzleLayer:init(questId)
	CCUI_PuzzleScene = WidgetLoader:loadCsbFile(CSB_PuzzleScene)
	self:addChild(CCUI_PuzzleScene,GameConst.ZOrder.Z_BossBg)
    self:onAssignCCSMemberVariable()
    
	--self:loadingMusic() -- 背景音乐
--	self:addTargets()
	self:addQuest(questId)
	
	self:addScore()
	self:initGameState()                -- 初始化游戏数据状态
	
	self:addPuzzle()
	self:addCombol()
	self:addSchedule()  -- 更新
	self:addTouch()     -- 触摸

	_bulletVicts = {}
	_fingerPosition = nil

	------------------------------------------------------------------------
	-- Interface , Card Skill発動する時呼ぶ
	------------------------------------------------------------------------
	local function skillDrawed(event)
		local data = event._data
		if data.type == 2 then
			PuzzleManager:changeBall(data.from,data.to)
		end
	end
	EventDispatchManager:createEventDispatcher(self,"CARD_SKILL_DRAWED",skillDrawed)
end

-------------------------------------------------------------------------------
-- onAssignCCSMemberVariable
-- Cocos Studio画面上の各コンポーネント
function PuzzleLayer:onAssignCCSMemberVariable()
	self:addUILayer()
	Node_Score = WidgetObj:searchWidgetByName(self.PuzzleUILayer,"Node_Score",WidgetConst.OBJ_TYPE.Node)
end
--------------------------------------------------------------------------------
-- addPuzzle
function PuzzleLayer:addPuzzle()
    local paddingBottom = 50
	local vec =
		{
			cc.p(AppConst.DESIGN_SIZE.width-1,AppConst.DESIGN_SIZE.height+100),
			cc.p(1, AppConst.DESIGN_SIZE.height+100),
			cc.p(1, 150 + paddingBottom),
			cc.p(AppConst.DESIGN_SIZE.width/3, 0 + paddingBottom),
			cc.p(AppConst.DESIGN_SIZE.width*2/3, 0 + paddingBottom),
			cc.p(AppConst.DESIGN_SIZE.width-1, 150 + paddingBottom),
			cc.p(AppConst.DESIGN_SIZE.width-1, AppConst.DESIGN_SIZE.height+100)
		}

	self.wall = cc.Node:create()
	local edge = cc.PhysicsBody:createEdgeChain(vec,cc.PhysicsMaterial(0,0,0.8),5)
	self.wall:setPhysicsBody(edge)
	self.wall:setPosition(cc.p(0,20))
	self:addChild(self.wall)

	touchPoint = cc.Node:create()
	local tpFrame = cc.PhysicsBody:createCircle(20, cc.PhysicsMaterial(self.DENSITY, self.RESTIUTION, self.FRICTION))
	tpFrame:setDynamic(false) --重力干渉を受けるか
	touchPoint:setTag(555)
	tpFrame:setCategoryBitmask(2)
	tpFrame:setCollisionBitmask(0x01)
	tpFrame:setContactTestBitmask(1)
	touchPoint:setPhysicsBody(tpFrame)

	self:addChild(touchPoint)
end

function PuzzleLayer:addQuest(questId)
    print("###########questId"..questId)
end

function PuzzleLayer:addTargets()
	local targets = nil
	local targets = Targets:create(i)
	targets:setRotation(math.random(1,360))
	local pBall = targets:getPhysicsBody()
	targets:setPosition(350, 460)
	self:addChild(targets,GameConst.ZOrder.Z_Ball)
		
	local targets = nil
	local targets = Targets:create(i)
	targets:setRotation(math.random(1,360))
	local pBall = targets:getPhysicsBody()
	targets:setPosition(470, 460)
	self:addChild(targets,GameConst.ZOrder.Z_Ball)
	
	local targets = nil
	local targets = Targets:create(i)
	targets:setRotation(math.random(1,360))
	local pBall = targets:getPhysicsBody()
	targets:setPosition(350, 350)
	self:addChild(targets,GameConst.ZOrder.Z_Ball)
	
	local targets = nil
	local targets = Targets:create(i)
	targets:setRotation(math.random(1,360))
	local pBall = targets:getPhysicsBody()
	targets:setPosition(470, 350)
	self:addChild(targets,GameConst.ZOrder.Z_Ball)
end

--------------------------------------------------------------------------------
--
function PuzzleLayer:addBalls()
	local all = {}
	if cc.Director:getInstance():getRunningScene():getPhysicsWorld() ~= nil then
		all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	end

	if MAX_BULLET <= #all then
		return
	end

	local kind = math.random(1,GameUtils:tablelength(GameConst.ATTRIBUTE))
	
	local ball = nil
--	if #all == 40 then
--		ball = Ball:create(GameConst.BALLTYPE.TARGET,222222)  -- 4はcard idを入れる、Ballの方で、Card　Idからkindを取得できるので！
--	else
		ball = Ball:create(GameConst.BALLTYPE.BLOCK,kind)
--	end
    

	local randomX = math.random(AppConst.WIN_SIZE.width/2 - 20,AppConst.WIN_SIZE.width/2 + 20)
--	local randomY = math.random(AppConst.WIN_SIZE.height*2/3 ,AppConst.WIN_SIZE.height*3/4)
	local randomY = AppConst.WIN_SIZE.height
	--  local randomX = math.random(AppConst.WIN_SIZE.width/2 - 20,AppConst.WIN_SIZE.width/2 + 20)
	--  local randomY = math.random(AppConst.WIN_SIZE.height + 60 ,AppConst.WIN_SIZE.height + 100)

	ball:setPosition(randomX, randomY)
	ball:setRotation(math.random(1,360))
	local pBall = ball:getPhysicsBody()
	pBall:setTag(GameConst.PUZZLEOBJTAG.T_Bullet)
	self:addChild(ball,GameConst.ZOrder.Z_Ball)
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
function PuzzleLayer:addSchedule()

	local function update(dt)
		self:update(dt)
	end
	self:scheduleUpdateWithPriorityLua(update,0)

	-- コンボの更新
	local function updateDt(dt)
		self.combolTimer = self.combolTimer - 1
		if self.combolTimer <= 0 then
			self.combolNumber = 0
			self.UI_Combol:setOpacity(0)
		end
	end
	schedule(self, updateDt, 1)

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
		touchIdx = 1
		touchIdx2 = 1
		local idx = 1
		local location = touch:getLocation()
		local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShape(location)
		local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()

		if GameUtils.IsGameActive then
			return
		end

		touchPoint:setPosition(cc.p(location.x,location.y))
		if arr ~= nil and arr:getBody():getTag() == GameConst.PUZZLEOBJTAG.T_Bullet then
			if _curBallTag ~= nil and _curBallTag ~= arr:getBody():getNode():getTag() then
				return false
			else

				if  GameUtils:inTable({"boom7","boom8"},arr:getBody():getNode():getName()) then
					local boomAround = self:getAroundBalls(all,arr:getBody():getNode())
					cc.SimpleAudioEngine:getInstance():playEffect("sound/se35.m4a")

					self:updateCombol()
					self:updateScore(#boomAround)
					if arr:getBody():getNode():brokenBoomX() and arr:getBody():getNode():getType() ~= 1 then
						for _, obj2 in ipairs(boomAround) do
							obj2:getNode():brokenBullet()
							local data = {
								action = "atkBoss",
								type = obj2:getNode():getTag(),
								count = 1,
								combol = self.combolNumber,
								isFerver = isFerverTime,
								startPos = obj2:getNode():getPosition()
							}
							--                          self.puzzleCardNode:ballToCard(data)
							                          self:setFerverPt(data.count)
						end
					end

					startBall = nil
					_bullets = {}
					_bullets2 = {}
					self.curTouchBall = nil
				elseif GameUtils:inTable(GameConst.BOOM.KINDS,arr:getBody():getNode():getName()) then
					local boomAround = self:getAroundBalls(all,arr:getBody():getNode())
					cc.SimpleAudioEngine:getInstance():playEffect("sound/se35.m4a")
					for _, obj2 in ipairs(boomAround) do
						obj2:getNode():brokenBullet()
						local data = {
							action = "atkBoss",
							type = obj2:getNode():getTag(),
							count = 1,
							combol = self.combolNumber,
							isFerver = isFerverTime,
							startPos = obj2:getNode():getPosition()
						}
						--                      self.puzzleCardNode:ballToCard(data)
						                      self:setFerverPt(data.count)
					end
					self:updateCombol()
					self:updateScore(#boomAround)
					arr:getBody():getNode():broken()
					startBall = nil
					_bullets = {}
					_bullets2 = {}
					self.curTouchBall = nil
				else
					GameUtils.IsGameActive = true
					startBall = arr:getBody():getNode()
					_curBallTag = arr:getBody():getNode():getTag()
					self.curTouchBall = arr:getBody():getNode()
					if next(_bullets) == nil then
						_bullets[touchIdx] = arr:getBody():getNode()
					end
					self.curTouchBall:addPuzzleNumber(1)
					self.curTouchBall:addBallTouchEffect()
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
		GameUtils.IsGameActive = true
		self.curTouchBall = nil
		local location = touch:getLocation()
		touchPoint:setPosition(cc.p(location.x,location.y))

		--      local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShape(location)
		--      if arr ~= nil and arr:getBody():getTag() == GameConst.PUZZLEOBJTAG.T_Bullet then
		--          self.curTouchBall = arr:getBody():getNode()
		--      end
		--      if self.curTouchBall ~= nil and (self.curTouchBall:getTag() ==_curBallTag or PuzzleManager.isAllColorPuzzle) then
		--          if next(_bullets) == nil then
		--              _bullets[touchIdx] = self.curTouchBall
		--          elseif isTableContains(_bullets,self.curTouchBall) == false then
		--              local p1 = _bullets[#_bullets]:getPosition()
		--              local p2 = self.curTouchBall:getPosition()
		--              local distance = cc.pGetDistance(p1,p2)
		--              if distance < 2 * math.sqrt(3) * self.curTouchBall.circleSize  then
		--                  touchIdx = touchIdx + 1
		--                  _bullets[touchIdx] = self.curTouchBall
		--                  if touchIdx > 1 then
		--                      _bullets[touchIdx-1]:removeSingleEffect()
		--                      _bullets[touchIdx-1]:removePuzzleNumber()
		--                  end
		--                  if next(_bullets) ~= nil then
		--                      _bullets[touchIdx]:addBallTouchEffect()
		--                      _bullets[touchIdx]:addPuzzleNumber(touchIdx)
		--                  end
		--              end
		--          else
		--              local obj1 = _bullets[#_bullets]
		--              local obj2 = _bullets[#_bullets-1]
		--              if self.curTouchBall == obj2 then
		--                  touchIdx = touchIdx - 1
		--                  obj1:removeAllEffect()
		--                  obj2:addBallTouchEffect()
		--                  table.remove(_bullets,#_bullets)
		--              end
		--          end
		--      elseif self.curTouchBall ~= nil and self.curTouchBall:getTag() ~= _curBallTag then
		--
		--      end
		--
		--      if #_bullets < 2 then
		--          _fingerPosition = location
		--      else
		--          _fingerPosition = nil
		--      end
	end

	local function onTouchEnded(touch, event)
		touchPoint:setPosition(cc.p(9999,9999))
		GameUtils.IsGameActive = false
		startBall = nil
		curBall = nil
		_curBallTag = nil
		local type = 1
		local lastPos = nil

		local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
		for _, obj in ipairs(all) do
			if obj:getTag() == GameConst.PUZZLEOBJTAG.T_Bullet then
				obj:getNode():removePuzzleNumber()
				obj:getNode():removeAllEffect()
			end
		end

		if next(_bullets) ~= nil then
			for key, var in ipairs(_bullets) do
				if  #_bullets > 1 then
					if  #_bullets == key then
						cc.SimpleAudioEngine:getInstance():playEffect(GameConst.SOUND.BALL_BROKEN)
						_bullets[#_bullets]:addBoom(#_bullets)
						type = _bullets[1]:getTag()
						lastPos = _bullets[#_bullets]:getPosition()
					end

					if var:getType() == 1 then
						var:addBoomCard(#_bullets)
					end
					var:removeAllEffect()
					var:brokenBullet()
				end
			end
			if  #_bullets > 1 then
				local data = {
					action = "atkBoss",
					type = type,
					count = #_bullets,
					combol = self.combolNumber,
					isFerver = isFerverTime,
					startPos = lastPos,
				}
				--              self.puzzleCardNode:ballToCard(data)
				self:setFerverPt(#_bullets)
				self:updateScore(#_bullets)
				if  #_bullets > 2 then
					self:updateCombol()
				end
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



	local function onContactBegin(contact)
		local bodyA = contact:getShapeA():getBody():getNode()
		local bodyB = contact:getShapeB():getBody():getNode()
		local tagA = bodyA:getTag()
		local tagB = bodyB:getTag()
		if tagA > 10 then
			self.curTouchBall = bodyB
		end
		if tagB > 10 then
			self.curTouchBall = bodyA
		end


		if self.curTouchBall ~= nil and (self.curTouchBall:getTag() ==_curBallTag or PuzzleManager.isAllColorPuzzle) then
			if next(_bullets) == nil then
				_bullets[touchIdx] = self.curTouchBall
			elseif isTableContains(_bullets,self.curTouchBall) == false then
				local p1 = _bullets[#_bullets]:getPosition()
				local p2 = self.curTouchBall:getPosition()
				local distance = cc.pGetDistance(p1,p2)
				if distance < 2 * math.sqrt(3) * self.curTouchBall.circleSize  then
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
		elseif self.curTouchBall ~= nil and self.curTouchBall:getTag() ~= _curBallTag then

		end

		if #_bullets < 2 then
			_fingerPosition = location
		else
			_fingerPosition = nil
		end
		return true
	end
	local contactListener = cc.EventListenerPhysicsContact:create()
	contactListener:registerScriptHandler(onContactBegin,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	dispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)

end


--------------------------------------------------------------------------------
-- add energy
function PuzzleLayer:setFerverPt(count)
	local point = count * 1.5
	if isFerverTime == false then
		ferver = ferver + point
		if ferver > 100 then
			isFerverTime = true

			ferverEffect = cc.ParticleSystemQuad:create(GameConst.PARTICLE.FERVER)
			ferverEffect:setAutoRemoveOnFinish(true)
			ferverEffect:setPosition(cc.p(0,0))
			ferverEffect:setScale(4)
			ferverEffect:setAnchorPoint(cc.p(0, 0))
			ferverEffect:setDuration(10)
			local to = cc.ProgressTo:create(10, 0)
			self.PuzzleUILayer.ferverBar:runAction(cc.RepeatForever:create(to))
			self:addChild(ferverEffect,0)
			cc.SimpleAudioEngine:getInstance():playEffect(GameConst.SOUND.FERVER,false)

		else
			local to = cc.ProgressTo:create(0.5, ferver)
			self.PuzzleUILayer.ferverBar:runAction(cc.RepeatForever:create(to))
		end
	end
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
--  self.puzzleCardNode = PuzzleCardNode:create()
--  self:addChild(self.puzzleCardNode, GameConst.ZOrder.Z_Deck)
end

function PuzzleLayer:addUILayer()
	self.PuzzleUILayer = PuzzleUILayer:create()
	self:addChild(self.PuzzleUILayer, GameConst.ZOrder.Z_Deck)
end

--------------------------------------------------------------------------------
--
-- BOSSをinitする
function PuzzleLayer:addBossSprite()
	self.boss = BossSprite:create()
	self:addChild(self.boss,GameConst.ZOrder.Z_Boss)
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
	--  local all = {}
	--  if cc.Director:getInstance():getRunningScene():getPhysicsWorld() ~= nil then
	--      all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	--  end

	--  if MAX_BULLET >= #all then
	self:addBalls()
	--  end
	
	
	self:DrawLineRemove()

	if GameUtils.IsGameActive == false then
		curBall = nil
		_curBallTag = nil
		_bullets = {}
		_bullets2 = {}
	else
		if next(_bullets) ~= nil then
			for key, var in ipairs(_bullets) do
				table.insert(_bulletVicts, var:getPosition())
			end
		end
		local node = DrawLine:create(_bulletVicts)
		self:addChild(node,GameConst.ZOrder.Z_Line,GameConst.PUZZLEOBJTAG.T_Line)
		_bulletVicts = {}
	end

	  if isFerverTime then
		if self.PuzzleUILayer.ferverBar:getPercentage() == 0 then
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
			if  GameUtils:inTable({GameConst.PUZZLEOBJTAG.T_Bullet, GameConst.PUZZLEOBJTAG.T_TARGET},obj:getTag()) then
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
	if self.boss ~= nil and self.boss:isActive() == false then
		--      self.gameState = self.stateGameOver
		--      self:gameResult(true)
		self.boss:removeSelf()
		self.boss = nil
		debug = false
	end
	--You Lost
	if self.PuzzleUILayer:isAllDead() then
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
	--  local scene = ResultScene:create()
	--  local tt = cc.TransitionCrossFade:create(1.0, scene)
	--  cc.Director:getInstance():replaceScene(tt)
	--  SceneManager:changeScene("app/scene/puzzle/ResultScene",nil)
	print("###Game Over#####")
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
--------------------------------------------------------------------------------
-- コンボ
function PuzzleLayer:addCombol()
	self.UI_Combol = ccui.TextAtlas:create()
	self.UI_Combol:setProperty(self.combolNumber, GameConst.FONT.NUMBER_MYELLOW, 25, 30, "0")
	self.UI_Combol:setPosition(cc.p(AppConst.WIN_SIZE.width - 80,AppConst.WIN_SIZE.height/2 + 150))
	self:addChild(self.UI_Combol,GameConst.ZOrder.Z_Combol)
	--  self.puzzleCardNode:addChild(self.UI_Combol,GameConst.ZOrder.Z_Combol)
	self.UI_Combol:setOpacity(0)
end
function PuzzleLayer:updateCombol()
	self.combolTimer = 4
	if self.UI_Combol ~= nil then
		self.UI_Combol:setOpacity(255)
		self.combolNumber = self.combolNumber + 1
		self.UI_Combol:setString(self.combolNumber)
		GameUtils:addCombolEffect(self.UI_Combol)
	end
end
--------------------------------------------------------------------------------
-- add Score
function PuzzleLayer:addScore()
	Label_Score = ccui.TextAtlas:create()
	Label_Score:setProperty("0", GameConst.FONT.NUMBER, 17, 22, "0")
	Node_Score:addChild(Label_Score)
end

function PuzzleLayer:updateScore(plusNum)
	if Label_Score ~= nil then
		m_Score = m_Score + plusNum
		Label_Score:setString(m_Score)
		GameUtils:addCombolEffect(Label_Score)
	end
end


return PuzzleLayer