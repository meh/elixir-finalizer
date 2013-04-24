#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Finalizer.Manager do
  use Application.Behaviour
  use GenServer.Behaviour

  def start(_, _) do
    if pid = Process.whereis(__MODULE__) do
      { :ok, pid }
    else
      case :gen_server.start_link(__MODULE__, [id: 0, finalizers: HashDict.new], []) do
        { :ok, pid } = r ->
          Process.register(pid, __MODULE__)
          r

        r -> r
      end
    end
  end

  def stop(_) do
    Process.exit(Process.whereis(__MODULE__), "application stopped")
  end

  def handle_call({ :register, fun }, _from, state) do
    id = state[:id] + 1

    { :reply, id, [ id: id, finalizers: Dict.put(state[:finalizers], id, fun) ] }
  end

  def handle_info({ :finalize, id, data }, state) do
    finalizer = Dict.get(state[:finalizers], id)

    cond do
      is_function finalizer, 0 ->
        finalizer.()

      is_function finalizer, 1 ->
        finalizer.(data)
    end

    { :noreply, [ id: state[:id], finalizers: Dict.delete(state[:finalizers], id) ] }
  end
end
