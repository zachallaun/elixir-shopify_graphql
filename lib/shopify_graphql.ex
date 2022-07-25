defmodule ShopifyGraphQL do
  @moduledoc """
  Client for Shopify GraphQL endpoints, including compile-time validation against Shopify GraphQL
  schemas.
  """

  def validate(doc) do
    pipeline =
      ShopifyGraphQL.Schema
      |> Absinthe.Pipeline.for_document()
      |> Absinthe.Pipeline.without(Absinthe.Phase.Subscription.SubscribeSelf)
      |> Absinthe.Pipeline.without(Absinthe.Phase.Document.Execution.Resolution)
      |> Absinthe.Pipeline.insert_before(Absinthe.Phase.Document.Result, __MODULE__)

    case Absinthe.Pipeline.run(doc, pipeline) do
      {:ok, %{execution: %{validation_errors: []}}, _} -> {:ok, []}
      {:ok, %{execution: %{validation_errors: errors}}, _} -> {:error, errors}
      other -> {:error, other}
    end
  end

  def run(blueprint, _) do
    blueprint = put_in(blueprint.execution.result, %{value: nil})
    {:ok, blueprint}
  end
end
