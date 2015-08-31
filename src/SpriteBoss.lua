--------------------------------------------------------------------------------
-- SpriteBoss
-- 【クラス】Player
-- @date 2014/12/24
-- @author  Cho Rai
local SpriteBoss = class("SpriteBoss", function()
    return cc.Sprite:create()
end)
SpriteBoss.node             = nil
SpriteBoss.sprite             = nil
SpriteBoss.active             = nil
SpriteBoss.canBeAttack        = nil
SpriteBoss.hp                 = nil
SpriteBoss.atk                = nil
SpriteBoss.power              = nil
SpriteBoss.speed              = nil
SpriteBoss.bulleSpeed         = nil
SpriteBoss.bulletPowerValue   = nil
SpriteBoss.delayTime          = nil
SpriteBoss.size               = nil
SpriteBoss.label_hp           = nil
SpriteBoss.slider_hp          = nil
SpriteBoss.action             = nil
SpriteBoss.time               = nil

local SPRITE_EVENT            = "SPRITE_BOSS_EVENT"
local SPRITE_EVENT_ATK        = "SPRITE_EVENT_ATK"

SpriteBoss.damage = {
    [1] = 123,
    [2] = 123,
    [3] = 123,
    [4] = 123,
    [5] = 123,
}

SpriteBoss.debuff    = {
    type = nil,
    value = nil,
}


SpriteBoss.color = {
    [0] = cc.c3b(255,255,255),
    [1] = cc.c3b(30,92,9),
    [2] = cc.c3b(239,225,13),
    [3] = cc.c3b(255,0,0),
    [4] = cc.c3b(2,105,248),
    [5] = cc.c3b(255,255,255),
}

--------------------------------------------------------------------------------
-- ctor
function SpriteBoss:ctor()
    self.active = true
    self.canBeAttack = false
    self.hp = 500000
    self.atk = 10000
    self.power = 1.0
    self.speed = 220
    self.bulleSpeed = 900
    self.bulletPowerValue = 1
    self.delayTime = 0.1
end
--------------------------------------------------------------------------------
-- init
function SpriteBoss:init()
    self:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height))
    self:addArmature()
    self:addHp()
    self:addEventDispatcher()
    self:addAI()
    -- BOSS时间
    self.time = 0
end
--------------------------------------------------------------------------------
-- create
function SpriteBoss:create()
    local player = SpriteBoss.new()
    player:init()
    return player
end

function SpriteBoss:addArmature()
    self.node = cc.CSLoader:createNode("huchey.csb")
    self.action = cc.CSLoader:createTimeline("huchey.csb")
    self.node:runAction(self.action)
    self.action:play("idel", true)
    self.node:setPosition(0,-180)
    
