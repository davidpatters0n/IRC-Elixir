defmodule Exile.Bot do
  use GenServer  

  def start_link(state) do 
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do 
    #Creates a socket connection IRC server. 
    #Pattern matching used here to expect the call to be successful
    {:ok, sock} = Socket.TCP.connect(state.host, state.port, packet: :line)
    #Genserver takes a 3rd opt param which represents the timeout
    #seting to 0 tells GenServer to timeout immediately. 
    {:ok, %{state | sock: sock}, 0} 
  end

  def handle_info(:timeout, state) do
    state |> do_join_channel |> do_listen
    #without pipe we'd do `do_listen(do_join_channel(state))`
     { :noreply, state }
  end

  defp do_join_channel(%{sock: sock} = state) do
    sock |> Socket.Stream.send!("NICK #{state.nick}\r\n")
    sock |> Socket.Stream.send!("USER #{state.nick} #{state.host} #{state.nick} #{state.nick}\r\n")
    sock |> Socket.Stream.send!("JOIN #{state.chan}\r\n")
    state
  end


  #Once we join the server need to listen to any replies from the server

  defp do_listen(%{sock: sock} = state) do
    case state.sock |> Socket.Stream.recv! do
      data when is_binary(data) ->
        IO.inspect data
        do_listen(state)
      nil ->
        :ok
    end
  end
end
