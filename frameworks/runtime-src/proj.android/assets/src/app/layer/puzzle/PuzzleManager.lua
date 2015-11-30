-------------------------------------------------------------------------------
-- @date 2015/11/24
-------------------------------------------------------------------------------
PuzzleManager = class("PuzzleManager")

PuzzleManager.isAllColorPuzzle = false
---#############################################################################
---### 
---#############################################################################
function PuzzleManager:resetAll()
	self.isAllColorPuzzle = false
end

function PuzzleManager:changeBall(fromTag,toTag)
    local data = {
        type = 2,
		from= fromTag,
		to = toTag
    }
	EventDispatchManager:broadcastEventDispatcher("CARD_SKILL_DRAWED",data)
end