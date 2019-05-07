-module(nx1_users_if).

-export([go/0]).
-compile([export_all]).

go()->
	io:format("Trying hard in solving the challenge 1....."),
	addUser(get_data()).

get_data()->
	{[{<<"fname">>,<<"Bob">>},{<<"lname">>,<<"Smith">>},{<<"account_balance">>,1323.34},
	{<<"account_id">>, <<"10000000000AD">>}],[{<<"fname">>,<<"Larry">>},{<<"lname">>,<<"Roberts">>},{<<"account_balance">>,1200.01},
	{<<"account_id">>, <<"10000000002FH">>}]}.

addUser(UDataSerice) when is_tuple(UDataSerice) ->
	addUser(erlang:tuple_to_list(UDataSerice));
addUser(UDataSerice) when is_list(UDataSerice) ->
	Process = 
		fun(UData)->
			nx1_db:addUser(UData)
		end,
	lists:foreach(Process,UDataSerice).


