defmodule ShopifyGraphQL.FakeAbsintheResult do
  # https://elixirforum.com/t/validation-only-pipeline-for-absinthe/28491/3
  @moduledoc false

  def run(blueprint, _) do
    blueprint = put_in(blueprint.execution.result, %{value: nil})
    {:ok, blueprint}
  end
end
