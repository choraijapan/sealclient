--------------------------------------------------------------------------------
-- SpritePlayer
-- 【クラス】Player
-- @date 2014/12/24
-- @author  Cho Rai
local SpritePlayer = class("SpritePlayer", function()
    return cc.Sprite:create()
end)
SpritePlayer.active             = nil
SpritePlayer.canBeAttack        = nil
SpritePlayer.hp                 = nil
SpritePlayer.atk                = nil
SpritePlayer.power              = nil
SpritePlayer.speed              = nil
SpritePlayer.bulleSpeed         = nil
SpritePlayer.bulletPowerValue   = nil
SpritePlayer.delayTime          = nil
SpritePlayer.size               = nil
SpritePlayer.label_hp           = nil
SpritePlayer.slider_hp          = nil
SpritePlayer.action     = nil
--------------------------------------------------------------------------------
-- ctor
function SpritePlayer:ctor()
    self.active = true
    self.hp = 20000
end
--------------------------------------------------------------------------------
-- create
function SpritePlayer:create()
    local player = SpritePlayer.new()
    player:init()
    return player
end
--------------------------------------------------------------------------------
-- init
function SpritePlayer:init()
    self:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2))
    self:addHp()
    self:addEventDispatcher()
end

function SpritePlayer:addEventDispatcher()
    print("##########  attack over")
    local function callBack(event)
        local data = event._data
        if data.action == "atk" then
            self:hurt(data.damage)
        end
    end
    EventDispatchManager:createEventDispatcher(self,"SPRITE_EVENT_ATK",callBack)
end

function SpritePlayer:addHp()
    self.label_hp = ccui.TextAtlas:create()
    self.label_hp:setSize(5)
    self.label_hp:setProperty(self.hp, "labelatlas.png", 17, 22, "0")
    self.label_hp:setPosition(cc.p(0,-WIN_SIZE.height/2 + 10))
    self:addChild(self.label_hp)
end

--------------------------------------------------------------------------------
-- hurt
function SpritePlayer:hurt(damageValue)
    self.hp = self.hp - damageValue
    self.label_hp:setString(self.hp)

    if self.hp <= 0 then
        self.active = false
    end
end
--------------------------------------------------------------------------------
-- isCanAttack
function SpritePlayer:isCanAttack()
    return self.canBeAttack
end
--------------------------------------------------------------------------------
-- isActive
function SpritePlayer:isActive()
    return self.active
end
--------------------------------------------------------------------------------
-- destroy
function SpritePlayer:destroy()
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():playEffect("Music/shipDestroyEffect.mp3")
    end
    self:removeFromParent()
end
return SpritePlayer