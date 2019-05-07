-module(nx1_db_worker).

-behaviour(gen_server).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3
        ]).

-export([start_link/0,
         addUser/2
        ]).

%% Used by worker_pool

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

addUser(UserData, Uuid) ->
    wpool:cast(db_pool, {add_user, UserData, Uuid}).

init(_Args) ->
  {ok, []}.

handle_call(_, _From, State) ->
  {noreply, State}.

handle_cast({add_user, UserInfo, Uuid}, State) ->
  addUserToDB(UserInfo, Uuid),
  {noreply, State};
handle_cast(stop, State) ->
  {stop, normal, State};
handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_, State) ->
  {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(normal, _State) ->
    ok;
terminate(Reason, _State) ->
    lager:error("DB worker terminate error: ~p", [Reason]),
    ok.

addUserToDB(UserInfo, Uuid) ->
    nx1_couch_db:write(UserInfo,Uuid).