-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local Hero = class("Hero")

local parameter = {
	file_path = 'parts/animation/character/hero.csb',
}

-- init
function Hero:ctor(node,imagePath,idx)
    self.charaIdx = idx 
	self.chara = node
	self.chara.startPosition = cc.p(node:getPositionX(),node:getPositionY())
	
	self.chara.sprite = node:getChildByName('chara')
	self.chara.sprite:setTexture(WidgetLoader:loadImage(imagePath,nil))
	
	self.chara.right_pos = cc.p(node:getPositionX(), node:getPositionY())
	self.chara.left_pos = cc.p(node:getPositionX() - 640,node:getPositionY())
	self.chara:setPosition(self.chara.left_pos)
	
	self.chara_animation = WidgetLoader:loadCsbAnimation("parts/animation/character/hero.csb")
	self.chara:runAction(self.chara_animation)
	
	self.chara.battleIdx = 0
	
	local effectNode = cc.Node:create()
	self.chara:addChild(effectNode)
	self.chara.effectNode = effectNode
	
	
end

-- init
function Hero:MoveIn()
	local function createMove()
		return cc.MoveTo:create(0.2, self.chara.right_pos)
	end

	local move = createMove()
	local move_ease_inout = cc.EaseIn:create(createMove(), 3)
	local seq = cc.Sequence:create(move_ease_inout, cc.CallFunc:create(
		function(sender)
			self.chara_animation:play("runin",false)
		end
	))
		
	self.chara:runAction(seq)
end

function Hero:MoveOut()

end

function Hero:showEffect(callback)

	local function test() 
			local randomI = math.random(1,4)
			local effect = WidgetLoader:loadCsbFile('parts/effect/effect_00'..randomI..'.csb')
			local animation = WidgetLoader:loadCsbAnimation('parts/effect/effect_00'..randomI..'.csb')
			self.chara.effectNode:addChild(effect)
			effect:runAction(animation)
			animation:play("attack",false)
			effect:setPosition(cc.p(math.random(0,1),math.random(100,300)))
			
			
		local seq = cc.Sequence:create(cc.MoveBy:create(0.1,cc.p(0,10)),cc.MoveBy:create(0.1,cc.p(0,-10)))
		self.chara:runAction(seq)
			
			performWithDelay(effect,function(node) effect:runAction(cc.RemoveSelf:create()) end,0.5)
	end
		
	local function finish()
		callback(self.chara.battleIdx, self.charaIdx)
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
	delay, cc.CallFunc:create(test),
	delay, cc.CallFunc:create(finish)
	)
	
	self.chara.effectNode:runAction(sequence)
end

-- init
function Hero:isSelected(touch)
	local pos_x = self.chara:getPositionX()
	local pos_y = self.chara:getPositionY()
	local touch_local_pos = self.chara:getParent():convertTouchToNodeSpace(touch)
	self.seleted = false
	if (cc.rectContainsPoint(cc.rect(pos_x - 60,pos_y - 60,120,120), touch_local_pos)) then
		self.seleted = true
	end
	return self.seleted 
end

function Hero:selected()
	return self.chara.seleted
end

function Hero:moveToTouchPosition(posY)

	if (self.chara:getPositionY() + posY < self.chara.startPosition.y) then
		self.chara:setPositionY(self.chara.startPosition.y)
	else
		self.chara:setPositionY(self.chara:getPositionY() + posY)
	end

end

function Hero:revertPosition()
	self.chara.battleIdx = 0
	local function createMove()
		return cc.MoveTo:create(0.02,cc.p(self.chara.startPosition.x,self.chara.startPosition.y))
	end
	local move_ease_inout = cc.EaseIn:create(createMove(), 3)
	self.chara:runAction(move_ease_inout)
end

function Hero:deciedPosition(posY,targetIdx,targetPos)
	
	if (self.chara.battleIdx ~= 0) then
			BattleData.battleChara[self.chara.battleIdx] = nil
			self:revertPosition()
		return false
	end
	
	if (self.chara:getPositionY() + posY > 50) then
		self.chara.battleIdx = targetIdx
		local function createMove()
			return cc.MoveTo:create(0.02,targetPos)
		end
		local move_ease_inout = cc.EaseIn:create(createMove(), 3)
		
		self.chara:setScale(3)
		local ScaleAction = cc.ScaleTo:create(0.3,0.8)
		local seqAction = cc.Spawn:create(move_ease_inout,ScaleAction)
		
		self.chara:runAction(seqAction)
		return true
	else
		self:revertPosition()
	end

	return false
end


function Hero:tempNextCard(imapgePath,idx)
	self.chara.right_pos = self.chara.startPosition
	self.chara.left_pos = cc.p(self.chara.startPosition.x - 640,self.chara.startPosition.y)
	self.chara:setPosition(self.chara.left_pos)
	self.chara.battleIdx = 0
end


return Hero
