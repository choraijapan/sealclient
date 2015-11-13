-------------------------------------------------------------------------------
-- GameUtils
-- @date 2015/10/28
-------------------------------------------------------------------------------
GameUtils = class("GameUtils")
GameUtils.TouchFlag = false
--------------------------------------------------------------------------------
-- @function
-- createParticle
function GameUtils:createParticle(img,plist)
	local particle = cc.ParticleSystemQuad:create(plist)
	particle:setTexture(cc.Director:getInstance():getTextureCache():addImage(img))
	particle:setAnchorPoint(cc.p(0.5, 0.5))
	particle:setAutoRemoveOnFinish(true)
	return particle
end
------------------------------------
--   addFerverBar  from left to right
function GameUtils:createProgressBar(img)
	local bar = cc.ProgressTimer:create(cc.Sprite:create(img))
	bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	bar:setAnchorPoint(cc.p(0.5, 0.5))
	bar:setMidpoint(cc.p(0, 0))
	bar:setBarChangeRate(cc.p(1, 0))
	return bar
end

-- createMaskLayer
function GameUtils:createMaskLayer()
	local layer = cc.LayerColor:create(cc.c3b(0, 0, 0),999999,999999)
	layer:setPosition(cc.p(0, 0))
	layer:setAnchorPoint(cc.p(0.5, 0.5))
	layer:setOpacity(200)
	return layer
end

function GameUtils:createBlockLayer()
	local layer = cc.Layer:create()
	local block = WidgetLoader:loadCsbFile("parts/common/BlockLayer.csb")
	layer:addChild(block)
	return layer
end

function GameUtils:createPauseLayer()
	local layer = cc.Layer:create()
	local block = WidgetLoader:loadCsbFile("parts/puzzle/PuzzlePauseLayer.csb")

	local buttonResume = WidgetObj:searchWidgetByName(block,"ButtonResume","ccui.Button")

	TouchManager:pressedDown(buttonResume,
		function()
			self:resumeGame()
		end)

	layer:addChild(block)
	return layer
end

function GameUtils:pauseGame()
	print("############### PAUSE ##############")
	GameUtils.TouchFlag = false
	cc.Director:getInstance():pause()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
	cc.SimpleAudioEngine:getInstance():pauseAllEffects()

	local curScene = cc.Director:getInstance():getRunningScene()
	if curScene:getChildByName("PAUSE_LAYER") == nil then
		local blockLayer = self:createPauseLayer()
		blockLayer:setName("PAUSE_LAYER")
		curScene:addChild(blockLayer,999)
	end
	
	local all = curScene:getPhysicsWorld():getAllBodies()
	for _, obj in ipairs(all) do
		if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
			obj:getNode():removeBallTouchEffect()
			obj:getNode():removePuzzleNumber()
		end
	end
end

function GameUtils:resumeGame()
	print("############### RESUME ##############")
	GameUtils.TouchFlag = false
	cc.Director:getInstance():resume()
	cc.SimpleAudioEngine:getInstance():resumeMusic()

	local curScene = cc.Director:getInstance():getRunningScene()
	curScene:removeChildByName("PAUSE_LAYER")
end