IAPManager = class("IAPManager")

function IAPManager:init()
    if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
        sdkbox.IAP:init()
    end
end

function IAPManager:purchase(id)
    if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
        sdkbox.IAP:purchase(id)
    end
end
 
--[[
sdkbox.IAP:setListener(function(args)
if "onSuccess" == args.event then
local product = args.product
dump(product, "onSuccess:")
elseif "onFailure" == args.event then
local product = args.product
local msg = args.msg
dump(product, "onFailure:")
print("msg:", msg)
elseif "onCanceled" == args.event then
local product = args.product
dump(product, "onCanceled:")
elseif "onRestored" == args.event then
local product = args.product
dump(product, "onRestored:")
elseif "onProductRequestSuccess" == args.event then
local products = args.products
dump(products, "onProductRequestSuccess:")
elseif "onProductRequestFailure" == args.event then
local msg = args.msg
print("msg:", msg)
else
print("unknown event ", args.event)
end
end)
]]--
function IAPManager:setListener(callback)
     if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
        sdkbox.IAP:setListener(callback)
     end
end
return IAPManager




