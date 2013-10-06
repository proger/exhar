defmodule Exhar.Mixfile do
  use Mix.Project

  def project do
    [ app: :exhar,
      version: "0.0.1",
      elixir: "~> 0.10.3",
      deps: deps ]
  end

  def application do
    [applications: [:hackney]]
  end

  defp deps do
    [{ :json, github: "cblage/elixir-json"},
     { :hackney, "0.4.4", [github: "benoitc/hackney", tag: "0.4.4"]}]
  end
end
