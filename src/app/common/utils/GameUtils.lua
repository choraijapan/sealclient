-------------------------------------------------------------------------------
-- GameUtils
-- SE,BGM
-- UIの作成
-- エフェクトの作成
-- アニメションの作成
-- note: 上記の各機能を分ける必要がある時に分ける
-- @date 2015/10/28
-------------------------------------------------------------------------------
GameUtils = class("GameUtils")
GameUtils.TouchFlag = false

---#############################################################################
---### Effect関連
---#############################################################################
--------------------------------------------------------------------------------
-- @Effect
-- Number：コンボとが連鎖とがの数字のアニメ
function GameUtils:addNumberEffect(obj)
	local action1 = cc.ScaleTo:create(0.1, 4)
	local action2 = cc.ScaleTo:create(0.1, 3)
	local action3 = cc.DelayTime:create(1.5)
	local action4 = cc.FadeOut:create(0.5)
	local action5 = cc.DelayTime:create(0.5)
	local action6 = cc.RemoveSelf:create()
	obj:runAction(cc.Sequence:create(action1, action2,action3))
end
function GameUtils:addCombolEffect(obj)
	local action1 = cc.ScaleTo:create(0.1, 3)
	local action2 = cc.ScaleTo:create(0.1, 2)
	local action3 = cc.DelayTime:create(1.5)
	obj:runAction(cc.Sequence:create(action1, action2,action3))
end
--------------------------------------------------------------------------------
-- @Effect
-- createParticle
function GameUtils:createParticle(plist,img)
	local particle = cc.ParticleSystemQuad:create(plist)
	if img then
		particle:setTexture(cc.Director:getInstance():getTextureCache():addImage(img))
	end
	particle:setAnchorPoint(cc.p(0.5, 0.5))
	particle:setScale(1.5)
	particle:setAutoRemoveOnFinish(true)
	return particle
end

--------------------------------------------------------------------------------
-- @Effect
-- shakeNode
function GameUtils:shakeNode(node,duration)
	local pos = cc.p(node:getPositionX(),node:getPositionY())
	local tmp = 0
	local zs = node:getScale()
	local function mutable(dt)
		tmp = tmp + dt
		if tmp >= duration then
			node:unscheduleUpdate()
			node:setPosition(pos)
			node:setScale(zs)
			return
		else
			local z = math.random(98,103) * 0.01
			local x = math.random(1,6)
			local y = math.random(1,8)
			local r = math.random(0,2)
			if r > 0 then
				x = x *(-1)
				r = math.random(0,2)
				if r > 0 then
					y = y*(-1)
				end
			end
			node:setPosition(pos.x+x,pos.y+y)
			node:setScale(z)
		end
	end
	node:scheduleUpdateWithPriorityLua(mutable, 0)
end

function GameUtils:shakeNode2(node,duration)
	local pos = node:getPosition()
	local r = math.random(0,1)
	local k = 0
	if r > 0 then
		k = 1
	else
		k = -1
	end
	local action1 = cc.MoveBy:create(0.1, cc.p( 10*k,10*k))
	local action2 = cc.MoveBy:create(0.1, cc.p( - 10*k,- 10*k))
	local action3 = action2:reverse()
	node:runAction(cc.Sequence:create(action1, action2,action3))
end
---#############################################################################
---### UI関連
---#############################################################################
------------------------------------
-- @UI
-- createLabel
function GameUtils:createTextAtlas(txt)
	local label = ccui.TextAtlas:create()
	label:setProperty(txt, GameConst.FONT.NUMBER, 17, 22, "0")
	return label
end
function GameUtils:addAtkNumberAction(obj)
	local action0 = cc.MoveTo:create(0,cc.p(0,60))
	local action1 = cc.ScaleTo:create(0.1, 1.2)
	local action2 = cc.ScaleTo:create(0.1, 1)
	local action3 = cc.MoveBy:create(1,cc.p(0,30))
	local action4 = cc.FadeOut:create(0.5)
	local action5 = cc.DelayTime:create(0.5)
	local action6 = cc.RemoveSelf:create()
	obj:runAction(cc.Sequence:create(action0,action1, action2,action3,action4,action5,action6))
end

