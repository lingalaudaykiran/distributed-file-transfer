-module(speakout_blockTable_DB_API).
%-record(blockTable, {'_id', blockedIds}).
-compile([export_all]).
-include("include.hrl").
-include("include_speakout.hrl").
-include_lib("mongrel/include/mongrel_macros.hrl").

add_mappings() ->
        mongrel_mapper:add_mapping(?mapping(blockTable)).


createEntry(BlockerId) ->
	Blocker = #blockTable{'_id' = BlockerId, blockedIds = []},
	{ok, Connection} = mongo:connect(localhost),
        		mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
                                           mongrel:insert_all([Blocker])
                           end),
		BlockerId.

blockUser(BlockerId, User) ->	
	ExistIds = getBlockedIds(BlockerId),
	case ExistIds of 
	noBlockerIdExist ->noBlockerIdExist;
	_ ->
		case lists:member(User,ExistIds) of
		true -> alreadyBlocked;
		false ->
		{ok, Connection} = mongo:connect(localhost),
	        	mongrel:do(safe, master, Connection, speakout, 
	                           fun() ->
				mongrel:modify(#blockTable{ '_id' = 	BlockerId}, {'$push', #blockTable{blockedIds = User}})
	                          end)
		end
	end.




getBlockedIds(BlockerId) ->
	{ok, Connection} = mongo:connect(localhost),
	{ok, Result} = mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
			Cursor = mongrel:find(#blockTable{ '_id' = BlockerId}),
			mongrel_cursor:rest(Cursor)
                          end),
			case Result of
			[] -> noBlockerIdExist;				
			_ -> Record = lists:last(Result),
			     Record#blockTable.blockedIds
			end.


removeBlockedUser(BlockerId, BlockedId) ->

ExistIds = getBlockedIds(BlockerId),
	case ExistIds of 
	noBlockerIdExist ->noBlockerIdExist;
	_ ->
		case lists:member(BlockedId,ExistIds) of
		false -> notBlocked;
		true ->
		{ok, Connection} = mongo:connect(localhost),
	        	mongrel:do(safe, master, Connection, speakout, 
	                           fun() ->
				mongrel:modify(#blockTable{ '_id' = 	BlockerId}, {'$pop', #blockTable{blockedIds = BlockedId}})
	                          end)
		end
	end.

