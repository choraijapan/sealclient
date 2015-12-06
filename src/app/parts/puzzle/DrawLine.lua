
local DrawLine = class("DrawLine", function()
	return cc.DrawNode:create()
end)

function DrawLine:ctor()
end

function DrawLine:create(vecs)
	local drawLine = DrawLine.new()
	drawLine:init(vecs)
	return drawLine
end

function DrawLine:init(vecs)

	local temVec = nil
	if vecs ~= nil then
		for key, var in ipairs(vecs) do
			--每个点上加圆圈！！！！
			--self:drawSolidCircle(cc.p(var.x,var.y),3, math.pi/2, 50, 5.0, 5.0, cc.c4f(1.0, 1.0, 1.0, 1.0))
			if temVec ~=nil then
				self:drawSegment(cc.p(temVec.x,temVec.y),cc.p(var.x,var.y),4,cc.c4f(1.0, 1.0, 1.0, 0.5))
				self:drawSegment(cc.p(temVec.x,temVec.y),cc.p(var.x,var.y),2,cc.c4f(1.0, 1.0, 1.0, 1.0))
			end
			self:drawDot(cc.p(var.x,var.y), 10, cc.c4f(1.0, 1.0, 1.0, 0.5))
			self:drawDot(cc.p(var.x,var.y), 6, cc.c4f(1.0, 1.0, 1.0, 1.0))
			temVec = var
		end
	end
end
function DrawLine:remove()
	local remove = cc.RemoveSelf:create()
	self:runAction(remove)
end

return DrawLine