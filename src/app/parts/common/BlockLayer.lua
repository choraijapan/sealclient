--------------------------------------------------------------------------------
-- BlockLayer
local BlockLayer = class("BlockLayer",cc.Layer)
--------------------------------------------------------------------------------
-- const変数
local TAG = "BlockLayer:"
local CSBFILE = "parts/common/BlockLayer.csb"
--------------------------------------------------------------------------------
-- メンバ変数
--------------------------------------------------------------------------------
-- UI変数
--------------------------------------------------------------------------------
-- constructor
function BlockLayer:ctor()
end
--------------------------------------------------------------------------------
-- create
function BlockLayer:create()
	local block = WidgetLoader:loadCsbFile(CSBFILE)
	local layer = BlockLayer.new()
	layer:addChild(block)
	return layer
end

return BlockLayer












