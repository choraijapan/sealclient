-------------------------------------------------------------------------------
-- CardData
-- @date 2015/01/05
-- @author cho rai
-- TODO
-------------------------------------------------------------------------------
local CardData = class("CardData", Game.BaseDb)

CardData.type = EnvironmentConst.DB.TYPE_MASTER
CardData.db_name = "master.db"
CardData.table_name = "area_data"
CardData.col_def = {
    id = "int",
    name = "card name",
	content = "string",
    rarity = 0,
    attribute = 0,
    skillId = 0,
    hp = 0,
}

return CardData