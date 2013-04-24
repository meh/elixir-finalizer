#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Finalizer do
  def define(fun) when is_function fun, 0 do
    manager = Process.whereis(Finalizer.Manager)
    id      = :gen_server.call(manager, { :register, fun })

    :resource.notify_when_destroyed(manager, { :finalize, id })
  end

  def define(pid) when is_pid pid do
    :resource.notify_when_destroyed(pid, nil)
  end

  def define(data, fun) when is_function fun, 1 do
    manager = Process.whereis(Finalizer.Manager)
    id      = :gen_server.call(manager, { :register, fun })

    :resource.notify_when_destroyed(manager, { :finalize, id, data })
  end

  def define(data, pid) when is_pid pid do
    :resource.notify_when_destroyed(pid, data)
  end
end