local numId = 0
function GameUtils:addDamageNumberAction(obj)
	local function actionEnd()
		numId = 0
	end
	local pos = cc.p(0,30)
	if numId == 0 then
		pos = cc.p(0,0)
	elseif numId == 1 then
		pos = cc.p(-100,35)
	elseif numId == 2 then
		pos = cc.p(100,0)
	elseif numId == 3 then
		pos = cc.p(-100,35)
	elseif numId == 4 then
		pos = cc.p(100,35)
	elseif numId == 5 then
		pos = cc.p(-120,-35)
	elseif numId == 6 then
		pos = cc.p(120,-35)
	elseif numId == 7 then
		pos = cc.p(-120,60)
	elseif numId == 8 then
		pos = cc.p(120,-60)
	elseif numId == 9 then
		pos = cc.p(-120,60)
	elseif numId == 10 then
		pos = cc.p(120,60)
	end

	local action0 = cc.MoveTo:create(0,pos)
	local action1 = cc.ScaleTo:create(0.1, 2.5)
	local action2 = cc.ScaleTo:create(0.1, 1.8)
	--	local action3 = cc.MoveBy:create(0.5,cc.p(0,20))
	local action4 = cc.DelayTime:create(1.5)
	local action5 = cc.FadeOut:create(0.5)
	local action6 = cc.RemoveSelf:create()
	local action7 = cc.CallFunc:create(actionEnd)
	obj:runAction(cc.Sequence:create(action0,action1, action2,action4,action5,action6,action7))
	numId = numId + 1
end
------------------------------------
-- @UI
-- addFerverBar  from left to right
function GameUtils:createProgressBar(img)
	local bar = cc.ProgressTimer:create(cc.Sprite:create(img))
	bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	bar:setAnchorPoint(cc.p(0.5, 0.5))
	bar:setMidpoint(cc.p(0, 0))
	bar:setBarChangeRate(cc.p(1, 0))
	return bar
end
------------------------------------
-- @UI
-- createMaskLayer
function GameUtils:createMaskLayer()
	local layer = cc.LayerColor:create(cc.c3b(0, 0, 0),999999,999999)
	layer:setPosition(cc.p(0, 0))
	layer:setAnchorPoint(cc.p(0.5, 0.5))
	layer:setOpacity(200)
	return layer
end
------------------------------------
-- @UI
-- createBlockLayer
function GameUtils:createBlockLayer()
	local layer = cc.Layer:create()
	local block = WidgetLoader:loadCsbFile("parts/common/BlockLayer.csb")
	layer:addChild(block)
	return layer
end

------------------------------------
-- @UI
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

function GameUtils:pauseScene(sqr,isFlip)
	local scene = cc.Scene:create()
	local size = cc.Director:sharedDirector():getWinSize()

	local _spr = cc.Sprite:createWithTexture(sqr:getSprite():getTexture())
	_spr:setPosition(cc.p(size.width / 2, size.height / 2))
	_spr:setFlipY(isFlip)
	scene:addChild(_spr)

	local layer = self:createPauseLayer()
	scene:addChild(layer)
	return scene
end
------------------------------------
-- @UI
-- pauseGame
function GameUtils:pauseGame()
	print("############### PAUSE ##############")
	GameUtils.TouchFlag = false
--	cc.Director:getInstance():pause()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
	cc.SimpleAudioEngine:getInstance():pauseAllEffects()

	local curScene = cc.Director:getInstance():getRunningScene()
	local renderTexture = cc.RenderTexture:create(AppConst.WIN_SIZE.width, AppConst.WIN_SIZE.height);

	if curScene:getTag() == GameConst.PUZZLE_SCENE_TAG then
		renderTexture:begin()
		curScene:visit()
		renderTexture:endToLua()
		local pause = self:pauseScene(renderTexture, true)
		pause:setTag(501)
		cc.Director:getInstance():pushScene(pause)
	end

	local all = curScene:getPhysicsWorld():getAllBodies()
	for _, obj in ipairs(all) do
		if bit.band(obj:getTag(), GameConst.PUZZLEOBJTAG.T_Bullet) ~= 0 then
			obj:getNode():removeBallTouchEffect()
			obj:getNode():removePuzzleNumber()
		end
	end
end
------------------------------------
-- @UI
function GameUtils:resumeGame()
	print("############### RESUME ##############")
	GameUtils.TouchFlag = false
	cc.Director:getInstance():resume()
	cc.Director:getInstance():startAnimation()
	cc.SimpleAudioEngine:getInstance():resumeMusic()

	local curScene = cc.Director:getInstance():getRunningScene()
	if curScene:getTag() == 501 then
		cc.Director:getInstance():popScene()
	end
end



