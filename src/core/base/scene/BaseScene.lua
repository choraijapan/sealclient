-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

local BaseScene = class("BaseScene")

-- init
function BaseScene:initialize(...)
	self:init(...)
	
	local function onNodeEvent(event)
		if event == "enter" then
			self:onEnter()
		elseif event == "exit" then
			self:onExit()
		end
	end
	self.scene:registerScriptHandler(onNodeEvent)
end

function BaseScene:init(...)
end

function BaseScene:onEnter()
end

function BaseScene:onExit()
end

return BaseScene