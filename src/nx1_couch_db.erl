-module(nx1_couch_db).
-compile([export_all]).


init()->
	ok.

create_database()->
	Url = get_url(),
	AuthStr = get_auth(),
	Method = put,
	Type = "application/json",
	FUrl = Url ++ "/nexos_payments",
	Header = [{"Authorization", "Basic " ++ AuthStr}],
	HTTPOptions = [],
	Options = [],
	{ok, Res} =
	httpc:request(Method, {FUrl, Header, Type, ""}, HTTPOptions, Options),
	io:format("The result is ~p",[Res]).

write(UserInfo,Uuid)->
	io:format("Writing the document:~p",[{UserInfo,Uuid}]),
	Url = get_url(),
	AuthStr = get_auth(),
	Method = put,
	Type = "application/json",
	FUrl = Url ++ "/nexos_payments/" ++ erlang:binary_to_list(Uuid) ,
	Header = [{"Authorization", "Basic " ++ AuthStr}],
	HTTPOptions = [],
	Options = [],
	{ok, Res} =
	httpc:request(Method, {FUrl, Header, Type, UserInfo}, HTTPOptions, Options),
	io:format("The result is ~p",[Res]).

get_auth()->
	Username = config:get_local_option(user),
	Password = config:get_local_option(password),
	base64:encode_to_string(Username ++ ":" ++ Password).

get_url()->
	config:get_local_option(couch_db).

