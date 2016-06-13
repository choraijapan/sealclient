-------------------------------------------------------------------------------
-- AreaData
-- @date 2015/02/25
-- @author cho rai
-------------------------------------------------------------------------------
local AreaData = class("AreaData", Game.BaseDb)
AreaData.type = EnvironmentConst.DB.TYPE_MASTER
AreaData.db_name = "area_data.db"
AreaData.table_name = "area_data"
AreaData.col_def = {
	id				= 0,
	name			= "",
	discription		= "",
	next_id			= 0,
	reward_id		= 0,
	start_story_id	= 0,
	end_story_id	= 0
}

function AreaData:init(data)
	if data ~= nil then
		AreaData.col_def.id = data.id
		AreaData.col_def.name = data.name
		AreaData.col_def.discription = data.discription
		AreaData.col_def.next_id = data.next_id
		AreaData.col_def.reward_id = data.reward_id
		AreaData.col_def.start_story_id = data.start_story_id
		AreaData.col_def.end_story_id = data.end_story_id
	end
end

function AreaData:initById(id)
	local data = self:findById(id)
	AreaData:init(data)
end

function AreaData:getAll()
	return self:findAll()	
end

function AreaData:getId()
	return AreaData.col_def.id
end

function AreaData:getName()
	return AreaData.col_def.name
end

function AreaData:getDiscription()
	return AreaData.col_def.discription
end

function AreaData:getNextId()
	return AreaData.col_def.next_id
end

function AreaData:getRewardId()
	return AreaData.col_def.reward_id
end

function AreaData:getStartStoryId()
	return AreaData.col_def.start_story_id
end

function AreaData:getEndStoryId()
	return AreaData.col_def.end_story_id
end

return AreaData