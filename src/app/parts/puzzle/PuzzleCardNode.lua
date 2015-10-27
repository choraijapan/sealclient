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
	local data = {
		deck = {
			card1 = {
			},
			card2 = {
			},
			card3 = {
			},
			card4 = {
			},
			card5 = {
			}
		},
		friendCard = {
			card = {
			}
		}
	}
	local cardNode_1 = WidgetObj:searchWidgetByName(self,"CardNode_1","cc.Node")
	local cardNode_2 = WidgetObj:searchWidgetByName(self,"CardNode_2","cc.Node")
	local cardNode_3 = WidgetObj:searchWidgetByName(self,"CardNode_3","cc.Node")
	local cardNode_4 = WidgetObj:searchWidgetByName(self,"CardNode_4","cc.Node")
	local cardNode_5 = WidgetObj:searchWidgetByName(self,"CardNode_5","cc.Node")
	local cardNode_6 = WidgetObj:searchWidgetByName(self,"CardNode_6","cc.Node")
	self.cards.card1 = WidgetObj:searchWidgetByName(cardNode_1,"Card","ccui.ImageView")
	self.cards.card2 = WidgetObj:searchWidgetByName(cardNode_2,"Card","ccui.ImageView")
	self.cards.card3 = WidgetObj:searchWidgetByName(cardNode_3,"Card","ccui.ImageView")
	self.cards.card4 = WidgetObj:searchWidgetByName(cardNode_4,"Card","ccui.ImageView")
	self.cards.card5 = WidgetObj:searchWidgetByName(cardNode_5,"Card","ccui.ImageView")
	self.cards.card6 = WidgetObj:searchWidgetByName(cardNode_6,"Card","ccui.ImageView")
	self.cards.card1.energyBar = WidgetObj:searchWidgetByName(cardNode_1,"EnergyBar","ccui.LoadingBar")
	self.cards.card2.energyBar = WidgetObj:searchWidgetByName(cardNode_2,"EnergyBar","ccui.LoadingBar")
	self.cards.card3.energyBar = WidgetObj:searchWidgetByName(cardNode_3,"EnergyBar","ccui.LoadingBar")
	self.cards.card4.energyBar = WidgetObj:searchWidgetByName(cardNode_4,"EnergyBar","ccui.LoadingBar")
	self.cards.card5.energyBar = WidgetObj:searchWidgetByName(cardNode_5,"EnergyBar","ccui.LoadingBar")
	self.cards.card6.energyBar = WidgetObj:searchWidgetByName(cardNode_6,"EnergyBar","ccui.LoadingBar")

	TouchManager:pressedDown(self.cards.card1,
		function()
			self:touchCard(self.cards.card1)
		end)
	TouchManager:pressedDown(self.cards.card2,
		function()
			self:touchCard(self.cards.card2)
		end)
	TouchManager:pressedDown(self.cards.card3,
		function()
			self:touchCard(self.cards.card3)
		end)
	TouchManager:pressedDown(self.cards.card4,
		function()
			self:touchCard(self.cards.card4)
		end)
	TouchManager:pressedDown(self.cards.card5,
		function()
			self:touchCard(self.cards.card5)
		end)
	TouchManager:pressedDown(self.cards.card6,
		function()
			self:touchCard(self.cards.card6)
		end)


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

end
--------------------------------------------------------------------------------
-- touchCard
function PuzzleCardNode:touchCard(obj)
	self:setEnergy(obj,0)
	-- スキル発動
	self:drawSkill(obj)
end

--------------------------------------------------------------------------------
-- skill 発動　３秒のEffect と　攻撃のダメージをBOSSに与えるため、BroadCastする
function PuzzleCardNode:drawSkill(obj)

	--	local listener = function(eventType, x, y)
	--		if eventType == cc.Handler.EVENT_TOUCH_BEGAN then
	--			return self:touch_began(x, y)
	--		elseif eventType == CCTOUCHMOVED then
	--			self:touch_moved(x, y)
	--		elseif eventType == CCTOUCHENDED then
	--			self:touch_ended(x, y)
	--		elseif eventType == CCTOUCHCANCELLED then
	--			self:touch_cancelled(x, y)
	--		end
	--	end
--	mask:registerScriptTouchHandler(listener, false, -999999999, true)
	-- http://blog.csdn.net/wwj_748/article/details/34494613
	-- Effectを表示する
	local mask = self:createMaskLayer()
	self:getParent():addChild(mask,999)
	mask:setTouchEnabled(true)

	local action1 = cc.DelayTime:create(3)
	local action2 = cc.FadeOut:create(0.5)
	local action3 = cc.RemoveSelf:create()
	mask:runAction(cc.Sequence:create(action1, action2,action3))
	-- 攻撃BroadCast TODO

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

--------------------------------------------------------------------------------
-- createMaskLayer
function PuzzleCardNode:createMaskLayer()
	local layer = cc.LayerColor:create(cc.c3b(0, 0, 0),999999,999999)
	layer:setPosition(cc.p(0, 0))
	layer:setAnchorPoint(cc.p(0.5, 0.5))
	layer:setOpacity(200)
	return layer
end

return PuzzleCardNode


