local BlockLayer = require("app.parts.common.BlockLayer")
--------------------------------------------------------------------------------
-- PuzzleCardNode
local PuzzleCardNode = class("PuzzleCardNode", cc.Node)

require("app.layer.puzzle.PuzzleManager")
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

PuzzleCardNode.hp = 0
PuzzleCardNode.maxHp = 0
PuzzleCardNode.cardNode = {}
PuzzleCardNode.hpBar = nil
PuzzleCardNode.ferverBar = nil
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

function PuzzleCardNode:update()

end

function PuzzleCardNode:addSchedule()
	local function update(dt)
		self:update(dt)
	end
	self:scheduleUpdateWithPriorityLua(update,0)
end
--------------------------------------------------------------------------------
-- Init
function PuzzleCardNode:init()
	self:addSchedule()
	self:addEventDispatcher()
	self:addFerverBar()
	-- TODO 通信,JSON情報
	local jsonData = {
		card = {
			[1] = {
				id = "images/card/weapon_menu_playerimage_arrow.png",
				hp = 6000,
				attribute = GameConst.ATTRIBUTE.FIRE,
				atk = {
					value = 12241,
					effect = "images/particles/effect_prt_142_1.plist"
				},
				skill = {
					name = "人生はただ一度だけ切り",
					description = "人生はただ一度だけ切り",
					type = 1, -- atk
					value = 1000000, --
					effect = "images/particles/effect_prt_142_1.plist"
				}
			},
			[2] = {
				id = "images/card/weapon_menu_playerimage_axe.png",
				hp = 6000,
				attribute = GameConst.ATTRIBUTE.WATER,
				atk = {
					value = 12241,
					effect = "images/particles/effect_prt_1025.plist"
				},
				skill = {
					name = "人生はただ一度だけ切り",
					description = "人生はただ一度だけ切り",
					type = 5, -- remove ball
					value = 4,
					effect = "images/particles/effect_prt_1025.plist"
				}
			},
			[3] = {
				id = "images/card/weapon_menu_playerimage_wond.png",
				hp = 8000,
				attribute = GameConst.ATTRIBUTE.FIRE,
				atk = {
					value = 12241,
					effect = "images/particles/effect_prt_142_1.plist"
				},
				skill = {
					name = "人生はただ一度だけ切り",
					description = "人生はただ一度だけ切り",
					type = 4, -- control:change
					value = {4,3}, --change from , to
					effect = GameConst.PARTICLE.ATK_SWORD
				}
			},
			[4] = {
				id = "images/card/weapon_menu_playerimage_twinsword.png",
				hp = 9000,
				attribute = GameConst.ATTRIBUTE.DARK,
				atk = {
					value = 12241,
					effect = "images/particles/effect_prt_1012R.plist"
				},
				skill = {
					name = "人生はただ一度だけ切り",
					description = "人生はただ一度だけ切り",
					type = 4, -- control:change
					value = {4,3}, --change from , to
					effect = "images/particles/effect_prt_1012R.plist"
				}
			},
			[5] = {
				id = "images/card/weapon_menu_playerimage_axe.png",
				hp = 14000,
				attribute = GameConst.ATTRIBUTE.TREE,
				atk = {
					value = 12241,
					effect = "images/particles/eff_page_723_1.plist"
				},
				skill = {
					name = "人生はただ一度だけ切り",
					description = "人生はただ一度だけ切り",
					type = 3, -- Healing
					value = 20000,
					effect = "images/particles/eff_page_723_1.plist"
				}
			},
--			[6] = {
--				id = "images/card/weapon_menu_playerimage_sword.png",
--				hp = 4000,
--				attribute = GameConst.ATTRIBUTE.FIRE,
--				atk = {
--					value = 8241,
--					effect = GameConst.PARTICLE.ATK_FIRE
--				},
--				skill = {
--					name = "人生はただ一度だけ切り",
--					description = "人生はただ一度だけ切り",
--					type = 1, -- atk
--					value = 1500000, --
--					effect = GameConst.PARTICLE.ATK_SWORD
--				}
--			}
		}
	}
	self.hpBar = WidgetObj:searchWidgetByName(self,"HpBar","ccui.LoadingBar")

	for i,v in ipairs(jsonData.card) do
		self.cards[i] = {}
		self.cards[i].CCUI_CardNode =  WidgetObj:searchWidgetByName(self,"CardNode_"..i,"cc.Node")
		self.cards[i].CCUI_Card = WidgetObj:searchWidgetByName(self.cards[i].CCUI_CardNode,"Card","ccui.ImageView")
		self.cards[i].CCUI_CardFrame = WidgetObj:searchWidgetByName(self.cards[i].CCUI_CardNode,"CardFrame","ccui.ImageView")
		self.cards[i].CCUI_EnergyBar = WidgetObj:searchWidgetByName(self.cards[i].CCUI_CardNode,"EnergyBar","ccui.LoadingBar")
		self.cards[i].CCUI_CardBg = WidgetObj:searchWidgetByName(self.cards[i].CCUI_CardNode,"CardFrame","ccui.Panel")
		self.cards[i].CCUI_Card:loadTexture(v.id)
		self.cards[i].CCUI_CardFrame:loadTexture(GameConst.CARD_FRAME_PNG[v.attribute])
		self.cards[i].CCUI_EnergyBar:setPercent(0)
		TouchManager:pressedDown(self.cards[i].CCUI_Card,
			function()
				self:touchCard(self.cards[i])
			end)
		self.cards[i].energy = 0
		self.cards[i].attribute = v.attribute
		self.cards[i].atk =  v.atk
		self.cards[i].skill = v.skill			
		self.hp = self.hp + v.hp
	end
	self.maxHp = self.hp
	self.isActive = true
	self.hpBar:setPercent(100)

	self.gameCardNode:setPosition(cc.p(0, 0))