--    self:addChild(self.node)

    self.sprite = cc.Sprite:create("boss_20150804.png")
    self.sprite:setScale(0.5)
    self.sprite:setPosition(0,-140)
    self:addChild(self.sprite)
    
    local function onFrameEvent(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "hurted" then
            self.action:play("idel", true)
        elseif(str == "atked") then

            self.action:play("idel", true)
        end
    end
    self.action:setFrameEventCallFunc(onFrameEvent)
end

function SpriteBoss:addEventDispatcher()
    local function callBack(event)
        local data = event._data
        if data.action == "hurt" then
            self:addHurt(data)
        end
        self.action:play(data.action, false)
    end
    EventDispatchManager:createEventDispatcher(self,SPRITE_EVENT,callBack)
end

function SpriteBoss:broadCastEvent(data)
    EventDispatchManager:broadcastEventDispatcher(SPRITE_EVENT,data)
end
--------------------------------------------------------------------------------
-- Hp
function SpriteBoss:addHp()
    self.label_hp = ccui.TextAtlas:create()
    self.label_hp:setProperty(self.hp, "labelatlas.png", 17, 22, "0")
    self.label_hp:setPosition(cc.p(0,-20))
    self:addChild(self.label_hp)
end
--------------------------------------------------------------------------------
-- hurt
function SpriteBoss:hurt(damageValue)
    self.hp = self.hp - damageValue
    self.label_hp:setString(self.hp)

    self.action:play("hurt",false)
    if self.hp <= 0 then
        self.active = false
    end
end
--------------------------------------------------------------------------------
-- isCanAttack
function SpriteBoss:isCanAttack()
    return self.canBeAttack
end
--------------------------------------------------------------------------------
-- isActive
function SpriteBoss:isActive()
    return self.active
end
--------------------------------------------------------------------------------
-- destroy
function SpriteBoss:destroy()
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():playEffect("Music/shipDestroyEffect.mp3")
    end
    self:removeFromParent()
end


function SpriteBoss:setDebuffOn(data)
    local type = data.type
    local count = data.count
    
    --冰冻
    if type ==  DEBUFF.FREEZE then
--        self.sprite:setColor(self.color[type])
        self.node:setColor(self.color[type])
        self.debuff.type = DEBUFF.FREEZE
        self.debuff.value = 2
        local function freezeFor()
        end
        schedule(self, freezeFor, count*self.debuff.value)
    elseif type ==  DEBUFF.DEFDOWN then  --减护甲
--        self.sprite:setColor(self.color[type])
        self.node:setColor(self.color[type])
        self.debuff.type = DEBUFF.DEFDOWN
        self.debuff.value = 100
    else
--        self.sprite:setColor(self.color[0])
        self.node:setColor(self.color[0])
        self.debuff.type = DEBUFF.ATK
        self.debuff.value = 1
    end
    
    
    
    --    if type == 2 then
    --        self.sprite:setColor(self.color[type])
    --        self.debuff = 10
    --    end
    --
    --    if type == 3 then
    --        self.sprite:setColor(self.color[type])
    --        self.debuff = 5
    --    end

end

function SpriteBoss:addAI()
    local bossSkill = cc.Label:createWithSystemFont("", "HelveticaNeue-Bold", 12)
    bossSkill:setPosition(cc.p(70,-100))
    self:addChild(bossSkill)
    
    -- 更新时间
    local function updateTime()
        self.time = self.time + 1
        
        
        if self.time % 30 == 0 then
            self.time = 0    
            self:startAtk()
        else
            --模仿魔兽世界插件的倒计时［BOSS发动技能倒计时］
            if self.debuff.type == DEBUFF.FREEZE then
                bossSkill:setString(string.format("Perfect,You have stopped it!"))
                self.debuff.type = nil
                self.time = 1  
            else
                bossSkill:setString(string.format("Atk will happen in %ss",30 - self.time))
            end
            
        end
    end
    schedule(self, updateTime, 1)
    

--    local a1 = cc.DelayTime:create(20)
--    local a2 = cc.DelayTime:create(20)
--    local action1 = cc.Spawn:create(a1,a2)
--    local action2 = cc.CallFunc:create(start)
--    self:runAction(cc.RepeatForever:create(cc.Sequence:create(action1, action2)))

end

function SpriteBoss:startAtk()
    local data = {
        action = "atk",
        damage = "10000",
    }
    
    self.action:play(data.action, false)
    EventDispatchManager:broadcastEventDispatcher(SPRITE_EVENT_ATK,data)
    print("##########  attack start")
end

function SpriteBoss:addHurt(data)
    local labelAtlas = ccui.TextAtlas:create()

    local count = data.count
    local type = data.type

    local function actionEnd()
    end


    local damage = 0
    --    if count >= 5 then
    if self.debuff.type == DEBUFF.DEFDOWN then
        damage = self.damage[type] * count * self.debuff.value
    else
        damage = self.damage[type] * count
    end
    
    local action1 = cc.ScaleTo:create(0.1, 2)
    local action2 = cc.ScaleTo:create(0.1, 1.5)
    local action3 = cc.DelayTime:create(1.5)
    local action4 = cc.FadeOut:create(0.5)
    local action5 = cc.DelayTime:create(0.5)
    local action6 = cc.RemoveSelf:create()
    local action7 = cc.CallFunc:create(actionEnd)
    labelAtlas:runAction(cc.Sequence:create(action1, action2,action3,action4,action5,action6,action7))
    --    else
    --        damage = self.damage[type] * count
    --        local action1 = cc.MoveBy:create(2,cc.p(0,80))
    --        local action2 = cc.FadeOut:create(2)
    --        local action = cc.Spawn:create(action1,action2)
    --        local action4 = cc.RemoveSelf:create()
    --        labelAtlas:runAction(cc.Sequence:create(action,action4))
    --    end

    labelAtlas:setProperty(damage, "labelatlas.png", 17, 22, "0")
    labelAtlas:setPosition(0,-100)
    self:addChild(labelAtlas)
    self:hurt(damage)

    self:setDebuffOn(data) -- 设置新Debuff
end



function SpriteBoss:getPosition()
    local pos = {}
    pos.x = self:getPositionX()
    pos.y = self:getPositionY()
    return pos
end

return SpriteBoss