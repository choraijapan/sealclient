local SpriteCard = require("SpriteCard")
local GameFooter = require("GameFooter")
local SceneGameResult = require("SceneGameResult")

require("VisibleRect")
local Ball = require("Ball")
local DrawLine = require("DrawLine")
local SpriteBoss = require("SpriteBoss")
local SpritePlayer = require("SpritePlayer")

GameLayer = class("GameLayer", function()
    return cc.Layer:create()
end)
GameLayer.stateGamePlaying = 0
GameLayer.stateGameOver = 1
GameLayer.resultWin = 1
GameLayer.resultLost = 0

GameLayer.gameState = nil
GameLayer.gameTime = nil                --
GameLayer.lbScore = nil                 -- 分数
GameLayer.lbLifeCount = nil             -- 显示生命值

GameLayer.player = nil                  -- Player (自分)
GameLayer.boss = nil                    -- boss

GameLayer.wall = nil

GameLayer.footer = nil
GameLayer.name = nil

local winSize = nil
local offside = nil

local MAX_BULLET = 40
local _bullet = 0
local _time = 0
local _tag = nil
local _bulletVicts = nil
local _fingerPosition = nil
local _bullets = {}
local tempBullets = {}
local touchIdx = 1
local ZOrder = {
    Z_Bg = 0,
    Z_Bullet = 1,
    Z_Line = 2,
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

function GameLayer:ctor()
    self.name = self.class.__cname
    _bullet = 0
    winSize = cc.Director:getInstance():getWinSize()
    offside = winSize.height/2 + 25
end


function GameLayer:create()
    local layer = GameLayer.new()
    layer:init()
    return layer
end


function GameLayer:init()
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

function GameLayer:addPuzzle()

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
    --    local edge = cc.PhysicsBody:createEdgeChain(vec,6,cc.PhysicsMaterial(0.0,0.0,0.5))
    local edge = cc.PhysicsBody:createEdgeBox(cc.size(winSize.width + 40,winSize.height),cc.PhysicsMaterial(0,0,0.5),20)
    self.wall:setPhysicsBody(edge)
    --    wall:setPosition(VisibleRect:bottom())
    self.wall:setPosition(cc.p(WIN_SIZE.width/2,WIN_SIZE.height/2))
    self:addChild(self.wall)
end

function GameLayer:addBalls()
    local addNum = MAX_BULLET - _bullet
    local typeId = math.random(1,5)
    local ball = Ball:create(typeId)

    local randomX = math.random(1,winSize.width)
    ball:setPosition(winSize.width - randomX, 400)

    local pBall = ball:getPhysicsBody()
    pBall:setTag(Tag.T_Bullet)
    self:addChild(ball,ZOrder.Z_Bullet,typeId+2)
    _bullet = _bullet + 1
end

-- 播放音乐
function GameLayer:loadingMusic()
    if Global:getInstance():getAudioState() == true then
        -- playMusic
        cc.SimpleAudioEngine:getInstance():stopMusic()
        cc.SimpleAudioEngine:getInstance():playMusic("Music/bgMusic.mp3", true)
    else
        cc.SimpleAudioEngine:getInstance():stopMusic()
    end
end


-- 添加背景
function GameLayer:addBG()
    self.bg1 = cc.Sprite:create("bg.png")
    --    self.bg2 = cc.Sprite:create("bg_01.jpg")
    self.bg1:setAnchorPoint(cc.p(0, 0))
--    self.bg1:setPosition(0, offside)
--    self.bg1:setScale(0.5)
    --    self.bg2:setPosition(0, self.bg1:getContentSize().height)
--    self:addChild(self.bg1, 1)
    --    self:addChild(self.bg2, -10)
end

-- 添加背景
function GameLayer:addFooter()
    self.footer = GameFooter:create()
    self.footer:setPosition(0, offside)
    self:addChild(self.footer, 0, 1001)
end


-- 背景滚动
function GameLayer:moveBG()
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
function GameLayer:addBtn()
    local function PauseGame()
        self:PauseGame()
    end
    local pause = cc.MenuItemImage:create("pause.png", "pause.png")
    pause:setAnchorPoint(cc.p(1, 0))
    pause:setPosition(cc.p(WIN_SIZE.width, 0))
    pause:registerScriptTapHandler(PauseGame)

    local menu = cc.Menu:create(pause)
    menu:setPosition(cc.p(0, 0))
    --    self:addChild(menu, 1, 10)
end


-- 更新
function GameLayer:addSchedule()

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

function GameLayer:addTouch()
    local function onTouchBegan(touch, event)
        touchIdx = 1
        local location = touch:getLocation()
        local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)

        for _, obj in ipairs(arr) do
            if bit.band(obj:getBody():getTag(), Tag.T_Bullet) ~= 0 then
                _tag = obj:getBody():getNode():getTag();
                break;
            end
        end
        return true
    end

    local function onTouchMoved(touch, event)
        local location = touch:getLocation()
        local arr = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getShapes(location)
        local bullet = nil
        for _, obj in ipairs(arr) do
            if bit.band(obj:getBody():getTag(), Tag.T_Bullet) ~= 0 then
                bullet = obj:getBody():getNode()
                if bullet:getTag() == _tag then
                    break
                else
                    bullet = nil
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

        if bullet ~= nil and bullet:getState() == Ball.MOVING then
            if next(_bullets) == nil then
                _bullets[touchIdx] = bullet
                --                touchIdx = touchIdx + 1
            elseif isTableContains(_bullets,bullet) == false then
                local p1 = _bullets[#_bullets]:getPosition()
                local p2 = bullet:getPosition()
                local distance = cc.pGetDistance(p1,p2)
                if distance < bullet.size * 4 then
                    print("####### touchIdx"..touchIdx)
                    touchIdx = touchIdx + 1
                    _bullets[touchIdx] = bullet
                end
            else
                local obj1 = _bullets[#_bullets]
                local obj2 = _bullets[#_bullets-1]
                if bullet == obj2 then
                    touchIdx = touchIdx - 1
                    table.remove(_bullets,#_bullets)
                end
            end
        end

        if #_bullets < 2 then
            _fingerPosition = location
        else
            _fingerPosition = nil
        end
    end

    local function onTouchEnded(touch, event)
        if next(_bullets) ~= nil and #_bullets > 2 then
            local type = 1
            local lastPos = nil
            for key, var in ipairs(_bullets) do
                if var:getState() == Ball.MOVING then
                    var:brokenBullet()
                    type = var:getType()
                    lastPos = var:getPosition()
                    _bullet = _bullet - 1
                end
            end
            local data = {
                action = "hurt",
                type = type,
                count = #_bullets,
            }
            self.boss:broadCastEvent(data)
            local bossPos = self.boss:getPosition()
            self:addAtkEffect(lastPos,bossPos)
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
function GameLayer:initGameState()
    -- 游戏状态
    self.gameState = self.stateGamePlaying
    -- 游戏时间
    self.gameTime = 0
end

-- Playerを追加する
function GameLayer:addPlayer()
    self.player = SpritePlayer:create()
    self:addChild(self.player, 2, 1001)
end

-- BOSSをinitする
function GameLayer:addSpriteBoss()
    self.boss = SpriteBoss:create()
    self:addChild(self.boss)
end


-- 更新时间
function GameLayer:updateTime()
    if self.gameState == self.stateGamePlaying then
        self.gameTime = self.gameTime + 1
    end
end


function GameLayer:update(dt)
    _time = _time + 1
    if MAX_BULLET >= _bullet then
        self:addBalls()
    end


    for key, var in ipairs(_bullets) do
        table.insert(_bulletVicts, var:getPosition())
    end

    if _fingerPosition ~= nil then
        table.insert(_bulletVicts, _fingerPosition)
    end

    self:DrawLineRemove()

    local node = DrawLine:create(_bulletVicts)
    self:addChild(node,ZOrder.Z_Line,Tag.T_Line)
    _bulletVicts = {}
end


-- 更新游戏
function GameLayer:updateGame()
    if self.gameState == self.stateGamePlaying then
        self:checkGameOver()
        self:updateUI()
    end
end

-- 游戏结束 or 使用道具
function GameLayer:checkGameOver()
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
function GameLayer:updateUI()
end

-- 游戏暂停
function GameLayer:PauseGame()
    cc.Director:getInstance():pause()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
    cc.SimpleAudioEngine:getInstance():pauseAllEffects()

    local pauseLayer = PauseLayer:create()
    self:addChild(pauseLayer, 9999)
end


-- 游戏继续
function GameLayer:resumeGame()
    cc.Director:getInstance():resume()
    cc.SimpleAudioEngine:getInstance():resumeMusic()
    cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end


-- 游戏结束
function GameLayer:gameResult(isWin)
    Global:getInstance():ExitGame()
    local scene = SceneGameResult:createScene(isWin)
    local tt = cc.TransitionCrossFade:create(1.0, scene)
    cc.Director:getInstance():replaceScene(tt)
end


-- 获取飞机
function GameLayer:getShip()
    return self.player
end



function GameLayer:addAtkEffect(from,to)
    local emitter = cc.ParticleSystemQuad:create("particle_atk2.plist")
    self:addChild(emitter,1111111)
    emitter:setPosition(from)
    local action1 = cc.MoveTo:create(1,to)
    local action2 = cc.RemoveSelf:create()
    emitter:runAction(cc.Sequence:create(action1, action2))
end

function GameLayer:DrawLineRemove()
    local nodes = self:getChildren()
    for key, var in ipairs(nodes) do
        if var:getTag() == Tag.T_Line then
            local line = var
            line:remove()
            break
        end
    end
end