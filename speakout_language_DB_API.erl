-module(speakout_userinfo_DB_API).


-include_lib("mongrel/include/mongrel_macros.hrl").

-record(language, {'_id', l_id, name }).

add_mappings() ->
        % For mongrel to work, we need to specify how to map books, authors and reviews.
	 mongrel_mapper:add_mapping(?mapping(language)).
