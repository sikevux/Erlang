-module(tcp_server).
-export([start_server/0, connect/1, recieve_loop/1]).

-define(LISTEN_PORT, 9999).
-define(TCP_OPTIONS, [binary, {packet, raw}, {nodelay, true}, {reuseaddr, true}, {active, once}]).

start_server() ->
	case gen_tcp:listen(?LISTEN_PORT, ?TCP_OPTIONS) of {ok, Listen} ->
			spawn(?MODULE, connect, [Listen]), io:format("~p Server Started.~n~n", [erlang:localtime()]);
		Error ->
			io:format("Error: ~p~n~n", [Error])
	end.

connect(Listen) ->
	{ok, Socket} = gen_tcp:accept(Listen), inet:setopts(Socket, ?TCP_OPTIONS), spawn(fun() ->
																							 connect(Listen) end), recieve_loop(Socket), gen_tcp:close(Socket).

recieve_loop(Socket) ->
	inet:setopts(Socket, [{active, once}]), receive {tcp, Socket, Data} ->
													io:format("~p ~p ~p~n~n", [erlang:localtime(), inet:peername(Socket), Data]), gen_tcp:send(Socket, "Got " ++ Data), recieve_loop(Socket);
													{tcp_closed, Socket} -> io:format("~p Luser left~n~n", [erlang:localtime()]) end.
