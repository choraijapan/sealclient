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