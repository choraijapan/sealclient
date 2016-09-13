local BlockLayer = require("app.parts.common.BlockLayer")
--------------------------------------------------------------------------------
-- PuzzleUILayer
local PuzzleManager = require("app.layer.puzzle.PuzzleManager")

local PuzzleUILayer = class("PuzzleUILayer", function()
	return cc.Layer:create()
end)

function PuzzleUILayer:ctor()

end

--------------------------------------------------------------------------------
-- const変数
local TAG = "PuzzleUILayer:"
local CSBFILE = "res/layer/puzzle/PuzzleUILayer.csb"
--------------------------------------------------------------------------------
-- メンバ変数
PuzzleUILayer.parent = nil
PuzzleUILayer.cards = {
	card1 = nil,
	card2 = nil,
	card3 = nil,
	card4 = nil,
	card5 = nil,
	card6 = nil

}
PuzzleUILayer.gameCardNode = nil
PuzzleUILayer.hp = 0
PuzzleUILayer.maxHp = 0
PuzzleUILayer.cardNode = {}
PuzzleUILayer.hpBar = nil
PuzzleUILayer.ferverBar = nil
--------------------------------------------------------------------------------
-- UI変数

--------------------------------------------------------------------------------
-- constructor
function PuzzleUILayer:ctor()
end
--------------------------------------------------------------------------------
-- create
function PuzzleUILayer:create()
	local layer = PuzzleUILayer.new()
	self.gameCardNode = WidgetLoader:loadCsbFile(CSBFILE)
	layer:addChild(self.gameCardNode)
	layer:init()
	return layer
    
end

function PuzzleUILayer:update()

end

function PuzzleUILayer:addSchedule()
	local function update(dt)
		self:update(dt)
	end
	self:scheduleUpdateWithPriorityLua(update,0)
end
--------------------------------------------------------------------------------
-- Init
function PuzzleUILayer:init()
	self:addSchedule()
	self:addEventDispatcher()
	self.Node_Status_Mine = WidgetObj:searchWidgetByName(self,"Node_Status_Mine",WidgetConst.OBJ_TYPE.Node)
	--self.hpBar = WidgetObj:searchWidgetByName(self.Node_Status_Mine,"LoadingBar","ccui.LoadingBar")
    
	--self.hpBar = WidgetObj:searchWidgetByName(self.Node_Status_Mine,"LoadingBar","ccui.LoadingBar")
--	self.ferverBar = WidgetObj:searchWidgetByName(self.Node_Status_Mine,"LoadingBar","ccui.LoadingBar")
	self:addFerverBar()
--	self.hp = 50000
--	self.maxHp = self.hp
--	self.isActive = true
	--self.hpBar:setPercent(100)
	
	
	self.gameCardNode:setPosition(cc.p(0, 0))
	--	self.gameCardNode:setPosition(cc.p(0,20))
end

--------------------------------------------------------------------------------
-- cardSkillDrawed
function PuzzleUILayer:cardSkillDrawed(skill)
	local function callBack()
		GameUtils:resumeAll(self:getParent())
	end

	if skill.type == GameConst.CardType.ATK then
		local data = {
			action = "atkBoss",
			damage = skill.value,
			effect = skill.effect
		}
		callBack()
		self:atkBoss(data)
	elseif skill.type == GameConst.CardType.HEAL then
		callBack()
		self:cardHeal(skill.value)
	elseif skill.type == GameConst.CardType.CONTROL then
		PuzzleManager:changeBall(skill.value[1],skill.value[2],callBack)
	elseif skill.type == GameConst.CardType.REMOVE then
		PuzzleManager:removeBall(skill.value,callBack)
	end
end
--------------------------------------------------------------------------------
-- touchCard
function PuzzleUILayer:touchCard(obj)
	if obj.energy >= 100 and self.isActive then
		GameUtils:pauseAll(self:getParent())
		-- スキル発動
		self:drawSkill(obj)
	end
