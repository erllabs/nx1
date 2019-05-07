-module(nx1_utils).
-compile([export_all]).

get_uuid() ->
  Uuid = uuid:uuid_to_string(uuid:get_v4()),
  re:replace(Uuid, "-", "", [global, {return, binary}]).

get_timestamp()->
	erlang:system_time(millisecond).