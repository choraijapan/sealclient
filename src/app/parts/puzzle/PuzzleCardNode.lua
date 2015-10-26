--------------------------------------------------------------------------------
-- PuzzleCardNode
local PuzzleCardNode = class("PuzzleCardNode", cc.Node)
--------------------------------------------------------------------------------
-- const変数
local TAG = "PuzzleCardNode:"
local CSBFILE = "parts/puzzle/PuzzleCardNode.csb"

--------------------------------------------------------------------------------
-- メンバ変数
PuzzleCardNode.parent = nil
PuzzleCardNode.cards = {
    card1 = nil,
    card2 = nil,
    card3 = nil,
    card4 = nil,
    card5 = nil,
    card6 = nil

}

PuzzleCardNode.energyBar = {
    energyBar1 = nil,
    energyBar2 = nil,
    energyBar3 = nil,
    energyBar4 = nil,
    energyBar5 = nil,
    energyBar6 = nil

}


--------------------------------------------------------------------------------
-- UI変数
--------------------------------------------------------------------------------
-- constructor
function PuzzleCardNode:ctor()
end
--------------------------------------------------------------------------------
-- create
function PuzzleCardNode:create()
    self.gameCardNode = WidgetLoader:loadCsbFile(CSBFILE)
    self:addChild(self.gameCardNode)
    self:init()
    return self
end
--------------------------------------------------------------------------------
-- Init
function PuzzleCardNode:init()
    local cardNode_1 = WidgetObj:searchWidgetByName(self,"CardNode_1","cc.Node")
    local cardNode_2 = WidgetObj:searchWidgetByName(self,"CardNode_2","cc.Node")
    local cardNode_3 = WidgetObj:searchWidgetByName(self,"CardNode_3","cc.Node")
    local cardNode_4 = WidgetObj:searchWidgetByName(self,"CardNode_4","cc.Node")
    local cardNode_5 = WidgetObj:searchWidgetByName(self,"CardNode_5","cc.Node")
    local cardNode_6 = WidgetObj:searchWidgetByName(self,"CardNode_6","cc.Node")
	self.cards.card1 = WidgetObj:searchWidgetByName(cardNode_1,"Card","cc.Sprite")
    self.cards.card2 = WidgetObj:searchWidgetByName(cardNode_2,"Card","cc.Sprite")
    self.cards.card3 = WidgetObj:searchWidgetByName(cardNode_3,"Card","cc.Sprite")
    self.cards.card4 = WidgetObj:searchWidgetByName(cardNode_4,"Card","cc.Sprite")
    self.cards.card5 = WidgetObj:searchWidgetByName(cardNode_5,"Card","cc.Sprite")
    self.cards.card6 = WidgetObj:searchWidgetByName(cardNode_6,"Card","cc.Sprite")
    self.cards.card1.energyBar = WidgetObj:searchWidgetByName(cardNode_1,"EnergyBar","ccui.LoadingBar")
    self.cards.card2.energyBar = WidgetObj:searchWidgetByName(cardNode_2,"EnergyBar","ccui.LoadingBar")
    self.cards.card3.energyBar = WidgetObj:searchWidgetByName(cardNode_3,"EnergyBar","ccui.LoadingBar")
    self.cards.card4.energyBar = WidgetObj:searchWidgetByName(cardNode_4,"EnergyBar","ccui.LoadingBar")
    self.cards.card5.energyBar = WidgetObj:searchWidgetByName(cardNode_5,"EnergyBar","ccui.LoadingBar")
    self.cards.card6.energyBar = WidgetObj:searchWidgetByName(cardNode_6,"EnergyBar","ccui.LoadingBar")

    self.cards.card1.energyBar:setPercent(0)
    self.cards.card2.energyBar:setPercent(0)
    self.cards.card3.energyBar:setPercent(0)
    self.cards.card4.energyBar:setPercent(0)
    self.cards.card5.energyBar:setPercent(0)
    self.cards.card6.energyBar:setPercent(0)

    self.cards.card1.energy = 0
    self.cards.card2.energy = 0
    self.cards.card3.energy = 0
    self.cards.card4.energy = 0
    self.cards.card5.energy = 0
    self.cards.card6.energy = 0

    self.cards.card1.attribute = 1
    self.cards.card2.attribute = 2
    self.cards.card3.attribute = 3
    self.cards.card4.attribute = 1
    self.cards.card5.attribute = 4
    self.cards.card6.attribute = 5
    self.gameCardNode:setPosition(cc.p(0,cc.Director:getInstance():getWinSize().height*1/2 + 60))

    self:addTouch()
