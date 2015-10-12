
local SceneGameResult = class("SceneGameResult", function()
    return cc.Layer:create()
end)

function SceneGameResult:ctor()

end

function SceneGameResult:create(isWin)
    local layer = SceneGameResult.new()
    layer:init(isWin)
    return layer
end


function SceneGameResult:createScene(isWin)
    local scene = cc.Scene:create()
    local layer = SceneGameResult:create(isWin)
    scene:addChild(layer)
    return scene
end


function SceneGameResult:init(isWin)
    self:loadingMusic()
    self:addBG()
    self:addBtn()
    local winOrLost = cc.Label:createWithSystemFont("", "HelveticaNeue-Bold", 30)
    winOrLost:setPosition(cc.p(WIN_SIZE.width/2,WIN_SIZE.height/2))
    self:addChild(winOrLost)
    if isWin then
        winOrLost:setString("You Win!!!")
    else
        winOrLost:setString("You Lost!!!")
    end
end


-- 背景音乐
function SceneGameResult:loadingMusic()
    if Global:getInstance():getAudioState() == true then
        cc.SimpleAudioEngine:getInstance():stopMusic()
        cc.SimpleAudioEngine:getInstance():playMusic("Music/mainMainMusic.mp3", true)
    else
        cc.SimpleAudioEngine:getInstance():stopMusic()
    end
end


-- 添加背景
function SceneGameResult:addBG()
--    -- 背景图片
--    local bg = cc.Sprite:create("loading.png")
--    bg:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2))
--    self:addChild(bg, -1)
--
--    -- logo
--    local logo = cc.Sprite:create("gameOver.png")
--    logo:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2 + 150))
--    self:addChild(logo, 10)
end


-- 添加按钮
function SceneGameResult:addBtn()
    local function callback(tag, sender)
        if sender:getTag() == 101 then
            self:turnToGameScene()
        else
            self:turnToLoadingScene()
        end
    end

    -- 重新游戏 tag = 101
    local playAgainNormal = cc.Sprite:create("menu.png",cc.rect(378, 0, 126, 33))
    local playAgainSelected = cc.Sprite:create("menu.png",cc.rect(378, 33, 126, 33))
    local playAgainDisabled = cc.Sprite:create("menu.png",cc.rect(378, 2*33, 126, 33))
    local playAgain = cc.MenuItemSprite:create(playAgainNormal, playAgainSelected, playAgainDisabled)
    playAgain:setTag(101)
    playAgain:registerScriptTapHandler(callback)

    -- 返回菜单 tag = 102
    local backNormal = cc.Sprite:create("menu.png", cc.rect(505, 1, 126, 31))
    local backSelected = cc.Sprite:create("menu.png", cc.rect(505, 34, 126, 31))
    local backDesabled = cc.Sprite:create("menu.png", cc.rect(505, 34*2, 126, 31))
    local back = cc.MenuItemSprite:create(backNormal, backSelected, backDesabled)
    back:setTag(102)
    back:registerScriptTapHandler(callback)

    -- 创建菜单
    local pmenu = cc.Menu:create(playAgain, back)
    pmenu:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2-100))
    self:addChild(pmenu,1,3);
    pmenu:alignItemsVerticallyWithPadding(40)
end


-- 重新游戏
function SceneGameResult:turnToGameScene()
    local scene = GameScene:createScene()
    local tt = cc.TransitionFade:create(1.0, scene)
    cc.Director:getInstance():replaceScene(tt)
end


-- 返回主界面
function SceneGameResult:turnToLoadingScene()
    local scene = LoadingScene:createScene()
    local tt = cc.TransitionFade:create(1.0, scene)
    cc.Director:getInstance():replaceScene(tt)
end

return SceneGameResult
    
