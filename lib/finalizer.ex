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
