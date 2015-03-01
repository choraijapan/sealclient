#include "lua_custlua_auto.hpp"
#include "LuaBridgeUtils.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_custlua_LuaBridgeUtils_test(lua_State* tolua_S)
{
    int argc = 0;
    custlua::LuaBridgeUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"custlua.LuaBridgeUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (custlua::LuaBridgeUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_custlua_LuaBridgeUtils_test'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "custlua.LuaBridgeUtils:test");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_custlua_LuaBridgeUtils_test'", nullptr);
            return 0;
        }
        std::string ret = cobj->test(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "custlua.LuaBridgeUtils:test",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_custlua_LuaBridgeUtils_test'.",&tolua_err);
#endif

    return 0;
}
int lua_custlua_LuaBridgeUtils_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"custlua.LuaBridgeUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_custlua_LuaBridgeUtils_getInstance'", nullptr);
            return 0;
        }
        custlua::LuaBridgeUtils* ret = custlua::LuaBridgeUtils::getInstance();
        object_to_luaval<custlua::LuaBridgeUtils>(tolua_S, "custlua.LuaBridgeUtils",(custlua::LuaBridgeUtils*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "custlua.LuaBridgeUtils:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_custlua_LuaBridgeUtils_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_custlua_LuaBridgeUtils_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LuaBridgeUtils)");
    return 0;
}

int lua_register_custlua_LuaBridgeUtils(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"custlua.LuaBridgeUtils");
    tolua_cclass(tolua_S,"LuaBridgeUtils","custlua.LuaBridgeUtils","",nullptr);

    tolua_beginmodule(tolua_S,"LuaBridgeUtils");
        tolua_function(tolua_S,"test",lua_custlua_LuaBridgeUtils_test);
        tolua_function(tolua_S,"getInstance", lua_custlua_LuaBridgeUtils_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(custlua::LuaBridgeUtils).name();
    g_luaType[typeName] = "custlua.LuaBridgeUtils";
    g_typeCast["LuaBridgeUtils"] = "custlua.LuaBridgeUtils";
    return 1;
}
TOLUA_API int register_all_custlua(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"custlua",0);
	tolua_beginmodule(tolua_S,"custlua");

	lua_register_custlua_LuaBridgeUtils(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

