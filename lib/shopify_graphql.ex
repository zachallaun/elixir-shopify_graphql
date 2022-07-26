defmodule ShopifyGraphQL do
  @moduledoc """
  Client for Shopify GraphQL endpoints, including compile-time validation against Shopify GraphQL
  schemas.

  ### Usage

      defmodule Example do
        use ShopifyGraphQL, api: "admin/2022-07"

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
          |> shopify()
        end
      end
  """

  alias ShopifyGraphQL.Schema

  defmacro __using__(opts) do
    schema = resolve_schema(opts)

    quote do
      import ShopifyGraphQL
      @__shopifygraphql_schema__ unquote(schema)
    end
  end

  @doc """

  """
  defmacro sigil_Q(query_string, modifiers)

  defmacro sigil_Q({:<<>>, _, [string]}, []) do
    __CALLER__.module
    |> Module.get_attribute(:__shopifygraphql_schema__)
    |> Schema.validate!(string)

    to_validated_query(string)
  end

  defp to_validated_query(string) do
    quote do
      %{
        __struct__: ShopifyGraphQL.Query,
        schema: @__shopifygraphql_schema__,
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
