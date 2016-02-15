-------------------------------------------------------------------------------
-- @date 2015/10/14
-- @author chorai
-------------------------------------------------------------------------------
NetWorkConst = {}

NetWorkConst.WS = {
	URL = 'ws://127.0.0.1',
	MSG_CODE = {
	   CREATE_ROOM = 1001,
	   JOIN_ROOM = 1002,
	   LEAVE_ROOM = 1003,
	   GET_MEMBERS = 1004,
	   ERROR = 9999,
	},
	
	CUST_OP_CODE = {
	   ACK = 1,
	   HEAL = 2,
	}
}
