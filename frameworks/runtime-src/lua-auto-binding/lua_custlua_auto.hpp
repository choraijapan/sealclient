#include "base/ccConfig.h"
#ifndef __custlua_h__
#define __custlua_h__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

int register_all_custlua(lua_State* tolua_S);




#endif // __custlua_h__
