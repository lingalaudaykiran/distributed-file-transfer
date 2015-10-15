
-record(userinfo, {'_id', user_id, phone, name, status, languageId, profilePic}).
-record(blockTable, {'_id', blockedIds}).
-record(language, {'_id', language}).
-record(pendData,{'_id', senderId, userList, binary, format, languageId, timeStamp }).
