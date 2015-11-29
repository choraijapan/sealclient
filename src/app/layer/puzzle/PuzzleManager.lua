-------------------------------------------------------------------------------
-- @date 2015/11/24
-- 各スキルのメソッド
-------------------------------------------------------------------------------
PuzzleManager = class("PuzzleManager")

---#############################################################################
---###　全部のボールを繋げることができる。
---#############################################################################
PuzzleManager.isAllColorPuzzle = false
function PuzzleManager:resetAll()
	self.isAllColorPuzzle = false
end

---#############################################################################
---### Ballを転換する
-- BallはTagで管理されている。GameConst.luaのATTRIBUTE(属性)
---#############################################################################
function PuzzleManager:changeBall(fromTag,toTag)
	local all = cc.Director:getInstance():getRunningScene():getPhysicsWorld():getAllBodies()
	for _, obj in ipairs(all) do
		if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
			if obj:getNode():getTag() == fromTag then
				obj:getNode():changeBall(toTag)
			end
		end
	end
end

function PuzzleManager:addHurtEffect()
	local sprite = cc.Sprite:create("images/puzzle/effect/layer_alert.png")
	local scene = cc.Director:getInstance():getRunningScene()
	sprite:setScaleY(1.2)
	sprite:setPosition(cc.p(AppConst.WIN_SIZE.width/2,AppConst.WIN_SIZE.height/2))
	local action3 = cc.FadeOut:create(1)
	local action4 = cc.RemoveSelf:create()
	sprite:runAction(cc.Sequence:create(action3,action4))
	scene:addChild(sprite,999)
end