end
--------------------------------------------------------------------------------
-- add touch
function PuzzleCardNode:addTouch()

    -- タッチ開始時に呼ばれる関数
    local function onTouchBegan(touch, event)
       --local target = event:getCurrentTarget()
       --local nodepos = target:getParent():convertTouchToNodeSpace(touch)
       --local box = target:getBoundingBox()
       --if cc.rectContainsPoint(box, nodepos) then
       --    print("#######################"..target.attribute)
       --    return true
       --end
        return true -- 開始イベントの関数はtrueを返す
    end

    -- タッチしながら指を動かしている時に呼ばれる関数
    local function onTouchMoved(touch, event)

    end

    -- タッチを離した時に呼ばれる関数
    local function onTouchEnded(touch, event)

    end

    -- タッチイベントで呼ばれる関数を登録
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED )

    -- このレイヤーでのタッチイベント取得を有効化
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end
--------------------------------------------------------------------------------
-- add energy
function PuzzleCardNode:setEnergy(card,per)
    card.energyBar:setPercent(per)
    if per == 100 then
        self:setCanSkillEffect(card)
    end
end
--------------------------------------------------------------------------------
-- card can make a skill atk effect
function PuzzleCardNode:setCanSkillEffect(card)
    print("################# skill")
    local action = cc.Blink:create(2, 10)
    card:runAction(cc.RepeatForever:create(action))
end
--------------------------------------------------------------------------------
-- addAtkEffect
function PuzzleCardNode:addCardAtk(data)
    for key, var in pairs(self.cards) do
        if data.type == var.attribute then
            print("############################# ATK EFFECT")
            local emitter = cc.ParticleSystemQuad:create("battle/particle_atk2.plist")
            self:getParent():getParent():addChild(emitter,1111111)
            emitter:setPosition(data.startPos)
            emitter:setAnchorPoint(cc.p(0.5, 0.5))
            local action1 = cc.MoveTo:create(0.5,var:getParent():convertToWorldSpace(cc.p(var:getPositionX(),var:getPositionY())))
            local action2 = cc.RemoveSelf:create()

            local function cardAtkEffect()
                local action1 = cc.JumpBy:create(0.3, cc.p(0,0), 10, 1)
                var:runAction(cc.Sequence:create(action1))
                self:broadEventDispatcher(data)
            end
            local callFunc1 = cc.CallFunc:create(cardAtkEffect)
            emitter:runAction(cc.Sequence:create(action1, action2,callFunc1))

            local energyPoint = data.count * 2

            var.energy = var.energy + energyPoint
            if var.energy > 100 then
                var.energy = 100
            end

            self:setEnergy(var,var.energy)
        end
    end
end

--------------------------------------------------------------------------------
-- broadEventDispatcher
function PuzzleCardNode:broadEventDispatcher(data)
    data.damage = 10000
    data.atkBossEffect = "effect/game/card_atk_001.plist"
    EventDispatchManager:broadcastEventDispatcher("SPRITE_CARD_ATK",data)
end

--------------------------------------------------------------------------------
-- TODO
function PuzzleCardNode:addEventDispatcher()
    local function callBack(event)
        local data = event._data
        if data.action == "atk" then
            self:hurt(data.damage)
        end
    end
    EventDispatchManager:createEventDispatcher(self,"todo",callBack)
end

return PuzzleCardNode


