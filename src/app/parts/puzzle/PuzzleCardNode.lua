local BlockLayer = require("app.parts.common.BlockLayer")
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

	-- TODO 通信,JSON情報
	local data = {
		card1 = {
		},
		card2 = {
		},
		card3 = {
		},
		card4 = {
		},
		card5 = {
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
	self.cards[1] = WidgetObj:searchWidgetByName(cardNode_1,"Card","ccui.ImageView")
	self.cards[2] = WidgetObj:searchWidgetByName(cardNode_2,"Card","ccui.ImageView")
	self.cards[3] = WidgetObj:searchWidgetByName(cardNode_3,"Card","ccui.ImageView")
	self.cards[4] = WidgetObj:searchWidgetByName(cardNode_4,"Card","ccui.ImageView")
	self.cards[5] = WidgetObj:searchWidgetByName(cardNode_5,"Card","ccui.ImageView")
	self.cards[6] = WidgetObj:searchWidgetByName(cardNode_6,"Card","ccui.ImageView")
    
	self.cards[1].CardFrame = WidgetObj:searchWidgetByName(cardNode_1,"CardFrame","ccui.ImageView")
	self.cards[2].CardFrame = WidgetObj:searchWidgetByName(cardNode_2,"CardFrame","ccui.ImageView")
	self.cards[3].CardFrame = WidgetObj:searchWidgetByName(cardNode_3,"CardFrame","ccui.ImageView")
	self.cards[4].CardFrame = WidgetObj:searchWidgetByName(cardNode_4,"CardFrame","ccui.ImageView")
	self.cards[5].CardFrame = WidgetObj:searchWidgetByName(cardNode_5,"CardFrame","ccui.ImageView")
	self.cards[6].CardFrame = WidgetObj:searchWidgetByName(cardNode_6,"CardFrame","ccui.ImageView")
    
	self.cards[1].CardFrame:loadTexture("images/Common/monster_thum_red.png")
	self.cards[2].CardFrame:loadTexture("images/Common/monster_thum_red.png")
	self.cards[3].CardFrame:loadTexture("images/Common/monster_thum_red.png")
	self.cards[4].CardFrame:loadTexture("images/Common/monster_thum_red.png")
	self.cards[5].CardFrame:loadTexture("images/Common/monster_thum_red.png")
	self.cards[6].CardFrame:loadTexture("images/Common/monster_thum_green.png")
    
	self.cards[1].CardBg = WidgetObj:searchWidgetByName(cardNode_1,"CardFrame","ccui.Panel")
	self.cards[2].CardBg = WidgetObj:searchWidgetByName(cardNode_2,"CardFrame","ccui.Panel")
	self.cards[3].CardBg = WidgetObj:searchWidgetByName(cardNode_3,"CardFrame","ccui.Panel")
	self.cards[4].CardBg = WidgetObj:searchWidgetByName(cardNode_4,"CardFrame","ccui.Panel")
	self.cards[5].CardBg = WidgetObj:searchWidgetByName(cardNode_5,"CardFrame","ccui.Panel")
	self.cards[6].CardBg = WidgetObj:searchWidgetByName(cardNode_6,"CardFrame","ccui.Panel")
    
	self.hpBar = WidgetObj:searchWidgetByName(self,"HpBar","ccui.LoadingBar")
	--	self.cards[1].hpBar = WidgetObj:searchWidgetByName(cardNode_1,"HPBar","ccui.LoadingBar")
	--	self.cards[2].hpBar = WidgetObj:searchWidgetByName(cardNode_2,"HPBar","ccui.LoadingBar")
	--	self.cards[3].hpBar = WidgetObj:searchWidgetByName(cardNode_3,"HPBar","ccui.LoadingBar")
	--	self.cards[4].hpBar = WidgetObj:searchWidgetByName(cardNode_4,"HPBar","ccui.LoadingBar")
	--	self.cards[5].hpBar = WidgetObj:searchWidgetByName(cardNode_5,"HPBar","ccui.LoadingBar")
	--	self.cards[6].hpBar = WidgetObj:searchWidgetByName(cardNode_6,"HPBar","ccui.LoadingBar")

	self.cards[1].energyBar = WidgetObj:searchWidgetByName(cardNode_1,"EnergyBar","ccui.LoadingBar")
	self.cards[2].energyBar = WidgetObj:searchWidgetByName(cardNode_2,"EnergyBar","ccui.LoadingBar")
	self.cards[3].energyBar = WidgetObj:searchWidgetByName(cardNode_3,"EnergyBar","ccui.LoadingBar")
	self.cards[4].energyBar = WidgetObj:searchWidgetByName(cardNode_4,"EnergyBar","ccui.LoadingBar")
	self.cards[5].energyBar = WidgetObj:searchWidgetByName(cardNode_5,"EnergyBar","ccui.LoadingBar")
	self.cards[6].energyBar = WidgetObj:searchWidgetByName(cardNode_6,"EnergyBar","ccui.LoadingBar")

	TouchManager:pressedDown(self.cards[1],
		function()
			self:touchCard(self.cards[1])
		end)
	TouchManager:pressedDown(self.cards[2],
		function()
			self:touchCard(self.cards[2])
		end)
	TouchManager:pressedDown(self.cards[3],
		function()
			self:touchCard(self.cards[3])
		end)
	TouchManager:pressedDown(self.cards[4],
		function()
			self:touchCard(self.cards[4])
		end)
	TouchManager:pressedDown(self.cards[5],
		function()
			self:touchCard(self.cards[5])
		end)
	TouchManager:pressedDown(self.cards[6],
		function()
			self:touchCard(self.cards[6])
		end)

	self.cards[1].energyBar:setPercent(0)
	self.cards[2].energyBar:setPercent(0)
	self.cards[3].energyBar:setPercent(0)
	self.cards[4].energyBar:setPercent(0)
	self.cards[5].energyBar:setPercent(0)
	self.cards[6].energyBar:setPercent(0)

	self.hpBar:setPercent(100)
	--	self.cards[1].hpBar:setPercent(100)
	--	self.cards[2].hpBar:setPercent(100)
	--	self.cards[3].hpBar:setPercent(100)
	--	self.cards[4].hpBar:setPercent(100)
	--	self.cards[5].hpBar:setPercent(100)
	--	self.cards[6].hpBar:setPercent(100)

	self.cards[1].maxHp = 4241
	self.cards[2].maxHp = 1234
	self.cards[3].maxHp = 2355
	self.cards[4].maxHp = 800
	self.cards[5].maxHp = 1235
	self.cards[6].maxHp = 6000
    
	self.cards[1].atk = 8241
	self.cards[2].atk = 2234
	self.cards[3].atk = 3355
	self.cards[4].atk = 5800
	self.cards[5].atk = 2235
	self.cards[6].atk = 3000
	
    self.hp = 0
	self.maxHp = 0
    for key, var in ipairs(self.cards) do
		self.hp = self.hp + var.maxHp
		self.maxHp = self.hp + var.maxHp
    end
      
--	self.cards[1].hp = self.cards[1].maxHp
--	self.cards[2].hp = self.cards[2].maxHp
--	self.cards[3].hp = self.cards[3].maxHp
--	self.cards[4].hp = self.cards[4].maxHp
--	self.cards[5].hp = self.cards[5].maxHp
--	self.cards[6].hp = self.cards[6].maxHp

	self.cards[1].energy = 0
	self.cards[2].energy = 0
	self.cards[3].energy = 0
	self.cards[4].energy = 0
	self.cards[5].energy = 0
	self.cards[6].energy = 0

	self.isActive = true
--	self.cards[1].isActive = true
--	self.cards[2].isActive = true
--	self.cards[3].isActive = true
--	self.cards[4].isActive = true
--	self.cards[5].isActive = true
--	self.cards[6].isActive = true

	self.cards[1].attribute = GameConst.ATTRIBUTE.FIRE
	self.cards[2].attribute = GameConst.ATTRIBUTE.FIRE
	self.cards[3].attribute = GameConst.ATTRIBUTE.FIRE
	self.cards[4].attribute = GameConst.ATTRIBUTE.FIRE
	self.cards[5].attribute = GameConst.ATTRIBUTE.FIRE
	self.cards[6].attribute = GameConst.ATTRIBUTE.TREE

	self.cards[1].skill = {
		name = "進撃のパンツ",
		description = "人生はただ一度だけ切り",
		type = 1, -- healing
		value = 100000,
		effect = ""
	}
	self.cards[2].skill = {
		name = "佐々木希",
		description = "４０歳になる時後悔しない",
		type = 1, -- atk
		value = 300000,
		effect = ""
	}
	self.cards[3].skill = {
		name = "進撃のパンツ",
		description = "４０歳になる時後悔しない",
		type = 1, -- atk
		value = 150000,
		effect = ""
	}
	self.cards[4].skill = {
		name = "進撃のパンツ",
		description = "人生はただ一度だけ切り",
		type = 1, -- atk
		value = 250000,
		effect = ""
	}
	self.cards[5].skill = {
		name = "進撃のパンツ",
		description = "人生はただ一度だけ切り",
		type = 1, -- atk
		value = 530000,
		effect = ""
	}
	self.cards[6].skill = {
		name = "進撃のパンツ",
		description = "人生はただ一度だけ切り",
		type = 3, -- atk
		value = 5300,
		effect = ""
	}
	self.cards[1].skillTxt = "人生はただ一度だけ切り"
	self.cards[2].skillTxt = "４０歳になる時後悔しない"
	self.cards[3].skillTxt = "エンジニアの命は４０歳までだ"
	self.cards[4].skillTxt = "４０歳後まだCodingするの？"
	self.cards[5].skillTxt = "咪咪，咪咪，咪咪咪！"
	self.cards[6].skillTxt = "１年頑張って６０年休み"

	--	self.gameCardNode:setPosition(cc.p(0,0))
	self.gameCardNode:setPosition(cc.p(0,cc.Director:getInstance():getWinSize().height*1/2 + 30))

end

--------------------------------------------------------------------------------
-- cardSkillDrawed
function PuzzleCardNode:cardSkillDrawed(skill)
	if skill.type == GameConst.CardType.ATK then
		print("##############ATK############")
		local data = {
		    action = "atkBoss",
			damage = skill.value
		}
		self:atkBoss(data)
	elseif skill.type == GameConst.CardType.HEAL then
        print("##############Healing############")
		self:cardHeal(skill.value)
    end
end
--------------------------------------------------------------------------------
-- touchCard
function PuzzleCardNode:touchCard(obj)
	if obj.energy >= 100 and self.isActive then
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
	local mask = GameUtils:createMaskLayer()
	mask:setTouchEnabled(true)
	local action1 = cc.DelayTime:create(2.3)
	local action2 = cc.FadeOut:create(0.1)
	local action3 = cc.RemoveSelf:create()
	local action4 = cc.CallFunc:create(stopAction)

	
	mask:runAction(cc.Sequence:create(action1, action2,action3,action4))

	local cardSprite = cc.Sprite:create("images/Boss/20151018.png") --TODO
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
		local action3 =  cc.MoveTo:create(2,cc.p(AppConst.VISIBLE_SIZE.width/2+10,AppConst.VISIBLE_SIZE.height/2))
		local action4 =  cc.MoveTo:create(0.1,cc.p(AppConst.VISIBLE_SIZE.width + cardSpriteSize.width/2,AppConst.VISIBLE_SIZE.height/2))
		cardSprite:runAction(cc.Sequence:create(action1, action2, action3, action4))
		return cardSprite
	end
	local emitter = GameUtils:createParticle("parts/effect/particle_snow.plist","parts/effect/particle_snow.png")
	local cardSprite = createCardCara()
	local blockLayer = BlockLayer:create()

	local text = createText(obj.skillTxt)
	mask:addChild(emitter, 0)
	mask:addChild(blockLayer, 1)
	mask:addChild(cardSprite, 2)
	mask:addChild(text, 3)

	self:getParent():addChild(mask,999)
	-- TODO 攻撃BroadCast

end
--------------------------------------------------------------------------------
-- add energy
function PuzzleCardNode:setEnergy(card,per)
	card.energyBar:setPercent(per)
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
		card.energyBar:stopAllActions()
	end
	local callFunc1 = cc.CallFunc:create(stopAction)

	if isDraw then
		card.energyBar:runAction(cc.RepeatForever:create(cc.Sequence:create(action,action2)))
	else
		card.energyBar:runAction(cc.Sequence:create(action2,callFunc1))
	end
end
--------------------------------------------------------------------------------
-- ballToCard
function PuzzleCardNode:ballToCard(data)
	for key, var in pairs(self.cards) do
		if data.type == var.attribute then
			local emitter = GameUtils:createParticle("effect/particle_atk.plist","effect/images/particle_4star.png")
			self:getParent():getParent():addChild(emitter,1111111)
			emitter:setPosition(data.startPos)
			local action1 = cc.MoveTo:create(0.5,var:getParent():convertToWorldSpace(cc.p(var:getPositionX(),var:getPositionY())))
			local action2 = cc.RemoveSelf:create()

			local function cardAtkEffect()
				local action1 = cc.JumpBy:create(0.3, cc.p(0,0), 10, 1)
				var:getParent():runAction(cc.Sequence:create(action1))
				
				data.damage = data.count * var.atk
				self:atkBoss(data)
				
				local _data = {
					type = data.type,
					count = data.count,
					damage = data.count * var.atk
				}
				self:addCardDamageNumber(var:getParent(),_data.damage)
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
end
--------------------------------------------------------------------------------
-- healing
function PuzzleCardNode:cardHeal(value)
	self:changeHp(value)
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

return PuzzleCardNode













