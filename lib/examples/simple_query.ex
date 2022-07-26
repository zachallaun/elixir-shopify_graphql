defmodule Examples.SimpleQuery do
  use ShopifyGraphQL, api: "admin/2022-07"

  def test do
    ~Q"""
      {
        orders(first: 10) {
          edges {
            node {
              id
            }
          }
        }
      }
    """
  end
end
