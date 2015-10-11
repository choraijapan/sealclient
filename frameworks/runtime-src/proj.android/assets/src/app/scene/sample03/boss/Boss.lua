-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local Boss = class("Boss")

local parameter = {
	file_path = 'parts/animation/character/boss.csb',
	life = 100
}

-- init
function Boss:ctor(node)
	self.chara = node
	
	self.chara.progress = WidgetObj:getChild(node:getChildByName('sprite'),'progress',WidgetConst.OBJ_TYPE.Slider)
	self.chara.progress:setPercent(100)
	
	self.chara_animation = WidgetLoader:loadCsbAnimation("parts/animation/character/boss.csb")
	self.chara:runAction(self.chara_animation)
	
	local effectNode = cc.Node:create()
	self.chara:addChild(effectNode)
	self.chara.effectNode = effectNode
end

function Boss:play(anime_name,loop)
	self.chara_animation:play(anime_name,loop)
end

function Boss:getHp()
	return self.chara.progress:getPercent()
end

function Boss:setHp()
	return self.chara.progress:setPercent(100)
end


function Boss:playHit()
	local function test() 
		self.chara_animation:play('hit',false)
		
		self.chara.progress:setPercent(self.chara.progress:getPercent() - math.random(1,5))
	end

	local delay = cc.DelayTime:create(0.3)
	local sequence = cc.Sequence:create(
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test),
		delay, cc.CallFunc:create(test)
	)
	self.chara.effectNode:runAction(sequence)
end

function Boss:hide()
	self.chara:setVisible(false)
end

function Boss:showNextBoss()
	self.chara:setVisible(true) 
	self.chara.sprite = self.chara:getChildByName('sprite')
	local num = math.random(1,3)
	self.chara.sprite:setTexture(WidgetLoader:loadImage('images/Card/boss_00'..num..'.jpg',nil))
	self.chara.progress:setPercent(100)
	self:play('showin',false)
end

return Boss

