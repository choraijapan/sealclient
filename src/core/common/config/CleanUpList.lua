-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------


CleanUpList = class("CleanUpList",nil)

CleanUpList.TYPE_SCENE = 'SCENE'

CleanUpList.TYPE_GLOBAL = 'GLOBAL'

CleanUpList.LIST = {
	[CleanUpList.TYPE_SCENE] = {
		'app.scene.GameScene'
	},
	
	[CleanUpList.TYPE_GLOBAL] = {
        'app.data',
        'app.common'
    }
}

