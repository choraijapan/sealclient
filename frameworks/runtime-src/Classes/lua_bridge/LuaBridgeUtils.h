//
//  LuaApiActivityIndicator.h
//  sample
//
//  Created by CF0235 on 2014/05/19.
//
//

#ifndef __game_client__LuaBridgeUtils__
#define __game_client__LuaBridgeUtils__

#include <iostream>
#include "cocos2d.h"

namespace custlua {
	
	class LuaBridgeUtils : public cocos2d::Ref {
    private:
        LuaBridgeUtils(void);
        LuaBridgeUtils* _singleton;

        
    public:
        static LuaBridgeUtils* getInstance();
        std::string test(std::string arg);
        
    };
	
}
#endif /* defined(__game_client__LuaBridgeUtils__) */
