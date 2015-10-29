-------------------------------------------------------------------------------
-- GameUtils
-- @date 2015/10/28
-------------------------------------------------------------------------------
GameUtils = class("GameUtils")
--------------------------------------------------------------------------------
-- @function
-- createParticle
function GameUtils:createParticle(img,plist)
	print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
	local particle = cc.ParticleSystemQuad:create(plist)
	particle:setTexture(cc.Director:getInstance():getTextureCache():addImage(img))
	particle:setAnchorPoint(cc.p(0.5, 0.5))
	particle:setAutoRemoveOnFinish(true)
	return particle
end