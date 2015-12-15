
#include "network/lua_extensions.h"

#if __cplusplus
extern "C" {
#endif
// socket
#include "lsqlite3.h"
#include "lua_cjson.h"
#include "orig_mplua/msgpack.h"

static luaL_Reg luax_exts[] = {
    {"lsqlite3", luaopen_lsqlite3},
    {"cjson", luaopen_cjson},
    {"msgpackcpp", luaopen_msgpackorig},

    {NULL, NULL}
};

void luaopen_lua_sqlite(lua_State *L)
{
    // load extensions
    luaL_Reg* lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for (; lib->func; lib++)
    {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);
}

#if __cplusplus
} // extern "C"
#endif
