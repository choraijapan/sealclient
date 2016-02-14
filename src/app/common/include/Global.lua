-------------------------------------------------------------------------------
-- Global
-- @date 2015/10/18
-------------------------------------------------------------------------------
Game = {}

require("app.common.const.GameConst")
require("app.common.const.EnvironmentConst")
require("app.common.const.AppConst")
require("app.common.const.DBConst")
require("app.common.const.NetWorkConst")
require("app.common.utils.GameUtils")


Game.BaseDb = require("app.data.db.BaseDB")
Game.BaseDb = require("app.network.ws.MultiManager")
Game.BaseApi = require("app.network.api.BaseApi")
Game.MultiManager = require("app.network.ws.MultiManager")


