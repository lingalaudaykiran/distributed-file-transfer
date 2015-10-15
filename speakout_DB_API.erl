-module(speakout_DB_API).
 -export([add_mappings/0, insertSampleUser/0, get_allUsers/0, get_user/2, insertSampleLanguage/0]).
 -include_lib("mongrel/include/mongrel_macros.hrl").

% the userinfo is the colletion name
% The field names should exactly match with the database field names.
% all the fields should start with small letters
  -record(userinfo, {'_id', user_id, phone, name, status, languageId}).
  -record(language, {'_id', l_id, name }).

add_mappings() ->
        % For mongrel to work, we need to specify how to map books, authors and reviews.
        mongrel_mapper:add_mapping(?mapping(userinfo)),
	 mongrel_mapper:add_mapping(?mapping(language)).


 insertSampleUser() ->
        % Create some users
	 % make sure that left hand side variable should start with Upper case letter
 	User2 = #userinfo{?id(), user_id = 1, phone = 4012344567, name = "kiran", status = "cool", languageId = 10},
	User1 = #userinfo{?id(), user_id = 2, phone = 4012344537, name = "k3iran", status = "coorel", languageId = 10},
       {ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:delete(#userinfo{}),
                                           mongrel:insert_all([User2, User1])
                           end).
 insertSampleLanguage() -> 
	Lang1 = #language{?id(), l_id = 1, name = "Hindi"},
	Lang2 = #language{?id(), l_id = 2, name = "Telugu"},
       {ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   mongrel:delete(#language{}),
                                           mongrel:insert_all([Lang1, Lang2])
                           end).
get_allUsers() ->
        {ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
                                           Cursor = mongrel:find(#userinfo{}),
                                           mongrel_cursor:rest(Cursor)
                           end).
 
get_user(Id, Name)-> 
	{ok, Connection} = mongo:connect(localhost),
        mongrel:do(safe, master, Connection, speakout, 
                           fun() ->
					   Cursor = mongrel:find(#userinfo{user_id = Id, name = Name}),
					   mongrel_cursor:rest(Cursor)
			   end).
