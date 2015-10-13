local layerPath = "app.scene.puzzle.layer"

local SpriteCard = require("app.parts.puzzle.SpriteCard")
local PuzzleResultLayer = require("app.layer.puzzle.PuzzleResultLayer")

local Ball = require("app.parts.puzzle.Ball")
local DrawLine = require("app.parts.puzzle.DrawLine")
local SpriteBoss = require("app.parts.puzzle.SpriteBoss")
local SpritePlayer = require("app.parts.puzzle.SpritePlayer")

PuzzleLayer = class("PuzzleLayer", cc.Layer)
PuzzleLayer.stateGamePlaying = 0
PuzzleLayer.stateGameOver = 1
PuzzleLayer.resultWin = 1
PuzzleLayer.resultLost = 0

PuzzleLayer.gameState = nil
PuzzleLayer.gameTime = nil                --
PuzzleLayer.lbScore = nil                 -- 分数
PuzzleLayer.lbLifeCount = nil             -- 显示生命值

PuzzleLayer.player = nil                  -- Player (自分)
PuzzleLayer.boss = nil                    -- boss

PuzzleLayer.wall = nil
PuzzleLayer.gameCardNode = nil
PuzzleLayer.cards = {
	card1 = nil,
	card2 = nil,
	card3 = nil,
	card4 = nil,
	card5 = nil,
	card6 = nil
}
PuzzleLayer.footer = nil
PuzzleLayer.name = nil

local winSize = nil
local offside = nil

local MAX_BULLET = 45
local _bullet = 0
local _time = 0
local _tag = nil
local _bulletVicts = nil
local _fingerPosition = nil
local _bullets = {}
local tempBullets = {}
local touchIdx = 1
local curTouchBall = nil
local firstTouchBall = nil
local lastTouchBall = nil
local ZOrder = {
    Z_Bg = 0,
    Z_Bullet = 1,
    Z_Line = 9,
    Z_Dialog = 3,
}

local Tag = {
    T_Bullet = 1,
    T_Bullet1 = 2,
    T_Bullet2 = 3,
    T_Bullet3 = 4,
    T_Bullet4 = 5,
    T_Bullet5 = 6,
    T_Dialog = 7,
    T_Line = 8,
}

function PuzzleLayer:ctor()
    self.name = self.class.__cname
    self:setName(self.name)
    _bullet = 0
    winSize = cc.Director:getInstance():getWinSize()
    offside = winSize.height/2 + 25
    
	self.gameCardNode = WidgetLoader:loadCsbFile('parts/game/GameCardNode.csb')
	self.gameCardNode:setPosition(cc.p(0,cc.Director:getInstance():getWinSize().height/2 + 40))
	self.gameCardNode:setName("GameCardNode")
	self:addChild(self.gameCardNode,2)
	self.cards.card1 = WidgetObj:searchWidgetByName(self.gameCardNode,"Sprite_1","cc.Sprite")
	self.cards.card2 = WidgetObj:searchWidgetByName(self.gameCardNode,"Sprite_2","cc.Sprite")
	self.cards.card3 = WidgetObj:searchWidgetByName(self.gameCardNode,"Sprite_3","cc.Sprite")
	self.cards.card4 = WidgetObj:searchWidgetByName(self.gameCardNode,"Sprite_4","cc.Sprite")
	self.cards.card5 = WidgetObj:searchWidgetByName(self.gameCardNode,"Sprite_5","cc.Sprite")
	self.cards.card6 = WidgetObj:searchWidgetByName(self.gameCardNode,"Sprite_6","cc.Sprite")
	
end


function PuzzleLayer:create()
    local layer = PuzzleLayer.new()
    layer:init()
    return layer
end


function PuzzleLayer:init()
    --    self:loadingMusic() -- 背景音乐
    self:addBG()        -- 初始化背景
    --    self:moveBG()       -- 背景移动
    --    self:addBtn()       -- 游戏暂停按钮

    Global:getInstance():resetGame()    -- 初始化全局变量
    self:initGameState()                -- 初始化游戏数据状态
    self:addPlayer()             -- 初期化（自分）

    self:addSpriteBoss()
    self:addPuzzle()

    self:addSchedule()  -- 更新
    self:addTouch()     -- 触摸

    _bulletVicts = {}
    _fingerPosition = nil


end

function PuzzleLayer:addPuzzle()

    local vec =
        {
            cc.p(winSize.width-1, winSize.height-1),
            cc.p(1, winSize.height-1),
            cc.p(1, 100),
            cc.p(winSize.width/2, 0),
            cc.p(winSize.width-1, 100),
            cc.p(winSize.width-1, winSize.height-1),
        }
    self.wall = cc.Node:create()
    --self.wall:setAnchorPoint(cc.p(0.5,0.5))
    --    local edge = cc.PhysicsBody:createEdgeChain(vec,6,cc.PhysicsMaterial(0.0,0.0,0.5))

    local edge = cc.PhysicsBody:createEdgeBox(cc.size(winSize.width + 40,winSize.height),cc.PhysicsMaterial(0,0,0.5),20)
    self.wall:setPhysicsBody(edge)
    --    wall:setPosition(VisibleRect:bottom())
    self.wall:setPosition(cc.p(WIN_SIZE.width/2,WIN_SIZE.height/2))
    self:addChild(self.wall)
