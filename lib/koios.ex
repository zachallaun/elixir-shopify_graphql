defmodule Koios do
  @moduledoc """
  General-purpose GraphQL client with compile-time validation against a schema.

  ### Usage

      defmodule Example do
        use Koios, sdl: "schemas/shopify-admin/2022-07.graphql"

        def example do
          ~Q\"""
            {
              orders(first: 10) {
                edges {
                  node {
                    id
                  }
                }
              }
            }
          \"""
        end
      end
  """

  alias Koios.Schema

  defmacro __using__(opts) do
    schema = resolve_schema(opts)

    quote do
      import Koios
      @__koios_schema__ unquote(schema)
    end
  end

  @doc """

  """
  defmacro sigil_Q(query_string, modifiers)

  defmacro sigil_Q({:<<>>, _, [string]}, []) do
    __CALLER__.module
    |> Module.get_attribute(:__koios_schema__)
    |> Schema.validate!(string)

    to_validated_query(string)
  end

  defp to_validated_query(string) do
    quote do
      %{
        __struct__: Koios.Query,
        schema: @__koios_schema__,
        query: unquote(string)
      }
    end
  end

  defp resolve_schema(opts) do
    case opts[:api] do
      "admin/2022-07" -> Schema.Admin202207
      other -> raise "Unknown schema: #{inspect(other)}"
    end
  end
end
