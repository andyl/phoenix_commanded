defmodule ComspecUtil do
  @moduledoc """
  Utilities to manage and manipulate comspec data.

  Generally, the functions here take a comspec and/or a submodule as an
  argument.

  Submodules are items from the Event/Command/Aggregate elements in the
  comspec.  Submodules have a `name` and a `fields` attributes.
  """

  def name(comspec) do
    comspec.spec_name || comspec.spec_key
  end

  def dirname(comspec, type, submodule) do
    Comspec.dirname(comspec, type) <> "/" <> submodule
  end

  def string_fields(submodule) do
    submodule.fields
    |> Enum.map(&":#{to_string(&1)}")
    |> Enum.join(", ")
  end

  def module_long(comspec, submodule, modtype) do
    "#{Mix.Comgen.app_module()}.#{name(comspec)}.#{modtype}.#{submodule.name}"
  end

  def module_short(submodule) do
    submodule.name
  end

  def generate_files(comspec, filedata, annotations \\ nil) do
    context = [comspec: comspec, filedata: filedata, annotations: annotations]
    paths = filedata[:templates]

    Mix.Comgen.gen_file(paths.lib.src, paths.lib.dst, context)
    Mix.Comgen.gen_file(paths.test.src, paths.test.dst, context)
  end
end