end

function PuzzleLayer:addBalls()
    local addNum = MAX_BULLET - _bullet
    local typeId = math.random(1,5)
    local ball = Ball:create(typeId)

    local randomX = math.random(20,winSize.width-20)
    ball:setPosition(winSize.width - randomX, winSize.height*2/3)
	ball:setRotation(math.random(1,360))
    local pBall = ball:getPhysicsBody()
    pBall:setTag(Tag.T_Bullet)
    self:addChild(ball,ZOrder.Z_Bullet,typeId+2)
    _bullet = _bullet + 1
end

-- 播放音乐
function PuzzleLayer:loadingMusic()
    if Global:getInstance():getAudioState() == true then
        -- playMusic
        cc.SimpleAudioEngine:getInstance():stopMusic()
        cc.SimpleAudioEngine:getInstance():playMusic("battle/Music/bgMusic.mp3", true)
    else
        cc.SimpleAudioEngine:getInstance():stopMusic()
    end
end


-- 添加背景
function PuzzleLayer:addBG()
    self.bg1 = cc.Sprite:create("battle/bg.png")
    --    self.bg2 = cc.Sprite:create("bg_01.jpg")
    self.bg1:setAnchorPoint(cc.p(0, 0))
    --    self.bg1:setPosition(0, offside)
    --    self.bg1:setScale(0.5)
    --    self.bg2:setPosition(0, self.bg1:getContentSize().height)
--    self:addChild(self.bg1, 1)
    --    self:addChild(self.bg2, -10)
end

-- 添加背景
function PuzzleLayer:addFooter()

end


-- 背景滚动
function PuzzleLayer:moveBG()
    local height = self.bg1:getContentSize().height
    local function updateBG()
        self.bg1:setPositionY(self.bg1:getPositionY() - 1)
        self.bg2:setPositionY(self.bg1:getPositionY() + height)
        if self.bg1:getPositionY() <= -height then
            self.bg1, self.bg2 = self.bg2, self.bg1
            self.bg2:setPositionY(WIN_SIZE.height)
        end
    end
    schedule(self, updateBG, 0)
end


-- 添加按钮
function PuzzleLayer:addBtn()
    local function PauseGame()
        self:PauseGame()
    end
    local pause = cc.MenuItemImage:create("battle/pause.png", "battle/pause.png")
    pause:setAnchorPoint(cc.p(1, 0))
    pause:setPosition(cc.p(WIN_SIZE.width, 0))
    pause:registerScriptTapHandler(PauseGame)

    local menu = cc.Menu:create(pause)
    menu:setPosition(cc.p(0, 0))
    --    self:addChild(menu, 1, 10)
end


-- 更新
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

