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
	io:format("~nConverting tuple to list ~n"),
	addUser(erlang:tuple_to_list(UDataSerice));
addUser(UDataSerice) when is_list(UDataSerice) ->
	Process = 
		fun(UData)->
			io:format("~n Passing the single User Data(Key value pair) to Worker Pool ~p~n",[UData]),
			nx1_db:addUser(UData)
		end,
	lists:foreach(Process,UDataSerice).


