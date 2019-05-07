-module(nx1_db).

-export([
         start_link/0,
         addUser/1,
         create_cache/0
        ]).

-define(Table, userTable).

-record(userTable,{
	user_id, 
	account_id, 
	fname, lname, 
	account_balance, 
	created_at}).

start_link() ->
  	WorkersAmount = config:get_local_option(db_workers_amount),
  	create_cache(),
  	wpool:start_pool(
    	db_pool,
    	[{workers, WorkersAmount}, {worker, {nx1_db_worker, []}}]
   		).

addUser(UData)->
	Uuid = nx1_utils:get_uuid(),
	Ts = nx1_utils:get_timestamp(),
	Rec = #userTable{
		user_id = Uuid,
		account_id = proplists:get_value(<<"account_id">>, UData),
		fname = proplists:get_value(<<"fname">>, UData),
		lname = proplists:get_value(<<"lname">>, UData),
		account_balance = proplists:get_value(<<"account_balance">>, UData),
		created_at = Ts
	},
	add_to_cache(proplists:get_value(<<"account_id">>,UData),Rec),
	JUData = jsx:encode([{<<"created_at">>,Ts},{<<"user_id">>, Uuid}] ++ UData),
	nx1_db_worker:addUser(JUData, Uuid).

create_cache()->
	io:format("~n Creating the Cache for faster User Data(Key value pair) access using ETS -~n",[]),
	ets:new(?Table, [named_table,public,set]).

add_to_cache(AccountId,Record)->
	io:format("~n Caching the User Data(Key value pair) using ETS - AccountId - ~p~n",[AccountId]),
	ets:insert(?Table,{AccountId,Record}).