--	self.gameCardNode:setPosition(cc.p(0,20))
end

--------------------------------------------------------------------------------
-- cardSkillDrawed
function PuzzleCardNode:cardSkillDrawed(skill)
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
function PuzzleCardNode:touchCard(obj)
	if obj.energy >= 100 and self.isActive then
		GameUtils:pauseAll(self:getParent())
		-- スキル発動
		self:drawSkill(obj)
	end
end
--------------------------------------------------------------------------------
-- skill 発動　３.5秒のEffect と　攻撃のダメージをBOSSに与えるため、BroadCastする
function PuzzleCardNode:drawSkill(obj)
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
		str:setPosition(cc.p(AppConst.VISIBLE_SIZE.width/2,AppConst.VISIBLE_SIZE.height/2-cardSpriteSize.height/2))
		str:setColor(cc.c3b(255,255,0))
		str:setString(txt)
		return str
	end

	-- create card character
	local function createCardCara()
		cardSprite:setAnchorPoint(cc.p(0.5,0.5))
		cardSprite:setPosition(cc.p(-cardSpriteSize.width/2,AppConst.VISIBLE_SIZE.height/2))
		local action1 = cc.DelayTime:create(0.1)
		local action2 = cc.MoveTo:create(0.1,cc.p(AppConst.VISIBLE_SIZE.width/2,AppConst.VISIBLE_SIZE.height/2))
		local action3 =  cc.MoveTo:create(0.7,cc.p(AppConst.VISIBLE_SIZE.width/2+10,AppConst.VISIBLE_SIZE.height/2))
		local action4 =  cc.MoveTo:create(0.1,cc.p(AppConst.VISIBLE_SIZE.width + cardSpriteSize.width/2,AppConst.VISIBLE_SIZE.height/2))
		cardSprite:runAction(cc.Sequence:create(action1, action2, action3, action4))
		return cardSprite
	end
--	local emitter = GameUtils:createParticle(GameConst.PARTICLE.SNOW,GameConst.PARTICLE_PNG.SNOW)
	
	local cardSprite = createCardCara()
	local blockLayer = BlockLayer:create()
	local text = createText(obj.skill.name)
	node:addChild(mask,0)
--	node:addChild(emitter, 1)
	node:addChild(blockLayer, 2)
	node:addChild(cardSprite, 3)
	node:addChild(text, 4)
	
	self:addChild(node,999)
	-- TODO 攻撃BroadCast
	
end

--------------------------------------------------------------------------------
-- add energy
function PuzzleCardNode:setEnergy(card,per)
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
function PuzzleCardNode:changeHp(value)
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
function PuzzleCardNode:makeSkillEffect(card,isDraw)
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
function PuzzleCardNode:ballToCard(data)
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
function PuzzleCardNode:addCardDamageNumber(obj,num)
	local label_dm = GameUtils:createTextAtlas(num)
	obj:addChild(label_dm,111)
	GameUtils:addAtkNumberAction(label_dm)
end
--------------------------------------------------------------------------------
-- broadEventDispatcher
function PuzzleCardNode:atkBoss(data)
	EventDispatchManager:broadcastEventDispatcher("SPRITE_CARD_ATK",data)
end

--------------------------------------------------------------------------------
-- addEventDispatcher
function PuzzleCardNode:addEventDispatcher()
	local function callBack(event)
		print("############ hurted !!!")
		local data = event._data
		if data.action == "atk" then
			self:hurt(data.damage)
		end
	end
	EventDispatchManager:createEventDispatcher(self,"BOSS_ATK_EVENT",callBack)
end

--------------------------------------------------------------------------------
-- hurt
function PuzzleCardNode:hurt(value)
	self:changeHp(-value)
	GameUtils:shakeNode(self.gameCardNode,0.2)
end
--------------------------------------------------------------------------------
-- healing
function PuzzleCardNode:cardHeal(value)
	self:changeHp(value)
	local emitter = GameUtils:createParticle(GameConst.PARTICLE.HEAL,nil)
	emitter:setAnchorPoint(0,0.5)
	emitter:setPosition(self.hpBar:getPosition())
	self.hpBar:addChild(emitter,1)
end
--------------------------------------------------------------------------------
-- atk boss
function PuzzleCardNode:cardAtk(value)

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
--------------------------------------------------------------------------------
-- isAllDead
function PuzzleCardNode:isAllDead()
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

function PuzzleCardNode:addFerverBar()
	local bg = WidgetObj:searchWidgetByName(self,"EnBar","ccui.LoadingBar")
	self.ferverBar = cc.ProgressTimer:create(cc.Sprite:create(GameConst.PUZZLE_PNG.FERVER_BAR))
	self.ferverBar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	self.ferverBar:setAnchorPoint(cc.p(0,0))
	self.ferverBar:setMidpoint(cc.p(0, 0))
	self.ferverBar:setBarChangeRate(cc.p(1, 0))
	bg:addChild(self.ferverBar,GameConst.ZOrder.Z_FerverBar)
end

return PuzzleCardNode













