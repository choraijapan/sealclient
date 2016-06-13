-------------------------------------------------------------------------------
-- @date 2015/11/24
-- 各スキルのメソッド
-------------------------------------------------------------------------------
local PuzzleManager = class("PuzzleManager")

-------------------------------------------------------------------------------
---　全部のボールを繋げることができる。
PuzzleManager.isAllColorPuzzle = false
function PuzzleManager:resetAll()
	self.isAllColorPuzzle = false
end
-------------------------------------------------------------------------------
-- SKILL
-- Ballを転換する
function PuzzleManager:changeBall(fromTag,toTag,callBack)
	
	local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	for _, obj in ipairs(all) do
		if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
			if obj:getNode():getTag() == fromTag then
--				self:changeBall(obj:getNode(),toTag)
				obj:getNode().type = toTag
				obj:getNode():setTag(toTag)
				local function changeImg()
					WidgetLoader:setSpriteImage(obj:getNode()._image, GameConst.BALL_PNG[toTag])
				end
				local action1 = cc.ScaleTo:create(0.5,0.1)
				local action2 = cc.CallFunc:create(changeImg)
				local action3 = cc.ScaleTo:create(0.5,1)
				local act = cc.Sequence:create(action1,action2,action3)
				obj:getNode()._image:runAction(act)
			end
		end
	end
	callBack()
end

-------------------------------------------------------------------------------
-- SKILL
-- Ballを消す   TODO 遮罩，动画，光柱下来后，展开效果需要用到遮罩。
PuzzleManager.REMOVE_SHARP = {

	}
function PuzzleManager:removeBall(width,callBack)
	local removeSharp = cc.LayerColor:create(cc.c4b(255,255,255,0),100*width,1500)
	removeSharp:setPositionX(AppConst.WIN_SIZE.width/2 - removeSharp:getContentSize().width/2)
	local blockLayer = GameUtils:createBlockLayer()
	local bg = cc.LayerColor:create(cc.c4b(0,0,0,200),1500,1500)
	local scene = cc.Director:getInstance():getRunningScene()
	local puzzleLayer = scene:getChildByName("PUZZLE_LAYER")
	local index = 1
	local balls = {}
	local box = removeSharp:getBoundingBox()
	local node = cc.Node:create()
	node:addChild(bg)
	node:addChild(removeSharp)
	node:addChild(blockLayer)
	puzzleLayer:addChild(node,GameConst.ZOrder.Z_Dark)

	local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	for _, obj in ipairs(all) do
		if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
			if cc.rectContainsPoint(box,obj:getPosition()) then
				obj:getNode():getParent():reorderChild(obj:getNode(),GameConst.ZOrder.Z_Dark + 1)
				balls[index] = obj
				index = index + 1
			end
		end
	end

	local function actEnd()
		for key, obj in ipairs(balls) do
			if  #balls == key then
				balls[key]:getNode():addBoom(#balls)
			end
			obj:getNode():brokenBullet()
		end
		local action = cc.RemoveSelf:create()
		node:runAction(action)
		callBack()
	end

	local action1 = cc.ScaleTo:create(0,0)
	local action2 = cc.ScaleTo:create(0.5,1)
	local action3 = cc.DelayTime:create(1)
	local action4 = cc.CallFunc:create(actEnd)
	removeSharp:runAction(cc.Sequence:create(action1, action2, action3, action4))
end
-------------------------------------------------------------------------------
--- Boss攻撃が来る時、画面が赤くになるEffect
function PuzzleManager:addHurtEffect()
	local sprite = cc.Sprite:create("images/puzzle/effect/layer_alert.png")
	local scene = cc.Director:getInstance():getRunningScene()
	sprite:setScaleY(1.5)
	sprite:setScaleX(1.2)
	sprite:setPosition(cc.p(AppConst.DESIGN_SIZE.width/2,AppConst.DESIGN_SIZE.height/2))
	local action1 = cc.FadeOut:create(2)
	local action2 = cc.RemoveSelf:create()
	sprite:runAction(cc.Sequence:create(action1,action2))
	scene:addChild(sprite,999)
end
return PuzzleManager