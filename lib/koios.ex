defmodule Koios do
  @moduledoc """
  General-purpose GraphQL client with compile-time validation against a schema.

  ### Usage

      defmodule Example do
        use Koios, schema: Example.Schema

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

      defmodule Example.Schema do
        use Koios.Schema, from_sdl: "schemas/shopify-admin/2022-07.graphql"
      end
  """

  alias Koios.Schema

  defmacro __using__(schema: schema) do
    quote do
      import Koios

      @__koios_schema__ unquote(schema)
      def __koios_schema__, do: @__koios_schema__
    end
  end

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
end
