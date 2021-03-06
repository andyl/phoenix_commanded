defmodule Comspec do
  @moduledoc """
  A struct to handle a comspec.
  """

  use TypedStruct

  typedstruct do
    # meta-data
    field(:spec_key, String.t())
    field(:spec_name, String.t())
    field(:spec_shortdoc, String.t())
    field(:spec_doc, String.t())
    field(:spec_run_before, list())
    field(:spec_run_after, list())
    # specification
    field(:aggregates, list())
    field(:commands, list())
    field(:command_handlers, list())
    field(:command_routers, list())
    field(:command_validators, list())
    field(:events, list())
    field(:event_handlers, list())
    field(:event_projectors, list())
    field(:process_managers, list())
    field(:read_schemas, list())
    field(:read_queries, list())
  end

  @doc """
  Run the code generator.
  """
  def build(comspec_name) do
    comspec = ComspecConfig.struct_data!(comspec_name)
    Comspec.Event.build_events(comspec)
    Comspec.Aggregate.build_aggregates(comspec)
    Comspec.Command.build_commands(comspec)
  end

  @doc """
  Return the 'name' for a comspec.

  The name is the 'resource name'.  (like "Accounts" or "Users")

  The default value for name is the key that is used to identify the resource.
  If a :spec_name is also defined, that will become the name.

  Sometimes it will be handy to create a series of comspecs, where each comspec
  layers incremental capability to a resource.  In this case, use a series of
  unique comspec keys (like 'Accounts1', 'Accounts2', etc.), each which use the
  same :spec_name (like 'Accounts').
  """
  def name(comspec) do
    # spec_name is manually (optionally) supplied
    # spec_key is the config key
    to_string(comspec.spec_name || comspec.spec_key)
  end

  @doc """
  Returns the directory name for a comspec.
  """
  def dirname(comspec, type \\ "lib") do
    res_dir = comspec |> name() |> Mix.Comgen.snake()
    app_dir = Mix.Comgen.app() |> to_string()
    "#{basedir()}#{type}/#{app_dir}/#{res_dir}"
  end

  @doc """
  Base directory for file generation.

  When MIX_ENV==test, basedir == "tmp/"
  Otherwise, basedir == ""
  """
  def basedir do
    case Mix.env() do
      :test -> "tmp/"
      _ -> ''
    end
  end

  @doc """
  Returns the template directory.
  """
  def template_dir do
    :code.priv_dir(:comgen)
    |> (&"#{&1}/templates/comgen.build/").()
  end
end
