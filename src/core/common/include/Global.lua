-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
collectgarbage("collect")
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)

require("core.common.DebugLog")

require("core.common.const.GameSysConst")
require('core.common.const.WidgetConst')
require('core.common.const.LayerConst')
require("core.common.CacheUtils")
require("core.common.VisibleRect")


require("core.manager.SceneManager")
require("core.manager.TouchManager")
require("core.manager.ScheduleManager")


require("core.common.config.CleanUpList")
require("core.common.config.Environment")


require('core.extension.WidgetObj')
require('core.extension.WidgetLoader')


require('core.utils.utf8')