end
--------------------------------------------------------------------------------
-- skill 発動　３.5秒のEffect と　攻撃のダメージをBOSSに与えるため、BroadCastする
function PuzzleUILayer:drawSkill(obj)
	local function stopAction()
		self:cardSkillDrawed(obj.skill)
	end

	self:setEnergy(obj,0)
	-- Effectを表示する
	local node = cc.Node:create()
	local mask = GameUtils:createMaskLayer()
	mask:setTouchEnabled(true)
	local action1 = cc.DelayTime:create(1)
	local action2 = cc.DelayTime:create(0.1)
	local action3 = cc.CallFunc:create(stopAction)
	local action4 = cc.FadeOut:create(0.3)
	local action5 = cc.RemoveSelf:create()
	node:runAction(cc.Sequence:create(action1, action2,action3,action4,action5))
	local cardSprite = cc.Sprite:create("images/boss/20151018.png") --TODO
	local cardSpriteSize = cardSprite:getContentSize()

	local function createText(txt)
		local str = cc.Label:createWithSystemFont("", "HelveticaNeue-Bold", 30)
		str:setPosition(cc.p(AppConst.DESIGN_SIZE.width/2,AppConst.DESIGN_SIZE.height/2-cardSpriteSize.height/2))
		str:setColor(cc.c3b(255,255,0))
		str:setString(txt)
		return str
	end

	-- create card character
	local function createCardCara()
		cardSprite:setAnchorPoint(cc.p(0.5,0.5))
		cardSprite:setPosition(cc.p(AppConst.DESIGN_SIZE.width + 200,AppConst.DESIGN_SIZE.height/2))
		local action1 = cc.DelayTime:create(0.1)
		local action2 = cc.MoveTo:create(0.1,cc.p(AppConst.DESIGN_SIZE.width/2,AppConst.DESIGN_SIZE.height/2))
		local action3 =  cc.MoveTo:create(0.7,cc.p(AppConst.DESIGN_SIZE.width/2 - 10,AppConst.DESIGN_SIZE.height/2))
		local action4 =  cc.MoveTo:create(0.1,cc.p(-AppConst.DESIGN_SIZE.width - cardSpriteSize.width/2,AppConst.DESIGN_SIZE.height/2))
		cardSprite:runAction(cc.Sequence:create(action1, action2, action3, action4))
		return cardSprite
	end

	local emitter = GameUtils:createParticle(GameConst.PARTICLE.SKILL_BG,nil)
	emitter:setScale(1.5)
	emitter:setPosition(cc.p(0,AppConst.DESIGN_SIZE.height/2))
	local cardSprite = createCardCara()
	local blockLayer = BlockLayer:create()
	local text = createText(obj.skill.name)
	node:addChild(mask,0)
	node:addChild(blockLayer, 2)
	node:addChild(emitter,2)
	node:addChild(cardSprite, 3)
	node:addChild(text, 4)

	self:addChild(node,999)
	-- TODO 攻撃BroadCast

end

--------------------------------------------------------------------------------
-- add energy
function PuzzleUILayer:setEnergy(card,per)
	card.CCUI_EnergyBar:setPercent(per)
	card.energy = per
	if per == 100 then
		self:makeSkillEffect(card,true)
	else
		self:makeSkillEffect(card,false)
	end
end
--------------------------------------------------------------------------------
-- change hp
function PuzzleUILayer:changeHp(value)
	self.hp = self.hp + value
	local per = (self.hp / self.maxHp) * 100
	self.hpBar:setPercent(per)
	if self.hp <= 0 then
		self.hpBar:setPercent(0)
		self.isActive = false
	else
		self.hpBar:setPercent(per)
	end
end

--------------------------------------------------------------------------------
-- card can make a skill atk effect
function PuzzleUILayer:makeSkillEffect(card,isDraw)
	local action = cc.FadeTo:create(0.3, 0)
	local action2 = cc.FadeTo:create(0.3, 255)

	local function stopAction()
		card.CCUI_EnergyBar:stopAllActions()
	end
	local callFunc1 = cc.CallFunc:create(stopAction)

	if isDraw then
		card.CCUI_EnergyBar:runAction(cc.RepeatForever:create(cc.Sequence:create(action,action2)))
	else
		card.CCUI_EnergyBar:runAction(cc.Sequence:create(action2,callFunc1))
	end
