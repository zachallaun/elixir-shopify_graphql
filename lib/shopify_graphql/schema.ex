defmodule ShopifyGraphQL.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_sdl(path: "schemas/2022-07/admin.graphql")

  def hydrate(%Absinthe.Blueprint.Schema.InterfaceTypeDefinition{}, _ancestors) do
    {:resolve_type, &ShopifyGraphQL.Resolver.interface_resolve_type/2}
  end

  def hydrate(_node, _ancestors) do
    []
  end
end
