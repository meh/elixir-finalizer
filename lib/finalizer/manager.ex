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
      case :gen_server.start_link(__MODULE__, { 0, HashDict.new }, []) do
        { :ok, pid } = r ->
          Process.register(pid, __MODULE__)
          r

        r -> r
      end
    end
  end

  def stop(_) do
    Process.whereis(__MODULE__) |> Process.exit("application stopped")
  end

  def handle_call({ :register, fun }, _from, { last_id, finalizers }) do
    id = last_id + 1

    { :reply, id, { id, Dict.put(finalizers, id, fun) } }
  end

  def handle_info({ :finalize, id }, { last_id, finalizers }) do
    Dict.get!(finalizers, id).()

    { :noreply, { last_id, Dict.delete(finalizers, id) } }
  end

  def handle_info({ :finalize, id, data }, { last_id, finalizers }) do
    Dict.get!(finalizers, id).(data)

    { :noreply, { last_id, Dict.delete(finalizers, id) } }
  end
end
