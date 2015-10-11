-------------------------------------------------------------------------------
-- core boot
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------
WidgetLoader = class("WidgetLoader")
local textureCache = cc.Director:getInstance():getTextureCache()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()

-- create node from csb
function WidgetLoader:loadCsbFile(fileName)
	return cc.CSLoader:createNode(fileName)
end

-- load animation from csb
function WidgetLoader:loadCsbAnimation(fileName)
	return cc.CSLoader:createTimeline(fileName)
end

-- load texture
function WidgetLoader:loadImage(imageFilename, callback)
	if not callback then
		return textureCache:addImage(imageFilename)
	else
		textureCache:addImageAsync(imageFilename, callback)
	end
end

-- load spriteframe
function WidgetLoader:loadSpriteFrames(plist)
	spriteFrameCache:addSpriteFramesWithFile(plist)
end

-- remove texture
function WidgetLoader:removeImage(imageFilename)
	textureCache:removeTextureForKey(imageFilename)
end

