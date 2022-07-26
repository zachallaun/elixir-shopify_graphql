defmodule Koios.Schema do
  @moduledoc false

  defmacro __using__(from_sdl: path) do
    quote generated: true, location: :keep do
      use Absinthe.Schema

      import_sdl(path: unquote(path))

      def hydrate(%Absinthe.Blueprint.Schema.InterfaceTypeDefinition{}, _ancestors) do
        {:resolve_type, &Koios.Schema.interface_resolve_type/2}
      end

      def hydrate(node, _ancestors) do
        []
      end
    end
  end

  @doc false
  def interface_resolve_type({:external, %{"__typename" => typename}}, _) do
    typename
    |> Absinthe.Adapter.LanguageConventions.to_internal_name(nil)
    |> String.to_atom()
  end

  def validate(schema, doc) do
    pipeline =
      schema
      |> Absinthe.Pipeline.for_document()
      |> Absinthe.Pipeline.without(Absinthe.Phase.Subscription.SubscribeSelf)
      |> Absinthe.Pipeline.without(Absinthe.Phase.Document.Execution.Resolution)
      |> Absinthe.Pipeline.insert_before(
        Absinthe.Phase.Document.Result,
        Koios.FakeAbsintheResult
      )

    case Absinthe.Pipeline.run(doc, pipeline) do
      {:ok, %{execution: %{validation_errors: []}}, _} -> {:ok, []}
      {:ok, %{execution: %{validation_errors: errors}}, _} -> {:error, errors}
      other -> {:error, other}
    end
  end

  def validate!(schema, doc) do
    case validate(schema, doc) do
      {:ok, []} -> :ok
      {:error, errors} -> raise Absinthe.Schema.Error, phase_errors: errors
    end
  end
end
