-module(speakout_conversation_DB_API).
-compile([export_all]).
-include_lib("mongrel/include/mongrel_macros.hrl").
-record(conversations, {'_id', id, user_list, messages}).
-record(data, { data_id, sender_id, language_id, format, length, binary,timestamp}).
add_mappings() ->
	mongrel_mapper:add_mapping(?mapping(conversations)),
	mongrel_mapper:add_mapping(?mapping(data)).

-spec(getConversationId(list(integer))->{ok, integer()}).	
getConversationId(UserList) ->
	{ok, Connection} = mongo:connect(localhost),
			mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					try
					   Result = mongrel:find_one(#conversations{user_list = UserList}),
					   Result#conversations.id
					catch
					Ex:Type -> {Ex, Type, erlang:get_stacktrace()},
					Result1=0,
					Result1
					end
				 
				end).
addDataToConversation(ConversationId, DataId, SenderId, Binary, TimeStamp) ->
	DataRecord = #data{ data_id = DataId, sender_id = SenderId, binary = Binary, timestamp = TimeStamp},
	{ok, Connection} = mongo:connect(localhost),
	mongrel:do(safe, master, Connection, speakout, 
                           fun() -> 
				   mongrel:modify(#conversations{id=ConversationId},{'$push',#conversations{messages=DataRecord}})
				   
			   end).

createConversation(UserList) ->
	{ok, Connection} = mongo:connect(localhost),
	mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					{ok, ConvId} = getConversationId(UserList),
					try
					case ConvId > 0 of
						true -> ConvId;
					false ->
						
					{A,B,C} = now(),
						
						Conv = #conversations{?id(), id = C, user_list = UserList},
						mongrel:insert_all([Conv]),
						C
					end
					catch
					Ex:Type -> {Ex, Type, erlang:get_stacktrace()}
					
					end
						
				end).
							
