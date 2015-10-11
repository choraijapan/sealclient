//
//  LuaApiAstarFindPath.cpp
//  sample
//
//  Created by CF0235 on 2014/05/19.
//
//

#include "LuaBridgeUtils.h"
#include "CCLuaEngine.h"
using namespace custlua;


static LuaBridgeUtils *_instance = nullptr;


LuaBridgeUtils* LuaBridgeUtils::getInstance()
{
    if (!_instance)
    {
        _instance = new LuaBridgeUtils();
    }
    
    return _instance;
}

LuaBridgeUtils::LuaBridgeUtils()
{
}


std::string LuaBridgeUtils::test(std::string arg)
{
    return "test";
}