function PuzzleLayer:addTouch()
    local function onTouchBegan(touch, event)
        touchIdx = 1
        local location = touch:getLocation()
        local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
        for _, obj in ipairs(arr) do
            if bit.band(obj:getBody():getTag(), Tag.T_Bullet) ~= 0 then
                if _tag ~= nil and _tag ~= obj:getBody():getNode():getTag() then
                    return false
                else
                    _tag = obj:getBody():getNode():getTag();
                    firstTouchBall = obj:getBody():getNode()
                    self.curTouchBall = obj:getBody():getNode()
                    firstTouchBall:addBallTouchEffect()
                    break;
                end
            end
        end
        return true
    end

    local function onTouchMoved(touch, event)
		DebugLog:debug("############ onTouchMoved START")
        local location = touch:getLocation()
        local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
        for _, obj in ipairs(arr) do
            if bit.band(obj:getBody():getTag(), Tag.T_Bullet) ~= 0 then
                if obj:getBody():getNode():getTag() == _tag then
                    self.curTouchBall = obj:getBody():getNode()
                    break
                else
                    self.curTouchBall = nil
                end
            end
        end

        local function isTableContains(tb,obj)
            for _,v in pairs(tb) do
                if v == obj then
                    return true
                end
            end
            return false
        end

        if self.curTouchBall ~= nil and self.curTouchBall:getState() == Ball.MOVING then
            if next(_bullets) == nil then
                DebugLog:debug("############ onTouchMoved BBB")
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
                        _bullets[touchIdx-1]:removeBallTouchEffect()
                    end
                    _bullets[touchIdx]:addBallTouchEffect()


                end
            else
                local obj1 = _bullets[#_bullets]
                local obj2 = _bullets[#_bullets-1]
                if self.curTouchBall == obj2 then
                    touchIdx = touchIdx - 1
                    obj1:removeBallTouchEffect()
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
        _tag = nil
        local location = touch:getLocation()
        local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
        for _, obj in ipairs(arr) do
            if obj:getBody():getTag() == Tag.T_Bullet then
                obj:getBody():getNode():removeBallTouchEffect()
            end
        end

        if firstTouchBall~= nil then
            firstTouchBall:removeBallTouchEffect()
        end

        if self.curTouchBall ~= nil then
            self.curTouchBall:removeBallTouchEffect()
        end

        for key, var in ipairs(_bullets) do
            var:removeBallTouchEffect()
        end

        if next(_bullets) ~= nil then
            local type = 1
            local lastPos = nil
            for key, var in ipairs(_bullets) do
                if var:getState() == Ball.MOVING then
                    if  #_bullets > 2 then
                        var:brokenBullet()
                        local particle = cc.ParticleSystemQuad:create("res/effect/game/puzzle.plist")
                        particle:setAutoRemoveOnFinish(true)
                        particle:setPosition(var:getPosition())
                        particle:setScale(0.2)
                        particle:setAutoRemoveOnFinish(true)
                        self:addChild(particle,999)
                        type = var:getType()
                        lastPos = var:getPosition()
                        _bullet = _bullet - 1
                    end
                end
                var:removeBallTouchEffect()
            end
            if  #_bullets > 2 then
                local data = {
                    action = "hurt",
                    type = type,
                    count = #_bullets,
                }
                self.boss:broadCastEvent(data)
				local pos = self.cards.card1:getParent():convertToWorldSpace(cc.p(self.cards.card1:getPositionX(),self.cards.card1:getPositionY()))
				self:addAtkEffect(lastPos,pos)
            end
        else

        end
        _bullets = {}
    end

    local dispatcher = self:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

-- 初始化游戏数据状态
function PuzzleLayer:initGameState()
    -- 游戏状态
    self.gameState = self.stateGamePlaying
    -- 游戏时间
    self.gameTime = 0
end

-- Playerを追加する
function PuzzleLayer:addPlayer()
    self.player = SpritePlayer:create()
    self:addChild(self.player, 2, 1001)
end

-- BOSSをinitする
function PuzzleLayer:addSpriteBoss()
    self.boss = SpriteBoss:create()
    self:addChild(self.boss)
end


-- 更新时间
function PuzzleLayer:updateTime()
    if self.gameState == self.stateGamePlaying then
        self.gameTime = self.gameTime + 1
    end
end


function PuzzleLayer:update(dt)
    _time = _time + 1
    if MAX_BULLET >= _bullet then
        self:addBalls()
    end

    for key, var in ipairs(_bullets) do
        table.insert(_bulletVicts, var:getPosition())
    end

    self:DrawLineRemove()
    local node = DrawLine:create(_bulletVicts)
    self:addChild(node,ZOrder.Z_Line,Tag.T_Line)
    _bulletVicts = {}
end


-- 更新游戏
function PuzzleLayer:updateGame()
    if self.gameState == self.stateGamePlaying then
        self:checkGameOver()
        self:updateUI()
    end
end

-- 游戏结束 or 使用道具
function PuzzleLayer:checkGameOver()
    if self.boss == nil then
        return
    end
    if  self.boss:isActive() == false then
        self.gameState = self.stateGameOver
        --You Win
        self:gameResult(true)
    elseif self.player:isActive() == false then
        self.gameState = self.stateGameOver
        --You Lost
        self:gameResult(false)
    end
end

-- 刷新界面
function PuzzleLayer:updateUI()
end

-- 游戏暂停
function PuzzleLayer:PauseGame()
    cc.Director:getInstance():pause()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    cc.SimpleAudioEngine:getInstance():pauseAllEffects()

    local pauseLayer = PauseLayer:create()
    self:addChild(pauseLayer, 9999)
end


-- 游戏继续
function PuzzleLayer:resumeGame()
    cc.Director:getInstance():resume()
    cc.SimpleAudioEngine:getInstance():resumeMusic()
    cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end


-- 游戏结束
function PuzzleLayer:gameResult(isWin)
    Global:getInstance():ExitGame()
    local scene = PuzzleResultLayer:createScene(isWin)
    local tt = cc.TransitionCrossFade:create(1.0, scene)
    cc.Director:getInstance():replaceScene(tt)
end


-- 获取Player
function PuzzleLayer:getShip()
    return self.player
end

function PuzzleLayer:addAtkEffect(from,to)
    local emitter = cc.ParticleSystemQuad:create("battle/particle_atk2.plist")
    self:addChild(emitter,1111111)
    emitter:setPosition(from)
	emitter:setAnchorPoint(cc.p(0.5, 0.5))
    local action1 = cc.MoveTo:create(1,to)
    local action2 = cc.RemoveSelf:create()
    emitter:runAction(cc.Sequence:create(action1, action2))

    local card_atk = cc.ParticleSystemQuad:create("effect/game/card_atk_001.plist")
    card_atk:setPosition(self.boss:getPosition())
    card_atk:setDuration(0.7)
    self:addChild(card_atk,1111111)

end

function PuzzleLayer:DrawLineRemove()
    local nodes = self:getChildren()
    for key, var in ipairs(nodes) do
        if var:getTag() == Tag.T_Line then
            local line = var
            line:remove()
            break
        end
    end
end



