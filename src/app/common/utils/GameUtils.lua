-------------------------------------------------------------------------------
-- GameUtils
-- @date 2015/10/28
-------------------------------------------------------------------------------
GameUtils = class("GameUtils")
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