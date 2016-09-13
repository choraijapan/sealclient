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

-- set sprite Image
function WidgetLoader:setSpriteImage(target, imagePath)
	local texture2d = WidgetLoader:loadImage(imagePath,nil)
	local rect = texture2d:getContentSize()
	target:setTexture(texture2d)
	target:setTextureRect(rect)
end

-- set sprite Atlas Image
function WidgetLoader:setSpriteAtlasImage(target, imageName)
	local spriteFrame = spriteFrameCache:getSpriteFrameByName(imageName)
	local texture2d = spriteFrame:getTexture()
	target:setTexture(texture2dtexture2d)
	target:setTextureRect(texture2d:getContentSize())
end
