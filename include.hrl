
-ifdef(ENABLE_DEBUG).
-define(INFO, io:format).
-define(DEBUG, io:format).
-else.
-define(INFO, ignore).
-define(DEBUG, ignore).
-endif.

-define(WARNING, io:format).
-define(ERROR, io:format).

