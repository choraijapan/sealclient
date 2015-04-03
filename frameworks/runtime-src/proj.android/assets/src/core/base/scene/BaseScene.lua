-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------

local BaseScene = class("BaseScene")

-- constructor
function BaseScene:ctor(scene_type)
	if scene_type == nil or scene_type == GameSysConst.SCENE_TYPE.STANDARD then
		self.scene = cc.Scene:create()
	elseif scene_type == GameSysConst.SCENE_TYPE.PHYSICS then
		self.scene = cc.Scene:createWithPhysics()
	end
end

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