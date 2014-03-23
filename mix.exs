defmodule Finalizer.Mixfile do
  use Mix.Project

  def project do
    [ app:     :finalizer,
      version: "0.0.2",
      elixir:  "~> 0.12.5",
      deps:    deps ]
  end

  def application do
    [ mod: { Finalizer, [] } ]
  end

  defp deps do
    [ { :resource, github: "tonyrog/resource" } ]
  end
end
