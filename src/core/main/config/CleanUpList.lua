-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------


CleanUpList = class("CleanUpList",nil)

CleanUpList.TYPE_SCENE = 'SCENE'

CleanUpList.LIST = {
  [CleanUpList.TYPE_SCENE] = {
    'app.scene.GameScene'
  }
}
