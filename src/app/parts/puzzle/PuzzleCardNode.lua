--------------------------------------------------------------------------------
-- PuzzleCardNode
local PuzzleCardNode = class("PuzzleCardNode", cc.Node)
--------------------------------------------------------------------------------
-- const変数
local TAG = "PuzzleCardNode:"
local CSBFILE = "parts/puzzle/PuzzleCardNode.csb"

--------------------------------------------------------------------------------
-- メンバ変数
PuzzleCardNode.parent = nil
PuzzleCardNode.cards = {
	card1 = nil,
	card2 = nil,
	card3 = nil,
	card4 = nil,
	card5 = nil,
	card6 = nil
}
--------------------------------------------------------------------------------
-- UI変数
--------------------------------------------------------------------------------
-- constructor
function PuzzleCardNode:ctor()
end
--------------------------------------------------------------------------------
-- create
function PuzzleCardNode:create()
	self.gameCardNode = WidgetLoader:loadCsbFile(CSBFILE)
	self:addChild(self.gameCardNode)
	self:init()
	return self
end
--------------------------------------------------------------------------------
-- Init
function PuzzleCardNode:init()
	self.cards.card1 = WidgetObj:searchWidgetByName(self,"Sprite_1","cc.Sprite")
	self.cards.card2 = WidgetObj:searchWidgetByName(self,"Sprite_2","cc.Sprite")
	self.cards.card3 = WidgetObj:searchWidgetByName(self,"Sprite_3","cc.Sprite")
	self.cards.card4 = WidgetObj:searchWidgetByName(self,"Sprite_4","cc.Sprite")
	self.cards.card5 = WidgetObj:searchWidgetByName(self,"Sprite_5","cc.Sprite")
	self.cards.card6 = WidgetObj:searchWidgetByName(self,"Sprite_6","cc.Sprite")
	self.cards.card1.attribute = 1
	self.cards.card2.attribute = 2
	self.cards.card3.attribute = 3
	self.cards.card4.attribute = 1
	self.cards.card5.attribute = 4
	self.cards.card6.attribute = 5
	self.gameCardNode:setPosition(cc.p(0,cc.Director:getInstance():getWinSize().height*1/2))
end
--------------------------------------------------------------------------------
-- add touch
function PuzzleCardNode:addTouch()
end
return PuzzleCardNode