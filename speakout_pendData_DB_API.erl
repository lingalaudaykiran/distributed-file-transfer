-module(speakout_pendData_DB_API).
-include("include_speakout.hrl").
-include_lib("mongrel/include/mongrel_macros.hrl").
-compile([export_all]).

add_mappings() ->
        % For mongrel to work, we need to specify how to map books, authors and reviews.
        mongrel_mapper:add_mapping(?mapping(pendData)).
addData(SenderId, UserList, Binary, TimeStamp) -> 
	Data = #pendData{?id(), senderId = SenderId, userList = UserList, binary = Binary, timeStamp = TimeStamp},
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
                                           mongrel:insert_all([Data])
                           end).
