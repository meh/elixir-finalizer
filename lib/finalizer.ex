#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Finalizer do
  def define(fun) when is_function fun, 0 do
    id = :gen_server.call(Finalizer.Manager, { :register, fun })

    Process.whereis(Finalizer.Manager)
      |> :resource.notify_when_destroyed({ :finalize, id })
  end

  def define(pid) when is_pid pid do
    :resource.notify_when_destroyed(pid, nil)
  end

  def define(name) do
    define(Process.whereis(name))
  end

  def define(data, fun) when is_function fun, 1 do
    id = :gen_server.call(Finalizer.Manager, { :register, fun })

    Process.whereis(Finalizer.Manager)
      |> :resource.notify_when_destroyed({ :finalize, id, data })
  end

  def define(data, pid) when is_pid pid do
    :resource.notify_when_destroyed(pid, data)
  end

  def define(data, name) do
    define(data, Process.whereis(name))
  end
end