end
--------------------------------------------------------------------------------
-- ballToCard
function PuzzleUILayer:ballToCard(data)
	for key, var in pairs(self.cards) do
		if data.type == var.attribute then

			local emitter = GameUtils:createParticle(GameConst.PARTICLE[var.attribute],nil)

			self:getParent():getParent():addChild(emitter,1111111)
			emitter:setPosition(data.startPos)
			local action1 = cc.MoveTo:create(0.5,var.CCUI_Card:getParent():convertToWorldSpace(cc.p(var.CCUI_Card:getPositionX(),var.CCUI_Card:getPositionY())))
			local action2 = cc.RemoveSelf:create()

			local function cardAtkEffect()
				local action1 = cc.JumpBy:create(0.3, cc.p(0,0), 10, 1)
				var.CCUI_Card:getParent():runAction(cc.Sequence:create(action1))

				-- attack boos ： skill effect on boss  TODO 計算式
				local ferverPoint = 1
				if data.isFerver then
					ferverPoint = 2
				end
				data.damage = ferverPoint * (1 + data.combol/100) * data.count * var.atk.value
				data.effect = var.atk.effect
				self:atkBoss(data)

				local damageNumber = data.damage
				self:addCardDamageNumber(var.CCUI_Card:getParent(),damageNumber)
			end
			local callFunc1 = cc.CallFunc:create(cardAtkEffect)
			emitter:runAction(cc.Sequence:create(action1, action2,callFunc1))

			local energyPoint = data.count * 4

			var.energy = var.energy + energyPoint
			if var.energy > 100 then
				var.energy = 100
			end

			self:setEnergy(var,var.energy)
		end
	end
end
--------------------------------------------------------------------------------
-- addCardDamageNumber
function PuzzleUILayer:addCardDamageNumber(obj,num)
	local label_dm = GameUtils:createTextAtlas(num)
	obj:addChild(label_dm,111)
	GameUtils:addAtkNumberAction(label_dm)
end
--------------------------------------------------------------------------------
-- broadEventDispatcher
function PuzzleUILayer:atkBoss(data)
	EventDispatchManager:broadcastEventDispatcher("SPRITE_CARD_ATK",data)
end

--------------------------------------------------------------------------------
-- addEventDispatcher
function PuzzleUILayer:addEventDispatcher()
--	local function callBack(event)
--		print("############ hurted !!!")
--		local data = event._data
--		if data.action == "atk" then
--			self:hurt(data.damage)
--		end
--	end
--	EventDispatchManager:createEventDispatcher(self,"BOSS_ATK_EVENT",callBack)
end

--------------------------------------------------------------------------------
-- hurt
function PuzzleUILayer:hurt(value)
	self:changeHp(-value)
	GameUtils:shakeNode(self.gameCardNode,0.2)
end
--------------------------------------------------------------------------------
-- healing
function PuzzleUILayer:cardHeal(value)
	self:changeHp(value)
	local emitter = GameUtils:createParticle(GameConst.PARTICLE.HEAL,nil)
	emitter:setAnchorPoint(0,0.5)
	emitter:setPosition(self.hpBar:getPosition())
	self.hpBar:addChild(emitter,1)
end
--------------------------------------------------------------------------------
-- atk boss
function PuzzleUILayer:cardAtk(value)

end
--------------------------------------------------------------------------------
-- createMaskLayer
function PuzzleUILayer:createMaskLayer()
	local layer = cc.LayerColor:create(cc.c3b(0, 0, 0),999999,999999)
	layer:setPosition(cc.p(0, 0))
	layer:setAnchorPoint(cc.p(0.5, 0.5))
	layer:setOpacity(200)
	return layer
end
--------------------------------------------------------------------------------
-- isAllDead
function PuzzleUILayer:isAllDead()
	return self.isActive == false
		--[[
		local isActive = true
		for key, var in ipairs(self.cards) do
		if var.isActive then
		return false
		end
		end
		return isActive
		]]--
end

function PuzzleUILayer:addFerverBar()
	local bg = WidgetObj:searchWidgetByName(self.Node_Status_Mine,"LoadingBar","ccui.LoadingBar")
	self.ferverBar = cc.ProgressTimer:create(cc.Sprite:create(GameConst.PUZZLE_PNG.FERVER_BAR))
	self.ferverBar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	self.ferverBar:setAnchorPoint(cc.p(0,0))
	self.ferverBar:setMidpoint(cc.p(0, 0))
	self.ferverBar:setBarChangeRate(cc.p(1, 0))
	if bg ~= nil then
		bg:addChild(self.ferverBar,GameConst.ZOrder.Z_FerverBar)
	end
end

return PuzzleUILayer
