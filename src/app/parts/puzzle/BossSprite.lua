--------------------------------------------------------------------------------
-- BossSprite
-- 【クラス】Player
-- @date 2014/12/24
-- @author  Cho Rai
local BossSprite = class("BossSprite", function()
	return cc.Sprite:create()
end)

BossSprite.node               = nil
BossSprite.sprite             = nil
BossSprite.active             = nil
BossSprite.canBeAttack        = nil
BossSprite.hpMax              = nil
BossSprite.hp                 = nil
BossSprite.atk                = nil
BossSprite.power              = nil
BossSprite.speed              = nil
BossSprite.bulleSpeed         = nil
BossSprite.bulletPowerValue   = nil
BossSprite.delayTime          = nil
BossSprite.size               = nil
BossSprite.label_hp           = nil
BossSprite.bar_hp             = nil
BossSprite.action             = nil
BossSprite.time               = nil
BossSprite.skill1 			  = nil
BossSprite.skill2 			  = nil

local SPRITE_CARD_ATK         = "SPRITE_CARD_ATK"
local BOSS_ATK_EVENT          = "BOSS_ATK_EVENT"

BossSprite.debuff    = {
	type = nil,
	value = nil,
}

BossSprite.color = {
	[0] = cc.c3b(255,255,255),
	[1] = cc.c3b(30,92,9),
	[2] = cc.c3b(239,225,13),
	[3] = cc.c3b(255,0,0),
	[4] = cc.c3b(2,105,248),
	[5] = cc.c3b(255,255,255),
}

--------------------------------------------------------------------------------
-- ctor
function BossSprite:ctor()
	self.active = true
	self.canBeAttack = false
	self.hpMax = 200000
	self.hp = self.hpMax
	self.atk = 1
	self.power = 1.0
	self.speed = 220
	self.bulleSpeed = 900
	self.bulletPowerValue = 1
	self.delayTime = 0.1
	
	self.skill1 = {
		skillId  = "NORMALATK",
		icon 	 = "images/boss/boss_skill.png",
		time 	 = 6,
		pos 	 = cc.p(0,-100),
		action = "atk",
		damage = "1200",
		effect = "images/puzzle/effect/particle/boss_atk_effect_fire.plist"
	}

	self.skill2 = {
		skillId  = "YAONIMING",
		icon 	 = "images/boss/boss_skill_2.png",
		time 	 = 60,
		pos 	 = cc.p(66,-100),
		action = "atk",
		damage = "15000",
		effect = "images/puzzle/effect/particle/gimmick_poisonbreath.plist"
	}
	
	
end
--------------------------------------------------------------------------------
-- init
function BossSprite:init()
	cc.SimpleAudioEngine:getInstance():playBackgroundMusic("sound/bgm31.m4a",true)
	self:addArmature()
	self:addHp()
	self:addEventDispatcher()
	self:addAI()
	self:setAnchorPoint(0.5)
	-- BOSS时间
	self.time = 0

	self:setPosition(cc.p(AppConst.DESIGN_SIZE.width/2, AppConst.DESIGN_SIZE.height - self.sprite:getContentSize().height/2 - 90))
end
--------------------------------------------------------------------------------
-- create
function BossSprite:create()
	local player = BossSprite.new()
	player:init()
	return player
end

function BossSprite:addArmature()
	self.sprite = cc.Sprite:create("images/boss/20151018.png")
	self.sprite:setAnchorPoint(0.5)
	self:addChild(self.sprite)
	self:setAnimation(self.sprite)
end

function BossSprite:setAnimation(obj)
	local action = cc.MoveBy:create(1, cc.p(0,20))
	local actionBack = action:reverse()
	obj:runAction(cc.RepeatForever:create(cc.Sequence:create(action, actionBack)))
end

