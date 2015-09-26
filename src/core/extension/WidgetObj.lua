-------------------------------------------------------------------------------
-- WidgetObj
-- @date 2015/04/03
-- @author masahiro mine
-------------------------------------------------------------------------------
WidgetObj = class("WidgetObj")

-- cast object type
function WidgetObj:castObj(obj,type)
	return tolua.cast(obj,type)
end

-- getChild
function WidgetObj:getChild(root,arg,objType)
	local type = type(arg)
	if type == "number" then
		return self:castObj(root:getChildByTag(arg),objType)
	elseif type == "string" then
		return self:castObj(root:getChildByName(arg),objType)
	end
end

-- searchWidgetByName
function WidgetObj:searchWidgetByName(root,name,objType)
	if root == nil then
		return nil
	end
	if root:getName() == name then
		return root
	end

	local childList = root:getChildren()
	for idx, child in ipairs(childList) do
		if child then
			local res = self:searchWidgetByName(child,name)
			if res ~= nil then
				return self:castObj(res,objType)
			end
		end
	end
	return nil
end
