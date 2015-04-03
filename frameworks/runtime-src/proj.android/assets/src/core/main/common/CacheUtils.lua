-------------------------------------------------------------------------------
-- core boot
-- @date 2015/02/18
-- @author masahiro mine
-------------------------------------------------------------------------------
--
CacheUtils = class("CacheData")

function CacheUtils:removeAllResource()
    cc.SpriteFrameCache:getInstance():removeSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeAllTextures()
    cc.Director:getInstance():getRunningScene():getEventDispatcher():removeAllEventListeners()
    ccs.SceneReader:destroyInstance()
    ccs.ActionManagerEx:destroyInstance()
    ccs.GUIReader:destroyInstance()
    ccs.ArmatureDataManager:destroyInstance()
end


function  CacheUtils:removeAllAppLua()
    local loadedLuaFile = package.loaded
    for k, v in pairs(loadedLuaFile) do
        local findPath =  string.find(k, "app.main")
        cclog(k)
        if findPath ~= nil then
            package.loaded[k] = nil
        end
    end
end
