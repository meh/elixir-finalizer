defmodule Finalizer.Mixfile do
  use Mix.Project

  def project do
    [ app: :finalizer,
      version: "0.0.1",
      deps: deps ]
  end

  def application do
    [ mod: { Finalizer.Manager, [] } ]
  end

  defp deps do
    [ { :resource, github: "tonyrog/resource" } ]
  end
end
