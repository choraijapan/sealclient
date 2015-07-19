-------------------------------------------------------------------------------
-- core BattleScene
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local BattleManager = class("BattleManager")


function BattleManager:init(battleNode)
	self.battleMainNode = battleNode
	self.heros = {}
	self.boss = {}
	self.selected_hero = 0
	self.attackStatus = BattleData.BATTLE_STATUS.START
	
end

function BattleManager:createHeros() 
	self.panel_heros = self.battleMainNode:getChildByName('panel_heros')
	
	for i=1, 5 do
		local randomImage = 'images/Card/'..math.random(1,2)..'_all.png'
		self.heros[i] = require('app/scene/sample03/chara/Hero').new(self.panel_heros:getChildByName('chara_0'..i),randomImage,i)
	end
end

function BattleManager:createBoss() 
	self.panel_boss = self.battleMainNode:getChildByName('panel_boss')
	self.boss[1] = require('app/scene/sample03/boss/Boss').new(self.panel_boss:getChildByName('boss_01'))
	
end

function BattleManager:createTargetPos()
	local tes = self.battleMainNode:getChildByName('attack_pos_001')
	for i=1, 3 do
		BattleData.targetPos[i] = self.battleMainNode:getChildByName('attack_pos_00'..i)
	end
end


function BattleManager:start()
	self.boss[1]:play('showin',false)
	
	local seq = cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(
		function(sender)
			for i=1, 5 do
				self.heros[i]:MoveIn()
			end
		end
	))
	self.battleMainNode:runAction(seq)
	
	self:registTouch()
end

function BattleManager:nextCard(idx)
	local randomImage = 'images/Card/'..math.random(1,2)..'_all.png'
	self.heros[idx]:tempNextCard(randomImage,idx)
	self.heros[idx]:MoveIn()
	local test = self.boss[1]:getHp()
	if (self.boss[1]:getHp() <= 0) then
		self:nextBoss()
	else
		self.attackStatus = BattleData.BATTLE_STATUS.START
		BattleData.battleChara = {}
	end
end


function BattleManager:nextBoss()
	local bg = self.battleMainNode:getChildByName('bg')
	local bg_0 = self.battleMainNode:getChildByName('bg_0')
	self.boss[1]:hide()
	if bg:getPositionY() < -400 then
		bg:setPositionY(bg:getPositionY() + 1280 * 2)
	end

	if bg_0:getPositionY() < -400 then
		bg_0:setPositionY(bg_0:getPositionY() + 1280 * 2)
	end
	
	
	bg:runAction(cc.MoveBy:create(1, cc.p(0,-200)))
	local function moveFinish()
		
		self.attackStatus = BattleData.BATTLE_STATUS.START
		BattleData.battleChara = {}
		self.boss[1]:showNextBoss()
	end
	bg_0:runAction(cc.Sequence:create(cc.MoveBy:create(1,cc.p(0,-200)), cc.CallFunc:create(moveFinish)))

end



function BattleManager:process()
	self.boss[1]:playHit()
	for i = 1 , 3 do
		BattleData.battleChara[i]:showEffect(function(battleIdx,charaIdx)
			self:nextCard(charaIdx)
		end)	
	end
	
end


--------------------------------------------------------------------------------
-- @function return one touch
-- #touchOneByOne
function BattleManager:registTouch(node, callBack)
	TouchManager:touchOneByOne(self.battleMainNode,function(touch,event)
		if self.attackStatus ~= BattleData.BATTLE_STATUS.START then
			return
		end
			
		if (event:getEventCode() == ccui.TouchEventType.began) then
		    if self.selected_hero > 0 then
		    	return
		    end
		    
			for i=1, 5 do
				if (self.heros[i]:isSelected(touch)) then
					self.selected_hero = i
					break
				end
			end
		end
		
		if (event:getEventCode() == ccui.TouchEventType.moved) then
			if self.selected_hero == 0 then
				return
			end
			local removeIdx = self.heros[self.selected_hero]:moveToTouchPosition(touch:getLocation().y - touch:getPreviousLocation().y)
		end
		if (event:getEventCode() == ccui.TouchEventType.canceled) then

			if self.selected_hero == 0 then
				return
			end

			self.heros[self.selected_hero]:revertPosition()
			self.selected_hero = 0 

		end

		if (event:getEventCode() == ccui.TouchEventType.ended) then
			if self.selected_hero == 0 then
				return
			end
			local posY = touch:getLocation().y - touch:getStartLocation().y
			
			if #BattleData.battleChara == 3 then
			 	return
			end
			
			for i = 1,3 do
				if BattleData.battleChara[i] == nil then
					local result = self.heros[self.selected_hero]:deciedPosition(posY,i,cc.p(BattleData.targetPos[i]:getPositionX(),BattleData.targetPos[i]:getPositionY()))
					if (result) then
						BattleData.battleChara[i] = self.heros[self.selected_hero]
					else 
						BattleData.battleChara[i] = nil
					end
					break;
				end
			end
			
			if #BattleData.battleChara == 3 then
			 	 self.attackStatus = BattleData.BATTLE_STATUS.PROCESS
				self:process()
			end
			
			self.selected_hero = 0
		end
	end)

end





return BattleManager

