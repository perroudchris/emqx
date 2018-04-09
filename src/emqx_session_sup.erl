%%--------------------------------------------------------------------
%% Copyright (c) 2013-2018 EMQ Inc. All rights reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_session_sup).

-behavior(supervisor).

-include("emqx.hrl").

-export([start_link/0, start_session/1]).

-export([init/1]).

-spec(start_link() -> {ok, pid()}).
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

-spec(start_session(session()) -> {ok, pid()}).
start_session(Session) ->
    supervisor:start_child(?MODULE, [Session]).

%%--------------------------------------------------------------------
%% Supervisor callbacks
%%--------------------------------------------------------------------

init([]) ->
    {ok, {{simple_one_for_one, 0, 1},
          [{session, {emqx_session, start_link, []},
              temporary, 5000, worker, [emqx_session]}]}}.
