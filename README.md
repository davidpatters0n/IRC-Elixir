Exile
=====

** TODO: Add description **
#IRC Logger in Elixir 

First little play around using Elixir following the above tutorial. 

In order to run execture the following 

```elixir 

iex -S mix 

state = %{host: "irc.freenode.net", port: 6667, chan: "#elixir-lang", nick: "exile-bot", sock: nil}

Exile.Bot.start_link(state) 

```
