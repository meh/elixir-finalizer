#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Finalizer do
  defp receiver(fun) do
    fn ->
      receive do
        data -> fun.(data)
      end
    end
  end

  def define(data, fun) when is_function fun do
    :resource.notify_when_destroyed(spawn(receiver(fun)), data)
  end

  def define(data, pid) when is_pid pid do
    :resource.notify_when_destroyed(pid, data)
  end
end
