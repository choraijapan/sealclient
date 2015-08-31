--------------------------------------------------------------------------------
-- SpriteATK
local SpriteATK = class("SpriteATK", function()
    return cc.Sprite:create("ball_cold.png")
end)

--------------------------------------------------------------------------------
-- const変数
local TAG = "SpriteATK:"
--------------------------------------------------------------------------------
-- メンバ変数
SpriteATK.kind         = nil
SpriteATK.type         = nil       -- タイプ：地面　＆　飛行
SpriteATK.atk          = nil       -- 攻撃力

SpriteATK.armature     = nil

SpriteATK.active     = nil

SpriteATK.gameLayer    = nil
--------------------------------------------------------------------------------
-- UI変数
SpriteATK.label_atk         = nil
--------------------------------------------------------------------------------
-- constructor
function SpriteATK:ctor()
    self.active = true
end
--------------------------------------------------------------------------------
-- Init
function SpriteATK:init(data)
    if data then
        self.kind       = data.kind
        self.type       = data.type
        self.atk        = data.atk
    end
    self:setScale(0.25)
    self:setTextureRect(cc.rect(0,0,self:getContentSize().width,self:getContentSize().height))
    self.label_atk = cc.Label:createWithBMFont("Font/arial-14.fnt", self.atk)
    self.label_atk:setSystemFontSize(30)
    self.label_atk:setPosition(self:getContentSize().width/2,self:getContentSize().height/2)

    self:addChild(self.label_atk)
    self:addMove(true)
end
--------------------------------------------------------------------------------
-- create
function SpriteATK:createSprite(data)
    local sprite = SpriteATK.new()
    sprite:init(data)
    return sprite
end

-- 碰撞
function SpriteATK:hurt(damageValue)
    print("######### SpriteATK hurt")
    self.atk = self.atk - damageValue
    if self.atk <= 0 then
        self.atk = 0
    end

    if self.atk <= 0 then
        self.active = false
    end
end
--------------------------------------------------------------------------------
-- isActive
function SpriteATK:isActive()
    return self.active
end
--------------------------------------------------------------------------------
-- add move
function SpriteATK:addMove(isFromLeft)
    local mvToX
    if isFromLeft then
        mvToX = WIN_SIZE.width
    else
        mvToX = 0
    end
    local delay = cc.DelayTime:create(2.0)
    local mv = cc.MoveTo:create(20.0, cc.p(mvToX,400))
    local function callBack()
--        self:removeFromParent()
        print("########### end")
    end
    local func = cc.CallFunc:create(callBack)
    self:runAction(cc.Sequence:create(mv, delay, func))
end

function SpriteATK:remove()
    local remove = cc.RemoveSelf:create()
    self:runAction(remove)
    self.active = false
end

return SpriteATK