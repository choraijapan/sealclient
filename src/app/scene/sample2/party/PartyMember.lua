-------------------------------------------------------------------------------
-- sprite
-- @date 2015/05/15
-- @author masahiro mine
-------------------------------------------------------------------------------

local PartyMember = class("PartyMember")

-- init
function PartyMember:ctor(sprite)
	self.sprite = sprite
end

-- init
function PartyMember:pull()
end

function PartyMember:release()
end

return PartyMember

