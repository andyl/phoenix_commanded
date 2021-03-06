defmodule Mix.Tasks.Comgen.Add.Estore do
  use Mix.Task

  @shortdoc "Add Commanded Event Store"

  @moduledoc """
  Add Commanded Event Store

  Runs mix tasks:

      mix compile
      MIX_ENV=test mix compile
      mix event_store.create
      mix event_store.init
      MIX_ENV=test mix event_store.create
      MIX_ENV=test mix event_store.init

  """

  @doc false
  def run(_) do
    div = "-----------------------------------------------------------"
    IO.puts "----- Compile DEV\n#{div}"
    Mix.Comgen.shellcmd("mix compile")
    IO.puts "----- Compile TEST\n#{div}"
    Mix.Comgen.shellcmd("mix compile", [{"MIX_ENV", "test"}])
    IO.puts "----- Estore for DEV\n#{div}"
    Mix.Comgen.shellcmd("mix event_store.create")
    Mix.Comgen.shellcmd("mix event_store.init")
    IO.puts "----- Estore for TEST\n#{div}"
    Mix.Comgen.shellcmd("mix event_store.create", [{"MIX_ENV", "test"}])
    Mix.Comgen.shellcmd("mix event_store.init", [{"MIX_ENV", "test"}])
  end
end