function BossSprite:addEventDispatcher()
	local function cardAtkBossEffect(effectFile)
		if effectFile then
			local card_atk = cc.ParticleSystemQuad:create(effectFile)
			card_atk:setPosition(self:getPosition())
			card_atk:setDuration(0.5)
			self:getParent():addChild(card_atk,GameConst.ZOrder.Z_EffectAtkBoss)

			--			local cache = cc.SpriteFrameCache:getInstance()
			--			cache:addSpriteFrames("battle/skill_aobao.plist")
			--
			--			local sprite = cc.Sprite:createWithSpriteFrameName("blizzard_0001.png")
			--
			--			local animFrames = {}
			--			for i = 0, 11 do
			--				local str = string.format("blizzard_%04d.png",(i+1))
			--				local frame = cache:getSpriteFrame(str)
			--				print("############"..str)
			--				animFrames[i + 1] = frame
			--			end
			--			local animation = cc.Animation:createWithSpriteFrames(animFrames,0.1)
			--			sprite:runAction(cc.Animate:create(animation))
			--
			--			self:addChild(sprite)
		end
	end

	local function callBack(event)
		local data = event._data
		if data.action == "atkBoss" then
			self:addHurt(data)
			cardAtkBossEffect(data.effect)
			GameUtils:shakeNode(self,0.1)
		end
	end
	EventDispatchManager:createEventDispatcher(self,"SPRITE_CARD_ATK",callBack)
end

--------------------------------------------------------------------------------
-- Hp
function BossSprite:addHp()
	self.label_hp = ccui.TextAtlas:create()
	self.label_hp:setProperty(self.hp,GameConst.FONT.NUMBER, 17, 22, "0")
	self.label_hp:setPosition(cc.p(0,self.sprite:getContentSize().height/2))
	self.bar_hp = GameUtils:createProgressBar(GameConst.PUZZLE_PNG.BOSS_HP_BAR)
	self.bar_hp:setScaleX(1.4)
	local bar_bg = cc.Sprite:create(GameConst.PUZZLE_PNG.BOSS_HP_BG)
	bar_bg:setPosition(cc.p(0,self.sprite:getContentSize().height/2))
	self.bar_hp:setColor(cc.c3b(225,225,0))
	self.bar_hp:setPosition(cc.p(1,self.sprite:getContentSize().height/2 -7))
	self:addChild(bar_bg)
	self:addChild(self.bar_hp)
	--	self:addChild(self.label_hp)

	local to = cc.ProgressTo:create(1, 100)
	self.bar_hp:runAction(cc.RepeatForever:create(to))
end

--------------------------------------------------------------------------------
-- hurt
function BossSprite:hurt(damageValue)
	self.hp = self.hp - damageValue
	--	self.label_hp:setString(self.hp)

	local hpPer = (self.hp / self.hpMax)*100
	local to = cc.ProgressTo:create(0.5, hpPer)
	self.bar_hp:runAction(cc.RepeatForever:create(to))

	--self.action:play("hurt",false)
	if self.hp <= 0 then
		self.active = false
	end
end
--------------------------------------------------------------------------------
-- isCanAttack
function BossSprite:isCanAttack()
	return self.canBeAttack
end
--------------------------------------------------------------------------------
-- isActive
function BossSprite:isActive()
	return self.active
end
--------------------------------------------------------------------------------
-- destroy
function BossSprite:destroy()
	if Global:getInstance():getAudioState() == true then
		cc.SimpleAudioEngine:getInstance():playEffect("Music/shipDestroyEffect.mp3")
	end
	self:removeFromParent()
end


