#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Finalizer.Manager do
  use GenServer.Behaviour

  def start_link(_args \\ []) do
    :gen_server.start_link({ :local, :finalizer }, __MODULE__, [], [])
  end

  def handle_call({ :register, fun }, _from, { last_id, finalizers }) do
    id = last_id + 1

    { :reply, id, { id, Dict.put(finalizers, id, fun) } }
  end

  def handle_info({ :finalize, id }, { last_id, finalizers }) do
    Dict.get(finalizers, id).()

    { :noreply, { last_id, Dict.delete(finalizers, id) } }
  end

  def handle_info({ :finalize, id, data }, { last_id, finalizers }) do
    Dict.get(finalizers, id).(data)

    { :noreply, { last_id, Dict.delete(finalizers, id) } }
  end
end
