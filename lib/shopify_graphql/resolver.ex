defmodule ShopifyGraphQL.Resolver do
  def interface_resolve_type({:external, %{"__typename" => typename}}, _) do
    typename
    |> Absinthe.Adapter.LanguageConventions.to_internal_name(nil)
    |> String.to_atom()
  end
end
