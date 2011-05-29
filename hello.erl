-module(hello).
-export([start/0]).

start() ->
		spawn(fun() ->
					  loop() end).
loop() ->
	receive
		hello ->
			io:format("Hello Ximena :3~n"),
			loop();
		goodbye ->
			ok
	end.
