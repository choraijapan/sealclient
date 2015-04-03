-------------------------------------------------------------------------------
-- core boot
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------
WidgetObj = class("WidgetObj")

local CONST_TYPE = {


}

-- create node from csb
function WidgetObj:loadCsbFile(fileName)
	cc.CSLoader:createNode(fileName)
end
