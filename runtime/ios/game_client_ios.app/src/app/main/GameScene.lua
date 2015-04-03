-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------


local GameScene = class("GameScene",function()
	return cc.Scene:create()
end)

function GameScene.create()
	local scene = GameScene.new()
	--    scene:addChild(scene:createLayerFarm())

	scene:addChild(scene:createLayerMenu())
	return scene
end

function GameScene:ctor()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
	self.origin = cc.Director:getInstance():getVisibleOrigin()
	self.schedulerID = nil
end


-- create menu
function GameScene:createLayerMenu()

	--    local node = ccs.GUIReader:getInstance():widgetFromBinaryFile("scene/main.csb")

	local node = cc.CSLoader:createNode("scene/main.csb")
	--  local sprite = node:getChildByName("Panel_1")
	--  local test = tolua.cast(sprite,"ccui.Layout")
	--
	--  local test = node:getChildByName("Node_6")
	--  local test = test:getChildByName("ProjectNode_5")
	--
	----  test:loadTexture("res/land.png",ccui.TextureResType.localType)
	--  cclog(sprite:getGlobalZOrder())
	--  sprite:setLocalZOrder(1)
	----  sprite:setGlobalZOrder(-1)
	--  local test = 1
	--  local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3")
	--  cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)


	return node

end

return GameScene