function BossSprite:setDebuffOn(data)
	local type = data.type
	local count = data.count

	--[[
	--冰冻
	if type ==  GameConst.DEBUFF.FREEZE then
	--        self.sprite:setColor(self.color[type])
	-- self.node:setColor(self.color[type])
	self.debuff.type = GameConst.DEBUFF.FREEZE
	self.debuff.value = 2
	local function freezeFor()
	end
	schedule(self, freezeFor, count*self.debuff.value)
	elseif type ==  GameConst.DEBUFF.DEFDOWN then  --减护甲
	--        self.sprite:setColor(self.color[type])
	-- self.node:setColor(self.color[type])
	self.debuff.type = GameConst.DEBUFF.DEFDOWN
	self.debuff.value = 100
	else
	--        self.sprite:setColor(self.color[0])
	--self.node:setColor(self.color[0])
	self.debuff.type = GameConst.DEBUFF.ATK
	self.debuff.value = 1
	end

	]]--
	self.debuff.type = GameConst.DEBUFF.ATK
	self.debuff.value = 1


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
function BossSprite:addAI()
	local function addSkill(skillObj)
		local timer = 0
		local node = cc.Node:create()
		node:setPosition(skillObj.pos)
		local sprite = cc.Sprite:create(skillObj.icon)
		sprite:setAnchorPoint(0.5)
		local atkLeftTime = ccui.TextAtlas:create()

		local text_turn = cc.Sprite:create(GameConst.PUZZLE_PNG.LEFT_TIME)
		text_turn:setPosition(cc.p(0,45))
		node:addChild(text_turn)
		node:addChild(sprite)
		node:addChild(atkLeftTime)
		self:addChild(node)
		local function skill()
			if timer % skillObj.time ~= 0 then
				if self.debuff.type == GameConst.DEBUFF.FREEZE then
					self.debuff.type = nil
				else
					atkLeftTime:setProperty(skillObj.time - timer % skillObj.time, GameConst.FONT.NUMBER_YELLOW, 25, 30, "0")
				end
			else
				self:startAtk(skillObj)
			end
		end
		local function updateTime()
			timer = timer + 1
			skill()
		end
		schedule(self.sprite, updateTime, 1)
	end
	
	addSkill(self.skill1)
	addSkill(self.skill2)
end

function BossSprite:startAtk(skillData)
	self:atkEffect()
	local effect = GameUtils:createParticle(skillData.effect,nil)
	effect:setPosition(cc.p(0,0))
	self:addChild(effect,111)
	EventDispatchManager:broadcastEventDispatcher(BOSS_ATK_EVENT,skillData)
end

function BossSprite:addHurt(data)
	local labelAtlas = ccui.TextAtlas:create()
	local damage = data.damage
	local function actionEnd()
	end
	--    local action1 = cc.ScaleTo:create(0.1, 4)
	--    local action2 = cc.ScaleTo:create(0.1, 3.5)
	--    local action3 = cc.DelayTime:create(1.5)
	--    local action4 = cc.FadeOut:create(0.5)
	--    local action5 = cc.DelayTime:create(0.5)
	--    local action6 = cc.RemoveSelf:create()
	--    local action7 = cc.CallFunc:create(actionEnd)
	--    labelAtlas:runAction(cc.Sequence:create(action1, action2,action3,action4,action5,action6,action7))
	--    else
	--        damage = self.damage[type] * count
	--        local action1 = cc.MoveBy:create(2,cc.p(0,80))
	--        local action2 = cc.FadeOut:create(2)
	--        local action = cc.Spawn:create(action1,action2)
	--        local action4 = cc.RemoveSelf:create()
	--        labelAtlas:runAction(cc.Sequence:create(action,action4))
	--    end

	local labelAtlas = GameUtils:createTextAtlas(damage)
	GameUtils:addDamageNumberAction(labelAtlas)
	self:addChild(labelAtlas)
	self:hurt(damage)

	self:setDebuffOn(data) -- 设置新Debuff
end

function BossSprite:getPosition()
	local pos = {}
	pos.x = self:getPositionX()
	pos.y = self:getPositionY()
	return pos
end

function BossSprite:atkEffect()
	local action1 = cc.ScaleTo:create(0.1,1.3)
	local action2 = cc.ScaleTo:create(0.1,1)
	local seq = cc.Sequence:create(action1, action2)
	self:runAction(seq)
end

return BossSprite




