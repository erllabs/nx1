-module(config).

-export([get_local_option/1]).

get_local_option(Key) ->
  get_local_option(Key, undefined).

%% Internal API
get_local_option(Key, Def) ->
  application:get_env(nx1, Key, Def).
